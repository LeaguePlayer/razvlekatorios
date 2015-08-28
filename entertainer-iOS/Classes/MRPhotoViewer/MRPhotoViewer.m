//
//  MRPhotoViewer.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "MRPhotoViewer.h"
#import "MRItem.h"
#import "SVProgressHUD.h"

@implementation MRPhotoViewer

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        size = frame.size;
        itemsCount = 0;
        //        gotItemsFromCD = [NSArray array];
        [self initGestures];
        self.mainScroll = [[UIScrollView alloc] initWithFrame:self.bounds];
        [self.mainScroll setDelegate:self];
        self.mainScroll.tag=-2;
        [self.mainScroll setPagingEnabled:YES];
        [self.mainScroll setShowsHorizontalScrollIndicator:NO];
        [self.mainScroll setShowsVerticalScrollIndicator:NO];
//        progressViews = [[NSMutableArray alloc] init];
   
        
        
        self.mainScroll.decelerationRate = UIScrollViewDecelerationRateNormal;
        [self addSubview:self.mainScroll];
        
        
    }
    return self;
}

-(void)initGestures{
    NSLog(@"initGestures");
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTaped:)];
    [recognizer setNumberOfTapsRequired:1];
    [recognizer setNumberOfTouchesRequired:1];
    [recognizer setCancelsTouchesInView:NO];
    [self addGestureRecognizer:recognizer];
}

-(void)viewTaped:(id)sender{
    NSLog(@"viewTaped");
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewerTaped:)]){
        [self.delegate photoViewerTaped:self];
    }
}

-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    size = frame.size;
}

-(void)reloadData{
//    for (MRPhoto *photo in self.items){
//        [photo removeFromSuperview];
//    }
//    for (UIActivityIndicatorView *progress in progressViews){
//        [progress removeFromSuperview];
//    }
    for(id view in self.mainScroll.subviews)
    {
        [view removeFromSuperview];
    }
    
    
    
    itemsCount = 0;
    currentIndex = 0;
    lastCurrentIndex = 0;
    shiftIndex = 0;
    counter = 0;
    activePart = 0;
    lastCounter = 0;
    currentPart = 0;
    initedFirst = NO;
//    progressViews = nil;
//    progressViews = [[NSMutableArray alloc] init];
    [self.mainScroll setContentOffset:CGPointZero];
    self.items = [NSMutableArray alloc];
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfPhotosInPhotoViewer:)]){
        itemsCount = [self.dataSource numberOfPhotosInPhotoViewer:self];
        //        if ([self.dataSource respondsToSelector:@selector(photoViewer:imageAtIndex:)]){
        //            CGFloat inset = 0;
        //            NSLog(@"itemsCount = %i",itemsCount);
        
        
        
        
//        for(int i=2; i<itemsCount;i++)
//        {
//            
//            float center_view_vertical = (size.width*i)-(size.width/2)-15;
//            float center_view_horizontal = (size.height/2)-15;
//            UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame: CGRectMake(center_view_vertical, center_view_horizontal, 30, 30)];
//            progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
//            progress.tag=-1;
//            [progress startAnimating];
//            [self.mainScroll addSubview:progress];
//        }
        
        partsCount = floor(itemsCount / 10.f);
        [self loadPart];
        gotItemsFromCD = [NSMutableDictionary dictionaryWithDictionary:self.items];
        self.items = nil;
        
        [self.mainScroll setContentSize:CGSizeMake(size.width*itemsCount, size.height)];
        //        }
    }
    [self sayDelegateIndexChanged];
}

-(void)loadPart
{
//    currentIndex = 0;
    self.items = nil;
//    gotItemsFromCD = nil;
    self.items = [[NSMutableDictionary alloc] init];

    
    self.items = [NSMutableDictionary dictionaryWithDictionary:[MRItem partItems:currentPart andSelectedBlockId:self.selectedBlock.id andShuffleArray:self.suffleArrayKeys]];
    

    
    if(shiftIndex>0)
    {
        
        currentIndex = (shiftIndex - ((shiftParts-1)*10));
        shiftParts = 0;
        shiftIndex = 0;
        NSLog(@"LAOD PART");

    } else if(shiftIndex<0)
    {
               currentIndex = 10-((shiftIndex*-1) - (((shiftParts*-1)-1)*10));
        shiftParts = 0;
        shiftIndex = 0;

    }
    
//    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
//    [self.mainScroll setScrollEnabled:YES];
}

