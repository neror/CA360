//
//  GradientLayers.m
//  CA360
//
//  Created by Nathan Eror on 8/15/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "GradientLayers.h"


@implementation GradientLayers

+ (NSString *)friendlyName {
  return @"Gradient Layers";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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
  myView.backgroundColor = [UIColor blackColor];
  self.view = myView;
}

- (void)viewDidUnload {
}

#pragma mark View drawing

- (void)viewWillAppear:(BOOL)animated {
}

- (void)viewDidAppear:(BOOL)animated {
}

@end
