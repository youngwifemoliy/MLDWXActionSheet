//
//  MLDWXActionSheet.h
//  JJStudy
//
//  Created by MoliySDev on 2019/7/23.
//  Copyright © 2019 Moliy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MLDWXActionSheet;

typedef enum {
    MLDWXActionSheetStyleDefault, // 正常字体样式
    MLDWXActionSheetStyleCancel,  // 粗体字样式
    MLDWXActionSheetStyleDestructive // 红色字体样式
} MLDWXActionSheetStyle;

//点击按钮
typedef void(^ClickBlock)(NSInteger index);
//隐藏
typedef void(^HideBlock)(void);


@protocol MLDWXActionSheetDelegate <NSObject>

/**
 *  代理方法
 *
 *  @param actionSheet actionSheet
 *  @param index       被点击按钮是哪个
 */
- (void)clickAction:(MLDWXActionSheet *)actionSheet
            atIndex:(NSUInteger)index;
@end

@interface MLDWXActionSheet : UIView

/**设置代理*/
@property (nonatomic, weak) id<MLDWXActionSheetDelegate> delegate;

/**
 *  初始化方法
 *
 *  @param title    提示内容
 *  @param confirms 选项标题数组
 *  @param cancel   取消按钮标题
 *  @param style    显示样式
 *  @return actionSheet
 */
+ (MLDWXActionSheet *)actionSheetWithTitle:(NSString *)title
                                  confirms:(NSArray *)confirms
                                    cancel:(NSString *)cancel
                                     style:(MLDWXActionSheetStyle)style;

/**带block的初始化方法*/
+ (MLDWXActionSheet *)actionSheetWithTitle:(NSString *)title
                                  confirms:(NSArray *)confirms
                                    cancel:(NSString *)cancel
                                     style:(MLDWXActionSheetStyle)style
                                     click:(ClickBlock)click
                                     hiden:(HideBlock)hiden;

/**
 *  展示
 *
 *  @param obj UIView/UIWindow
 */
- (void)showInView:(UIView *)obj;

@end

NS_ASSUME_NONNULL_END
