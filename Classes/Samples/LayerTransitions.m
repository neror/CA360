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

#import "LayerTransitions.h"
#import <QuartzCore/QuartzCore.h>

@implementation LayerTransitions

+ (NSString *)friendlyName {
  return @"Layer Transitions";
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
  FTRELEASE(blueLayer_);
  FTRELEASE(redLayer_);
  FTRELEASE(transitionButton_);
  FTRELEASE(typeSelectControl_);
  FTRELEASE(subtypeSelectControl_);
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor grayColor];
  
  NSArray *typeItems = [NSArray arrayWithObjects:@"Push", @"Move In", @"Reveal", @"Fade", nil];
  typeSelectControl_ = [[UISegmentedControl alloc] initWithItems:typeItems];
  typeSelectControl_.frame = CGRectMake(10.f, 10.f, 300.f, 44.f);
  typeSelectControl_.selectedSegmentIndex = 0;
  [myView addSubview:typeSelectControl_];
  
  NSArray *subtypeItems = [NSArray arrayWithObjects:@"Right", @"Left", @"Top", @"Bottom", nil];
  subtypeSelectControl_ = [[UISegmentedControl alloc] initWithItems:subtypeItems];
  subtypeSelectControl_.frame = CGRectMake(10.f, 60.f, 300.f, 44.f);
  subtypeSelectControl_.selectedSegmentIndex = 0;
  [myView addSubview:subtypeSelectControl_];
  
  transitionButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  transitionButton_.frame = CGRectMake(10.f, 110.f, 300.f, 44.f);
  [transitionButton_ setTitle:@"Start Transition" forState:UIControlStateNormal];
  [transitionButton_ addTarget:self action:@selector(toggleTransition:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:transitionButton_];

  
  blueLayer_ = [[CALayer layer] retain];
  redLayer_ = [[CALayer layer] retain];
  containerLayer_ = [[CALayer layer] retain];

  [myView.layer addSublayer:containerLayer_];
  [containerLayer_ addSublayer:blueLayer_];
  [containerLayer_ addSublayer:redLayer_];
  self.view = myView;
}

- (void)viewDidUnload {
  FTRELEASE(containerLayer_);
  FTRELEASE(blueLayer_);
  FTRELEASE(redLayer_);
  FTRELEASE(transitionButton_);
  FTRELEASE(typeSelectControl_);
  FTRELEASE(subtypeSelectControl_);
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  CGRect rect = CGRectMake(0.f, 0.f, 240.f, 240.f);
  
  containerLayer_.backgroundColor = [[UIColor clearColor] CGColor];
  containerLayer_.bounds = rect;
  containerLayer_.position = CGPointMake(160.f, 280.f);
  [containerLayer_ setNeedsDisplay];
  
  redLayer_.backgroundColor = [UIColorFromRGBA(0xFF0000, .75f) CGColor];
  redLayer_.bounds = rect;
  redLayer_.position = CGPointMake(120.f, 120.f);
  redLayer_.hidden = YES;
  [redLayer_ setNeedsDisplay];
  
  blueLayer_.backgroundColor = [UIColorFromRGBA(0x0000FF, .75f) CGColor];
  blueLayer_.bounds = rect;
  blueLayer_.position = CGPointMake(120.f, 120.f);
  [blueLayer_ setNeedsDisplay];
}

#pragma mark Button Event Handlers

- (void)toggleTransition:(id)sender {
  CATransition *transition = [CATransition animation];
  transition.duration = .5f;
  transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  
  NSString *transitionTypes[4] = { kCATransitionPush, kCATransitionMoveIn, kCATransitionReveal, kCATransitionFade };
  transition.type = transitionTypes[typeSelectControl_.selectedSegmentIndex];
  
  NSString *transitionSubtypes[4] = { kCATransitionFromRight, kCATransitionFromLeft, kCATransitionFromTop, kCATransitionFromBottom };
  transition.subtype = transitionSubtypes[subtypeSelectControl_.selectedSegmentIndex];
  
  [containerLayer_ addAnimation:transition forKey:nil];
  blueLayer_.hidden = !blueLayer_.hidden;
  redLayer_.hidden = !redLayer_.hidden;
}

@end
