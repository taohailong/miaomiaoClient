//
//  NetWorkRequest.m
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "NetWorkRequest.h"
#import "ASIHTTPRequest.h"
#import "OpenUDID.h"
#import "UserManager.h"
#import "ASIFormDataRequest.h"
#import "DateFormateManager.h"
#import "ShopInfoData.h"
#import "DateFormateManager.h"
#import "ShopCategoryData.h"
#import "ShopProductData.h"
#import "AddressData.h"
#import "JSONKit.h"
#import "OrderData.h"
#import "DiscountData.h"
#import "THActivityView.h"
#import "CommentData.h"


#define HTTPADD(X) X = [NSString stringWithFormat:@"%@&%@",X, [NSString stringWithFormat:@"uid=%@&gid=%@&chn=ios&user_token=%@",[OpenUDID value],[[NSUserDefaults  standardUserDefaults] objectForKey:UGID]?[[NSUserDefaults  standardUserDefaults] objectForKey:UGID]:@"",[[NSUserDefaults  standardUserDefaults] objectForKey:UTOKEN]?[[NSUserDefaults  standardUserDefaults] objectForKey:UTOKEN]:@""]]

#define HTTPNOTTOKEN [NSString stringWithFormat:@"uid=%@&gid=%@&chn=ios",[OpenUDID value],[[NSUserDefaults  standardUserDefaults] objectForKey:UGID]?[[NSUserDefaults  standardUserDefaults] objectForKey:UGID]:@""]

#define HTTPPREFIX  [NSString stringWithFormat:@"uid=%@&gid=%@&chn=ios&user_token=%@",[OpenUDID value],[[NSUserDefaults  standardUserDefaults] objectForKey:UGID]?[[NSUserDefaults  standardUserDefaults] objectForKey:UGID]:@"",[[NSUserDefaults  standardUserDefaults] objectForKey:UTOKEN]?[[NSUserDefaults  standardUserDefaults] objectForKey:UTOKEN]:@""]


@interface NetWorkRequest()
{
    ASIHTTPRequest* _asi;
    ASIFormDataRequest* _postAsi;
}
@end;
@implementation NetWorkRequest

#pragma mark-favoriteAPI

-(void)setFavoriteShop:(ShopInfoData*)shop withCompleteBk:(NetCallback)bk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/favourite/mark?shop_id=%@",HTTPHOST,shop.shopID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            bk(sourceDic,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            bk(nil,status);
        }
        else
        {
            bk(sourceDic,status);
        }
    }];
}


-(void)cancelFavoriteShop:(ShopInfoData*)shop withCompleteBk:(NetCallback)bk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/favourite/unmark?shop_id=%@",HTTPHOST,shop.shopID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            bk(sourceDic,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            bk(nil,status);
        }
        else
        {
            bk(sourceDic,status);
        }
    }];
}

-(void)getFavoriteList:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/favourite/myMark?%@",HTTPHOST,HTTPPREFIX];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
     NetWorkRequest* wself = self;
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
         __strong NetWorkRequest * sself =  wself;
    
            if (status==NetWorkSuccess) {
                
                NSMutableArray* backArr = [[NSMutableArray alloc]init];
                NSArray* shopArr = sourceDic[@"data"][@"myMarkShops"];
                for (NSDictionary* dic in shopArr)
                {
                    ShopInfoData* shop = [sself getShopFromDic:dic];
                    shop.favorite = YES;
                    [backArr addObject:shop];
                }
                
                completeBk(backArr,status);
            }
            else if (status==NetWorkErrorTokenInvalid)
            {
                completeBk(nil,status);
            }
            else
            {
                completeBk(sourceDic,status);
            }
    }];
}


#pragma mark-CommentApi-

-(void)commitCommentWithOrder:(OrderData*)order comment:(NSString*)comment score:(int)score completeBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/comment/submit?shopId=%@&orderId=%@&starComment=%d&wordsComment=%@",HTTPHOST,order.shopID,order.orderNu,score,comment];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            completeBk(sourceDic,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
        }
        else
        {
            completeBk(sourceDic,status);
        }
    }];
}


