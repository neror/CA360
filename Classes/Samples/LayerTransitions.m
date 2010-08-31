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
  [containerLayer_ release], containerLayer_ = nil;
  [blueLayer_ release], blueLayer_ = nil;
  [redLayer_ release], redLayer_ = nil;
  [transitionButton_ release], transitionButton_ = nil;
  [typeSelectControl_ release], typeSelectControl_ = nil;
  [subtypeSelectControl_ release], subtypeSelectControl_ = nil;
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];
  
  NSArray *typeItems = [NSArray arrayWithObjects:@"Push", @"Move In", @"Reveal", @"Fade", nil];
  typeSelectControl_ = [[UISegmentedControl alloc] initWithItems:typeItems];
  typeSelectControl_.frame = CGRectMake(10., 10., 300., 44.);
  typeSelectControl_.selectedSegmentIndex = 0;
  [myView addSubview:typeSelectControl_];
  
  NSArray *subtypeItems = [NSArray arrayWithObjects:@"Right", @"Left", @"Top", @"Bottom", nil];
  subtypeSelectControl_ = [[UISegmentedControl alloc] initWithItems:subtypeItems];
  subtypeSelectControl_.frame = CGRectMake(10., 60., 300., 44.);
  subtypeSelectControl_.selectedSegmentIndex = 0;
  [myView addSubview:subtypeSelectControl_];
  
  transitionButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  transitionButton_.frame = CGRectMake(10., 110., 300., 44.);
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

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  CGRect rect = CGRectMake(0., 0., 240., 240.);
  
  containerLayer_.backgroundColor = [[UIColor clearColor] CGColor];
  containerLayer_.bounds = rect;
  containerLayer_.position = CGPointMake(160., 280.);
  [containerLayer_ setNeedsDisplay];
  
  redLayer_.backgroundColor = [UIColorFromRGBA(0xFF0000, .75) CGColor];
  redLayer_.bounds = rect;
  redLayer_.position = CGPointMake(120., 120.);
  redLayer_.hidden = YES;
  [redLayer_ setNeedsDisplay];
  
  blueLayer_.backgroundColor = [UIColorFromRGBA(0x0000FF, .75) CGColor];
  blueLayer_.bounds = rect;
  blueLayer_.position = CGPointMake(120., 120.);
  [blueLayer_ setNeedsDisplay];
}

#pragma mark Button Event Handlers

- (void)toggleTransition:(id)sender {
  CATransition *transition = [CATransition animation];
  transition.duration = .5;
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
