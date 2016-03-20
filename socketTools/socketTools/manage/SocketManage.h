//
//  SocketManage.h
//  socketTools
//
//  Created by 李进 on 16/3/20.
//  Copyright © 2016年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    BSDs = 0,
    CFNet = 1,
    STREMA = 2,
}socketType;


typedef void(^finishedBlock)(NSData *data,NSString *str);


@protocol SocketManageDelegate <NSObject>



@end
@interface SocketManage : NSObject

@property (nonatomic, copy)id delegate;
@property (nonatomic, copy)finishedBlock finished;


- (void)sendMessage:(NSString *)message;

+ (instancetype)socketManageHost:(NSURL *)host port:(NSString *)port type:(socketType)type;

- (void)closeConnet;
- (void)startConnet;

@end
