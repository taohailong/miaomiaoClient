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
    
    NSString* item = [jsonArr JSONString];
    
    NSString* url = [NSString stringWithFormat:@"http://%@/app/order/save?shop_id=%@&items=%@&address_id=%@&remarks=%@&act=%@",HTTPHOST,shop,item,add,mes,payWay];
    
    if (discount&&payWay!= OrderPayInCash) {
        url = [NSString stringWithFormat:@"%@&coupon_code=%@&coupon_id=%@",url,discount.discountCode,discount.discountID];
    }
    
    HTTPADD(url);
    url= [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
//    __weak NetWorkRequest* wself = self;
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
                order.orderTime = [manager  formateFloatTimeValueToString:timeLength] ;
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
                    [order setOrderStatueWithString:dic[@"order_status"]];
                }
                ;
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
            completeBk(nil,status);
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
//      __weak NetWorkRequest* wself = self;
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




#pragma mark--------------商铺定位－－－－－－－－－－－－－

-(void)seachShopWithCharacter:(NSString*)character WithBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/commy/query?q=%@",HTTPHOST,character];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err)
     {
         
         if (status==NetWorkSuccess) {
             
             NSMutableArray* returnArr = [[NSMutableArray alloc]init];
             
             DateFormateManager* formate = [DateFormateManager shareDateFormateManager];
             [formate setDateStyleString:@"HH:mm"];
             
             
             NSArray* arrDic = sourceDic[@"data"][@"communitys"];
             for (NSDictionary* dic in arrDic) {
                 
                 NSMutableDictionary* districtDic = [NSMutableDictionary dictionary];
                 
                 [districtDic setObject:dic[@"address"] forKey:@"address"];
                 [districtDic setObject:dic[@"name"] forKey:@"name"];
                 [districtDic setObject:dic[@"district"] forKey:@"distance"];

                 
                 NSMutableArray* shopArr = [[NSMutableArray alloc]init];
                 NSArray* shopDic = dic[@"shops"];
                 
                 for (NSDictionary* temp in shopDic)
                 {
                     ShopInfoData* shop = [[ShopInfoData alloc]init];
                     shop.shopID = [temp[@"id"] stringValue];
                     shop.shopName = temp[@"name"];
                     shop.longitude = [temp[@"lng"] floatValue];
                     shop.latitude = [temp[@"lat"] floatValue];
                     shop.shopAddress = temp[@"shop_address"];
                     shop.shopStatue = [temp[@"status"] intValue]?ShopClose:ShopOpen;
                     shop.mobilePhoneNu = temp[@"owner_phone"];
                     shop.minPrice = [temp[@"base_price"] floatValue]/100;
                     
                     
                     double openT = [temp[@"open_time"] doubleValue]/1000;
                     shop.openTime =  [formate formateFloatTimeValueToString:openT];
                     
                     double closeT = [temp[@"close_time"] doubleValue]/1000;
                     shop.closeTime = [formate formateFloatTimeValueToString:closeT];
                     
                     [shopArr addObject:shop];
                 }
                 [districtDic setObject:shopArr forKey:@"shops"];
                 [returnArr addObject:districtDic];
             }
             
             
             completeBk(returnArr,status);
         }
         else if (NetWorkErrorTokenInvalid==status)
         {
             completeBk(nil,status);
         }
         
         else
         {
             completeBk(nil,status);
         }
         
     }];
}



-(void)throughLocationGetShopWithlatitude:(float)latitude WithLong:(float)longitude WithBk:(NetCallback)completeBk
{
    
    NSString* url = [NSString stringWithFormat:@"http://%@/app/commy/near?lat=%f&lng=%f",HTTPHOST,latitude,longitude];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            
            NSMutableArray* returnArr = [[NSMutableArray alloc]init];
            
            DateFormateManager* formate = [DateFormateManager shareDateFormateManager];
            [formate setDateStyleString:@"HH:mm"];
            
            
            NSArray* arrDic = sourceDic[@"data"][@"communitys"];
            for (NSDictionary* dic in arrDic) {
                
                NSMutableDictionary* districtDic = [NSMutableDictionary dictionary];
                
                [districtDic setObject:dic[@"address"] forKey:@"address"];
                [districtDic setObject:dic[@"name"] forKey:@"name"];
                [districtDic setObject:dic[@"district"] forKey:@"distance"];
                NSMutableArray* shopArr = [[NSMutableArray alloc]init];
                NSArray* shopDic = dic[@"shops"];
                
                for (NSDictionary* temp in shopDic)
                {
                    ShopInfoData* shop = [[ShopInfoData alloc]init];
                    shop.shopID = [temp[@"id"] stringValue];
                    shop.shopName = temp[@"name"];
                    shop.longitude = [temp[@"lng"] floatValue];
                    shop.latitude = [temp[@"lat"] floatValue];
                    shop.shopAddress = temp[@"shop_address"];
                    shop.shopStatue = [temp[@"status"] intValue]?ShopClose:ShopOpen;
                    shop.mobilePhoneNu = temp[@"owner_phone"];
                    shop.minPrice = [temp[@"base_price"] floatValue]/100;
                    
                    
                    double openT = [temp[@"open_time"] doubleValue]/1000;
                    shop.openTime =  [formate formateFloatTimeValueToString:openT];
                    
                    double closeT = [temp[@"close_time"] doubleValue]/1000;
                    shop.closeTime = [formate formateFloatTimeValueToString:closeT];
                    
                    [shopArr addObject:shop];
                }
                [districtDic setObject:shopArr forKey:@"shops"];
                [returnArr addObject:districtDic];
            }
            
            
            completeBk(returnArr,status);
        }
        else if (NetWorkErrorTokenInvalid==status)
        {
            completeBk(nil,status);
        }
        
        else
        {
            completeBk(nil,status);
        }
        
    }];
    
}



