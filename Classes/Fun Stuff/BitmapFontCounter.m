#import "BitmapFontCounter.h"
#import <QuartzCore/QuartzCore.h>

static const CGFloat kDigitWidth = 32.f;
static const CGFloat kDigitHeight = 26.f;
static const unichar kCharacterOffset = 48;


@implementation CounterView

- (CounterView *)initWithNumber:(double)num {
  if (self = [super initWithFrame:CGRectMake(0.f, 0.f, kDigitWidth, kDigitHeight)]) {
    digitLayers_ = [[NSMutableArray alloc] init];
    [self setNumber:num];
  }
  return self;
}

- (void)dealloc {
  [numberString_ release], numberString_ = nil;
  [digitLayers_ release], digitLayers_ = nil;
  [super dealloc];
}

- (double)number {
    return number_;
}

- (void)setNumber:(double)num {
  number_ = num;
  [digitLayers_ makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
  [numberString_ release], numberString_ = nil;
  numberString_ = [[NSString stringWithFormat:@"%.0F", num] retain];
  
  NSUInteger count = [numberString_ length];
  [self setBounds:CGRectMake(0.f, 0.f, (CGFloat)count * kDigitWidth, kDigitHeight)];
  
  for(NSUInteger i = 0; i < count; i++) {
    CALayer *theLayer = [self layerForDigitAtIndex:i];
    int theNumber = (int)([numberString_ characterAtIndex:i] - kCharacterOffset);
    if(theNumber < 0) {
      theNumber = 10;
    }
    CGFloat height = 1.f/11.f;
    CGFloat width = 1.f;
    CGRect contentsRect = CGRectMake(0.f, theNumber * height, width, height);
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    theLayer.frame = CGRectMake(kDigitWidth * i, 0.f, kDigitWidth, kDigitHeight);
    [CATransaction begin];
    [CATransaction setDisableActions:(theNumber == 10)];
    theLayer.contentsRect = contentsRect;
    [CATransaction commit];
    [CATransaction commit];
    
    [self.layer addSublayer:theLayer];
  }
}

- (CALayer *)layerForDigitAtIndex:(NSUInteger)index {
  CALayer *theLayer;
  if(index >= [digitLayers_ count] || 
     (theLayer = [digitLayers_ objectAtIndex:index]) == nil)
  {
    theLayer = [CALayer layer];
    theLayer.anchorPoint = CGPointZero;
    theLayer.masksToBounds = YES;
    theLayer.frame = CGRectMake(0.f, 0.f, kDigitWidth, kDigitHeight);
    theLayer.contentsGravity = kCAGravityCenter;
    theLayer.contents = (id)[[UIImage imageNamed:@"NumberStrip.png"] CGImage];
    
    CGFloat height = 1.f/11.f;
    CGFloat width = 1.f;
    theLayer.contentsRect = CGRectMake(0.f, height, width, height);
    
    [digitLayers_ insertObject:theLayer atIndex:index];
  }
  return theLayer;
}


@end


@implementation BitmapFontCounter

+ (NSString *)friendlyName {
  return @"Bitmap Font Counter";
}

#pragma mark init and dealloc

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
    self.title = [[self class] friendlyName];
  }
  return self;
}

- (void)dealloc {
  [counter_ release], counter_ = nil;
  [textField_ release], textField_ = nil;
  [setNumberButton_ release], setNumberButton_ = nil;
  [super dealloc];
}

#pragma mark Event Handlers
- (void)updateNumber:(id)sender {
  [counter_ setNumber:[textField_.text doubleValue]];
}

#pragma mark Load and unload the view

- (void)loadView {
  UIView *myView = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
  myView.backgroundColor = [UIColor whiteColor];
  
  setNumberButton_ = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
  setNumberButton_.frame = CGRectMake(10., 56., 300., 36.);
  [setNumberButton_ setTitle:@"Update Number" forState:UIControlStateNormal];
  [setNumberButton_ addTarget:self action:@selector(updateNumber:) forControlEvents:UIControlEventTouchUpInside];
  [myView addSubview:setNumberButton_];
  
  textField_ = [[UITextField alloc] initWithFrame:CGRectMake(10., 10., 300., 36.)];
  textField_.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
  textField_.clearButtonMode = UITextFieldViewModeWhileEditing;
  textField_.borderStyle = UITextBorderStyleRoundedRect;
  textField_.text = @"1919";
  [myView addSubview:textField_];
  
  counter_ = [[CounterView alloc] initWithNumber:1919.f];
  counter_.center = CGPointMake(160.f, 160.f);
  [myView addSubview:counter_];
  
  self.view = myView;
}

- (void)viewDidAppear:(BOOL)animated {
  [textField_ becomeFirstResponder];
}

@end
