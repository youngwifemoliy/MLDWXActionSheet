//
//  MLDWXActionSheet.m
//  JJStudy
//
//  Created by MoliySDev on 2019/7/23.
//  Copyright © 2019 Moliy. All rights reserved.
//

#import "MLDWXActionSheet.h"

#define MLDHeight_44 44
#define MLDHeight_50 50
#define MLDHeight_60 60
#define MLDlineHeight  0.5
#define MLDLineSpacing 5

#define MLDSize_5  5
#define MLDSize_13 13
#define MLDSize_14 14
#define MLDConfirmSize 16
#define MLDSize_40 40

#define kScreenCenter self.window.center

#define MLDWXActionSheet_SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define MLDWXActionSheet_SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//Color
//"毁灭"颜色
#define MLDDestructiveColor [UIColor redColor]
//取消颜色
#define MLDCancelColor [UIColor colorWithRed:1.00 green:0.75 blue:0.00 alpha:1.00]
//分割线颜色
#define MLDLineColor [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00]
//"取消"与上面的分割线
#define MLDSeparatorColor [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.00]

#define MLDTitleBackgroundColor [UIColor colorWithRed:0.96 green:0.97 blue:0.98 alpha:1.00]

#define MLDTitleTextColor [UIColor colorWithRed:0.77 green:0.77 blue:0.77 alpha:1.00]

@interface MLDWXActionSheet ()
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString  *title;
@property (nonatomic, strong) NSArray *confirms;
@property (nonatomic, strong) NSString *cancel;
@property (nonatomic, strong) UIView *shadowView;
@property (nonatomic, assign) MLDWXActionSheetStyle style;
@property(nonatomic ,strong) ClickBlock clickBlock;
@property(nonatomic ,strong) HideBlock hideBlock;
@end

@implementation MLDWXActionSheet

+ (MLDWXActionSheet *)actionSheetWithTitle:(NSString *)title
                                  confirms:(NSArray *)confirms
                                    cancel:(NSString *)cancel
                                     style:(MLDWXActionSheetStyle)style {
    return [[self alloc] initWithTitle:title
                              confirms:confirms
                                cancel:cancel
                                 style:style];
}

+ (MLDWXActionSheet *)actionSheetWithTitle:(NSString *)title
                                  confirms:(NSArray *)confirms
                                    cancel:(NSString *)cancel
                                     style:(MLDWXActionSheetStyle)style
                                     click:(ClickBlock)click
                                     hiden:(HideBlock)hiden {
    return [[self alloc] initWithTitle:title
                              confirms:confirms
                                cancel:cancel
                                 style:style
                                 click:click
                                 hiden:hiden];
}

#pragma mark - 初始化控件

- (instancetype)initWithTitle:(NSString *)title
                     confirms:(NSArray *)confirms
                       cancel:(NSString *)cancel
                        style:(MLDWXActionSheetStyle)style {
    self = [super init];
    if (self) {
        self.title = title;
        self.confirms = confirms;
        self.cancel = cancel;
        self.style = style;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews];
    }
    return self;
}

#pragma mark - 初始化控件

- (instancetype)initWithTitle:(NSString *)title
                     confirms:(NSArray *)confirms
                       cancel:(NSString *)cancel
                        style:(MLDWXActionSheetStyle)style
                        click:(ClickBlock)click
                        hiden:(HideBlock)hiden {
    self = [super init];
    if (self) {
        self.title = title;
        self.confirms = confirms;
        self.cancel = cancel;
        self.style = style;
        self.clickBlock = click;
        self.hideBlock = hiden;
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self createSubViews];
    }
    return self;
}

- (UIView *)shadowView {
    if (!_shadowView) {
        _shadowView = [[UIView alloc] init];
        _shadowView.frame = CGRectMake(0, 0,
                                       MLDWXActionSheet_SCREEN_WIDTH,
                                       MLDWXActionSheet_SCREEN_HEIGHT);
        _shadowView.backgroundColor = [UIColor blackColor];
        _shadowView.alpha = 0.4;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(tapAction)];
        [_shadowView addGestureRecognizer:tap];
    }
    return _shadowView;
}

