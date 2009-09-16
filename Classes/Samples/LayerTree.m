/*
 The MIT License
 
 Copyright (c) 2009 Free Time Studios and Nathan Eror
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
*/

#import "LayerTree.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+FTDebugDrawing.h"

@implementation LayerTree

+ (NSString *)friendlyName {
  return @"Layer Tree";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  FTRELEASE(containerLayer_);
  FTRELEASE(redLayer_);
  FTRELEASE(blueLayer_);
  FTRELEASE(purpleLayer_);
  FTRELEASE(yellowLayer_);
  FTRELEASE(maskContainerButton_);
  FTRELEASE(maskBlueButton_);
  FTRELEASE(reparentPurpleButton_);
  FTRELEASE(addRemoveYellowButton_);
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];

  maskBlueButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  maskBlueButton_.frame = CGRectMake(10.f, 10.f, 145.f, 44.f);
  [maskBlueButton_ setTitle:@"Mask Blue" forState:UIControlStateNormal];
  [maskBlueButton_ addTarget:self action:@selector(toggleBlueMask:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:maskBlueButton_];
  
  maskContainerButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  maskContainerButton_.frame = CGRectMake(165.f, 10.f, 145.f, 44.f);
  [maskContainerButton_ setTitle:@"Mask Container" forState:UIControlStateNormal];
  [maskContainerButton_ addTarget:self action:@selector(toggleContainerMask:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:maskContainerButton_];
  
  reparentPurpleButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  reparentPurpleButton_.frame = CGRectMake(10.f, 60.f, 145.f, 44.f);
  [reparentPurpleButton_ setTitle:@"Reparent Purple" forState:UIControlStateNormal];
  [reparentPurpleButton_ addTarget:self action:@selector(reparentPurpleLayer:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:reparentPurpleButton_];

  addRemoveYellowButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  addRemoveYellowButton_.frame = CGRectMake(165.f, 60.f, 145.f, 44.f);
  [addRemoveYellowButton_ setTitle:@"Add/Remove Yellow" forState:UIControlStateNormal];
  [addRemoveYellowButton_ addTarget:self action:@selector(addRemoveYellow:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:addRemoveYellowButton_];
  
  containerLayer_ = [[CALayer layer] retain];
  redLayer_ = [[CALayer layer] retain];
  blueLayer_ = [[CALayer layer] retain];
  purpleLayer_ = [[CALayer layer] retain];
  yellowLayer_ = [[CALayer layer] retain];
  
  [myView.layer addSublayer:containerLayer_];
  [containerLayer_ addSublayer:redLayer_];
  [containerLayer_ addSublayer:blueLayer_];
  [blueLayer_ addSublayer:purpleLayer_];
  
  self.view = myView;
}

- (void)viewDidUnload {
  FTRELEASE(containerLayer_);
  FTRELEASE(redLayer_);
  FTRELEASE(blueLayer_);
  FTRELEASE(purpleLayer_);
  FTRELEASE(yellowLayer_);
  FTRELEASE(maskBlueButton_);
  FTRELEASE(maskContainerButton_);
  FTRELEASE(reparentPurpleButton_);
  FTRELEASE(addRemoveYellowButton_);
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  containerLayer_.backgroundColor = [[UIColor greenColor] CGColor];
  containerLayer_.bounds = CGRectMake(0.f, 0.f, 200.f, 200.f);
  containerLayer_.delegate = self;
  containerLayer_.position = self.view.center;
  [containerLayer_ setNeedsDisplay];
  
  CGRect rect = CGRectMake(0.f, 0.f, 100.f, 100.f);

  redLayer_.backgroundColor = [UIColorFromRGBA(0xFF0000, .75f) CGColor];
  redLayer_.bounds = rect;
  redLayer_.position = CGPointMake(0.f, 200.f);
  redLayer_.delegate = self;
  [redLayer_ setNeedsDisplay];
  
  blueLayer_.backgroundColor = [UIColorFromRGBA(0x0000FF, .75f) CGColor];
  blueLayer_.bounds = rect;
  blueLayer_.position = CGPointMake(200.f, 200.f);
  blueLayer_.delegate = self;
  [blueLayer_ setNeedsDisplay];

  purpleLayer_.backgroundColor = [UIColorFromRGBA(0xFF00FF, .75f) CGColor];
  purpleLayer_.bounds = rect;
  purpleLayer_.position = CGPointMake(25.f, 25.f);
  purpleLayer_.delegate = self;
  [purpleLayer_ setNeedsDisplay];
  
  yellowLayer_.backgroundColor = [UIColorFromRGBA(0xFFFF00, .75f) CGColor];
  yellowLayer_.bounds = rect;
  yellowLayer_.position = CGPointMake(0.f, 0.f);
  yellowLayer_.delegate = self;
  [yellowLayer_ setNeedsDisplay];
}


- (void)viewWillDisappear:(BOOL)animated {
  containerLayer_.delegate = nil;
  redLayer_.delegate = nil;
  blueLayer_.delegate = nil;
  purpleLayer_.delegate = nil;
  yellowLayer_.delegate = nil;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
  [layer debugDrawAnchorPointInContext:context withSize:CGSizeMake(6.f, 6.f) color:[UIColor blackColor]];
}

#pragma mark Event Handlers

- (void)toggleBlueMask:(id)sender {
  blueLayer_.masksToBounds = !blueLayer_.masksToBounds;
}

- (void)toggleContainerMask:(id)sender {
  containerLayer_.masksToBounds = !containerLayer_.masksToBounds;
}

- (void)reparentPurpleLayer:(id)sender {
  BOOL isChildOfRoot = (purpleLayer_.superlayer == containerLayer_);
  [purpleLayer_ removeFromSuperlayer];
  if(isChildOfRoot) {
    [blueLayer_ addSublayer:purpleLayer_];
  } else {
    [containerLayer_ addSublayer:purpleLayer_];
  }
}

- (void)addRemoveYellow:(id)sender {
  if(yellowLayer_.superlayer == nil) {
    CALayer *purpleParent = purpleLayer_.superlayer;
    [purpleParent insertSublayer:yellowLayer_ below:purpleLayer_];
  } else {
    [yellowLayer_ removeFromSuperlayer];
  }
}

@end
