//
//  JWGCD_DemoTests.m
//  JWGCD_DemoTests
//
//  Created by JackWong on 14/7/23.
//  Copyright (c) 2014年 Jack Wong. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface JWGCD_DemoTests : XCTestCase

@end

@implementation JWGCD_DemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
