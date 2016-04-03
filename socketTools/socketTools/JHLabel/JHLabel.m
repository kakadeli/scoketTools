//
//  JHLabel.m
//  xiangmuceshi
//
//  Created by 李进 on 16/4/1.
//  Copyright © 2016年 com. All rights reserved.
//

#import "JHLabel.h"

@interface JHLabel ()

@property (nonatomic, copy)NSString *str;

@property (nonatomic, strong)JHTextStorage *textStorage;

@property (nonatomic, assign)BOOL beginWork;

@property (nonatomic, strong)NSTextContainer *textContainer;

@property (nonatomic, strong)NSMutableArray *tempArray;

@property (nonatomic, strong)NSMutableArray *strMArray;

@property (nonatomic, strong)JHLayoutManage *layoutManager;

@end



@implementation JHLabel


+ (instancetype)JHLabeltext:(NSString *)string textFont:(CGFloat)size textCorol:(UIColor *)color rangColor:(UIColor *)rangColor userEnder:(BOOL)isok allStrAttributes:(nullable NSDictionary *)Attributes rangAddAttributes:(nullable NSDictionary *)Attribute regular:(nullable NSString *)regular{
    
    JHLabel *label = [JHLabel new];
    label.str = string;
    label.textStorage.baseColor = color;
    label.textStorage.rangColor = rangColor;
    label.beginWork = isok;
    label.textStorage.fontSize = size;
    [label.textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:label.str];
    label.userInteractionEnabled = label.beginWork;
    label.textStorage.attArray = Attributes;
    label.textStorage.dic = Attribute;
    label.textStorage.regular = regular;
    label.text = string;
    label.textColor = [UIColor clearColor];
    label.numberOfLines = 0;
    return label;
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self prepareLabel];
    }
    return self;
}


- (instancetype)init{
    
    if (self = [super init]) {
        
        [self prepareLabel];
    
    }
    return self;
}

//准备开始
- (void)prepareLabel{
    
    self.textStorage = [JHTextStorage new];
    self.layoutManager = [JHLayoutManage new];
    [self.textStorage addLayoutManager: self.layoutManager];
    self.textContainer = [[NSTextContainer alloc] initWithSize: CGSizeZero];
    [self.layoutManager addTextContainer: self.textContainer];

    self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.translatesAutoresizingMaskIntoConstraints = YES;
    
    self.layoutManager.delegate = self;
    __weak typeof(self)weakeself = self;
    self.layoutManager.layoutBlock = ^(CGRect rect,NSRange rang){
        NSValue *value = [NSValue valueWithCGRect:rect];
        NSString *str = [weakeself.str substringWithRange:rang];
        [weakeself.strMArray addObject:str];
        [weakeself.tempArray addObject:value];
    };
    
    
    [self setNeedsDisplay];
    
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    self.textContainer.size = self.bounds.size;
}


- (void)drawTextInRect:(CGRect)rect{
    
    [super drawTextInRect:rect];
    
    NSRange rang = NSMakeRange(0, self.str.length);
    
   CGRect ct = [self.layoutManager boundingRectForGlyphRange:rang inTextContainer:self.textContainer];
    
    CGFloat h = (self.bounds.size.height -ct.size.height);
    
    CGPoint point = CGPointMake(0, h);
    
    [self.layoutManager drawBackgroundForGlyphRange:rang atPoint:point];
    [self.layoutManager drawGlyphsForGlyphRange:rang atPoint:CGPointZero];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //获取UITouch对象
    UITouch *touch = [touches anyObject];
    //获取触摸点击当前view的坐标位置
    CGPoint location = [touch locationInView:self];
    for (int i = 0;i< self.tempArray.count;i++) {
        NSValue *va = self.tempArray[i];
        CGRect ct = va.CGRectValue;
        CGFloat minx = ct.origin.x;
        CGFloat maxx = ct.origin.x + ct.size.width;
        CGFloat miny = ct.origin.y;
        CGFloat maxy = ct.origin.y +ct.size.height;
        CGFloat lx = location.x;
        CGFloat ly = location.y;
        
        NSString *str = self.strMArray[i];
        
        if ((lx>=minx-1 && lx<=maxx+1) && (ly>=miny-1 && ly<=maxy+1)) {
            self.block(str);
        }
    }
}

#pragma mark 代理方法
//- (BOOL)layoutManager:(NSLayoutManager *)layoutManager shouldBreakLineByWordBeforeCharacterAtIndex:(NSUInteger)charIndex{
//    NSRange range;
//    NSURL *linkURL = [layoutManager.textStorage attribute:NSLinkAttributeName atIndex:charIndex effectiveRange:&range];
//    
//    // Do not break lines in links unless absolutely required
//    if (linkURL && charIndex > range.location && charIndex <= NSMaxRange(range))
//        return NO;
//    else
//        return YES;
//}
//
//- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager lineSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect{
//    return floorf(glyphIndex/100);
//}
//
//- (CGFloat)layoutManager:(NSLayoutManager *)layoutManager paragraphSpacingAfterGlyphAtIndex:(NSUInteger)glyphIndex withProposedLineFragmentRect:(CGRect)rect{
//    return 10;
//}

#pragma mark 懒加载
- (NSMutableArray *)tempArray{
    
    if (_tempArray == nil) {
        
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
    
}

- (NSMutableArray *)strMArray{
    
    if (_strMArray == nil) {
        
        _strMArray = [NSMutableArray array];
    }
    return _strMArray;
}



@end
