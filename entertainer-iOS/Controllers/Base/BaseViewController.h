//
//  BaseViewController.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 21.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController{
    @protected
    UIView *currentView;
}

-(void)initBackButton;
-(void)initInfoButtonWithTarget:(id)target;
-(void)leftItemClick:(id)sender;
-(void)rightItemClick:(id)sender;

@end
