#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// ============================================================================
// ⚙️ إعدادات التخصيص السريعة (عدّل بياناتك هنا بسهولة)
// ============================================================================
#define DEV_BADGE_TEXT      @"VIP EDITION • MODIFIED"
#define WELCOME_TITLE       @"HAIDER AL SULTAN"
#define WELCOME_SUBTITLE    @"تم تعديل وتطوير هذا التطبيق بأحدث التقنيات لضمان أفضل أداء وتجربة مستخدم سلسة."

// الروابط
#define CHANNEL_URL         @"https://t.me/YourChannel"
#define SUPPORT_URL         @"https://t.me/YourUsername"

// النصوص على الأزرار
#define CHANNEL_BTN_TEXT    @"انضم لقناتنا على تيليجرام"
#define SUPPORT_BTN_TEXT    @"تواصل مع المطور"
#define CONTINUE_BTN_TEXT   @"متابعة إلى التطبيق"

// اللون الأساسي للواجهة (RGB) - حالياً أزرق سماوي نيون احترافي
#define ACCENT_COLOR        [UIColor colorWithRed:0.04 green:0.52 blue:1.00 alpha:1.0]
// ============================================================================

@interface HaiderWelcomeManager : NSObject
@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIView *cardView;
@property (nonatomic, strong) UIButton *floatingBtn;
+ (instancetype)sharedInstance;
- (void)showWelcomePopup;
- (void)setupFloatingButton;
@end

@implementation HaiderWelcomeManager

+ (instancetype)sharedInstance {
    static HaiderWelcomeManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (UIWindow *)getKeyWindow {
    UIWindow *foundWindow = nil;
    NSArray *windows = [[UIApplication sharedApplication] windows];
    for (UIWindow *window in windows) {
        if (window.isKeyWindow) {
            foundWindow = window;
            break;
        }
    }
    if (!foundWindow && windows.count > 0) {
        foundWindow = windows.firstObject;
    }
    return foundWindow;
}

#pragma mark - إنشاء وعرض الواجهة الترحيبية
- (void)showWelcomePopup {
    if (self.overlayView) return; // منع التكرار إذا كانت مفتوحة
    
    UIWindow *window = [self getKeyWindow];
    if (!window) return;
    
    // 1. الخلفية المعتمة
    self.overlayView = [[UIView alloc] initWithFrame:window.bounds];
    self.overlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.65];
    self.overlayView.alpha = 0.0;
    [window addSubview:self.overlayView];
    
    // 2. البطاقة الزجاجية الرئيسية
    CGFloat cardWidth = MIN(window.bounds.size.width - 48, 340);
    CGFloat cardHeight = 350;
    self.cardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, cardHeight)];
    self.cardView.center = window.center;
    self.cardView.layer.cornerRadius = 26;
    self.cardView.clipsToBounds = YES;
    self.cardView.layer.borderWidth = 1.2;
    self.cardView.layer.borderColor = [UIColor colorWithWhite:1.0 alpha:0.18].CGColor;
    
    // تأثير الضبابية (Glassmorphism)
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleSystemUltraThinMaterialDark];
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    blurView.frame = self.cardView.bounds;
    [self.cardView addSubview:blurView];
    
    // شريط علوي مضيء خفيف
    UIView *topGlow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, 4)];
    topGlow.backgroundColor = ACCENT_COLOR;
    [self.cardView addSubview:topGlow];
    
    // 3. شارة المطور (Badge)
    UILabel *badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake((cardWidth - 180)/2, 24, 180, 24)];
    badgeLabel.text = DEV_BADGE_TEXT;
    badgeLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
    badgeLabel.textColor = ACCENT_COLOR;
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.backgroundColor = [ACCENT_COLOR colorWithAlphaComponent:0.15];
    badgeLabel.layer.cornerRadius = 12;
    badgeLabel.clipsToBounds = YES;
    [self.cardView addSubview:badgeLabel];
    
    // 4. الاسم / العنوان الرئيسي
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 62, cardWidth - 40, 32)];
    titleLabel.text = WELCOME_TITLE;
    titleLabel.font = [UIFont systemFontOfSize:22 weight:UIFontWeightHeavy];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.cardView addSubview:titleLabel];
    
    // 5. النص الفرعي
    UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(24, 100, cardWidth - 48, 60)];
    subLabel.text = WELCOME_SUBTITLE;
    subLabel.font = [UIFont systemFontOfSize:13.5 weight:UIFontWeightRegular];
    subLabel.textColor = [UIColor colorWithWhite:0.82 alpha:1.0];
    subLabel.textAlignment = NSTextAlignmentCenter;
    subLabel.numberOfLines = 3;
    [self.cardView addSubview:subLabel];
    
    // 6. الأزرار التفاعلية
    CGFloat btnWidth = cardWidth - 48;
    CGFloat btnHeight = 44;
    
    // زر القناة الرئيسي
    UIButton *channelBtn = [self createStyledButtonWithTitle:CHANNEL_BTN_TEXT
                                                      frame:CGRectMake(24, 175, btnWidth, btnHeight)
                                                    bgColor:ACCENT_COLOR
                                                  textColor:[UIColor whiteColor]
                                                borderColor:nil];
    [channelBtn addTarget:self action:@selector(openChannel) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:channelBtn];
    
    // زر الدعم الفني
    UIButton *supportBtn = [self createStyledButtonWithTitle:SUPPORT_BTN_TEXT
                                                      frame:CGRectMake(24, 229, btnWidth, btnHeight)
                                                    bgColor:[UIColor colorWithWhite:1.0 alpha:0.08]
                                                  textColor:[UIColor whiteColor]
                                                borderColor:[UIColor colorWithWhite:1.0 alpha:0.15]];
    [supportBtn addTarget:self action:@selector(openSupport) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:supportBtn];
    
    // زر الإغلاق / المتابعة
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(24, 286, btnWidth, 40);
    [closeBtn setTitle:CONTINUE_BTN_TEXT forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor colorWithWhite:0.65 alpha:1.0] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightSemibold];
    [closeBtn addTarget:self action:@selector(dismissPopup) forControlEvents:UIControlEventTouchUpInside];
    [self.cardView addSubview:closeBtn];
    
    [self.overlayView addSubview:self.cardView];
    
    // 7. أنيميشن الدخول (Spring Effect)
    self.cardView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.45
                          delay:0.0
         usingSpringWithDamping:0.75
          initialSpringVelocity:0.5
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        self.overlayView.alpha = 1.0;
        self.cardView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (UIButton *)createStyledButtonWithTitle:(NSString *)title frame:(CGRect)frame bgColor:(UIColor *)bgColor textColor:(UIColor *)textColor borderColor:(UIColor *)borderColor {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = frame;
    btn.backgroundColor = bgColor;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14.5 weight:UIFontWeightBold];
    btn.layer.cornerRadius = 14;
    if (borderColor) {
        btn.layer.borderWidth = 1.0;
        btn.layer.borderColor = borderColor.CGColor;
    }
    return btn;
}