#pragma mark--------------shop product--------------------------


-(void)getShopInfoWithShopID:(NSString*)shopid WithBk:(NetCallback)completeBk
{
    NSString* url = [NSString stringWithFormat:@"http://%@/app/shop?shop_id=%@",HTTPHOST,shopid];
    HTTPADD(url);
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        DateFormateManager* formate = [DateFormateManager shareDateFormateManager];
        
        [formate setDateStyleString:@"HH:mm"];

        if (status==NetWorkSuccess) {
            
            ShopInfoData* data = [[ShopInfoData alloc]init];
            
            data.shopName = sourceDic[@"data"][@"shop"][@"name"];
            data.shopAddress = sourceDic[@"data"][@"shop"][@"shop_address"];
            data.serveArea = sourceDic[@"data"][@"shop"][@"shop_info"];
            
            if (sourceDic[@"data"][@"shop"][@"open_time"]) {
                
                double openT = [sourceDic[@"data"][@"shop"][@"open_time"] doubleValue]/1000;
                data.openTime =  [formate formateFloatTimeValueToString:openT];
                
                double closeT = [sourceDic[@"data"][@"shop"][@"close_time"] doubleValue]/1000;
                data.closeTime = [formate formateFloatTimeValueToString:closeT];
            }
            
            data.mobilePhoneNu = sourceDic[@"data"][@"shop"][@"owner_phone"];
            data.shopStatue = [sourceDic[@"data"][@"shop"][@"status"] intValue]?ShopClose:ShopOpen;//0 营业中,1 打烊
            data.minPrice = [sourceDic[@"data"][@"shop"][@"base_price"] floatValue]/100;
            data.telPhoneNu  = sourceDic[@"data"][@"shop"][@"tel"];
            data.shopID = shopid;
            completeBk(data,status);
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
    NSString* url = [NSString stringWithFormat:@"http://%@/app/shop/category/get?shop_id=%@",HTTPHOST,shopID];
    HTTPADD(url);
    
    [self getMethodRequestStrUrl:url complete:^(NetWorkStatus status, NSDictionary *sourceDic, NSError *err) {
        
        if (status==NetWorkSuccess) {
            
            NSArray* categoryArr = sourceDic[@"data"][@"categoryls"];
            NSMutableArray* backArr = [[NSMutableArray alloc]init];
            for (NSDictionary* dic in categoryArr)
            {
                ShopCategoryData* category = [[ShopCategoryData alloc]init];
                category.categoryID = dic[@"category_id"];
                category.categoryName = dic[@"name"];
//                category.shopID = dic[@"shop_id"];
                category.subCategory = dic[@"category_sub_id"];
                [backArr addObject:category];
            }
            
            completeBk(backArr,status);
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
            completeBk(nil,status);
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
             completeBk(nil,status);
        }

        else
        {
            completeBk(nil,status);
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
             completeBk(nil,status);
        }

        else
        {
            completeBk(nil,status);
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
             completeBk(nil,status);
        }

        else
        {
            completeBk(nil,status);
        }
        
    }];
}

#pragma mark-----------address-------------------

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
                completeBk(nil,status);
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
            completeBk(nil,status);
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
                    address.addressID = temp[@"id"];
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
            completeBk(nil,status);
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
            completeBk(nil,status);
        }
        
    }];


}


//-(void)pushTokenInvalid
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:PNEEDLOG object:nil];
//}

#pragma mark--------------------api----------------------

-(void)getMethodRequestStrUrl:(NSString*)url complete:(void(^)(NetWorkStatus status,NSDictionary* sourceDic,NSError* err))block
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
            NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
            [def removeObjectForKey:UTOKEN];
            [def synchronize];
            THActivityView* warnView = [[THActivityView alloc]initWithString:@"登录失效,请重新登录！"];
            [warnView show];
            block(NetWorkErrorTokenInvalid,dataDic,nil);
        }
        else
        {
           NSMutableString* errStr = [[NSMutableString alloc]initWithString:dataDic[@"msg"]];
            
           block(NetWorkErrorCanntConnect,(id)errStr,nil);
        }
        
    }];
    
    [_asi setFailedBlock:^{
        NSLog(@"bkAsi.error %@",bkAsi.error);
        block( NetWorkErrorCanntConnect,nil,bkAsi.error);
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