- (void)retrieveImageDataWithIndexPhoto:(int)indexPhoto {

    MRItem *item = [gotItemsFromCD objectForKey:@(indexPhoto)];
    
    MRPhoto *lastView = (MRPhoto *)[self.mainScroll viewWithTag:item.id];
    if(lastView == nil || (!initedFirst && item.id==0))
    {
        if(item.id==0)
            initedFirst = YES;
        
        CGFloat inset = indexPhoto*size.width;
        MRPhoto *photo = [[MRPhoto alloc] initWithFrame:CGRectMake(inset, 0, size.width, size.height)];
        photo.tag = item.id;
        [photo setImage:[UIImage imageWithData:item.imageData]];
        [self.mainScroll addSubview:photo];
        photo = nil;
    }

    
}


#pragma mark - scroll view delegate methods

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    //    NSLog(@"scrollViewDidScroll");
//    
//    CGPoint point = scrollView.contentOffset;
//    int index = floor((point.x - size.width / 2) / size.width) + 1;
//    
//    index = (index-(currentPart*10));
//    //    index = (index<0) ? index+1 : index;
//    if (index == currentIndex) return;
//    NSLog(@"currentIndex is %i",(currentIndex+(currentPart*10)));
//    //     NSLog(@"was_index is %i",was_index);
//    NSLog(@"index is %i",index);
//    
//    lastCurrentIndex = currentIndex;
//    currentIndex = index;
//    [self sayDelegateIndexChanged];
//}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
   NSLog(@"IS_LOADING NO");
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    [self performSelector:@selector(scrollViewDidEndScrollingAnimation:) withObject:nil afterDelay:0.1];
//    NSLog(@"scrollViewDidLoad");
    if(IS_LOADING) return;
    [self scrollAction];
//    CGPoint point = scrollView.contentOffset;
//    //    NSLog(@"X IS %f",point.x);
//    int index = floor((point.x - size.width / 2) / size.width) +1;
//    
//    index = (index-(currentPart*10));
//    NSLog(@"index = %i",index);
//    if(lastCurrentIndex-(currentPart*10) < index)
//    {
//        NSLog(@"vpered!!");
//        if((index)==10)
//        {
//            NSLog(@"scrollvisable");
//            [self.mainScroll setScrollEnabled:NO];
//        }
//    }
//    else if(lastCurrentIndex-(currentPart*10) > index)
//    {
//        NSLog(@"nazad!!");
//        if((index)==0)
//        {
//            NSLog(@"scrollvisable");
//            [self.mainScroll setScrollEnabled:NO];
//        }
//    }
    
   
}
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
}

-(void)scrollAction
{
//    NSLog(@"subivews i")
    CGPoint point = self.mainScroll.contentOffset;
    int index = floor((point.x - size.width / 2) / size.width) +1;
    
    
    
    index = (index-(activePart*10));
    
    if (index == currentIndex) return;
    
    
//    if(index <= 0)
//    {
//        shiftIndex = index;
//        index = 0;
//    }
//    else if(index >= 10)
//    {
//        shiftIndex = index-10;
//        index = 10;
//    }
    lastCurrentIndex = currentIndex;
    currentIndex = index;
    
    [self sayDelegateIndexChanged];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
//    NSLog(@"scrollViewDidEndDragging");
//    int plus_k_part = (int)ceil((float)shiftIndex/10);
//    NSLog(@"plus_k_part %f",ceil((float)shiftIndex/10));
    
}


//-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    
//   
//}

//- (void)didReceiveMemoryWarning
//{
////    items = nil;
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}

-(void)moveAtIndex:(NSUInteger)index animated:(BOOL)animated{
    NSLog(@"moveAtIndex");

    CGFloat offset = index * size.width;
    CGPoint point = CGPointMake(offset, 0);
    if (animated){
        [UIView animateWithDuration:0.1 animations:^{
            [self.mainScroll setContentOffset:point];
        }];
    } else {
        [self.mainScroll setContentOffset:point];
    }
    [self scrollAction];

}

