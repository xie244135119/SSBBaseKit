//
//  NSURLProtocolCustom.m
//  AppMicroDistribution
//
//  Created by SunSet on 15-12-23.
//  Copyright (c) 2015年 SunSet. All rights reserved.
//

#import "NSURLProtocolCustom.h"


NSString *const URLProtocolHandledKey = @"URLProtocolHandledKey";


@implementation NSURLProtocolCustom


// 这个方法用来返回是否需要处理这个请求，如果需要处理，返回YES
+ (BOOL)canInitWithRequest:(NSURLRequest*)request
{
    if (isIP([request.URL.host UTF8String]) == 1) {
        //IP请求不处理
                    return NO;
     }
    
//    NSString *scheme = [[request URL] scheme];
//    if ( ([scheme caseInsensitiveCompare:@"http"] == NSOrderedSame ||
//          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame))
//    {
//        //看看是否已经处理过了，防止无限循环
//        if ([NSURLProtocol propertyForKey:URLProtocolHandledKey inRequest:request]) {
//            return NO;
//        }
//        
//        return YES;
//    }
    return YES;
    
//    // 非ip情况下重定向请求
//    if (isIP([theRequest.URL.host UTF8String]) != 1) {
//                return YES;
//            }
//    
//    return NO;
}

// 重写该方法，可以对请求进行修改，例如添加新的头部信息，修改，修改url等，返回修改后的请求
+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)theRequest
{
    NSString *urlstr = [[AMDRequestService sharedAMDRequestService] getHostIPWithUrlStr:theRequest.URL.description];
    NSMutableURLRequest *request = [theRequest mutableCopy];
    request.URL = [[NSURL alloc]initWithString:urlstr];
    [request setValue:theRequest.URL.host forHTTPHeaderField:@"Host"];
    
//    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:request];
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a
                       toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

//- (void)startLoading
//{
//    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
//    [NSURLProtocol setProperty:@YES forKey:URLProtocolHandledKey inRequest:mutableReqeust];
//    [super startLoading];
//}

//
- (void)startLoading
{
    NSLog(@"%@", self.request.URL);
//    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:[self.request URL]
//                                                        MIMEType:@"image/png"
//                                           expectedContentLength:-1
//                                                textEncodingName:nil];
//    
//    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"image1" ofType:@"png"];
//    NSData *data = [NSData dataWithContentsOfFile:imagePath];
//    
//    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
//    [[self client] URLProtocol:self didLoadData:data];
//    [[self client] URLProtocolDidFinishLoading:self];

    
//    self.connection = [NSURLConnection connectionWithRequest:self.request
//                                                    delegate:self];
}

- (void)stopLoading
{
    NSLog(@"something went wrong!");
}


#pragma mark - 是否为IP
// 判断是否为IP地址
static int isIP(const char* pStr)
{
    int bRet = 1;
    if (NULL == pStr) return -1;
    const char* p = pStr;
    for (; *p != '\0'; p++)
    {
        if ((isalpha(*p)) && (*p != '.'))
        {
            bRet = 0;
            break;
        }
    }
    return bRet;
}

@end










