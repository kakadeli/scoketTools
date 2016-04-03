//
//  ViewController.m
//  socketTools
//
//  Created by 李进 on 16/3/20.
//  Copyright © 2016年 com. All rights reserved.
//

#import "ViewController.h"
#import "SocketManage.h"
#import "JHLabel.h"

@interface ViewController ()

@property (nonatomic, strong)SocketManage *manage;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL *url = [NSURL URLWithString:@"http://192.168.0.102"];
    
    SocketManage *maname = [SocketManage socketManageHost:url port:@"12345" type:BSDs];
    [maname startConnet];
    self.manage = maname;
    maname.finished = ^(NSData *data,NSString *str){
//        NSNumber *num = [NSNumber]
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"%@",str);
        
    };
    
    /**
     *  创建
     */
    
    JHLabel *label = [JHLabel JHLabeltext:@"《开玩笑》就是这样玩" textFont:17 textCorol:[UIColor blueColor] rangColor:[UIColor redColor] userEnder:YES allStrAttributes:nil rangAddAttributes:nil regular:nil];
    label.frame = CGRectMake(50, 50, 300, 40);
    [self.view addSubview:label];
    //点击相应字符串
    label.block = ^(NSString *name){
        NSLog(@"%@",name);
    };

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.manage sendMessage:@"12121297979797979799797\n"];
    [self.manage closeConnet];
}

@end
