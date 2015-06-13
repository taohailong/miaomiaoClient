//
//  AddressViewController.m
//  miaomiaoClient
//
//  Created by 陶海龙 on 15-5-14.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import "AddressViewController.h"
#import "NetWorkRequest.h"
#import "THActivityView.h"
#import "AddressData.h"
#import "NSString+ZhengZe.h"
#import "LogViewController.h"
#import "AddressEditController.h"
#import "AddressCell.h"
@interface AddressViewController()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,AddressEditProtocol>
{
    UITableView* _table;
    NSMutableArray* _dataArr;
}
@end
@implementation AddressViewController
@synthesize delegate;


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择地址";
    
    _table = [[UITableView alloc]initWithFrame:self.view.bounds    style:UITableViewStyleGrouped];
    [self.view addSubview:_table];
    _table.delegate = self;
    _table.dataSource = self;
    _table.sectionHeaderHeight = 5;
    _table.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_table]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_table)]];
    
    
    UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(setTableEditModel:)];
    self.navigationItem.rightBarButtonItem =rightBar;
    rightBar.tag = 0;
    [self getAddress];
}

-(void)setTableEditModel:(UIBarButtonItem*)sender
{
    if (sender.tag==0) {
        UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(setTableEditModel:)];
        rightBar.tag = 1;
        [self.navigationItem setRightBarButtonItem:rightBar animated:YES];
    }
    else
    {
        UIBarButtonItem* rightBar = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(setTableEditModel:)];
        self.navigationItem.rightBarButtonItem =rightBar;
        rightBar.tag = 0;
    }
    [_table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)getAddress
{
    __weak AddressViewController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req getAddressWithBk:^(NSMutableArray* respond, NetWorkStatus error) {
        
        if (error == NetWorkErrorCanntConnect) {
            
            THActivityView* loadView = [[THActivityView alloc]initWithNetErrorWithSuperView:wself.view];
            
            [loadView setErrorBk:^{
                [wself getAddress];
            }];
            return ;
        }
        
        if (error==NetWorkErrorTokenInvalid) {
             [wself tokenInvalid];
            return;
        }
        
        _dataArr = respond;
        [_table reloadData];
        NSLog(@"req is %@",respond);
    }];
    [req startAsynchronous];
}

-(void)tokenInvalid
{
    LogViewController* log = [self.storyboard instantiateViewControllerWithIdentifier:@"LogViewController"];
    [self presentViewController:log animated:YES completion:NULL];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row==0?45:55;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count+1;
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* str = @"cell";
    AddressCell* cell = [tableView dequeueReusableCellWithIdentifier:str];
    
    if (cell==nil) {
        cell = [[AddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    
    if (indexPath.row==0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        
        NSMutableAttributedString* attribute = [[NSMutableAttributedString alloc]initWithString:@"+ 添加新地址"];
        
        [attribute addAttribute:NSFontAttributeName value:DEFAULTFONT(25) range:NSMakeRange(0, 1)];
         [attribute addAttribute:NSFontAttributeName value:DEFAULTFONT(15) range:NSMakeRange(1, 6)];
        cell.textLabel.attributedText = attribute;
        cell.textLabel.textColor = DEFAULTNAVCOLOR;
        [cell getTitleLabel].text = @"";
        [cell getDetailLabel].text = @"";

    }
    else
    {
        if (self.navigationItem.rightBarButtonItem.tag==0)//更改状态
        {
            if (indexPath.row==1) {
                [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
            }
            else
            {
               [cell setAccessoryType:UITableViewCellAccessoryNone];
            }
        }
        else
        {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        }
        AddressData* data = _dataArr[indexPath.row-1];
         cell.textLabel.text = @"";
        
        UILabel* title = [cell getTitleLabel];
        title.font = DEFAULTFONT(15);
        title.textColor = DEFAULTBLACK;
        title.text =[NSString stringWithFormat:@"收货地址：%@",data.address] ;
        
        UILabel* detail = [cell getDetailLabel];
         detail.textColor = DEFAULTBLACK;
         detail.font = DEFAULTFONT(15);
         detail.text =[NSString stringWithFormat:@"联系电话：%@",data.phoneNu] ;
    }
    
    return cell;
}


-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        return NO;
    }
    return YES;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 11;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row==0) {
        AddressEditController* addEditor = [[AddressEditController alloc]initWithAddressData:nil];
        addEditor.delegate = self;
        [self.navigationController pushViewController:addEditor animated:YES];
    }
    else if (self.navigationItem.rightBarButtonItem.tag==1)
    {
        AddressEditController* addEditor = [[AddressEditController alloc]initWithAddressData:_dataArr[indexPath.row-1]];
        addEditor.delegate = self;
        [self.navigationController pushViewController:addEditor animated:YES];

    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(selectAddressOverWithAddress:)]) {
            
            [self.delegate selectAddressOverWithAddress:_dataArr[indexPath.row-1]];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}

#pragma mark---------------address edit add delegate------

-(void)AddressUpdateComplete
{
    [_table reloadData];
}


-(void)AddressAddWithAddressData:(AddressData *)add
{
    [_dataArr addObject:add];
    [_table reloadData];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AddressData* data = _dataArr[indexPath.row-1];
        THActivityView* loadV = [[THActivityView alloc]initFullViewTransparentWithSuperView:self.view];
        
        __weak NSMutableArray* wdataArr = _dataArr;
        
        NetWorkRequest* req = [[NetWorkRequest alloc]init];
        [req addressDeleteWithAddID:data.addressID WithBk:^(id respond, NetWorkStatus status) {
            
            [loadV removeFromSuperview];
            
            if (status==NetWorkSuccess)
            {
                [wdataArr removeObject:data];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
            else
            {
                THActivityView* showStr = [[THActivityView alloc]initWithString:@"删除失败！"];
                [showStr show];
                
            }
        }];
        [req startAsynchronous];
       
    } else {
        NSLog(@"Unhandled editing style! %d", editingStyle);
    }
}




-(void)addNewAddress:(NSString*)address WithPhone:(NSString*)phone
{
    THActivityView* loadView = [[THActivityView alloc]initActivityViewWithSuperView:self.view];
    
    __weak AddressViewController* wself = self;
    NetWorkRequest* req = [[NetWorkRequest alloc]init];
    [req addAddressWithAddress:address WithPhone:phone WithBk:^(AddressData* respond, NetWorkStatus error) {
        [loadView removeFromSuperview];
        
        if (NetWorkErrorTokenInvalid==error) {
            
            [wself tokenInvalid];
            return ;
        }
        
        
        if (NetWorkSuccess==error) {
            [_dataArr addObject:respond];
            [_table reloadData];
        }
        
    }];
    [req startAsynchronous];
    
}


@end