- (void)createSubViews {
    CGFloat titleHeight = 0;
    CGFloat confirmHeight = 0;
    CGFloat separatorHeight = 0;
    CGFloat cancelHeight = 0;
    /** 提示信息 */
    if (self.title &&
        self.title.length) {
        UIFont *font = [UIFont systemFontOfSize:MLDSize_13];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = MLDLineSpacing;
        NSDictionary *attributes = @{NSFontAttributeName:font,
                                     NSParagraphStyleAttributeName:paragraphStyle.copy};
        CGSize maxSize = CGSizeMake(MLDWXActionSheet_SCREEN_WIDTH,
                                    MLDWXActionSheet_SCREEN_HEIGHT);
        CGSize titleSize = [self.title boundingRectWithSize:maxSize
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil].size;
        titleHeight = titleSize.height + 16;
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.numberOfLines = 0;
        titleLabel.textColor = MLDTitleTextColor;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:MLDSize_13];
        titleLabel.frame = CGRectMake(0, 0, MLDWXActionSheet_SCREEN_WIDTH, titleHeight);
        titleLabel.text = self.title;
        titleLabel.backgroundColor = MLDTitleBackgroundColor;
        [self addSubview:titleLabel];
    }
    
    /** 选项按钮 */
    CGFloat buttonHeight;
    if (MLDWXActionSheet_SCREEN_WIDTH <= 320) {
        buttonHeight = MLDHeight_44;
    }else if (MLDWXActionSheet_SCREEN_WIDTH <=375) {
        buttonHeight = MLDHeight_50;
    }else{
        buttonHeight = MLDHeight_60;
    }
    for (int i=0; i<self.confirms.count; i++) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = [UIColor whiteColor];
        if ((!self.title ||
             !self.title.length) &&
            i==0) {
            line.frame = CGRectZero;
        }else{
            line.frame = CGRectMake(0,
                                    titleHeight + i*(buttonHeight + MLDlineHeight),
                                    MLDWXActionSheet_SCREEN_WIDTH,
                                    MLDlineHeight);
        }
        
        line.backgroundColor = MLDLineColor;
        [self addSubview:line];
        confirmHeight += MLDlineHeight;
        UIButton *confirm = [UIButton buttonWithType:UIButtonTypeCustom];
        confirm.frame = CGRectMake(0,
                                   line.frame.origin.y + MLDlineHeight,
                                   MLDWXActionSheet_SCREEN_WIDTH,
                                   buttonHeight);
        [confirm setTitle:self.confirms[i] forState:UIControlStateNormal];
        confirm.titleLabel.font = [UIFont systemFontOfSize:MLDConfirmSize];
        [confirm setTitleColor:[UIColor blackColor]
                      forState:UIControlStateNormal];
        if (self.style == MLDWXActionSheetStyleDestructive) {
            [confirm setTitleColor:MLDDestructiveColor forState:UIControlStateNormal];
        }else if(self.style == MLDWXActionSheetStyleCancel){
            confirm.titleLabel.font = [UIFont boldSystemFontOfSize:MLDConfirmSize];
        }
        if ([self.confirms[i] isEqualToString:@"删除"]) {
            [confirm setTitleColor:MLDDestructiveColor forState:UIControlStateNormal];
        }
        [confirm addTarget:self
                    action:@selector(button:clickAtIndex:)
          forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:confirm];
        confirmHeight += buttonHeight;
    }
    
    /** 确定/取消之间的分割线 */
    UIView *separator = [[UIView alloc] init];
    separator.backgroundColor = MLDSeparatorColor;
    separator.frame = CGRectMake(0, titleHeight + confirmHeight, MLDWXActionSheet_SCREEN_WIDTH, MLDSize_5);
    [self addSubview:separator];
    separatorHeight = MLDSize_5;
    
    /** 取消 */
    if (MLDWXActionSheet_SCREEN_WIDTH <= 320) {
        cancelHeight = MLDHeight_44;
    }else if (MLDWXActionSheet_SCREEN_WIDTH <=375){
        cancelHeight = MLDHeight_50;
    }else{
        cancelHeight = MLDHeight_60;
    }
    CGFloat cancelY = titleHeight + confirmHeight + separatorHeight;
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, cancelY, MLDWXActionSheet_SCREEN_WIDTH, cancelHeight);
    [cancel setTitleColor:MLDCancelColor forState:UIControlStateNormal];
    [cancel setTitle:self.cancel forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:MLDConfirmSize
                                               weight:UIFontWeightSemibold];
    [cancel addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancel];
    cancelHeight = cancelHeight + [self getBottomHeight];
    
    CGFloat ActionSheetHeight = titleHeight + confirmHeight + separatorHeight + cancelHeight;
    self.frame = CGRectMake(0,
                            MLDWXActionSheet_SCREEN_HEIGHT - ActionSheetHeight,
                            MLDWXActionSheet_SCREEN_WIDTH,
                            ActionSheetHeight);
    /**单面圆角*/
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(16,16)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (CGFloat)getBottomHeight {
    if ([self isPhoneX]) {
        return 20;
    }
    return 0;
}

