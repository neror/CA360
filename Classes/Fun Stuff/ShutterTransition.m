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

#import "ShutterTransition.h"

#define USE_FLATTENED_LAYER 0
#define BAND_COUNT 7

@implementation ShutterTransition

+ (NSString *)friendlyName {
  return @"Shutter Transition";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  [goButton_ release], goButton_ = nil;
  [mainLayer_ release], mainLayer_ = nil;
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)viewDidLoad {
  self.view.backgroundColor = [UIColor whiteColor];
  
  mainLayer_ = [[CALayer alloc] init];
  
  [self.view.layer addSublayer:mainLayer_];
  
  goButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  goButton_.frame = CGRectMake(10., 10., 300., 44.);
  [goButton_ setTitle:@"Shutter Transition!" forState:UIControlStateNormal];
  [goButton_ addTarget:self action:@selector(doShutterTransition) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:goButton_];
  
}

- (void)viewDidUnload {
  [mainLayer_ release], mainLayer_ = nil;
  [goButton_ release], goButton_ = nil;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
  CGContextAddEllipseInRect(ctx, mainLayer_.bounds);
  CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor]);
  CGContextSetLineWidth(ctx, 4.f);
  CGContextDrawPath(ctx, kCGPathStroke);
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  mainLayer_.delegate = self;
  mainLayer_.bounds = CGRectMake(0.f, 0.f, 200.f, 200.f);
  mainLayer_.backgroundColor = [[UIColor blueColor] CGColor];
  mainLayer_.position = self.view.center;
  [mainLayer_ setNeedsDisplay];
}

- (void)viewWillDisappear:(BOOL)animated {
  mainLayer_.delegate = nil;
}

#pragma mark -
#pragma mark Event Handlers

- (void)doShutterTransition {
  CGSize layerSize = mainLayer_.bounds.size;

#if USE_FLATTENED_LAYER
  //Grab the bits from the layer
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGContextRef context = CGBitmapContextCreate(NULL, (int)layerSize.width, (int)layerSize.height, 8, (int)layerSize.width * 4, colorSpace, kCGImageAlphaPremultipliedLast);

  [mainLayer_ renderInContext:context];
  UIImage *layerImage = [UIImage imageWithCGImage:CGBitmapContextCreateImage(context)];
#endif
  
  //Set up a single instance of the slide animations to be reused in the bands
  CABasicAnimation *slideUp = [CABasicAnimation animationWithKeyPath:@"position.y"];
  slideUp.toValue = [NSNumber numberWithFloat:-(mainLayer_.frame.size.height / 2.f)];
  slideUp.duration = 1.f;
  slideUp.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  slideUp.fillMode = kCAFillModeForwards;

  CABasicAnimation *slideDown = [CABasicAnimation animationWithKeyPath:@"position.y"];
  slideDown.toValue = [NSNumber numberWithFloat:(mainLayer_.frame.size.height / 2.f) + [UIScreen mainScreen].bounds.size.height];
  slideDown.duration = 1.f;
  slideDown.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
  slideDown.fillMode = kCAFillModeForwards;
  
  NSMutableArray *bands = [[NSMutableArray alloc] initWithCapacity:BAND_COUNT];

  [mainLayer_ removeFromSuperlayer];
  [CATransaction begin];
  [CATransaction setCompletionBlock:^(void) {
    [bands enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      [obj setDelegate:nil];
      [obj removeFromSuperlayer];
    }];
    [self.view.layer addSublayer:mainLayer_];
  }];
  
  CGFloat bandWidth = layerSize.width / (CGFloat)BAND_COUNT;
  for(int i = 0; i < BAND_COUNT; i++) {
    CALayer *band = [[CALayer alloc] init];
    band.masksToBounds = YES;

#if USE_FLATTENED_LAYER
    CGFloat xOffset = 1.f / (CGFloat)BAND_COUNT;
    band.bounds = CGRectMake(0.f, 0.f, bandWidth, layerSize.height);
    band.contents = (id)[layerImage CGImage];
    band.contentsGravity = kCAGravityCenter;
    band.contentsRect = CGRectMake(xOffset * i , 0.f, xOffset, 1.f);
#else    
    band.bounds = CGRectMake(bandWidth * i, 0.f, bandWidth, layerSize.height);
    band.backgroundColor = mainLayer_.backgroundColor;
    band.delegate = self;
    [band setNeedsDisplay];
#endif

    CGPoint bandOrigin = mainLayer_.frame.origin;
    bandOrigin.x = bandOrigin.x + (bandWidth * i);
    [band setValue:[NSValue valueWithCGPoint:bandOrigin] forKeyPath:@"frame.origin"];

    [self.view.layer addSublayer:band];
    
    [band addAnimation:(i % 2) ? slideUp : slideDown forKey:nil];
    [bands addObject:band];
    [band release];
  }
  [CATransaction commit];
  
  [bands release];

#if USE_FLATTENED_LAYER
  CGColorSpaceRelease(colorSpace);
  CGContextRelease(context);
#endif  
}


@end