-(void)getShopCommentFromIndex:(NSInteger)start completeBlock:(NetCallback)completeBk
{
    UserManager* user = [UserManager shareUserManager];
    NSString* url = [NSString stringWithFormat:@"http://%@/app/comment/shopAllComments?from=%ld&offset=20&shopId=%@",HTTPHOST,(long)start,user.shop.shopID];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess)
        {
            NSMutableArray* backArr = [[NSMutableArray alloc]init];
            NSArray* arr = sourceDic[@"data"][@"orderComments"];
            
            for (NSDictionary* dic in arr)
            {
                CommentData* comment = [[CommentData alloc]init];
                comment.creatTime = dic[@"createTime"];
                comment.comments = dic[@"wordsComment"];
                comment.score = [dic[@"starComment"] floatValue];
                comment.telphone = dic[@"phone"];
                [backArr addObject:comment];
            }
            completeBk(backArr,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
        }
        else
        {
            completeBk(sourceDic,status);
        }
    }];
}



-(void)getAllUserCommentWithIndex:(NSInteger)start ompleteBlock:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/comment/userAllComments?from=%ld&offset=20",HTTPHOST,(long)start];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess)
        {
            NSMutableArray* backArr = [[NSMutableArray alloc]init];
            NSArray* arr = sourceDic[@"data"][@"orderComments"];
            
            for (NSDictionary* dic in arr)
            {
                CommentData* comment = [[CommentData alloc]init];
                comment.creatTime = dic[@"createTime"];
                comment.comments = dic[@"wordsComment"];
                comment.score = [dic[@"starComment"] floatValue];
                comment.shopName = dic[@"shopName"];
                [backArr addObject:comment];
            }
            completeBk(backArr,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
        }
        else
        {
            completeBk(sourceDic,status);
        }
    }];
}






#pragma mark-RootCollectionView

-(void)getRootCollectionDataWithCompleteBk:(NetCallback)completeBk
{
   
}

#pragma mark----------spread-----------

-(void)verifySpreadCode:(NSString*)code WithCompleteBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/user/confirmInviteCode?code=%@",HTTPHOST,code];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            completeBk(sourceDic,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
        }
        else
        {
            completeBk(sourceDic,status);
        }
    }];
}


#pragma mark-----------discount ticket----------------

-(void)getDiscountTicketListWithIndex:(int)index WithBk:(NetCallback)completeBk
{
    UserManager* user = [UserManager shareUserManager];
    NSString* url = [NSString stringWithFormat:@"http://%@/app/coupon/allCoupons?type=all&from=%d&offet=20&shop_id=%@",HTTPHOST,index,user.shopID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            
            NSArray* sourceArr = sourceDic[@"data"][@"coupons"];
            NSMutableArray* backArr = [[NSMutableArray alloc]init];
            
            for (NSDictionary* dic in sourceArr)
            {
                DiscountData* discount = [[DiscountData alloc]init];
                discount.discountCode = dic[@"code"];
                discount.discountID = dic[@"id"];
                [discount setDateStamp:[dic[@"end_time"] doubleValue]];
                [discount setStartDate:[dic[@"start_time"] doubleValue]];
                [discount setDiscountStatus:[dic[@"status"] intValue]];
                discount.discountTitle = dic[@"name"];
                discount.discountMoney = [dic[@"price"] intValue]/100.0;
                discount.minMoney = [dic[@"fullCutPrice"] intValue]/100.0;
                [backArr addObject:discount];
            }
            
            completeBk(backArr,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
        }
        
        else
        {
            completeBk(sourceDic,status);
        }
    }];
}

-(void)getValidDiscountTicketWithBk:(NetCallback)completeBk
{
    UserManager* user = [UserManager shareUserManager];
    NSString* url = [NSString stringWithFormat:@"http://%@/app/coupon/allCoupons?shop_id=%@",HTTPHOST,user.shopID];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
    
        if (status==NetWorkSuccess) {
            
            NSArray* sourceArr = sourceDic[@"data"][@"coupons"];
            NSMutableArray* backArr = [[NSMutableArray alloc]init];
            
            for (NSDictionary* dic in sourceArr)
            {
                DiscountData* discount = [[DiscountData alloc]init];
                discount.discountCode = dic[@"code"];
                discount.discountID = dic[@"id"];
                [discount setDateStamp:[dic[@"end_time"] doubleValue]];
                [discount setStartDate:[dic[@"start_time"] doubleValue]];
                [discount setDiscountStatus:[dic[@"status"] intValue]];
                discount.discountTitle = dic[@"ext"];
                discount.discountMoney = [dic[@"price"] intValue]/100.0;
                discount.minMoney = [dic[@"fullCutPrice"] intValue]/100.0;
                [backArr addObject:discount];
            }
            completeBk(backArr,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
        }
        else
        {
            completeBk(sourceDic,status);
        }
        
    }];
}

#pragma mark---------suggest----------

