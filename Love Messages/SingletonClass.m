//
//  SingletonClass.m
//  E_Sign
//
//  Created by Muhammad Luqman on 10/4/16.
//  Copyright © 2016 Muhammad Luqman. All rights reserved.
//

#import "SingletonClass.h"

@implementation SingletonClass

+ (id)SingletonClass{
    
    static SingletonClass *value;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        value = [[SingletonClass alloc] init];
    });
    return value;
}

-(id)init {
    
    _arrayForOneMessageData = [[NSMutableArray alloc] init];
    _arrayForOneMessageDataBookmarks = [[NSMutableArray alloc] init];
    
    _ArrayIndex = 0;
    
    return self;
}

@end
