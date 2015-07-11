//
//  AddProductCommonCell.h
//  miaomiaoShop
//
//  Created by 陶海龙 on 15-4-25.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TextFieldBk)(NSString*text);
@interface AddProductCommonCell : UITableViewCell<UITextFieldDelegate>
{
    UILabel* _titleL;
    UITextField* _contentField;
    TextFieldBk _fieldBk;
}
-(void)registeFirstRespond;
-(NSString*)getTextFieldString;
-(void)setTextField:(NSString*)fieldStr;
-(void)setFieldKeyboardStyle:(UIKeyboardType)style;
-(UITextField*)getTextFieldView;

-(UILabel*)getTitleLabel;
-(void)setTextTitleLabel:(NSString*)text;


-(void)setFieldBlock:(TextFieldBk)bk;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithFieldBk:(TextFieldBk)bk;
-(void)setLayout;
@end