-(void)commitSuggestionString:(NSString*)string WithBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/feedback?opinion=%@",HTTPHOST,string];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            
            completeBk(@"yes",status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
        }
        
        else
        {
            completeBk(nil,status);
        }
        
    }];

}


#pragma mark-------------order------------------

-(void)commitOrderWithProducts:(NSMutableArray*)arr WithMessage:(NSString*)mes WithPayWay:(OrderPayWay)way WithDiscount:(DiscountData*)discount WithAddress:(NSString*)add WithShopID:(NSString*)shop WithBk:(NetCallback)completeBk
{
    NSString* payWay = nil;
    switch (way) {
        case OrderPayInWx:
            payWay = @"wx_native";
            break;
            
        case OrderPayInZfb:
            payWay = @"ali_native";
            break;

        default:
            payWay = @"cash";
            break;
    }
    NSMutableArray* jsonArr = [[NSMutableArray alloc]init];
    for (ShopProductData* temp in arr)
    {
        NSDictionary*dic = @{@"item_id":temp.pID,@"count":[NSString stringWithFormat:@"%d",temp.count]};
        [jsonArr addObject:dic];
    }
    NSString* startT = nil;
    NSString* endT = nil;
    
    UserManager* manager = [UserManager shareUserManager];
    if (manager.shop.shopStatue == ShopClose) {
       startT = [manager.shop getOpenTime];
       endT = [manager.shop getOpenTimeAddThirtyMins];
    }
    else
    {
       startT = @"00:00";
        endT = @"08:30";
    }
    NSString* item = [jsonArr JSONString];
    
    NSString* url = [NSString stringWithFormat:@"http://%@/app/order/submit?shop_id=%@&items=%@&address_id=%@&remarks=%@&act=%@&express_start=%@&express_end=%@",HTTPHOST,shop,item,add,mes,payWay,startT,endT];
//    NSString* url = [NSString stringWithFormat:@"http://%@/app/order/save?shop_id=%@&items=%@&address_id=%@&remarks=%@&act=%@&express_start=%@&express_end=%@",HTTPHOST,shop,item,add,mes,payWay,startT,endT];
    
    if (discount&&payWay!= OrderPayInCash) {
        url = [NSString stringWithFormat:@"%@&coupon_code=%@&coupon_id=%@",url,discount.discountCode,discount.discountID];
    }
    
    HTTPADD(url);
    url= [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess)
        {
            completeBk(sourceDic[@"data"],status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
           completeBk(nil,status);
           [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
        }
        else
        {
            completeBk(sourceDic,status);
        }
        
    }];

}

-(void)getAllOrdersWithFromIndex:(int)index WithBk:(NetCallback)completeBk
{
    
    NSString* url = [NSString stringWithFormat:@"http://%@/app/user/profile?from=%d&offset=20&%@",HTTPHOST,index,HTTPPREFIX];
    
//    __weak NetWorkRequest* wself = self;
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {

            DateFormateManager* manager = [DateFormateManager shareDateFormateManager];
            [manager  setDateStyleString:@"YY-MM-dd HH:mm"];
            
            NSMutableArray* returnArr = [[NSMutableArray alloc]init];
            NSArray* arr = sourceDic[@"data"][@"orders"];
            for (NSDictionary* dic in arr)
            {
                OrderData* order = [[OrderData alloc]init];
                order.orderAddress = dic[@"address"];
                order.orderID = dic[@"id"];
                order.shopID = dic[@"shop_id"];
                double timeLength = [dic[@"create_time"] doubleValue]/1000;
                order.orderTime = [manager  formateFloatTimeValueToString:timeLength];
                order.orderNu = dic[@"order_id"];
                order.payWay = dic[@"act"];
                order.discountMoney = [dic[@"dprice"] floatValue]/100.0;
                order.telPhone = dic[@"phone"];
                order.shopName = dic[@"shop_name4V"];
                order.totalMoney = dic[@"price4V"] ;
                order.messageStr = dic[@"remarks"];
                
                if ([dic[@"status"] intValue]==0) {
                    
                    [order setOrderPayStatus:dic[@"status"] WithType:dic[@"act"]];
                }
                else
                {
                    [order setOrderStatueWithString:dic[@"order_status"] comment:[dic[@"comment"] intValue]];
                }
                [order setOrderInfoString:dic[@"info"]];
                [returnArr addObject:order];
            }
            
            completeBk(returnArr,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);

            [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
        }

        else
        {
            completeBk(sourceDic,status);
        }
        
    }];

}


