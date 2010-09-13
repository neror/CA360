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

/*
 Delicious font by Jos Buivenga (exljbris) -> http://www.exljbris.com
 Retrieved from http://www.josbuivenga.demon.nl/delicious.html
*/

#import "TextLayers.h"
#import <CoreText/CoreText.h>

#define EXAMPLE_STRING \
@"Hello everyone! I am a CATextLayer.\n\n" \
@"I can render any attributed string you want. " \
@"Even if it's long like this one and wraps.\n\n" \
@"Want to see something really cool?\n\n" \
@"A blue link: http://www.freetimestudios.com/"


@implementation TextLayers

+ (NSString *)friendlyName {
  return @"Text Layers";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  [attributedTextLayer_ release], attributedTextLayer_ = nil;
  [normalTextLayer_ release], normalTextLayer_ = nil;
  [super dealloc];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];
  myView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
  self.view = myView;
  
  attributedTextLayer_ = [[CATextLayer alloc] init];
  attributedTextLayer_.frame = self.view.bounds;
  [self.view.layer addSublayer:attributedTextLayer_];
  
  UIButton *animateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [animateButton setTitle: @"Animate Text" forState:UIControlStateNormal];
  animateButton.bounds = CGRectMake(0.f, 0.f, self.view.bounds.size.width - 20.f, 44.f);
  animateButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height - 34.f);
  animateButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
  [animateButton addTarget:self action:@selector(animate) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:animateButton];
}

#pragma mark View drawing

- (void)colorAndUnderlineLinksInAttributedString:(NSMutableAttributedString *)attrString 
                                       withColor:(UIColor *)linkColor 
                                  underlineStyle:(CTUnderlineStyle)underlineStyle
{
  //NSDataDetector is part of the new (in iOS 4) regular expression engine
  Class nsDataDetector = NSClassFromString(@"NSDataDetector");
  if(nsDataDetector) {
    NSError *error = nil;
    id linkDetector = [nsDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:&error];
    NSAssert(error == nil, @"Problem creating the link detector: %@", [error localizedDescription]);
    [linkDetector enumerateMatchesInString:[attrString string]
                                   options:0 
                                     range:NSMakeRange(0, [attrString length]) 
                                usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop) 
     {
       [attrString addAttribute:(NSString *)kCTForegroundColorAttributeName 
                          value:(id)[linkColor CGColor] 
                          range:[match range]];
       
       [attrString addAttribute:(NSString *)kCTUnderlineStyleAttributeName 
                          value:[NSNumber numberWithInt:underlineStyle] 
                          range:[match range]];
     }];
  } else {
    SHOW_VERSION_ALERT_FOR_FEATURE(@"Link highlighting")
  }
}

- (CTFontRef)newFontWithAttributes:(NSDictionary *)attributes {
  CTFontDescriptorRef descriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attributes);
  CTFontRef font = CTFontCreateWithFontDescriptor(descriptor, 0, NULL);
  CFRelease(descriptor);
  return font;
}

- (CTFontRef)newCustomFontWithName:(NSString *)fontName ofType:(NSString *)type attributes:(NSDictionary *)attributes {
  NSString *fontPath = [[NSBundle mainBundle] pathForResource:fontName ofType:type];
  
  NSData *data = [[NSData alloc] initWithContentsOfFile:fontPath];
  CGDataProviderRef fontProvider = CGDataProviderCreateWithCFData((CFDataRef)data);
  [data release];
  
  CGFontRef cgFont = CGFontCreateWithDataProvider(fontProvider);
  CGDataProviderRelease(fontProvider);
  
  CTFontDescriptorRef fontDescriptor = CTFontDescriptorCreateWithAttributes((CFDictionaryRef)attributes);
  CTFontRef font = CTFontCreateWithGraphicsFont(cgFont, 0, NULL, fontDescriptor);
  CFRelease(fontDescriptor);
  CGFontRelease(cgFont);
  return font;
}

- (CGSize)suggestSizeAndFitRange:(CFRange *)range 
             forAttributedString:(NSMutableAttributedString *)attrString 
                       usingSize:(CGSize)referenceSize
{
  CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
  CGSize suggestedSize = 
  CTFramesetterSuggestFrameSizeWithConstraints(framesetter, 
                                               CFRangeMake(0, [attrString length]), 
                                               NULL,
                                               referenceSize,
                                               range);
  
  //HACK: There is a bug in Core Text where suggested size is not quite right
  //I'm padding it with half line height to make up for the bug.
  //see the coretext-dev list: http://web.archiveorange.com/archive/v/nagQXwVJ6Gzix0veMh09
  
  CTLineRef line = CTLineCreateWithAttributedString((CFAttributedStringRef)attrString);
  CGFloat ascent, descent, leading;
  CTLineGetTypographicBounds(line, &ascent, &descent, &leading);  
  CGFloat lineHeight = ascent + descent + leading;
  suggestedSize.height += lineHeight / 2.f;
  //END HACK
  
  return suggestedSize;
}

