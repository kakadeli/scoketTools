//
//  JHLabel.h
//  xiangmuceshi
//
//  Created by 李进 on 16/4/1.
//  Copyright © 2016年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLayoutManage.h"
#import "JHTextStorage.h"


typedef void(^JHlabelBlock)(NSString *str);

@interface JHLabel : UILabel<NSLayoutManagerDelegate>


@property (nonatomic, copy)JHlabelBlock block;
//默认匹配《》
/**
 *  可以点击相应字符的label
 *
 *  @param string     label的text
 *  @param size       字体大小
 *  @param color      字体颜色
 *  @param rangColor  选中字体颜色
 *  @param isok       是否开启可以点击
 *  @param Attributes 设置所有字符串的属性
 *  @param Attribute  设置选中字符串的属性
 *  @param regular    正则表达式可以为空默认是匹配《》号
 *
 *  @return label
 */
+ (instancetype)JHLabeltext:(NSString *)string textFont:(CGFloat)size textCorol:(UIColor *)color rangColor:(UIColor *)rangColor userEnder:(BOOL)isok allStrAttributes:(nullable NSDictionary *)Attributes rangAddAttributes:(nullable NSDictionary *)Attribute regular:(nullable NSString *)regular;

@end
