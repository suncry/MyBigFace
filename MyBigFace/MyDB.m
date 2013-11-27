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
        [_db executeUpdate:@"create table face (num integer,id integer,content text,created_at text,updated_at text,lat text,lng text,plus integer,url text,user_id text)"];
        NSLog(@"face 表 创建语句执行了！！！！");
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

//- (void)setdate:(NSString *)name
//          value:(id)value
//          id:(int)face_id
//{
//    [self openDB];
//
//    NSString *queryString =[[NSString alloc]initWithFormat:@"update face set %@ = ? where id = ?",name];
//    [_db executeUpdate:queryString,[NSNumber numberWithInt:[value intValue]],face_id];
//    [_db executeUpdate:@"UPDATE face SET plus = ? WHERE id = ?",[NSNumber numberWithInt:[value intValue]],[NSNumber numberWithInt:face_id]];
//
////    [_db executeUpdate:queryString];
//
//}
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
{
    [self openDB];
    [_db executeUpdate:@"insert into face (num,id,content,created_at,updated_at,lat,lng,plus,url,user_id) values(?,?,?,?,?,?,?,?,?,?)",
     [NSNumber numberWithInt:num],
     [NSNumber numberWithInt:face_id],
     content,
     created_at,
     updated_at,
     lat,
     lng,
     [NSNumber numberWithInt:plus],
     url,
     user_id];
    
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
//    NSLog(@"清空前 数据条数为 == %d",[self getTableItemCount:@"face"]);
    NSString *sqlstr = [NSString stringWithFormat:@"DELETE FROM %@", tableName];
    if (![_db executeUpdate:sqlstr])
    {
        NSLog(@"Erase table error!");
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

@end
