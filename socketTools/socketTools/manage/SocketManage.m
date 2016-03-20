//
//  SocketManage.m
//  socketTools
//
//  Created by 李进 on 16/3/20.
//  Copyright © 2016年 com. All rights reserved.
//
#import "SocketManage.h"
#import <arpa/inet.h>
#import <netdb.h>
#import <CoreFoundation/CoreFoundation.h>



@interface SocketManage ()
//主机
@property (nonatomic, copy)NSURL *host;
//端口号
@property (nonatomic, assign)NSString *port;

@property (nonatomic, assign)struct sockaddr_in *socketpames;

@property (nonatomic, assign)int socketFileDescriptor;

@property (nonatomic, strong)NSNumber *numport;

@property (nonatomic, strong)NSString * strhost;

@property (nonatomic, assign)socketType type;





@end

@implementation SocketManage

//构造方法
+ (instancetype)socketManageHost:(NSURL *)host port:(NSString *)port type:(socketType)type{
    SocketManage *manamge = [[SocketManage alloc]init];
    manamge.host = host;
    manamge.port = port;
    manamge.type = type;
    return manamge;
}

//关闭连接
- (void)closeConnet{
    //关闭连接
    close(self.socketFileDescriptor);
}
//开始连接
- (void)startConnet{
    
    [self creatBSDSocket];
}


//另开一线程进行监听
- (void)creatBSDSocket{
    
    //判断主机和端口是否为空
    if (self.host == nil || self.port == NULL) {
        self.finished(nil,@"传如参数失败");
        return;
    }
    //创建url;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@:%@",self.host,self.port]];
    
    //另开一线程进行监听
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(receiveData:) object:url];
    //开启线程
    [thread start];
    
}

//创建连接
- (void)receiveData:(NSURL *)sender{
    
    switch (self.type) {
        case BSDs:
            [self bsdurl:sender];
            break;
        case CFNet:
            [self cfneturl:sender];
            break;
            
        default:
            break;
    }
 
    
    
}

- (void)bsdurl:(NSURL *)url{
    //创建socket 第一个参数是 IPv4(AF_INET) 或 IPv6(AF_INET6)
    //第二个参数是socket 的类型，通常是流stream(SOCK_STREAM) 或数据报文datagram(SOCK_DGRAM)
    //第三个参数通常设置为0，以便让系统自动为选择我们合适的协议，对于 stream socket 来说会是 TCP 协议(IPPROTO_TCP)，而对于 datagram来说会是 UDP 协议
    //如果描述符为 -1
    
    self.strhost = [url host];
    self.numport = [url port];
    self.socketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0);
    
    if (-1 == self.socketFileDescriptor) {
        NSLog(@"创建失败");
        self.finished(nil,@"创建失败");
        return;
    }
    
    struct hostent * remoteHostEnt = gethostbyname([self.strhost UTF8String]);
    
    if (NULL == remoteHostEnt) {
        close(self.socketFileDescriptor);
        self.finished(nil,@"获取远程主机信息失败");
        NSLog(@"获取远程主机信息失败");
        return;
    }
    
    struct in_addr * remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];
    
    struct sockaddr_in socketParameters;
    socketParameters.sin_family = AF_INET;
    socketParameters.sin_addr = *remoteInAddr;
    //将主机字节顺序转换为网络字节顺序
    socketParameters.sin_port = htons([self.numport intValue]);
    
    self.socketpames = &(socketParameters);
    //创建连接
//    int list = list(self.socketFileDescriptor);
    int ret = connect(self.socketFileDescriptor, (struct sockaddr *) self.socketpames, sizeof(socketParameters));
    if (-1 == ret) {
        close(self.socketFileDescriptor);
        self.finished(nil,@"连接失败");
        NSLog(@"连接失败");
        return;
    }
    [self loaddata];

}

- (void)loaddata{
    
    NSMutableData * data = [[NSMutableData alloc] init];
    //接收数据
    const char * buffer[1024];
    int length = sizeof(buffer);
    //该函数的第一个参数指定接收端套接字描述符； 第二个参数指明一个缓冲区，该缓冲区用来存放recv函数接收到的数据； 第三个参数指明buf的长度； 第四个参数一般置0
    //    NSInteger result = recv(self.socketFileDescriptor, &buffer, length, 0);
    
    NSInteger result = recv(self.socketFileDescriptor, &buffer, length, 0);
    if (result >= 0) {
        [data appendBytes:buffer length:result];
        self.finished(data,@"成功");
        
    }else{
        self.finished(nil,@"copy接收数据失败");
        return;
    }
    
    [self loaddata];
}


