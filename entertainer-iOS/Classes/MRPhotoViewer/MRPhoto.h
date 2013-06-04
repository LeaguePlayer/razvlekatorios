//
//  MRPhoto.h
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MRPhoto : UIScrollView{
    UIImageView *imageView;
    CGSize size;
}

-(void)setImage:(UIImage *)image;

@end
