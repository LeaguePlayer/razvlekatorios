//
//  AboutViewController.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 21.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "BaseViewController.h"

@interface AboutViewController : BaseViewController{
    NSString *information;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