-(void)confirmOrderWithOrder:(OrderData*)order WithBk:(NetCallback)completeBk
{
    
    NSString* url = [NSString stringWithFormat:@"http://%@/app/order/order_confirm?order_id=%@&shop_id=%@",HTTPHOST,order.orderNu,order.shopID];
    HTTPADD(url);
//     __weak NetWorkRequest* wself = self;
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {

            completeBk(@"yes",status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
            [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
        }
        
        else
        {
            completeBk(sourceDic,status);
        }
        
    }];

}

-(void)cancelOrderWithOrder:(OrderData*)order WithBk:(NetCallback)completeBk
{
    
    NSString* url = [NSString stringWithFormat:@"http://%@/app/order/order_cancel?order_id=%@&shop_id=%@",HTTPHOST,order.orderNu,order.shopID];
    HTTPADD(url);
//     __weak NetWorkRequest* wself = self;
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            
            completeBk(@"yes",status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
             [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
        }
        
        else
        {
            completeBk(nil,status);
        }
        
    }];
    
}

-(void)remindOrderWithOrder:(OrderData*)order WithBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/order/order_remindShopping?order_id=%@&shop_id=%@",HTTPHOST,order.orderNu,order.shopID];
    HTTPADD(url);
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
            
            if (status==NetWorkSuccess) {
                
                completeBk(@"yes",status);
            }
            else if (status==NetWorkErrorTokenInvalid)
            {
                completeBk(nil,status);
                [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
            }
            else
            {
                completeBk(sourceDic,status);
            }
            
        }];
}

-(void)rePayOrderWithOrder:(OrderData*)order WithBk:(NetCallback)completeBk
{
    
    NSString* url = [NSString stringWithFormat:@"http://%@/app/order/pay?shopId=%@&orderId=%@&act=%@",HTTPHOST,order.shopID,order.orderNu,order.payWay];
    HTTPADD(url);

    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            
            completeBk(sourceDic[@"data"],status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
            [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
        }
        
        else
        {
            completeBk(sourceDic,status);
        }
        
    }];


}


#pragma mark--------------商铺定位－－－－－－－－－－－－－

-(void)getShopsWithAddress:(ShopInfoData*)shop WithComplete:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/shopGeo/searchShop?buildingId=%@&lat=%f&lng=%f",HTTPHOST,shop.shopID,shop.latitude,shop.longitude];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
     NetWorkRequest* wself = self;

    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err)
     {
         __strong NetWorkRequest* sself = wself;
         
         if (status==NetWorkSuccess) {
             
             NSArray* arrDic = sourceDic[@"data"][@"searchShops"];
             NSMutableArray* shopArr = [[NSMutableArray alloc]init];
             for (NSDictionary* temp in arrDic) {
                 
                 ShopInfoData* shop = [sself getShopFromDic:temp];
                 [shopArr addObject:shop];
             }
             completeBk(shopArr,status);
         }
         else if (NetWorkErrorTokenInvalid==status)
         {
             completeBk(nil,status);
         }
         
         else
         {
             completeBk(sourceDic,status);
         }
         
     }];
}



-(void)seachShopWithCharacter:(NSString*)character WithBk:(NetCallback)completeBk
{
//    NSString* url = [NSString stringWithFormat:@"http://%@/app/commy/query?q=%@",HTTPHOST,character];
    NSString* url = [NSString stringWithFormat:@"http://%@/app/shopGeo/communityList?q=%@&city_id=131",HTTPHOST,character];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err)
     {
         if (status==NetWorkSuccess) {
             
            NSArray* arrDic = sourceDic[@"data"][@"communitys"];
            NSMutableArray* shopArr = [[NSMutableArray alloc]init];
            for (NSDictionary* temp in arrDic)
            {
                ShopInfoData* shop = [[ShopInfoData alloc]init];
                shop.shopID = temp[@"uid"] ;
                shop.longitude = [temp[@"lng"] floatValue];
                shop.latitude = [temp[@"lat"] floatValue];
                shop.shopName = temp[@"name"];
                shop.shopAddress = temp[@"address"];
                
                [shopArr addObject:shop];
             }
             completeBk(shopArr,status);
         }
         else if (NetWorkErrorTokenInvalid==status)
         {
             completeBk(nil,status);
         }
         
         else
         {
             completeBk(sourceDic,status);
         }
         
     }];
}



