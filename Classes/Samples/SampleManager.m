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

#import "SampleManager.h"
#import <objc/runtime.h>
#import "LayerTree.h"
#import "ShapeLayers.h"
#import "GeometryProperties.h"
#import "LayerDrawing.h"
#import "BasicAnimation.h"
#import "KeyframeAnimation.h"
#import "GradientLayers.h"
#import "LayerTransforms.h"
#import "ImageContent.h"
#import "StyleProperties.h"
#import "LayerActions.h"
#import "AnimationTransactions.h"
#import "AnimationGroups.h"

@interface SampleManager ()

+ (SampleManager *)sharedSampleManager;

@end

@interface UIViewController (ThisIsHereToAviodACompilerWarning)

+ (NSString *)friendlyName;

@end

@implementation SampleManager

#pragma mark -
#pragma mark Singleton Management

static SampleManager *sharedSampleManager = nil;

+ (SampleManager *)sharedSampleManager {
  @synchronized(self) {
    if (sharedSampleManager == nil) {
      sharedSampleManager = [[self alloc] init];
    }
  }
  return sharedSampleManager;
}

- (id)init {
  self = [super init];
  if (self != nil) {
    NSArray *geom = [NSArray arrayWithObjects:[GeometryProperties class], [LayerTransforms class], nil];
    NSArray *hier = [NSArray arrayWithObjects:[LayerTree class], nil];
    NSArray *drawing = [NSArray arrayWithObjects:[ImageContent class], [LayerDrawing class], [StyleProperties class], nil];
    NSArray *animation = [NSArray arrayWithObjects:[BasicAnimation class], [AnimationGroups class], 
                          [AnimationTransactions class], [KeyframeAnimation class], [LayerActions class], nil];
    NSArray *special = [NSArray arrayWithObjects:[ShapeLayers class], [GradientLayers class], nil];
    
    
    groups_ = [[NSArray alloc] initWithObjects:@"Geometry & Transforms",
                                               @"Layer Hierarchy",
                                               @"Content & Style Properties",
                                               @"Animation",
                                               @"Special Layer Types",
                                               nil];
    
    samples_ = [[NSArray alloc] initWithObjects:geom, hier, drawing, animation, special, nil]; 
  }
  return self;
}

#pragma mark -
#pragma mark Public class methods

+ (NSUInteger)groupCount {
  SampleManager *SELF = [SampleManager sharedSampleManager];
  return [SELF->groups_ count];
}

+ (NSUInteger)sampleCountForGroup:(NSUInteger)group {
  SampleManager *SELF = [SampleManager sharedSampleManager];
  return [[SELF->samples_ objectAtIndex:group] count];
}

+ (NSArray *)samplesForGroup:(NSUInteger)group {
  SampleManager *SELF = [SampleManager sharedSampleManager];
  return [[[SELF->samples_ objectAtIndex:group] copy] autorelease];
}

+ (NSString *)sampleNameAtIndexPath:(NSIndexPath *)indexPath {
  SampleManager *SELF = [SampleManager sharedSampleManager];
  NSArray *samples = [SELF->samples_ objectAtIndex:indexPath.section];
  Class clazz = [samples objectAtIndex:indexPath.row];
  return [clazz friendlyName];
}

+ (UIViewController *)sampleInstanceAtIndexPath:(NSIndexPath *)indexPath {
  SampleManager *SELF = [SampleManager sharedSampleManager];
  NSArray *samples = [SELF->samples_ objectAtIndex:indexPath.section];
  Class clazz = [samples objectAtIndex:indexPath.row];
  UIViewController *instance = [[clazz alloc] initWithNibName:nil bundle:nil];
  return [instance autorelease];
}

+ (NSString *)groupTitleAtIndex:(NSUInteger)index {
  SampleManager *SELF = [SampleManager sharedSampleManager];
 return [[[SELF->groups_ objectAtIndex:index] copy] autorelease];
}

@end
