//
//  DataBase.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/28.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "DataBase.h"
@interface DataBase()
{
   NSManagedObjectContext *_context;
}
@end
@implementation DataBase
+(DataBase*)shareDataBase
{
    static DataBase* shareData = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        
        shareData = [[self alloc]init];
    });
    return shareData;
}

-(id)init
{
    self = [super init];
    [self creatCoreData];
    return self;
}

-(void)creatCoreData
{
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ShopBase" withExtension:@"momd"];
    
    NSManagedObjectModel* model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    NSPersistentStoreCoordinator* stroeCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    NSDictionary* options = @{[NSNumber numberWithBool:YES]:NSMigratePersistentStoresAutomaticallyOption,[NSNumber numberWithBool:YES]:NSInferMappingModelAutomaticallyOption};
    
    
    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sqlitePath = [doc stringByAppendingPathComponent:@"shop.sqlite"];
    sqlitePath = [NSString stringWithFormat:@"file://%@",sqlitePath];
    
    NSError* err;
    [stroeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:[NSURL URLWithString:sqlitePath] options:options error:&err];
    NSLog(@"err is %@",err);
    
    
    _context = [[NSManagedObjectContext alloc] init];
    _context.persistentStoreCoordinator = stroeCoordinator;

}

-(void)insertShopWithID:(NSString*)shopID shopName:(NSString*)name
{
    NSArray* arr = [self searchObjWithID:shopID];
    if (arr.count != 0) {
        return;
    }
    
    ShopBase* ob = [NSEntityDescription insertNewObjectForEntityForName:@"Entity" inManagedObjectContext:_context];
    ob.shopID = shopID;
    ob.shopName = name;
    
    NSError* saveErr = nil;
    [_context save:&saveErr];
    NSLog(@"err %@",saveErr);
    
}

-(NSArray*)getAllShops
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Entity"];
    NSError* erro = nil;
    NSArray* arr = [_context executeFetchRequest:request error:&erro];
    NSLog(@"arr %@ err%@",arr,erro);
    return arr;


}


-(NSArray*)searchObjWithID:(NSString*)ids
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Entity"];
    
    NSPredicate* pre = [NSPredicate predicateWithFormat:@"shopID = %@",ids];
    request.predicate =pre;
    
    NSError* erro = nil;
    NSArray* arr = [_context executeFetchRequest:request error:&erro];
    NSLog(@"arr %@ err%@",arr,erro);
    return arr;
}


@end
