//
//  NHMHelpWindowContentResponseTests.m
//  NoHoldMusic
//
//  Created by Mark D. Freeman Williams on 6/8/16.
//  Copyright © 2016 The Fascinating Group. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NHMHelpWindowContentResponse.h"

@interface NHMHelpWindowContentResponseTests : XCTestCase

@end

@implementation NHMHelpWindowContentResponseTests

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
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testCreateHelpWindowURLContentResponse {
    NSURL *url = [NSURL URLWithString:@"http://noholdmusic.org"];
    NHMHelpWindowURLContentResponse *urlResponse = [NHMHelpWindowURLContentResponse contentResponseWithURL:url];
    XCTAssertNotNil(urlResponse);
    XCTAssertEqual(url, urlResponse.url);
}

@end
