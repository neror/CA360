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

#import "AnimationGroups.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnimationGroups

+ (NSString *)friendlyName {
  return @"Animation Groups";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  FTRELEASE(pulseLayer_);
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];
  
  pulseLayer_ = [[CALayer layer] retain];
  [myView.layer addSublayer:pulseLayer_];
  
  self.view = myView;
}


#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  pulseLayer_.backgroundColor = [UIColorFromRGBA(0x000000, .75) CGColor];
  pulseLayer_.bounds = CGRectMake(0., 0., 200., 200.);
  pulseLayer_.cornerRadius = 12.;
  pulseLayer_.position = self.view.center;
  [pulseLayer_ setNeedsDisplay];
}

- (void)viewDidAppear:(BOOL)animated {
  CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
  pulseAnimation.duration = 2.;
  pulseAnimation.toValue = [NSNumber numberWithFloat:1.15];
  
  CABasicAnimation *pulseColorAnimation = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
  pulseColorAnimation.duration = 1.;
  pulseColorAnimation.fillMode = kCAFillModeForwards;
  pulseColorAnimation.toValue = (id)[UIColorFromRGBA(0xFF0000, .75) CGColor];
  
  CABasicAnimation *rotateLayerAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
  rotateLayerAnimation.duration = .5;
  rotateLayerAnimation.beginTime = .5;
  rotateLayerAnimation.fillMode = kCAFillModeBoth;
  rotateLayerAnimation.toValue = [NSNumber numberWithFloat:DEGREES_TO_RADIANS(45.)];
  
  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.animations = [NSArray arrayWithObjects:pulseAnimation, pulseColorAnimation, rotateLayerAnimation, nil];
  group.duration = 2.;
  group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  group.autoreverses = YES;
  group.repeatCount = FLT_MAX;
  
  [pulseLayer_ addAnimation:group forKey:nil];
}

@end