#pragma mark - الإجراءات (Actions)
- (void)openChannel {
    NSURL *url = [NSURL URLWithString:CHANNEL_URL];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (void)openSupport {
    NSURL *url = [NSURL URLWithString:SUPPORT_URL];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
}

- (void)dismissPopup {
    [UIView animateWithDuration:0.25 animations:^{
        self.overlayView.alpha = 0.0;
        self.cardView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    } completion:^(BOOL finished) {
        [self.overlayView removeFromSuperview];
        self.overlayView = nil;
        self.cardView = nil;
    }];
}

#pragma mark - الزر العائم الذكي
- (void)setupFloatingButton {
    if (self.floatingBtn) return;
    UIWindow *window = [self getKeyWindow];
    if (!window) return;
    
    self.floatingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.floatingBtn.frame = CGRectMake(window.bounds.size.width - 54, 140, 42, 42);
    self.floatingBtn.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.85];
    self.floatingBtn.layer.cornerRadius = 21;
    self.floatingBtn.layer.borderWidth = 1.5;
    self.floatingBtn.layer.borderColor = ACCENT_COLOR.CGColor;
    
    // ظل احترافي للزر العائم
    self.floatingBtn.layer.shadowColor = ACCENT_COLOR.CGColor;
    self.floatingBtn.layer.shadowOffset = CGSizeMake(0, 2);
    self.floatingBtn.layer.shadowOpacity = 0.5;
    self.floatingBtn.layer.shadowRadius = 6;
    
    // أيقونة داخل الزر (حرف H أو رمز)
    [self.floatingBtn setTitle:@"⚡" forState:UIControlStateNormal];
    self.floatingBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [self.floatingBtn addTarget:self action:@selector(showWelcomePopup) forControlEvents:UIControlEventTouchUpInside];
    
    // إضافة إمكانية السحب (Drag) في أي مكان بالشاشة
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self.floatingBtn addGestureRecognizer:pan];
    
    [window addSubview:self.floatingBtn];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    UIWindow *window = [self getKeyWindow];
    CGPoint translation = [pan translationInView:window];
    pan.view.center = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
    [pan setTranslation:CGPointZero inView:window];
    
    // التصاق تلقائي بالحواف عند الإفلات
    if (pan.state == UIGestureRecognizerStateEnded) {
        CGFloat screenWidth = window.bounds.size.width;
        CGFloat targetX = (pan.view.center.x < screenWidth / 2) ? 32 : (screenWidth - 32);
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:0 animations:^{
            pan.view.center = CGPointMake(targetX, pan.view.center.y);
        } completion:nil];
    }
}

@end

#pragma mark - نقطة الدخول التلقائية عند تشغيل التطبيق
static void __attribute__((constructor)) initialize_welcome_dylib(void) {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        HaiderWelcomeManager *manager = [HaiderWelcomeManager sharedInstance];
        [manager setupFloatingButton];
        [manager showWelcomePopup];
    });
}
