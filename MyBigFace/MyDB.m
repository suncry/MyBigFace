//
//  MyDB.m
//  Clock
//
//  Created by Suncry on 13-6-24.
//  Copyright (c) 2013年 ipointek. All rights reserved.
//

#import "MyDB.h"

@implementation MyDB
- (void)openDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"MyDatabase.db"];
    _db = [FMDatabase databaseWithPath:dbPath];
    //为数据库设置缓存，提高查询效率
    [_db setShouldCacheStatements:YES];
    if (![_db open])
    {
        NSLog(@"could not open DB!!!");
        return;
    }
    if (![_db tableExists:@"face"])//如果没有创建表 那么就创建并且初始化
    {
        [_db executeUpdate:@"create table face (num integer,id integer,content text,created_at text,updated_at text,lat text,lng text,plus integer,latest_plus integer,url text,user_id text,all_comment integer,latest_num integer,address text)"];
        NSLog(@"face 表 创建语句执行了！！！！");
    }
    if (![_db tableExists:@"myFace"])//如果没有创建表 那么就创建并且初始化
    {
        [_db executeUpdate:@"create table myFace (num integer,id integer,content text,created_at text,updated_at text,lat text,lng text,plus integer,latest_plus integer,url text,user_id text,all_comment integer,latest_num integer,address text)"];
        NSLog(@"myFace 表 创建语句执行了！！！！");
    }

}
- (id)date:(NSString *)name
        id:(int)face_id
{
    [self openDB];
    NSString *queryString =[[NSString alloc]initWithFormat:@"select %@ from face where id = %d",name,face_id];
    return [_db stringForQuery:queryString];
}
- (id)date:(NSString *)name
       num:(int)num
{
    [self openDB];
    NSString *queryString =[[NSString alloc]initWithFormat:@"select %@ from face where num = %d",name,num];
    return [_db stringForQuery:queryString];
}
//myface 表 的操作
- (id)myDate:(NSString *)name
          id:(int)face_id
{
    [self openDB];
    NSString *queryString =[[NSString alloc]initWithFormat:@"select %@ from myFace where id = %d",name,face_id];
    return [_db stringForQuery:queryString];

}
- (id)myDate:(NSString *)name
         num:(int)num
{
    [self openDB];
    NSString *queryString =[[NSString alloc]initWithFormat:@"select %@ from myFace where num = %d",name,num];
    return [_db stringForQuery:queryString];

}

/**
 *  将获取到得face信息写入本地数据库
 *
 *  @param num                myface 在数据库中得排序
 *  @param face_id            face 在后台的ID
 *  @param content            face 的内容
 *  @param created_at         face 的创建时间
 *  @param updated_at         face 的更新时间
 *  @param lat                face 经度
 *  @param lng                face 纬度
 *  @param plus               face 赞的个数
 *  @param latest_plus_num    face 新的赞的个数
 *  @param url                face 图片的地址
 *  @param user_id            发表face的用户的ID
 *  @param all_comment_num    face 总的评论数量
 *  @param latest_comment_num face 新的评论的数量
 *  @param address            face address
 */
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
             address:(NSString *)address
{
    [self openDB];
    [_db executeUpdate:@"insert into myFace (num,id,content,created_at,updated_at,lat,lng,plus,latest_plus,url,user_id,all_comment,latest_num,address) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
     [NSNumber numberWithInt:num],
     [NSNumber numberWithInt:face_id],
     content,
     created_at,
     updated_at,
     lat,
     lng,
     [NSNumber numberWithInt:plus],
     [NSNumber numberWithInt:latest_plus_num],
     url,
     user_id,
     [NSNumber numberWithInt:all_comment_num],
     [NSNumber numberWithInt:latest_comment_num],
     address];
    
}

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
           address:(NSString *)address

{
    [self openDB];
    [_db executeUpdate:@"insert into face (num,id,content,created_at,updated_at,lat,lng,plus,latest_plus,url,user_id,all_comment,latest_num,address) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
     [NSNumber numberWithInt:num],
     [NSNumber numberWithInt:face_id],
     content,
     created_at,
     updated_at,
     lat,
     lng,
     [NSNumber numberWithInt:plus],
     [NSNumber numberWithInt:latest_plus_num],
     url,
     user_id,
     [NSNumber numberWithInt:all_comment_num],
     [NSNumber numberWithInt:latest_comment_num],
     address];

}
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
           address:(NSString *)address

{
    [self openDB];
    [_db executeUpdate:@"insert into face (num,id,content,created_at,updated_at,lat,lng,plus,url,user_id,address) values(?,?,?,?,?,?,?,?,?,?,?)",
     [NSNumber numberWithInt:num],
     [NSNumber numberWithInt:face_id],
     content,
     created_at,
     updated_at,
     lat,
     lng,
     [NSNumber numberWithInt:plus],
     url,
     user_id,
     address];

}

// 获得表的数据条数
- (NSInteger)getTableItemCount:(NSString *)tableName
{
//    [self openDB];

    NSString *sqlstr = [NSString stringWithFormat:@"SELECT count(*) as 'count' FROM %@", tableName];
    FMResultSet *rs = [_db executeQuery:sqlstr];
    while ([rs next])
    {
        // just print out what we've got in a number of formats.
        NSInteger count = [rs intForColumn:@"count"];
        NSLog(@"TableItemCount %d", count);
        return count;
    }
    
    return 0;
}
// 清除表
- (BOOL)eraseTable:(NSString *)tableName
{
    [self openDB];

//    NSLog(@"清空前 数据条数为 == %d",[self getTableItemCount:@"face"]);
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![_db executeUpdate:sqlstr])
    {
        NSLog(@"======================================================");
        NSLog(@"==================Erase table error!==================");
        NSLog(@"======================================================");
        return NO;
    }
//    NSLog(@"表的数据清空了！！！");
//    NSLog(@"清空后 数据条数为 == %d",[self getTableItemCount:@"face"]);
    return YES;
}
- (void)setPlus:(int)face_id
           plus:(int)plus
{
    [self openDB];
    [_db executeUpdate:@"update face set plus = ? where id = ?",[NSNumber numberWithInt:plus],[NSNumber numberWithInt:face_id]];
}
- (void)setMyPlus:(int)face_id
             plus:(int)plus
{
    [self openDB];
    [_db executeUpdate:@"update myFace set plus = ? where id = ?",[NSNumber numberWithInt:plus],[NSNumber numberWithInt:face_id]];
}

@end