-(void)throughLocationGetShopWithlatitude:(float)latitude WithLong:(float)longitude WithBk:(NetCallback)completeBk
{
    
//    NSString* url = [NSString stringWithFormat:@"http://%@/app/commy/near?lat=%f&lng=%f",HTTPHOST,latitude,longitude];
    
    NSString* url = [NSString stringWithFormat:@"http://%@/app/shopGeo/allShop?lat=%f&lng=%f&city_id=131",HTTPHOST,latitude,longitude];
    HTTPADD(url);
//    NSLog(@"%@",url);
     NetWorkRequest* wself = self;
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        __strong NetWorkRequest* sself = wself;
        if (status==NetWorkSuccess) {
            
            NSMutableDictionary* returnDic = [[NSMutableDictionary alloc]init];
        
            NSString* area = sourceDic[@"data"][@"geoMsg"];
            if (area) {
               [returnDic setObject:area forKey:@"area"];
            }
            
            NSArray* arrBest = sourceDic[@"data"][@"bestShops"];
            NSMutableArray* shopBest = [[NSMutableArray alloc]init];
            
            for (NSDictionary* dic in arrBest)
            {
                ShopInfoData* shop = [sself getShopFromDic:dic];
                [shopBest addObject:shop];
            }
            
            NSArray* arrNear = sourceDic[@"data"][@"nearShops"];
            NSMutableArray* shopNear = [[NSMutableArray alloc]init];
            
            for (NSDictionary* dic in arrNear)
            {
                ShopInfoData* shop = [sself getShopFromDic:dic];
                [shopNear addObject:shop];
            }
  
//            markShops
            
            NSArray* arrFavorite = sourceDic[@"data"][@"markShops"];
            NSMutableArray* shopFavorite = [[NSMutableArray alloc]init];
            
            for (NSDictionary* dic in arrFavorite)
            {
                ShopInfoData* shop = [sself getShopFromDic:dic];
                [shopFavorite addObject:shop];
            }

            [returnDic setObject:shopFavorite forKey:@"favorite"];
            [returnDic setObject:shopBest  forKey:@"best"];
            [returnDic setObject:shopNear  forKey:@"near"];
            completeBk(returnDic,status);
        }
        else if (NetWorkErrorTokenInvalid==status)
        {
            completeBk(nil,status);
        }
        
        else
        {
            completeBk(sourceDic,status);
        }
        
    }];
    
}


-(ShopInfoData*)getShopFromDic:(NSDictionary*)temp
{
    ShopInfoData* shop = [[ShopInfoData alloc]init];
    shop.shopID = [temp[@"id"] stringValue];
    shop.score = [temp[@"avgStar"] floatValue];
    shop.shopName = temp[@"name"];
    shop.longitude = [temp[@"lng"] floatValue];
    shop.latitude = [temp[@"lat"] floatValue];
    shop.shopAddress = temp[@"shop_address"];
    shop.shopStatue = [temp[@"status"] intValue]?ShopClose:ShopOpen;
    shop.favorite = [temp[@"mark"] intValue]?YES:NO;
    shop.distance = [temp[@"distance"] intValue];
    [shop setServeArea:temp[@"serviceArea"]];
//    [shop setServeArea:@"1,2,3,4,5,6,78,999,1,0"];
    shop.mobilePhoneNu = temp[@"owner_phone"];
    shop.minPrice = [temp[@"base_price"] floatValue]/100;
    shop.deliverCharge = [temp[@"express_fee"] intValue]/100.0;
    [shop parseCombinPay:[temp[@"combin_pay"] intValue]];
    double openT = [temp[@"open_time"] doubleValue]/1000;
    shop.openTime =  openT;
    
    double closeT = [temp[@"close_time"] doubleValue]/1000;
    shop.closeTime = closeT;
    return shop;
}

#pragma mark--------------shop product--------------------------