-(void)sayDelegateIndexChanged{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewer:positionChangedAtIndex:)]){
        [self.delegate photoViewer:self positionChangedAtIndex:currentIndex];
        
        //        [self.mainScroll addSubview:[items objectAtIndex:currentIndex]];
        //        [self makeNextSlide];
        
        
//        if(lastCurrentIndex > 0)
//        {
//            int TagView = lastCurrentIndex+(currentPart*10);
//            MRPhoto *lastView = (MRPhoto*)[self.mainScroll viewWithTag:TagView];
//            [lastView removeFromSuperview];
//        }

        
        NSLog(@"%li",currentIndex);
        NSLog(@"%li > %li",(currentIndex+(activePart*10)), counter);
        
        BOOL SCROLL_TO_RIGHT = NO;
        if((currentIndex+(activePart*10)) > counter)
        {
//            NSLog(@"listaem vpered");
            lastCounter = counter;
            counter++;
            
            activePart = (int)floor((float)counter/10.f);
            [self makeNextSlide];
            SCROLL_TO_RIGHT = YES;
        }
        else if((currentIndex+(activePart*10)) < counter)
        {
            
            lastCounter = counter;
            counter--;
            
            activePart = (int)floor((float)counter/10.f);
            [self makePrevSlide];
        }
        
        [self retrieveImageDataWithIndexPhoto:counter];
        
        if([[self.mainScroll subviews] count]>3)
        {
            NSLog(@"subviews is %lu",(unsigned long)[[self.mainScroll subviews] count]);
            if(SCROLL_TO_RIGHT)
            {
                MRPhoto* view = (MRPhoto *)[self.mainScroll subviews][0];
                [view removeFromSuperview];
            }else
            {
                MRPhoto* view = (MRPhoto *)[[self.mainScroll subviews] lastObject];
                [view removeFromSuperview];
            }
        }
        
    }
}

-(void)makeNextSlide{
    
//    int n = (currentIndex==10) ? 0 : currentIndex;
    int next_index = counter+2;
    if( (next_index) >= ((currentPart+1)*10) )
    {

        if((currentPart+1) <= partsCount)
        {

            int plus_k_part = (int)ceil((float)shiftIndex/10);
            if(plus_k_part==0) plus_k_part++;
            
            shiftParts = (currentPart+plus_k_part)-currentPart;
            
            currentPart+=plus_k_part;
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //Do background work
                
                    
                    [self loadPart];
                dispatch_async(dispatch_get_main_queue(), ^{
                    gotItemsFromCD = nil;
                    gotItemsFromCD = [NSMutableDictionary dictionaryWithDictionary:self.items];
                    self.items = nil;
                    NSLog(@"%@",gotItemsFromCD);
                    IS_LOADING = NO;
                });
            });
            
        }
    }
    
    int next_slide = counter + 1;
    if( next_slide <= itemsCount )
    {
        [self retrieveImageDataWithIndexPhoto:next_slide];
    }
}

-(void)makePrevSlide{
    
    int next_index = currentIndex;
//    NSLog(@"nazad index is %i",currentIndex);
    if( next_index == 0 )
    {
        if((currentPart-1) >= 0)
        {
//            [self.mainScroll setScrollEnabled:NO];
            
            int minus_k_part = (int)ceil(((float)shiftIndex/10.f)*-1.f);
            if(minus_k_part==0) minus_k_part++;
            
            shiftParts = (currentPart-minus_k_part)-currentPart;
            
            currentPart-=minus_k_part;
            
//            currentPart--;
            [self loadPart];
        }
    }
    
    
    
    //    next_index++;
    //    if( next_index <= itemsCount )
    //    {
    //        MRPhoto *next_photo = [self.items objectAtIndex:next_index];
    //        [self.mainScroll addSubview:next_photo];
    //        next_photo = nil;
    //
    //        NSLog(@"cnt subviews is %i",[self.mainScroll.subviews count]);
    //
    //        if([self.mainScroll.subviews count] >=3)
    //        {
    //            for(MRPhoto* a in self.mainScroll.subviews)
    //            {
    //                [a removeFromSuperview];
    //                break;
    //            }
    //        }
    //
    //    }
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