//cfnet
- (void)cfneturl:(NSURL *)url{
    
    NSString * host = [url host];
    NSInteger port = [[url port] integerValue];
    
    // Keep a reference to self to use for controller callbacks
    //
    CFStreamClientContext ctx = {0, (__bridge void *)(self), NULL, NULL, NULL};
    
    // Get callbacks for stream data, stream end, and any errors
    //
    CFOptionFlags registeredEvents = (kCFStreamEventHasBytesAvailable | kCFStreamEventEndEncountered | kCFStreamEventErrorOccurred);
    
    // Create a read-only socket
    //
    CFReadStreamRef readStream;
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault, (__bridge CFStringRef)host, (unsigned int)port, &readStream, NULL);
    
    // Schedule the stream on the run loop to enable callbacks
    //
    if (CFReadStreamSetClient(readStream, registeredEvents, socketCallback, &ctx)) {
        CFReadStreamScheduleWithRunLoop(readStream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
        
    }else {
        return;
    }
    
    // Open the stream for reading
    //
    if (CFReadStreamOpen(readStream) == NO) {
        
        return;
    }
    
    CFErrorRef error = CFReadStreamCopyError(readStream);
    if (error != NULL) {
        if (CFErrorGetCode(error) != 0) {
  
        }
        
        CFRelease(error);
        
        return;
    }
    
    // Start processing
    //
    CFRunLoopRun();
}

//block回调
void socketCallback(CFReadStreamRef stream, CFStreamEventType event, void * myPtr){
    NSLog(@" >> socketCallback in Thread %@", [NSThread currentThread]);
    
    
    switch(event) {
        case kCFStreamEventHasBytesAvailable: {
            // Read bytes until there are no more
            //
            while (CFReadStreamHasBytesAvailable(stream)) {
                UInt8 buffer[1024];
                int numBytesRead = CFReadStreamRead(stream, buffer,1024);
                
                NSData *data = [[NSData alloc]initWithBytes:buffer length:numBytesRead];
                NSLog(@"%@",[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]) ;
//                self.finished(data,@"好了");
            }
            
            break;
        }
            
        case kCFStreamEventErrorOccurred: {
            CFErrorRef error = CFReadStreamCopyError(stream);
            if (error != NULL) {
                if (CFErrorGetCode(error) != 0) {
                    NSString * errorInfo = [NSString stringWithFormat:@"Failed while reading stream; error '%@' (code %ld)", (__bridge NSString*)CFErrorGetDomain(error), CFErrorGetCode(error)];
                    NSLog(@"%@",errorInfo);
                }
                
                CFRelease(error);
            }
            
            
            break;
        }
            
        case kCFStreamEventEndEncountered:
            // Finnish receiveing data
            //
            
            // Clean up
            //
            CFReadStreamClose(stream);
            CFReadStreamUnscheduleFromRunLoop(stream, CFRunLoopGetCurrent(), kCFRunLoopCommonModes);
            CFRunLoopStop(CFRunLoopGetCurrent());
            
            break;
            
        default:
            break;
    }
}

- (void)sendMessage:(NSString *)message{
    
    switch (self.type) {
        case BSDs:
            [self bsdSendMeg:message];
            break;
        case CFNet:
            [self cfnetsendmeg:message];
            break;
            
        default:
            break;
    }
    

}

//发送消息
- (void)bsdSendMeg:(NSString *)message{
    char *data = (char *)[message UTF8String];
    struct iovec iov[1];
    struct msghdr msg;
    iov[0].iov_base = data;
    iov[0].iov_len = strlen(data);
    msg.msg_name = NULL;
    msg.msg_namelen = sizeof(self.socketpames);
    msg.msg_iov = &iov[0];
    msg.msg_iovlen = 1;
    //    msg.msg_iov->iov_len = 13;
    msg.msg_control = 0;
    msg.msg_controllen = 0;
    msg.msg_flags = 0;
    /**
     *  返回说明：
     成功执行时，返回已发送的字节数。失败返回-1，errno被设为以下的某个值
     EACCES：对于Unix域套接字，不允许对目标套接字文件进行写，或者路径前驱的一个目录节点不可搜索
     EAGAIN，EWOULDBLOCK： 套接字已标记为非阻塞，而发送操作被阻塞
     EBADF：sock不是有效的描述词
     ECONNRESET：连接被用户重置
     EDESTADDRREQ：套接字不处于连接模式，没有指定对端地址
     EFAULT：内存空间访问出错
     EINTR：操作被信号中断
     EINVAL：参数无效
     EISCONN：基于连接的套接字已被连接上，同时指定接收对象
     EMSGSIZE：消息太大
     ENOMEM：内存不足
     ENOTCONN：套接字尚未连接，目标没有给出
     ENOTSOCK：sock索引的不是套接字
     EPIPE：本地连接已关闭
     */
   
    NSLog(@"%zd",sendmsg(self.socketFileDescriptor, &msg, 0));

}

- (void)cfnetsendmeg:(NSString *)message{
    
        NSString *stringTosend = @"你好";
        char *data = [stringTosend UTF8String];
//        send();
    
}

@end
