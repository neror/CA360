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

const static CGPoint kSimpleLayerStartPosition = { 160., 310. };

@implementation LayerTransforms

@synthesize cumulative = cumulative_;

+ (NSString *)friendlyName {
  return @"Layer Transforms";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = [[self class] friendlyName];
    self.cumulative = YES;
  }
  return self;
}

- (void)dealloc {
  FTRELEASE(simpleLayer_);
  FTRELEASE(moveAnchorPointButton_);
  FTRELEASE(rotateButton_);
  FTRELEASE(scaleButton_);
  FTRELEASE(translateButton_);
  FTRELEASE(propertiesTextView_);
  FTRELEASE(resetButton_);
  FTRELEASE(cumulativeSwitch_);
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];
  
  moveAnchorPointButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  moveAnchorPointButton_.frame = CGRectMake(10., 10., 145., 44.);
  [moveAnchorPointButton_ setTitle:@"Move Anchor Point" forState:UIControlStateNormal];
  [moveAnchorPointButton_ addTarget:self action:@selector(moveAnchorPoint:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:moveAnchorPointButton_];
  
  rotateButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  rotateButton_.frame = CGRectMake(165., 10., 145., 44.);
  [rotateButton_ setTitle:@"Rotate" forState:UIControlStateNormal];
  [rotateButton_ addTarget:self action:@selector(rotate:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:rotateButton_];
  

  scaleButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  scaleButton_.frame = CGRectMake(10., 60., 145., 44.);
  [scaleButton_ setTitle:@"Scale" forState:UIControlStateNormal];
  [scaleButton_ addTarget:self action:@selector(scale:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:scaleButton_];
  
  translateButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  translateButton_.frame = CGRectMake(165., 60., 145., 44.);
  [translateButton_ setTitle:@"Tanslate" forState:UIControlStateNormal];
  [translateButton_ addTarget:self action:@selector(translate:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:translateButton_];

  resetButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  resetButton_.frame = CGRectMake(10., 110., 145., 44.);
  [resetButton_ setTitle:@"Reset" forState:UIControlStateNormal];
  [resetButton_ addTarget:self action:@selector(reset:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:resetButton_];
  
  cumulativeSwitch_ = [[UISwitch alloc] initWithFrame:CGRectZero];
  CGRect rect = CGRectMake(165., 110., 145., 44.);
  CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
  cumulativeSwitch_.center = center;
  cumulativeSwitch_.on = self.cumulative;
  [cumulativeSwitch_ addTarget:self action:@selector(toggleCumulative:) forControlEvents:UIControlEventValueChanged];
  [myView addSubview:cumulativeSwitch_];
  
  propertiesTextView_ = [[UITextView alloc] initWithFrame:CGRectMake(0., 160., 320., 44.)];
  propertiesTextView_.backgroundColor = [UIColor clearColor];
  propertiesTextView_.editable = NO;
  propertiesTextView_.textAlignment = UITextAlignmentCenter;
  propertiesTextView_.font = [UIFont systemFontOfSize:12.];
  [myView addSubview:propertiesTextView_];
  
  simpleLayer_ = [[CALayer layer] retain];
  [myView.layer addSublayer:simpleLayer_];
  self.view = myView;
}

#pragma mark View drawing

- (void)updatePropertiesLabel {
  propertiesTextView_.text = [NSString stringWithFormat:@"Bounds: %@  Position: %@\nFrame: %@  Anchor Point: %@",
                              NSStringFromCGRect(simpleLayer_.bounds), 
                              NSStringFromCGPoint(simpleLayer_.position),
                              NSStringFromCGRect(simpleLayer_.frame), 
                              NSStringFromCGPoint(simpleLayer_.anchorPoint)];
}

- (void)viewWillAppear:(BOOL)animated {  
  simpleLayer_.backgroundColor = [UIColorFromRGBA(0x00FF00, .85) CGColor];
  simpleLayer_.bounds = CGRectMake(0., 0., 200., 200.);
  simpleLayer_.position = kSimpleLayerStartPosition;
  simpleLayer_.transform = CATransform3DIdentity;
  simpleLayer_.delegate = self;
  [simpleLayer_ setNeedsDisplay];
  [self updatePropertiesLabel];
}

- (void)viewWillDisappear:(BOOL)animated {
  simpleLayer_.delegate = nil;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)context {
  [layer debugDrawAnchorPointInContext:context withSize:CGSizeMake(8., 8.) color:[UIColor redColor]];
}

#pragma mark Button Event Handlers

- (void)moveAnchorPoint:(id)sender {
  if(CGPointEqualToPoint(simpleLayer_.anchorPoint, CGPointZero)) {
    simpleLayer_.anchorPoint = CGPointMake(.5, .5);
  } else {
    simpleLayer_.anchorPoint = CGPointZero;
  }
  [simpleLayer_ setNeedsDisplay];
  [self updatePropertiesLabel];
}

- (void)rotate:(id)sender {
  if(self.cumulative) {
//    CATransform3D perspective = CATransform3DIdentity;
//    perspective.m34 = 1 / -2000.;
//    self.view.layer.sublayerTransform = perspective;
    CATransform3D currentTransform = simpleLayer_.transform;
    CATransform3D rotated = CATransform3DRotate(currentTransform, 45., 0., 0., 1.);
    simpleLayer_.transform = rotated;
  } else {
    self.view.layer.sublayerTransform = CATransform3DIdentity;
    simpleLayer_.transform = CATransform3DIdentity;
    [simpleLayer_ setValue:[NSNumber numberWithFloat:45.] forKeyPath:@"transform.rotation.x"];
  }
  [simpleLayer_ setNeedsDisplay];
  [self updatePropertiesLabel];
}

- (void)scale:(id)sender {
  if(self.cumulative) {
    CATransform3D currentTransform = simpleLayer_.transform;
    CATransform3D scaled = CATransform3DScale(currentTransform, 1.5, 1.5, 1.5);
    simpleLayer_.transform = scaled;
  } else {
    simpleLayer_.transform = CATransform3DIdentity;
    [simpleLayer_ setValue:[NSNumber numberWithFloat:1.5] forKeyPath:@"transform.scale"];
  }
  [simpleLayer_ setNeedsDisplay];
  [self updatePropertiesLabel];
}

- (void)translate:(id)sender {
  CATransform3D translated;
  if(self.cumulative) {
    CATransform3D currentTransform = simpleLayer_.transform;
    translated = CATransform3DTranslate(currentTransform, 0., 0., -20.);
  } else {
    // The following is equvalent to:
    // translated = CATransform3DMakeTranslation(50., 50., 0.);
    translated = CATransform3DIdentity;
    translated.m41 = 50.;
    translated.m42 = 50.;
  }
  simpleLayer_.transform = translated;
  [simpleLayer_ setNeedsDisplay];
  [self updatePropertiesLabel];
}

- (void)reset:(id)sender {
  simpleLayer_.transform = CATransform3DIdentity;
  [simpleLayer_ setNeedsDisplay];
  [self updatePropertiesLabel];
}

- (void)toggleCumulative:(id)sender {
  self.cumulative = [(UISwitch *)sender isOn];
}

@end