-(void)getShopInfoWithShopID:(NSString*)shopid WithBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/shop/index?shopId=%@",HTTPHOST,shopid];
    HTTPADD(url);
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
         if (status==NetWorkSuccess) {
            
            NSMutableArray* category_return = [[NSMutableArray alloc]init];
            NSArray* categoryArr = sourceDic[@"data"][@"categoryls"];
             for (NSDictionary* dic in categoryArr) {
                 
                 ShopCategoryData* category = [[ShopCategoryData alloc]init];
                 category.categoryID = [dic[@"category_id"] stringValue];
                 category.categoryName = dic[@"name"];
                 
                 NSMutableArray* p_return = [[NSMutableArray alloc]init];
                 
                 NSArray* productArr = dic[@"items"];
                 for (NSDictionary* p in productArr) {
                     ShopProductData* pData = [[ShopProductData alloc]init];
                     pData.pID = [p[@"id"] stringValue];
                     pData.pName = p[@"name"];
                     pData.price = [p[@"price"] intValue]/100.0;
                     pData.pUrl = p[@"pic_url"];
                     [p_return addObject:pData];
                 }
                 category.products = p_return;
                 
                 [category_return addObject: category];
             }
        
//             ////////////shopinfo////////////
            ShopInfoData* data = [[ShopInfoData alloc]init];
            NSDictionary* shopDic = sourceDic[@"data"][@"shop"];
             
            data.longitude = [shopDic[@"lng"] floatValue];
            data.latitude = [shopDic[@"lat"] floatValue];
             
             data.score = [shopDic[@"avgStar"] floatValue];
             [data parseCombinPay:[shopDic[@"combin_pay"] intValue]];
            data.shopName = shopDic[@"name"];
            data.shopAddress = shopDic[@"shop_address"];
            data.serveArea = shopDic[@"shop_info"];
            data.deliverCharge = [shopDic[@"express_fee"] intValue]/100.0;
            if (shopDic[@"open_time"])
            {
                double openT = [shopDic[@"open_time"] doubleValue]/1000;
                data.openTime =  openT;
                
                double closeT = [shopDic[@"close_time"] doubleValue]/1000;
                data.closeTime = closeT;
            }
            
            data.mobilePhoneNu = shopDic[@"owner_phone"];
            data.shopStatue = [shopDic[@"status"] intValue]?ShopClose:ShopOpen;//0 营业中,1 打烊
            data.minPrice = [shopDic[@"base_price"] floatValue]/100;
            data.telPhoneNu  = shopDic[@"tel"];
            data.shopID = shopid;
             
             
             NSMutableDictionary* returnDic = [[NSMutableDictionary alloc]init];
             [returnDic setObject:data forKey:ROOTSHOP];
             [returnDic setObject:category_return forKey:ROOTCATEGORY];
             [returnDic setObject:sourceDic[@"data"][@"urls"] forKey:ROOTPIC];
             [returnDic setObject:sourceDic[@"data"][@"activites"] forKey:ROOTACTIVITY];
            completeBk(returnDic,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
        }
        
        else
        {
            completeBk(sourceDic,status);
        }
        
    }];

}


-(void)seachProductWithShopID:(NSString*)shopID WithCharacter:(NSString*)character WithBk:(NetCallback)completeBk
{

    NSString* url = [NSString stringWithFormat:@"http://%@/app/search/query?shop_id=%@&key=%@",HTTPHOST,shopID,character];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess)
        {
            NSMutableArray* arr = [NSMutableArray array];
            NSArray* products = sourceDic[@"data"][@"items"];
            for (NSDictionary* dic in products)
            {
                ShopProductData* product = [[ShopProductData alloc]init];
                product.pUrl = dic[@"pic_url"];
                product.shopID = dic[@"shop_id"];
                product.categoryID = dic[@"category_id"];
                product.price = [dic[@"price"] floatValue]/100;
                product.pName = dic[@"name"];
                product.pID = [dic[@"id"] stringValue];
                [arr addObject:product];
            }
            completeBk(arr,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
        }
        
        else
        {
            completeBk(sourceDic,status);
        }
        
    }];
}


-(void)shopGetCategoryWithShopID:(NSString *)shopID callBack:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/shop/category/get/v2?shop_id=%@",HTTPHOST,shopID];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            
            NSMutableArray* backArr = [[NSMutableArray alloc]init];
            NSArray* cateArr = sourceDic[@"data"][@"categoryList"];
            for (NSDictionary* dic in cateArr)
            {
                ShopCategoryData* cateData = [[ShopCategoryData alloc]init];
                cateData.categoryID = [dic[@"category_id"] stringValue];
                cateData.categoryName = dic[@"name"];
//                cateData.type = CategoryMainClass;
                [backArr addObject:cateData];
                
                
                NSMutableArray* back_sub = [[NSMutableArray alloc]init];
                NSArray* subCategory = dic[@"subCategoryList"];
                for (NSDictionary* subDic in subCategory) {
                    
                    ShopCategoryData* cateSub = [[ShopCategoryData alloc]init];
                    cateSub.categoryID = [subDic[@"category_id"] stringValue];
                    cateSub.categoryName = subDic[@"name"];
//                    cateSub.type = CategorySubClass;
                    [back_sub addObject:cateSub];
                }
                cateData.subClass = back_sub;
            }
            
            completeBk(backArr,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
        }

        else
        {
            completeBk(sourceDic,status);
        }
        
    }];
}