- (void)setupAttributedTextLayerWithFont:(CTFontRef)font {
  NSDictionary *baseAttributes = [NSDictionary dictionaryWithObject:(id)font 
                                                             forKey:(NSString *)kCTFontAttributeName];
  
  NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:EXAMPLE_STRING 
                                                                                 attributes:baseAttributes];
  CFRelease(font);  
  
  [self colorAndUnderlineLinksInAttributedString:attrString 
                                       withColor:[UIColor blueColor] 
                                  underlineStyle:kCTUnderlineStyleSingle|kCTUnderlinePatternDash];
  
  //Make the class name in the string Courier Bold and red
  NSDictionary *fontAttributes = [NSDictionary dictionaryWithObjectsAndKeys: 
                                  @"Courier", (NSString *)kCTFontFamilyNameAttribute,
                                  @"Bold", (NSString *)kCTFontStyleNameAttribute,
                                  [NSNumber numberWithFloat:16.f], (NSString *)kCTFontSizeAttribute,
                                  nil];
  CTFontRef courierFont = [self newFontWithAttributes:fontAttributes];
  
  NSRange rangeOfClassName = [[attrString string] rangeOfString:@"CATextLayer"];
  
  [attrString addAttribute:(NSString *)kCTFontAttributeName 
                     value:(id)courierFont 
                     range:rangeOfClassName];
  [attrString addAttribute:(NSString *)kCTForegroundColorAttributeName 
                     value:(id)[[UIColor redColor] CGColor] 
                     range:rangeOfClassName];
  
  CFRelease(courierFont);
  
  attributedTextLayer_.string = attrString;
  attributedTextLayer_.wrapped = YES;
  CFRange fitRange;
  CGRect textDisplayRect = CGRectInset(attributedTextLayer_.bounds, 10.f, 10.f);
  CGSize recommendedSize = [self suggestSizeAndFitRange:&fitRange 
                                    forAttributedString:attrString 
                                              usingSize:textDisplayRect.size];
  [attributedTextLayer_ setValue:[NSValue valueWithCGSize:recommendedSize] forKeyPath:@"bounds.size"];
  attributedTextLayer_.position = self.view.center;
  [attrString release];
}

- (void)viewWillAppear:(BOOL)animated {
  CTFontRef font = [self newCustomFontWithName:@"Delicious-Roman" 
                                        ofType:@"otf" 
                                    attributes:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:16.f] 
                                                                           forKey:(NSString *)kCTFontSizeAttribute]];
  [self setupAttributedTextLayerWithFont:font];
  
  normalTextLayer_ = [[CATextLayer alloc] init];
  normalTextLayer_.font = font;
  normalTextLayer_.string = @"This is just a plain old CATextLayer";
  normalTextLayer_.wrapped = YES;
  normalTextLayer_.foregroundColor = [[UIColor purpleColor] CGColor];
  normalTextLayer_.fontSize = 20.f;
  normalTextLayer_.alignmentMode = kCAAlignmentCenter;
  normalTextLayer_.frame = CGRectMake(0.f, 10.f, 320.f, 32.f);
  [self.view.layer addSublayer:normalTextLayer_];
  CFRelease(font);
}

- (void)viewDidAppear:(BOOL)animated {
}

#pragma mark Event Handlers

- (void)animate {
  CABasicAnimation *spin = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
  spin.toValue = [NSNumber numberWithFloat:M_PI * 2];
  spin.duration = 1.f;
  spin.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
  
  [CATransaction begin];
  if(IS_IOS4) {
    [CATransaction setCompletionBlock:^{
      CABasicAnimation *squish = [CABasicAnimation animationWithKeyPath:@"transform"];
      CATransform3D squishTransform = CATransform3DMakeScale(1.75f, .25f, 1.f);
      squish.toValue = [NSValue valueWithCATransform3D:squishTransform];
      squish.duration = .5f;
      squish.repeatCount = 1;
      squish.autoreverses = YES;
      
      CABasicAnimation *fadeOutBG = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
      fadeOutBG.toValue = (id)[[UIColor yellowColor] CGColor];
      fadeOutBG.duration = .55f;
      fadeOutBG.repeatCount = 1;
      fadeOutBG.autoreverses = YES;
      fadeOutBG.beginTime = 1.f;

      CAAnimationGroup *group = [CAAnimationGroup animation];
      group.animations = [NSArray arrayWithObjects:squish, fadeOutBG, nil];
      group.duration = 2.f;
      group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
      
      [attributedTextLayer_ addAnimation:group forKey:@"SquishAndHighlight"];
    }];
  }
  [attributedTextLayer_ addAnimation:spin forKey:@"spinTheText"];
  [CATransaction commit];
}


@end
