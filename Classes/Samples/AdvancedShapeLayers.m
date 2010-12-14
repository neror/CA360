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

#import "AdvancedShapeLayers.h"

@implementation AdvancedShapeLayers

+ (NSString *)friendlyName {
  return @"Advanced Shape Layers";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  [shapeLayer_ release], shapeLayer_ = nil;
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];
  
  shapeLayer_ = [[CAShapeLayer alloc] init];
  [myView.layer addSublayer:shapeLayer_];

  self.view = myView;
}

- (void)viewDidUnload {
  [shapeLayer_ release], shapeLayer_ = nil;
}

#pragma mark View drawing

- (void)drawPathWithArc:(CGFloat)arc {
  CGMutablePathRef thePath = CGPathCreateMutable();
  CGPathMoveToPoint(thePath, NULL, 100.f, 100.f);
  CGPathAddLineToPoint(thePath, NULL, 200.f, 100.f);
  CGPathAddArc(thePath, NULL, 100.f, 100.f, 100.f, 0.f, arc, NO);
  CGPathCloseSubpath(thePath);
  shapeLayer_.path = thePath;
  CGPathRelease(thePath);
}

- (void)viewWillAppear:(BOOL)animated {
  shapeLayer_.bounds = CGRectMake(0.f, 0.f, 200.f, 200.f);
  shapeLayer_.position = self.view.center;
  shapeLayer_.strokeColor = [[UIColor blueColor] CGColor];
  shapeLayer_.lineWidth = 4.f;
  shapeLayer_.fillColor = [[UIColor yellowColor] CGColor];
  currentArc = M_PI_2;
  [self drawPathWithArc:currentArc];
}

- (void)updatePath:(CADisplayLink *)displayLink {
  currentArc = fminf(currentArc * 1.1f, M_PI * 1.5f);
  [self drawPathWithArc:currentArc];
  if(currentArc >= M_PI * 1.5f) {
    [displayLink invalidate];
  }
}

- (void)viewDidAppear:(BOOL)animated {
  CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updatePath:)];
  [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

@end
