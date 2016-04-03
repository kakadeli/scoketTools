//
//  JHLayoutManage.m
//  xiangmuceshi
//
//  Created by 李进 on 16/4/2.
//  Copyright © 2016年 com. All rights reserved.
//

#import "JHLayoutManage.h"

@implementation JHLayoutManage


- (void)drawUnderlineForGlyphRange:(NSRange)glyphRange underlineType:(NSUnderlineStyle)underlineVal baselineOffset:(CGFloat)baselineOffset lineFragmentRect:(CGRect)lineRect lineFragmentGlyphRange:(NSRange)lineGlyphRange containerOrigin:(CGPoint)containerOrigin{
    
    //glyphRange:相匹配文字的在字符串中的范围
    //lineRect:相匹配字段所在的范围
    //lineGlyphRange:相匹配文字的在字符串中所在行的字节 和行总字节
    //containerOrigin:整个容器的原点
    //获取当前范围的起始x
    CGFloat firstPosition = [self locationForGlyphAtIndex: glyphRange.location].x;

    CGFloat lastPosition;

    if (NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange)) {
        //获取最后位置
        lastPosition = [self locationForGlyphAtIndex: NSMaxRange(glyphRange)].x;
        
    }else {
        lastPosition = [self lineFragmentUsedRectForGlyphAtIndex:NSMaxRange(glyphRange)-1 effectiveRange:NULL].size.width;
    }
    
    lineRect.origin.x += firstPosition;
    lineRect.size.width = lastPosition - firstPosition;
    
    lineRect.origin.x += containerOrigin.x;
    lineRect.origin.y += containerOrigin.y;
    //相匹配字断的位置及范围
    lineRect = CGRectInset(CGRectIntegral(lineRect), .5, .5);
    
    if (self.layoutBlock) {
        self.layoutBlock(lineRect,glyphRange);
    }

}

@end