- (BOOL)isPhoneX {
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
        return iPhoneX;
    }
    if (@available(iOS 11.0, *)) {
        UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
        if (mainWindow.safeAreaInsets.bottom > 0.0) {
            iPhoneX = YES;
        }
    }
    return iPhoneX;
}

#pragma mark - 显示界面

- (void)showInView:(UIView *)obj {
    [obj addSubview:self.shadowView];
    [obj addSubview:self];
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacity.fromValue = @(0);
    opacity.duration = 0.3;
    [self.shadowView.layer addAnimation:opacity forKey:nil];
    CABasicAnimation *move = [CABasicAnimation animationWithKeyPath:@"position"];
    move.fromValue = [NSValue valueWithCGPoint:CGPointMake(kScreenCenter.x, MLDWXActionSheet_SCREEN_HEIGHT)];
    move.duration = 0.2;
    [self.layer addAnimation:move forKey:nil];
}

#pragma mark - 代理方法 或者block

- (void)button:(UIButton *)button
  clickAtIndex:(NSUInteger)index {
    if (self.clickBlock) {
        [self animationHideShadowView];
        [self animationHideActionSheet];
        NSInteger index = [self.confirms indexOfObject:button.titleLabel.text];
        self.clickBlock(index);
    }
    else {
        if ([self.delegate respondsToSelector:@selector(clickAction:atIndex:)]) {
            [self animationHideShadowView];
            [self animationHideActionSheet];
            NSInteger index = [self.confirms indexOfObject:button.titleLabel.text];
            [self.delegate clickAction:self atIndex:index];
        }
    }
}

#pragma mark - 背景点击事件

- (void)tapAction {
    [self animationHideShadowView];
    [self animationHideActionSheet];
}

#pragma mark - 取消

- (void)cancelButtonClick {
    [self animationHideShadowView];
    [self animationHideActionSheet];
}

#pragma mark - 隐藏动画

- (void)animationHideShadowView {
    [UIView animateWithDuration:0.3
                     animations:^{
        self.shadowView.alpha = 0;
    }
                     completion:^(BOOL finished) {
        [self.shadowView removeFromSuperview];
    }];
}

- (void)animationHideActionSheet {
    [UIView animateWithDuration:0.2
                     animations:^{
        self.frame = CGRectMake(0,
                                MLDWXActionSheet_SCREEN_HEIGHT,
                                MLDWXActionSheet_SCREEN_WIDTH,
                                self.height);
    }
                     completion:^(BOOL finished) {
        [self removeFromSuperview];
        self.hideBlock();
    }];
}

- (CGFloat)height {
    return self.frame.size.height;
}

@end
