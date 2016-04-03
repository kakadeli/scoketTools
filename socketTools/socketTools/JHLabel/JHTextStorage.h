//
//  LHTextStorage.h
//  xiangmuceshi
//
//  Created by 李进 on 16/4/2.
//  Copyright © 2016年 com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JHTextStorage : NSTextStorage

@property (nonatomic, strong)UIColor *baseColor;

@property (nonatomic, strong)UIColor *rangColor;

@property (nonatomic, assign)CGFloat fontSize;

@property (nonatomic, strong)NSDictionary *attArray;

@property (nonatomic, strong)NSDictionary *dic;

@property (nonatomic, copy)NSString *regular;

@end
