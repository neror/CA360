/*
 The MIT License
 
 Copyright (c) 2010 Free Time Studios and Nathan Eror
 
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

#import "CustomPropertyAnimation.h"
#import <QuartzCore/QuartzCore.h>

@interface CustomLayer : CALayer {
}

@property (assign) CGFloat margin;

@end

@implementation CustomLayer

@synthesize margin;

+ (BOOL)needsDisplayForKey:(NSString *)key {
  if([key isEqualToString:@"margin"]) {
    return YES;
  }
  return [super needsDisplayForKey:key];
}

- (void)drawInContext:(CGContextRef)ctx {
  CGContextSaveGState(ctx);
  CGContextAddEllipseInRect(ctx, CGRectInset(self.bounds, self.margin, self.margin));
  CGContextSetStrokeColorWithColor(ctx, [[UIColor yellowColor] CGColor]);
  CGContextSetLineWidth(ctx, 4.f);
  CGContextDrawPath(ctx, kCGPathStroke);
  CGContextRestoreGState(ctx);
}

@end


@implementation CustomPropertyAnimation

+ (NSString *)friendlyName {
  return @"Custom Properties";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];

  customLayer_ = [[CustomLayer alloc] init];
  [myView.layer addSublayer:customLayer_];
  
  self.view = myView;
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  customLayer_.backgroundColor = [[UIColor blueColor] CGColor];
  customLayer_.frame = CGRectInset(self.view.bounds, 50.f, 100.f);
  customLayer_.position = self.view.center;
  customLayer_.margin = 0.f;
}

- (void)viewDidAppear:(BOOL)animated {
  CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"margin"];
  anim.duration = 1.f;
  anim.fromValue = [NSNumber numberWithFloat:5.f];
  anim.toValue = [NSNumber numberWithFloat:25.f];
  anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  anim.repeatCount = CGFLOAT_MAX;
  anim.autoreverses = YES;
  
  [customLayer_ addAnimation:anim forKey:@"margin"];
  
  CABasicAnimation *anim2 = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
  anim2.duration = 1.f;
  anim2.fromValue = [NSNumber numberWithFloat:0.f];
  anim2.toValue = [NSNumber numberWithFloat:20.f];
  anim2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  anim2.repeatCount = CGFLOAT_MAX;
  anim2.autoreverses = YES;
  
  [customLayer_ addAnimation:anim2 forKey:@"cornerRadius"];
}

@end
