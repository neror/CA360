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

#import "KeyframeAnimation.h"
#import <QuartzCore/QuartzCore.h>

static const CGRect kMarioStandingSpriteCoords = { .5f, 0.f, .5f, 1.f };
static const CGRect kMarioJumpingSpriteCoords = { 0.f, 0.f, .5f, 1.f };

@implementation KeyframeAnimation

+ (NSString *)friendlyName {
  return @"Keyframe Animation";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  FTRELEASE(platformLayer_);
  FTRELEASE(marioLayer_);
  FTRELEASE(jumpButton_);
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];
  
  jumpButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  jumpButton_.frame = CGRectMake(10.f, 10.f, 300.f, 44.f);
  [jumpButton_ setTitle:@"Jump!" forState:UIControlStateNormal];
  [jumpButton_ addTarget:self action:@selector(jump:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:jumpButton_];
  
  platformLayer_ = [[CALayer layer] retain];
  marioLayer_ = [[CALayer layer] retain];
  
  [myView.layer addSublayer:platformLayer_];
  [myView.layer addSublayer:marioLayer_];
  self.view = myView;
}

- (void)viewDidUnload {
  FTRELEASE(platformLayer_);
  FTRELEASE(marioLayer_);
  FTRELEASE(jumpButton_);
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  CGSize viewSize = self.view.bounds.size;
  
  marioLayer_.backgroundColor = [[UIColor clearColor] CGColor];
  marioLayer_.anchorPoint = CGPointMake(0.f, 1.f);
  marioLayer_.bounds = CGRectMake(0.f, 0.f, 32.f, 64.f);
  marioLayer_.position = CGPointMake(0.f, viewSize.height);
  marioLayer_.contents = (id)[[UIImage imageNamed:@"Mario.png"] CGImage];
  marioLayer_.contentsGravity = kCAGravityResizeAspect;
  marioLayer_.contentsRect = kMarioStandingSpriteCoords;
  
  platformLayer_.backgroundColor = [[UIColor brownColor] CGColor];
  platformLayer_.anchorPoint = CGPointZero;
  platformLayer_.frame = CGRectMake(160.f, 200.f, 160.f, 20.f);
  platformLayer_.cornerRadius = 4.f;
  [platformLayer_ setNeedsDisplay];
  [platformLayer_ setNeedsDisplay];
}

- (void)viewDidAppear:(BOOL)animated {
}

#pragma mark Event Handlers

- (void)jump:(id)sender {
  CGSize viewSize = self.view.bounds.size;
  [marioLayer_ removeAnimationForKey:@"marioJump"];
  
  CGMutablePathRef jumpPath = CGPathCreateMutable();
  CGPathMoveToPoint(jumpPath, NULL, 0.f, viewSize.height);
  CGPathAddCurveToPoint(jumpPath, NULL, 30.f, 140.f, 170.f, 140.f, 170.f, 200.f);

  CAKeyframeAnimation *jumpAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
  jumpAnimation.path = jumpPath;
  jumpAnimation.duration = 1.f;
  jumpAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  jumpAnimation.delegate = self;

  CGPathRelease(jumpPath);
  
  [marioLayer_ addAnimation:jumpAnimation forKey:@"marioJump"];
    
}

#pragma mark Animation delegate methods

- (void)animationDidStart:(CAAnimation *)theAnimation {
  [CATransaction begin];
  {
    [CATransaction setDisableActions:YES];
    marioLayer_.contentsRect = kMarioJumpingSpriteCoords;
  }
  [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)finished {
  [CATransaction begin];
  {
    [CATransaction setDisableActions:YES];
    marioLayer_.contentsRect = kMarioStandingSpriteCoords;
    if(finished) {
      marioLayer_.position = CGPointMake(170.f, 200.f);
    }
  }
  [CATransaction commit];
}

@end
