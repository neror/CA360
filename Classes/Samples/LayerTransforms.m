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

#import "LayerTransforms.h"
#import <QuartzCore/QuartzCore.h>
#import "CALayer+FTDebugDrawing.h"

@implementation LayerTransforms

+ (NSString *)friendlyName {
  return @"Layer Transforms";
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
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor grayColor];
  
  simpleLayer_ = [[CALayer layer] retain];
  [myView.layer addSublayer:simpleLayer_];
  self.view = myView;
}

- (void)viewDidUnload {
  FTRELEASE(simpleLayer_);
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  simpleLayer_.backgroundColor = [UIColorFromRGBA(0xFFFFFF, .85f) CGColor];
  simpleLayer_.bounds = CGRectMake(0.f, 0.f, 200.f, 200.f);
  simpleLayer_.position = self.view.center;
  simpleLayer_.delegate = self;
  [simpleLayer_ setNeedsDisplay];
}

- (void)viewWillDisappear:(BOOL)animated {
  simpleLayer_.delegate = nil;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
  [layer debugDrawAnchorPointInContext:context withSize:CGSizeMake(8.f, 8.f) color:[UIColor redColor]];
}

@end
