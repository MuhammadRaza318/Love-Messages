//
//  SingletonClass.h
//  E_Sign
//
//  Created by Muhammad Luqman on 10/4/16.
//  Copyright © 2016 Muhammad Luqman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SingletonClass : NSObject

#define SINGLETON_FOR_CLASS(SingletonClass)
+ (id)SingletonClass;

@property (nonatomic, strong) NSMutableArray *arrayForOneMessageData;
@property (nonatomic, strong) NSMutableArray *arrayForOneMessageDataBookmarks;

@property (nonatomic) NSInteger ArrayIndex;

@end
