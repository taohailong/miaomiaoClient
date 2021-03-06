//
//  NetWorkRequest.h
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-22.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ShopProductData,ShopCategoryData,ShopInfoData,DiscountData,OrderData,AddressData;

typedef enum _OrderPayWay {
    OrderPayInCash = 0,
    OrderPayInWx = 1,
     OrderPayInZfb = 2
} OrderPayWay;


typedef  enum _NetWorkStatus{
    NetWorkSuccess,
    NetWorkErrorCanntConnect,
    NetWorkErrorTokenInvalid,
    NetWorkErrorUnKnow
    
}NetWorkStatus;


typedef void (^NetCallback)(id respond,NetWorkStatus status);
@interface NetWorkRequest : NSObject



//评论

-(void)getAllUserCommentWithIndex:(NSInteger)start ompleteBlock:(NetCallback)completeBk;

-(void)getShopCommentFromIndex:(NSInteger)start completeBlock:(NetCallback)completeBk;

-(void)commitCommentWithOrder:(OrderData*)order comment:(NSString*)comment score:(int)score completeBk:(NetCallback)completeBk;



//数据
-(void)startAsynchronous;
-(void)cancel;

//收藏

-(void)setFavoriteShop:(ShopInfoData*)shop withCompleteBk:(NetCallback)bk;

-(void)cancelFavoriteShop:(ShopInfoData*)shop withCompleteBk:(NetCallback)bk;
-(void)getFavoriteList:(NetCallback)completeBk;

//推荐码
-(void)verifySpreadCode:(NSString*)code WithCompleteBk:(NetCallback)completeBk;


//代金券
-(void)getDiscountTicketListWithIndex:(int)index WithBk:(NetCallback)completeBk;
-(void)getValidDiscountTicketWithBk:(NetCallback)completeBk;


//建议
-(void)commitSuggestionString:(NSString*)string WithBk:(NetCallback)completeBk;

//订单
-(void)commitOrderWithProducts:(NSMutableArray*)arr WithMessage:(NSString*)mes WithPayWay:(OrderPayWay)way WithDiscount:(DiscountData*)discount WithAddress:(NSString*)add WithShopID:(NSString*)shop WithBk:(NetCallback)completeBk;
-(void)getAllOrdersWithFromIndex:(int)index WithBk:(NetCallback)completeBk;

-(void)confirmOrderWithOrder:(OrderData*)order WithBk:(NetCallback)completeBk;
-(void)cancelOrderWithOrder:(OrderData*)order WithBk:(NetCallback)completeBk;

-(void)remindOrderWithOrder:(OrderData*)order WithBk:(NetCallback)completeBk;

-(void)rePayOrderWithOrder:(OrderData*)order WithBk:(NetCallback)completeBk;
//商铺、商品

#define ROOTCATEGORY @"category_root"
#define ROOTPIC @"pics_root"
#define ROOTACTIVITY @"activity_root"
#define ROOTSHOP @"shop_root"
-(void)getShopInfoWithShopID:(NSString*)shopid WithBk:(NetCallback)completeBk;

-(void)shopGetCategoryWithShopID:(NSString*)shopID callBack:(NetCallback)back
;
-(void)shopGetProductWithShopID:(NSString*)shopID withCategory:(NSString*)category fromIndex:(int)nu WithCallBack:(NetCallback)back;

-(void)seachProductWithShopID:(NSString*)shopID WithCharacter:(NSString*)character WithBk:(NetCallback)completeBk;
//地址

-(void)setDefaultAddress:(AddressData*)address WithCompleteBk:(NetCallback)completeBk;
-(void)getDefaultAddressWithBk:(NetCallback)completeBk;

-(void)addressDeleteWithAddID:(NSString*)addressID WithBk:(NetCallback)completeBk;

-(void)addAddressWithAddress:(NSString*)address WithPhone:(NSString*)phone WithBk:(NetCallback)completeBk;

-(void)getAddressWithBk:(NetCallback)completeBk;


-(void)addressUpdateWithAddID:(NSString*)addressID withAddress:(NSString*)address withPhone:(NSString*)phone WithBk:(NetCallback)completeBk;

//定位
-(void)getShopsWithAddress:(ShopInfoData*)shop WithComplete:(NetCallback)completeBk;
-(void)seachShopWithCharacter:(NSString*)character WithBk:(NetCallback)completeBk;
-(void)throughLocationGetShopWithlatitude:(float)latitude WithLong:(float)longitude WithBk:(NetCallback)completeBk;


//登录
-(void)getVerifyCodeWithAccount:(NSString*)phone WithBk:(NetCallback)completeBk;
-(void)getPhoneVerifyCodeWithAccount:(NSString *)phone WithBk:(NetCallback)completeBk;
-(void)getGidWithBk:(NetCallback)completeBk;

-(void)userLoginWithAccount:(NSString*)account WithPw:(NSString*)pw WithBk:(NetCallback)completeBk;

-(void)userLogOutWithAccount:(NSString*)account withBk:(NetCallback)completeBk;
@end