-(void)shopGetProductWithShopID:(NSString *)shopID withCategory:(NSString *)category fromIndex:(int)nu WithCallBack:(NetCallback)back
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/shop/getitems?shop_id=%@&category_id=%@&from=%d&offset=20",HTTPHOST,shopID,category,nu];
    HTTPADD(url);

    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess)
        {
            NSMutableArray* arr = [NSMutableArray array];
            NSArray* products = sourceDic[@"data"][@"items"];
            for (NSDictionary* dic in products)
            {
                ShopProductData* product = [[ShopProductData alloc]init];
                product.pUrl = dic[@"pic_url"];
                product.shopID = dic[@"shop_id"];
                product.categoryID = dic[@"category_id"];
                product.price = [dic[@"price"] floatValue]/100;
                product.pName = dic[@"name"];
//                product.status = [dic[@"onsell"] intValue];
                product.pID = [dic[@"id"] stringValue];
//                product.count = [dic[@"count"] intValue];
//                product.scanNu = dic[@"serialNo"] ;
                [arr addObject:product];
            }
            back(arr,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            back(nil,status);
        }

        else
        {
            back(sourceDic,status);
        }
        
    }];

}


#pragma mark-----------login--------------

-(void)getPhoneVerifyCodeWithAccount:(NSString *)phone WithBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/verifyCode/sendVoiceCode?phone=%@&%@",HTTPHOST,phone,HTTPPREFIX];
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            completeBk(sourceDic,status);
        }
        else if (NetWorkErrorTokenInvalid==status)
        {
            completeBk(sourceDic,status);
        }
        
        else
        {
            completeBk(sourceDic,status);
        }
        
    }];


}

-(void)getGidWithBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/m_login?",HTTPHOST];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            completeBk(sourceDic,status);
        }
        else if (NetWorkErrorTokenInvalid==status)
        {
             completeBk(nil,status);
        }

        else
        {
            completeBk(sourceDic,status);
        }
    }];
}


-(void)userLoginWithAccount:(NSString*)account WithPw:(NSString*)pw WithBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/user/login?validate_code=%@&phone=%@",HTTPHOST,pw,account];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            completeBk(sourceDic,status);
        }
        else if (NetWorkErrorTokenInvalid==status)
        {
             completeBk(sourceDic,status);
        }

        else
        {
            completeBk(sourceDic,status);
        }
        
    }];
}


-(void)userLogOutWithAccount:(NSString*)account withBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/user/logOut?phone=%@",HTTPHOST,account];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            completeBk(sourceDic,status);
        }
        else if (NetWorkErrorTokenInvalid==status)
        {
             completeBk(sourceDic,status);
        }

        else
        {
            completeBk(sourceDic,status);
        }
        
    }];
}


-(void)getVerifyCodeWithAccount:(NSString*)phone WithBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/verifyCode/send?phone=%@&",HTTPHOST,phone];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            completeBk(sourceDic,status);
        }
        else if (NetWorkErrorTokenInvalid==status)
        {
             completeBk(sourceDic,status);
        }

        else
        {
            completeBk(sourceDic,status);
        }
        
    }];
}

#pragma mark-----------address-------------------


-(void)getDefaultAddressWithBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/address/get/default?%@",HTTPHOST,HTTPPREFIX];
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            
            NSDictionary* adressDic = sourceDic[@"data"][@"addr"];
            
            if (adressDic==nil) {
                completeBk(nil,status);
                return ;
            }
            AddressData* adress = [[AddressData alloc]init];
            adress.address = adressDic[@"address"];
            adress.addressID = [adressDic[@"id"] stringValue];
            adress.phoneNu = adressDic[@"phone"];
            completeBk(adress,status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
            [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
        }
        
        else
        {
            completeBk(sourceDic,status);
        }
    }];
}



-(void)setDefaultAddress:(AddressData*)address WithCompleteBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/address/set/default?addrId=%@",HTTPHOST,address.addressID];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            
            completeBk(@"ok",status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(sourceDic,status);
            [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
        }
        else
        {
            completeBk(sourceDic,status);
        }
    }];
}



-(void)addressDeleteWithAddID:(NSString*)addressID WithBk:(NetCallback)completeBk
{
   NSString* url = [NSString stringWithFormat:@"http://%@/app/address/del?address_id=%@",HTTPHOST,addressID];
    HTTPADD(url);
//     __weak NetWorkRequest* wself = self;
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
            
            if (status==NetWorkSuccess) {
                
                completeBk(@"yes",status);
            }
            else if (status==NetWorkErrorTokenInvalid)
            {
                completeBk(nil,status);
               [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
            }
            
            else
            {
                completeBk(sourceDic,status);
            }
    }];
}

