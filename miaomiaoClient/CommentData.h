//
//  CommentData.h
//  miaomiaoClient
//
//  Created by 陶海龙 on 15/8/21.
//  Copyright (c) 2015年 miaomiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface CommentData : NSObject
{
    float _fontSize;
    CGSize _size;
}
@property(nonatomic,strong)NSString* shopName;
@property(nonatomic,strong)NSString* comments;
@property(nonatomic,strong)NSString* creatTime;
@property(nonatomic,strong)NSString* telphone;
@property(nonatomic,assign)float score;

-(CGSize)calculateStringHeightWithFont:(UIFont *)font WithSize:(CGSize)size;
@end
