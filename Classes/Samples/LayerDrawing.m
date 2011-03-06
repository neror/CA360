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

#import "LayerDrawing.h"

@implementation LayerDrawing

+ (NSString *)friendlyName {
  return @"Draw Your Own Content";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  [drawingLayer_ release], drawingLayer_ = nil;
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];

  drawingLayer_ = [[CALayer layer] retain];
  
  [myView.layer addSublayer:drawingLayer_];
  self.view = myView;
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  drawingLayer_.backgroundColor = [[UIColor clearColor] CGColor];
  drawingLayer_.bounds = CGRectMake(0., 0., 300., 300.);
  drawingLayer_.position = self.view.center;
  drawingLayer_.delegate = self;
  [drawingLayer_ setNeedsDisplay];
}

- (void)viewWillDisappear:(BOOL)animated {
  drawingLayer_.delegate = nil;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
  CGContextAddEllipseInRect(context, CGRectInset(layer.bounds, 4., 4.));
  
  CGContextSetLineWidth(context, 2.);
  const CGFloat lineDashLengths[2] = { 6., 2. };
  CGContextSetLineDash(context, 0., lineDashLengths, 2);
  
  CGContextSetFillColorWithColor(context, [[UIColor greenColor] CGColor]);
  CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
  
  CGContextDrawPath(context, kCGPathFillStroke);
}

@end