-(void)addressUpdateWithAddID:(NSString*)addressID withAddress:(NSString*)address withPhone:(NSString*)phone WithBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/address/update?address_id=%@&phone=%@&address=%@",HTTPHOST,addressID,phone,address];
    
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            
            completeBk(@"yes",status);
        }
        else if (status==NetWorkErrorTokenInvalid)
        {
            completeBk(nil,status);
            [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
        }
        
        else
        {
            completeBk(sourceDic,status);
        }
        
    }];
}



-(void)getAddressWithBk:(NetCallback)completeBk
{
//   __weak NetWorkRequest* wself = self;
    NSString* url = [NSString stringWithFormat:@"http://%@/app/address?%@",HTTPHOST,HTTPPREFIX];
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            
            NSArray * arr = sourceDic[@"data"][@"addressls"];
            NSMutableArray* backArr = [[NSMutableArray alloc]init];
            if (arr.count)
            {
                for (NSDictionary * temp in arr) {
                    AddressData* address = [[AddressData alloc]init];
                    address.address = temp[@"address"];
                    address.phoneNu = temp[@"phone"];
                    address.addressID = [temp[@"id"] stringValue];
                    address.isDefault = [temp[@"type"] intValue];
                    [backArr addObject:address];
                }
            }

            completeBk(backArr,status);
        }
        else if (NetWorkErrorTokenInvalid==status)
        {
             completeBk(nil,status);
            [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
        }

        else
        {
            completeBk(sourceDic,status);
        }
        
    }];

}

-(void)addAddressWithAddress:(NSString*)address WithPhone:(NSString*)phone WithBk:(NetCallback)completeBk
{
    
    NSString* url = [NSString stringWithFormat:@"http://%@/app/address/add?address=%@&phone=%@",HTTPHOST,address,phone];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);

    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (NetWorkSuccess==status) {
            
            NSDictionary* dic = sourceDic[@"data"];
            AddressData* address = [[AddressData alloc]init];
            address.address = dic[@"address"];
            address.addressID=dic[@"address_id"];
            address.phoneNu = dic[@"phone"];
            
            completeBk(address,status);
        }
        else if (NetWorkErrorTokenInvalid==status)
        {
            completeBk(nil,status);

            [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
        }
        else
        {
            completeBk(sourceDic,status);
        }
        
    }];
}


//-(void)pushTokenInvalid
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
//}

#pragma mark--------------------api----------------------

-(void)getMethodRequestStrUrl:(NSString*)url complete:(void(^)(NetWorkStatus status,id sourceDic,NSError* err))block
{
    
    _asi = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
//    _asi.shouldAttemptPersistentConnection   = NO;
    __weak ASIHTTPRequest* bkAsi = _asi;
    
    [_asi setCompletionBlock:^{
        
        NSDictionary* dataDic = [NSJSONSerialization JSONObjectWithData:bkAsi.responseData options:NSJSONReadingMutableContainers error:NULL];
        
        int codeNu = [dataDic[@"code"] intValue];
        
        if (dataDic&&codeNu==0) {

             block(NetWorkSuccess,dataDic,nil);
        }
        else if (codeNu==300)
        {
            THActivityView* warnView = [[THActivityView alloc]initWithString:@"登录失效,请重新登录"];
            [warnView show];
            
            NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
            [def removeObjectForKey:UTOKEN];
            [def synchronize];
            block(NetWorkErrorTokenInvalid,dataDic,nil);
        }
        else if (dataDic==nil)
        {
            block(NetWorkErrorUnKnow,@"服务器错误",nil);
        }
        else
        {
           NSMutableString* errStr = [[NSMutableString alloc]initWithString:dataDic[@"msg"]];
           block(NetWorkErrorUnKnow,(id)errStr,nil);
        }
        
    }];
    
    [_asi setFailedBlock:^{
        
        NSLog(@"bkAsi.error %@",bkAsi.error.localizedFailureReason);
        block(NetWorkErrorCanntConnect,@"网络连接失败",bkAsi.error);
    }];
    
}


-(void)startAsynchronous
{
    [_asi startAsynchronous];
}

-(void)cancel
{
    [_asi cancel];
    _asi = nil;
}

-(void)dealloc
{
//    [self cancel];
}

@end
