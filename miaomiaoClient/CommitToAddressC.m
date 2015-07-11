//
//  CommitToAddressC.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/7/9.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "CommitToAddressC.h"

@implementation CommitToAddressC
-(void)getAddress
{
    __weak CommitToAddressC* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getAddressWithBk:^(NSMutableArray* respond, NetWorkStatus error) {
        
        if (error != NetWorkSuccess) {
            
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wself.view];
            
            [loadView setErrorBk:^{
                [wself getAddress];
            }];
            return ;
        }
        
        if (error==NetWorkErrorTokenInvalid) {
//            [wself tokenInvalid];
            return;
        }
        
        [wself searchSelectAddress:respond];
        NSLog(@"req is %@",respond);
    }];
    [req startAsynchronous];
}


-(void)searchSelectAddress:(NSMutableArray*)arr
{
    _dataArr = arr;
    
//    if (_defaultArr==nil) {
//        
//        [_table reloadData];
//        return;
//    }
    
    for (AddressData* addr in _dataArr) {
        
        if ([addr.addressID isEqualToString:_defaultArr.addressID]) {
            addr.isDefault = 1;
        }
        else
        {
           addr.isDefault = 0;
        }
    }
    
    [_table reloadData];

}

-(void)setSelectAddress:(AddressData*)address
{
    _defaultArr = address;
}

@end
