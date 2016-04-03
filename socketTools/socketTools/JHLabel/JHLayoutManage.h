//
//  JHLayoutManage.h
//  xiangmuceshi
//
//  Created by 李进 on 16/4/2.
//  Copyright © 2016年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JHLayoutManageBlock)(CGRect rect,NSRange rang);

@interface JHLayoutManage : NSLayoutManager

@property (nonatomic, copy)JHLayoutManageBlock layoutBlock;

@end
