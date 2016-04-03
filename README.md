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
   
    //发送数据以及关闭连接
    [self.manage sendMessage:@"12121297979797979799797\n"];
    [self.manage closeConnet];

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
