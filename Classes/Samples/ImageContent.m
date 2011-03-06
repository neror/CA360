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

#import "ImageContent.h"

@implementation ImageContent

+ (NSString *)friendlyName {
  return @"Image Content";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  [simpleLayer_ release], simpleLayer_ = nil;
  [moneyLayer_ release], moneyLayer_ = nil;
  [magicButton_ release], magicButton_ = nil;
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];
  
  magicButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  magicButton_.frame = CGRectMake(10., 10., 300., 44.);
  [magicButton_ setTitle:@"Invoke Magic!" forState:UIControlStateNormal];
  [magicButton_ addTarget:self action:@selector(toggleMoney:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:magicButton_];

  simpleLayer_ = [[CALayer layer] retain];
  moneyLayer_ = [[CALayer layer] retain];

  [myView.layer addSublayer:simpleLayer_];
  [myView.layer addSublayer:moneyLayer_];
  
  self.view = myView;
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
  simpleLayer_.backgroundColor = [[UIColor clearColor] CGColor];
  simpleLayer_.bounds = CGRectMake(0., 0., 240., 66.);
  simpleLayer_.position = CGPointMake(160., 150.);
  simpleLayer_.contents = (id)[[UIImage imageNamed:@"FTSLogo.png"] CGImage];

  moneyLayer_.backgroundColor = [[UIColor clearColor] CGColor];
  moneyLayer_.bounds = CGRectMake(0., 0., 290., 125.);
  moneyLayer_.position = CGPointMake(160., 265.);
  moneyLayer_.delegate = self;
  [moneyLayer_ setValue:[NSNumber numberWithBool:YES] forKey:@"moneyImageIsBen"];
  [moneyLayer_ setNeedsDisplay];
}

- (void)viewWillDisappear:(BOOL)animated {
  moneyLayer_.delegate = nil;
}

- (void)displayLayer:(CALayer *)layer {
  if(layer == moneyLayer_) {
    if([[layer valueForKey:@"moneyImageIsBen"] boolValue]) {
      layer.contents = (id)[[UIImage imageNamed:@"Ben.png"] CGImage];
    } else {
      layer.contents = (id)[[UIImage imageNamed:@"Steve.png"] CGImage];
    }
  }
}

#pragma mark Event Handlers

- (void)toggleMoney:(id)sender {
  BOOL isBen = [[moneyLayer_ valueForKey:@"moneyImageIsBen"] boolValue];
  [moneyLayer_ setValue:[NSNumber numberWithBool:!isBen] forKey:@"moneyImageIsBen"];
  [moneyLayer_ setNeedsDisplay];
}

@end
