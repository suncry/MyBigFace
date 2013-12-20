//
//  MyDB.h
//  Clock
//
//  Created by Suncry on 13-6-24.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"

@interface MyDB : NSObject
{
    FMDatabase *_db;

}
- (void)openDB;
//face 表 的操作
- (id)date:(NSString *)name
        id:(int)face_id;
- (id)date:(NSString *)name
       num:(int)num;
//myface 表 的操作
- (id)myDate:(NSString *)name
        id:(int)face_id;
- (id)myDate:(NSString *)name
       num:(int)num;


- (void)insertMyFace:(int)num
             face_id:(int)face_id
             content:(NSString *)content
          created_at:(NSString *)created_at
          updated_at:(NSString *)updated_at
                 lat:(NSString *)lat
                 lng:(NSString *)lng
                plus:(int)plus
         latest_plus:(int)latest_plus_num
                 url:(NSString *)url
             user_id:(NSString *)user_id
         all_comment:(int)all_comment_num
          latest_num:(int)latest_comment_num
             address:(NSString *)address;

- (void)insertFace:(int)num
           face_id:(int)face_id
           content:(NSString *)content
        created_at:(NSString *)created_at
        updated_at:(NSString *)updated_at
               lat:(NSString *)lat
               lng:(NSString *)lng
              plus:(int)plus
       latest_plus:(int)latest_plus_num
               url:(NSString *)url
           user_id:(NSString *)user_id
       all_comment:(int)all_comment_num
        latest_num:(int)latest_comment_num
           address:(NSString *)address;


- (void)insertFace:(int)num
           face_id:(int)face_id
           content:(NSString *)content
        created_at:(NSString *)created_at
        updated_at:(NSString *)updated_at
               lat:(NSString *)lat
               lng:(NSString *)lng
              plus:(int)plus
               url:(NSString *)url
           user_id:(NSString *)user_id
           address:(NSString *)address;



// 获得表的数据条数
- (NSInteger)getTableItemCount:(NSString *)tableName;
// 清除表-清数据
- (BOOL)eraseTable:(NSString *)tableName;
- (void)setPlus:(int)face_id
           plus:(int)plus;
- (void)setMyPlus:(int)face_id
           plus:(int)plus;

@end
