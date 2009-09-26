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

#import "GeometricProperties.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+FTDebugDrawing.h"

@implementation GeometricProperties

+ (NSString *)friendlyName {
  return @"Geometric Properties";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  FTRELEASE(simpleLayer_);
  FTRELEASE(moveAnchorPointButton_);
  FTRELEASE(movePositionButton_);
  FTRELEASE(propertiesTextView_);
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];
  
  moveAnchorPointButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  moveAnchorPointButton_.frame = CGRectMake(10., 10., 145., 44.);
  [moveAnchorPointButton_ setTitle:@"Move Anchor Point" forState:UIControlStateNormal];
  [moveAnchorPointButton_ addTarget:self action:@selector(moveAnchorPoint:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:moveAnchorPointButton_];
  
  movePositionButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  movePositionButton_.frame = CGRectMake(165., 10., 145., 44.);
  [movePositionButton_ setTitle:@"Move Position" forState:UIControlStateNormal];
  [movePositionButton_ addTarget:self action:@selector(movePosition:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:movePositionButton_];
  
  propertiesTextView_ = [[UITextView alloc] initWithFrame:CGRectMake(0., 60., 320., 44.)];
  propertiesTextView_.backgroundColor = [UIColor clearColor];
  propertiesTextView_.editable = NO;
  propertiesTextView_.textAlignment = UITextAlignmentCenter;
  propertiesTextView_.font = [UIFont systemFontOfSize:12.];
  [myView addSubview:propertiesTextView_];
  
  simpleLayer_ = [[CALayer layer] retain];
  [myView.layer addSublayer:simpleLayer_];
  self.view = myView;
}

#pragma mark View drawing

- (void)updatePropertiesLabel {
  propertiesTextView_.text = [NSString stringWithFormat:@"Bounds: %@  Position: %@\nFrame: %@  Anchor Point: %@",
                              NSStringFromCGRect(simpleLayer_.bounds), 
                              NSStringFromCGPoint(simpleLayer_.position),
                              NSStringFromCGRect(simpleLayer_.frame), 
                              NSStringFromCGPoint(simpleLayer_.anchorPoint)];
}

- (void)viewWillAppear:(BOOL)animated {
  simpleLayer_.backgroundColor = [UIColorFromRGBA(0x00FF00, .85) CGColor];
  simpleLayer_.bounds = CGRectMake(0., 0., 200., 200.);
  simpleLayer_.position = self.view.center;
  simpleLayer_.delegate = self;
  [simpleLayer_ setNeedsDisplay];
  [self updatePropertiesLabel];
}

- (void)viewWillDisappear:(BOOL)animated {
  simpleLayer_.delegate = nil;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
  [layer debugDrawAnchorPointInContext:context withSize:CGSizeMake(8., 8.) color:[UIColor redColor]];
}

#pragma mark Button Event Handlers

- (void)moveAnchorPoint:(id)sender {
  if(CGPointEqualToPoint(simpleLayer_.anchorPoint, CGPointZero)) {
    simpleLayer_.anchorPoint = CGPointMake(.5, .5);
  } else {
    simpleLayer_.anchorPoint = CGPointZero;
  }
  [simpleLayer_ setNeedsDisplay];
  [self updatePropertiesLabel];
}

- (void)movePosition:(id)sender {
  if(CGPointEqualToPoint(simpleLayer_.position, self.view.center)) {
    CGPoint newPos = self.view.center;
    newPos.y += 100.;
    simpleLayer_.position = newPos;
  } else {
    simpleLayer_.position = self.view.center;
  }
  [simpleLayer_ setNeedsDisplay];
  [self updatePropertiesLabel];
}

@end
