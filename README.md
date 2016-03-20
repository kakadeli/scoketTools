# scoketTools

    NSURL *url = [NSURL URLWithString:@"http://192.168.0.102"];
    
    SocketManage *maname = [SocketManage socketManageHost:url port:@"12345" type:BSDs];
    self.manage = maname;
    //开始连接
    [maname startConnet] ;
    //数据回调
    maname.finished = ^(NSData *data,NSString *str){
        NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        NSLog(@"%@",str);
        
    };
   
}
//发送数据以及关闭连接
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.manage sendMessage:@"12121297979797979799797\n"];
    [self.manage closeConnet];
}
