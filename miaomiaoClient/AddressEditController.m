//
//  AddressEditController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-19.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "AddressEditController.h"
#import "AddProductCommonCell.h"
#import "THActivityView.h"
#import "NetWorkRequest.h"
@interface AddressEditController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView* _table;
    AddressData* _addData;
}

@end
@implementation AddressEditController
@synthesize delegate;
-(id)initWithAddressData:(AddressData*)address
{
    self = [super init];
    if (address) {
        _addData = address;
    }
    else
    {
        _addData = [[AddressData alloc]init];
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    //    _table
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveAddressAction)];
    self.navigationItem.rightBarButtonItem = rightBar;
}

-(void)saveAddressAction
{
    
    if (_addData.address.length==0) {
        THActivityView* warnView = [[THActivityView alloc]initWithString:@"请输入地址"];
        [warnView show];
        return;
    }
    

    NSString* phone = _addData.phoneNu;
    if ([NSString verifyIsMobilePhoneNu:phone]==NO)
    {
        
        THActivityView* warnView = [[THActivityView alloc]initWithString:@"请输入正确的手机号"];
        [warnView show];
        return;
    }

    if (_addData.addressID) {
        [self  updateAddress];
    }
    else
    {
        [self addNewAddress:_addData.address WithPhone:_addData.phoneNu];
    }

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 11;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* str = @"ids";
    AddProductCommonCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        
        cell = [[AddProductCommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
        UILabel* titleLabel = [cell getTitleLabel];
        titleLabel.textColor = FUNCTCOLOR(102, 102, 102);
    }
    
    __weak AddressData* wAddress = _addData;
    UITextField* field = [cell getTextFieldView];
    field.borderStyle = UITextBorderStyleNone;
    field.textColor = DEFAULTGRAYCOLO;
    if (indexPath.row==0) {
        
        [cell setFieldBlock:^(NSString *text) {
             wAddress.address = text;
           
        }];
        UILabel* title = [cell getTitleLabel];
        title.font = DEFAULTFONT(15);
        [cell setTextTitleLabel:@"收货地址:"];
        field.placeholder = @"收货地址";
        
        field.text = _addData.address?_addData.address:@"";

    }
    else
    {
        
        [cell setFieldBlock:^(NSString *text) {
           
             wAddress.phoneNu = text;
        }];
        UILabel* title = [cell getTitleLabel];
        title.font = DEFAULTFONT(15);
        [cell setFieldKeyboardStyle:UIKeyboardTypeNumberPad];
        [cell setTextTitleLabel:@"联系电话:"];
        field.placeholder = @"联系电话";
        field.text = _addData.phoneNu?_addData.phoneNu:@"";
    }
    
    
     return cell;
}

-(void)addNewAddress:(NSString*)address WithPhone:(NSString*)phone
{
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    __weak AddressEditController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req addAddressWithAddress:address WithPhone:phone WithBk:^(AddressData* respond, NetWorkStatus error) {
        
        [loadView removeFromSuperview];
        
        
        if (NetWorkSuccess==error)
        {
            THActivityView* alert = [[THActivityView alloc]initWithString:@"添加成功!"];
            [alert show];
            
            [wself.delegate AddressAddWithAddressData:respond];
            [wself.navigationController popViewControllerAnimated:YES];
            return ;
        }
        else if (NetWorkErrorUnKnow == error)
        {
            THActivityView* alert = [[THActivityView alloc]initWithString:(NSString*)respond];
            [alert show];
            
            return ;

        }
        else
        {
        
        }
    }];
    [req startAsynchronous];
    
}


-(void)updateAddress
{
     __weak AddressEditController* wself = self;
    
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req addressUpdateWithAddID:_addData.addressID withAddress:_addData.address withPhone:_addData.phoneNu WithBk:^(id respond, NetWorkStatus status) {
        
        [loadView removeFromSuperview];
        
        if (status == NetWorkErrorUnKnow) {
            
            THActivityView* alert = [[THActivityView alloc]initWithString:@"更新失败!"];
            [alert show];

            return ;
        }
        
        if (NetWorkSuccess==status) {
            THActivityView* alert = [[THActivityView alloc]initWithString:@"更新成功!"];
            [alert show];
            
            [wself.delegate AddressUpdateComplete];
            [wself.navigationController popViewControllerAnimated:YES];
        }
        
    }];
    [req startAsynchronous];
    
}

@end
