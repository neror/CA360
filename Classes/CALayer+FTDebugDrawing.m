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

#import "CALayer+FTDebugDrawing.h"


@implementation CALayer (FTDebugDrawing)

- (void)debugDrawPoint:(CGPoint)point inContext:(CGContextRef)context withSize:(CGSize)size color:(UIColor *)color {
  CGRect rect = CGRectMake(point.x - (size.width / 2), point.y - (size.height / 2), size.width, size.height);
  CGContextAddEllipseInRect(context, rect);
  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextDrawPath(context, kCGPathFill);
}

- (void)debugDrawAnchorPointInContext:(CGContextRef)context withSize:(CGSize)size color:(UIColor *)color {
  CGSize layerSize = self.bounds.size;
  CGPoint realAnchorPoint = CGPointMake(layerSize.width * self.anchorPoint.x, layerSize.height * self.anchorPoint.y);
  [self debugDrawPoint:realAnchorPoint inContext:context withSize:size color:color];
}

- (void)debugDrawBoundingBoxInContext:(CGContextRef)context withLineWidth:(CGFloat)lineWidth color:(UIColor *)color {
  CGContextAddRect(context, self.bounds);
  CGContextSetStrokeColorWithColor(context, [color CGColor]);
  CGContextSetLineWidth(context, lineWidth);
  CGContextDrawPath(context, kCGPathStroke);
}

@end
