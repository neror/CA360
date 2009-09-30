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

#import "ShapeLayers.h"

@interface ShapeLayers ()

- (CGMutablePathRef)newRectPathInRect:(CGRect)rect;
- (CGMutablePathRef)newCirclePathInRect:(CGRect)rect;
- (void)animateShape:(id)sender;

@end


@implementation ShapeLayers

+ (NSString *)friendlyName {
  return @"Shape Layers";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  FTRELEASE(shapeLayer_);
  FTRELEASE(animateButton_);
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];
  
  animateButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  animateButton_.frame = CGRectMake(10., 10., 300., 44.);
  [animateButton_ setTitle:@"Animate!" forState:UIControlStateNormal];
  [animateButton_ addTarget:self action:@selector(animateShape:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:animateButton_];
  
  shapeLayer_ = [[CAShapeLayer layer] retain];
  [myView.layer addSublayer:shapeLayer_];
  self.view = myView;
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  shapeLayer_.backgroundColor = [[UIColor clearColor] CGColor];
  shapeLayer_.frame = CGRectMake(0., 0., 200., 200.);
  shapeLayer_.position = self.view.center;
  CGPathRef path = [self newCirclePathInRect:shapeLayer_.bounds];
  shapeLayer_.path = path;
  CGPathRelease(path);
  [shapeLayer_ setValue:[NSNumber numberWithBool:NO] forKey:@"isFlower"];
  shapeLayer_.fillColor = [[UIColor blueColor] CGColor];
  shapeLayer_.strokeColor = [[UIColor blackColor] CGColor];
  shapeLayer_.lineWidth = 4.;
  shapeLayer_.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:8], [NSNumber numberWithInt:8], nil];
  shapeLayer_.lineCap = kCALineCapRound;
}

- (void)viewDidAppear:(BOOL)animated {
}

#pragma mark Button Event Handlers

- (void)animateShape:(id)sender {
  CGPathRef path;
  BOOL isFlower = [[shapeLayer_ valueForKey:@"isFlower"] boolValue];
  if(isFlower) {
    path = [self newCirclePathInRect:shapeLayer_.bounds];
  } else {
    path = [self newRectPathInRect:shapeLayer_.bounds];
  }
  CABasicAnimation *pathAnim = [CABasicAnimation animationWithKeyPath:@"path"];
  pathAnim.toValue = (id)path;
  pathAnim.duration = 1.;
  pathAnim.delegate = self;

  [shapeLayer_ setValue:[NSNumber numberWithBool:!isFlower] forKey:@"isFlower"];
  [shapeLayer_ addAnimation:pathAnim forKey:@"animatePath"];
  CGPathRelease(path);
}

#pragma mark Animation Delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)finished {
  CGPathRef path;
  BOOL isFlower = [[shapeLayer_ valueForKey:@"isFlower"] boolValue];
  [CATransaction begin];
  [CATransaction setDisableActions:YES];
  if(isFlower) {
    path = [self newRectPathInRect:shapeLayer_.bounds];
  } else {
    path = [self newCirclePathInRect:shapeLayer_.bounds];
  }
  shapeLayer_.path = path;
  CGPathRelease(path);
  [CATransaction commit];
}

#pragma mark Paths

- (CGMutablePathRef)newRectPathInRect:(CGRect)rect {
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddRect(path, NULL, rect);
  return path;
}

- (CGMutablePathRef)newCirclePathInRect:(CGRect)rect {
  CGMutablePathRef path = CGPathCreateMutable();
  CGPathAddEllipseInRect(path, NULL, rect);
  return path;
}


@end
