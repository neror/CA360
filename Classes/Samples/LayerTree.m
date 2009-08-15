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
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor blackColor];
  
  containerLayer_ = [[CALayer layer] retain];
  redLayer_ = [[CALayer layer] retain];
  blueLayer_ = [[CALayer layer] retain];
  
  [myView.layer addSublayer:containerLayer_];
  [containerLayer_ addSublayer:redLayer_];
  [containerLayer_ addSublayer:blueLayer_];
  
  self.view = myView;
}

- (void)viewDidUnload {
  FTRELEASE(containerLayer_);
  FTRELEASE(redLayer_);
  FTRELEASE(blueLayer_);
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  containerLayer_.backgroundColor = [[UIColor colorWithRed:1.f green:1.f blue:1.f alpha:1.f] CGColor];
  containerLayer_.cornerRadius = 20.f;
  containerLayer_.frame = self.view.layer.bounds;
  containerLayer_.position = CGPointZero;
}

- (void)viewDidAppear:(BOOL)animated {
  CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
  anim.toValue = [NSValue valueWithCGPoint:CGPointMake(320.f, 480.f)];
  anim.repeatCount = FLT_MAX;
  anim.duration = 1.f;
  anim.autoreverses = YES;
  anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
  [containerLayer_ addAnimation:anim forKey:@"grow"];  
}

@end
