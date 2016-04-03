//
//  LHTextStorage.m
//  xiangmuceshi
//
//  Created by 李进 on 16/4/2.
//  Copyright © 2016年 com. All rights reserved.
//

#import "JHTextStorage.h"

@implementation JHTextStorage
{
    NSTextStorage *imp;
}


//+ (instancetype)JHTextStorage


- (instancetype)init{
    
    if (self = [super init]) {
        
        imp = [NSTextStorage new];
    }
    return self;
}

- (NSString *)string{
    
    return imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range{
    return [imp attributesAtIndex:location effectiveRange:range];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str{
    
    [imp replaceCharactersInRange:range withString:str];
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
    
    
    //查找文字的政治表达式
//    static NSDataDetector *linkDetector;
//    linkDetector = linkDetector ?: [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:NULL];
    NSString *re = [NSString string];
    if (self.regular) {
        re = self.regular;
    }else{
        re = @"《[\\u4e00-\\u9fa5a-zA-Z0-9_-]*》";
    }
    
    static NSRegularExpression *iExpression;
    iExpression = iExpression ?: [NSRegularExpression regularExpressionWithPattern:re options:0 error:NULL];
    
    // Clear text color of edited range
    NSRange paragaphRange = [self.string paragraphRangeForRange: NSMakeRange(range.location, str.length)];
    [self removeAttribute:NSLinkAttributeName range:paragaphRange];
    [self removeAttribute:NSBackgroundColorAttributeName range:paragaphRange];
    [self removeAttribute:NSUnderlineStyleAttributeName range:paragaphRange];
    [self addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:self.fontSize] range:NSMakeRange(0, self.string.length)];
    //设置所有文字的颜色
    [self addAttribute:NSForegroundColorAttributeName value:self.baseColor range:NSMakeRange(0, self.string.length)];
    if (self.attArray != nil) {
        [self addAttributes:self.attArray range:NSMakeRange(0, self.string.length)];
    }
    
    [iExpression enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        
        NSLog(@"%@",NSStringFromRange(result.range));
        [self addAttribute:NSForegroundColorAttributeName value:self.rangColor range:result.range];
        [self addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:result.range];
        if (self.dic != nil) {
            [self addAttributes:self.dic range:result.range];
        }
    }];
    
//    [linkDetector enumerateMatchesInString:self.string options:0 range:paragaphRange usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
//        // Add red highlight color
//        [self addAttribute:NSLinkAttributeName value:result.URL range:result.range];
//        
//        [self addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:result.range];
//    }];
    
 
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range{
    [imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}
@end
