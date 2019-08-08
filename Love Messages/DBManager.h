//
//  DBManager.h
//  SQLite3DBSample
//
//  Created by Apple on 07/01/2016.
//  Copyright © 2016 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;
@property (nonatomic) int affectedRows;
@property (nonatomic) long long lastInsertedRowID;


-(NSArray *)loadDataFromDB:(NSString *)query;

-(void)executeQuery:(NSString *)query;

@end
