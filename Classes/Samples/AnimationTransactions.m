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

#import "AnimationTransactions.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnimationTransactions

+ (NSString *)friendlyName {
  return @"Animation Transactions";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  FTRELEASE(blueLayer_);
  FTRELEASE(redLayer_);
  FTRELEASE(runButton_);
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor grayColor];
  
  runButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  runButton_.frame = CGRectMake(10.f, 10.f, 300.f, 44.f);
  [runButton_ setTitle:@"Run Animation" forState:UIControlStateNormal];
  [runButton_ addTarget:self action:@selector(toggleRun:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:runButton_];
  
  blueLayer_ = [[CALayer layer] retain];
  redLayer_ = [[CALayer layer] retain];
  
  [myView.layer addSublayer:blueLayer_];
  [myView.layer addSublayer:redLayer_];
  self.view = myView;
}

- (void)viewDidUnload {
  FTRELEASE(blueLayer_);
  FTRELEASE(redLayer_);
  FTRELEASE(runButton_);
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  CGRect rect = CGRectMake(0.f, 0.f, 100.f, 100.f);
  blueLayer_.backgroundColor = [UIColorFromRGBA(0x0000FF, .75f) CGColor];
  blueLayer_.bounds = rect;
  blueLayer_.position = CGPointMake(50.f, 50.f);
  blueLayer_.cornerRadius = 10.f;
  [blueLayer_ setNeedsDisplay];
  
  redLayer_.backgroundColor = [UIColorFromRGBA(0xFF0000, .75f) CGColor];
  redLayer_.bounds = rect;
  CGSize viewSize = self.view.bounds.size;
  redLayer_.position = CGPointMake(viewSize.width - 50.f, viewSize.height - 50.f);
  redLayer_.cornerRadius = 10.f;
  [redLayer_ setNeedsDisplay];
}

- (void)viewDidAppear:(BOOL)animated {
}

#pragma mark Event Handlers

- (void)toggleRun:(id)sender {
  [redLayer_ removeAnimationForKey:@"changePosition"];
  [blueLayer_ removeAnimationForKey:@"changePosition"];
  [CATransaction begin];
  {
    [CATransaction setAnimationDuration:1.f];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *moveRed = [CABasicAnimation animationWithKeyPath:@"position"];
    moveRed.toValue = [NSValue valueWithCGPoint:CGPointMake(75.f, self.view.center.y)];
    [redLayer_ addAnimation:moveRed forKey:@"changePosition"];
    
    [CATransaction begin];
    {
      [CATransaction setAnimationDuration:2.f];
      [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
      CABasicAnimation *moveBlue = [CABasicAnimation animationWithKeyPath:@"position"];
      CGSize viewSize = self.view.bounds.size;
      moveBlue.toValue = [NSValue valueWithCGPoint:CGPointMake(viewSize.width - 75.f, self.view.center.y)];
      [blueLayer_ addAnimation:moveBlue forKey:@"changePosition"];
    }
    [CATransaction commit];
    
  }
  [CATransaction commit];
}

@end
