#pragma mark -
#pragma mark Math

#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
#define RADIANS_TO_DEGREES(r) (r * 180 / M_PI)

#pragma mark -
#pragma mark Colors

#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:1.f]

#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/256.f green:g/256.f blue:b/256.f alpha:a]

#define UIColorFromRGB(rgbValue) \
[UIColor \
  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
         green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
          blue:((float)(rgbValue & 0x0000FF))/255.0 \
         alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
  colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
         green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
          blue:((float)(rgbValue & 0x0000FF))/255.0 \
         alpha:alphaValue]

#pragma mark -
#pragma mark iOS 4 Version Checkers

#define IS_IOS4 ([[[UIDevice currentDevice] systemVersion] hasPrefix:@"4"])

#define CA360_SAMPLE_IOS4_ONLY \
if(!IS_IOS4) { \
  UILabel *badVersionLabel = [[UILabel alloc] initWithFrame:self.view.frame]; \
  badVersionLabel.text = @"This sample only works on iOS 4+"; \
  badVersionLabel.font = [UIFont boldSystemFontOfSize:26.f]; \
  badVersionLabel.textColor = [UIColor blackColor]; \
  badVersionLabel.textAlignment = UITextAlignmentCenter; \
  badVersionLabel.adjustsFontSizeToFitWidth = YES; \
  [self.view addSubview:badVersionLabel]; \
  [badVersionLabel release]; \
  NSLog(@"The sample '%@' only works in iOS 4+", [[self class] friendlyName]); \
  return; \
}

#define SHOW_VERSION_ALERT_FOR_FEATURE(__featureName) \
UIAlertView *__versionAlert = \
 [[[UIAlertView alloc] initWithTitle:@"Version Warning" \
                             message:[NSString stringWithFormat:@"%@ uses features added " \
                                                                @"in iOS 4, and it will only work on " \
                                                                @"devices running iOS 4.0 or higher.", \
                                                                __featureName] \
                                                       delegate:nil \
                                              cancelButtonTitle:@"OK" \
                                              otherButtonTitles:nil] autorelease]; \
  [__versionAlert show];
