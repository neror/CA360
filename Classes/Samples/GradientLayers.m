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

#import "GradientLayers.h"

@interface GradientLayers ()

- (void)animateGradient:(id)sender;

@end


@implementation GradientLayers

+ (NSString *)friendlyName {
  return @"Gradient Layers";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  FTRELEASE(gradientLayer_);
  [super dealloc];
}


- (void)animateGradient:(id)sender {
  if([gradientLayer_ animationForKey:@"gradientAnimation"] == nil) {
    CABasicAnimation *endPointAnim = [CABasicAnimation animationWithKeyPath:@"endPoint"];
    endPointAnim.toValue = [NSValue valueWithCGPoint:CGPointMake(0., .1)];
    endPointAnim.duration = 1.;
    endPointAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    endPointAnim.repeatCount = FLT_MAX;
    endPointAnim.autoreverses = YES;
    
    [gradientLayer_ addAnimation:endPointAnim forKey:@"gradientAnimation"];
  } else {
    [gradientLayer_ removeAnimationForKey:@"gradientAnimation"];
  }
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];  
  
  animateButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  animateButton_.frame = CGRectMake(10., 10., 300., 44.);
  [animateButton_ setTitle:@"Animate!" forState:UIControlStateNormal];
  [animateButton_ addTarget:self action:@selector(animateGradient:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:animateButton_];
  
  gradientLayer_ = [[CAGradientLayer layer] retain];
  [myView.layer addSublayer:gradientLayer_];
  self.view = myView;
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  gradientLayer_.backgroundColor = [[UIColor blackColor] CGColor];
  gradientLayer_.bounds = CGRectMake(0., 0., 200., 200.);
  gradientLayer_.position = self.view.center;
  gradientLayer_.cornerRadius = 12.;
  gradientLayer_.borderWidth = 2.;
  gradientLayer_.borderColor = [[UIColor blackColor] CGColor];
  gradientLayer_.startPoint = CGPointZero;
  gradientLayer_.endPoint = CGPointMake(0., 1.);
  gradientLayer_.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[UIColorFromRGBA(0xFFFFFF, .1) CGColor], nil];
}

- (void)viewDidAppear:(BOOL)animated {
}

@end
