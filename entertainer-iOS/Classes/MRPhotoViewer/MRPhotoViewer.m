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
        
        leftScrollHistory = [NSMutableArray array];
        rightScrollHistory = [NSMutableArray array];
        
        self.mainScroll.decelerationRate = UIScrollViewDecelerationRateNormal;
        [self addSubview:self.mainScroll];
        NSLog(@"reload data subviews is %i",[[self.mainScroll subviews] count]);
        
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
    
    leftScrollHistory = nil;
    rightScrollHistory = nil;
    
    leftScrollHistory = [NSMutableArray array];
    rightScrollHistory = [NSMutableArray array];
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
    self.items = [NSMutableDictionary alloc];
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
        
        partsCount = floor(itemsCount / 40.f);
        [self loadPart];
        gotItemsFromCD = [NSMutableDictionary dictionaryWithDictionary:[self.items objectForKey:@"values"]];
        NSLog(@"%@",gotItemsFromCD);
        self.items = nil;
        
        if(itemsCount > 1)
        {
//            int id_item_next = (self.suffleArrayKeys) ? [[self.suffleArrayKeys objectAtIndex:1] integerValue] : 1;
//            [rightScrollHistory addObject:@(id_item_next)];
            [self retrieveImageDataWithIndexPhoto:1];
        }
        
        
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
    
    
    

}

- (void)retrieveImageDataWithIndexPhoto:(int)indexPhoto {
    int indexSelect = indexPhoto;
    if(self.suffleArrayKeys)
    {
        indexSelect = [[self.suffleArrayKeys objectAtIndex:indexPhoto] integerValue];
    }
//    NSLog(@"look view ID is %i",indexSelect);
    MRItem *item = [gotItemsFromCD objectForKey:@(indexSelect)];
    
    MRPhoto *lastView = (MRPhoto *)[self.mainScroll viewWithTag:item.id+1000];
    if(lastView == nil || ![lastView isKindOfClass:[MRPhoto class]])
    {
//        NSLog(@"make image id %i",item.id);
        CGFloat inset = indexPhoto*size.width;
        MRPhoto *photo = [[MRPhoto alloc] initWithFrame:CGRectMake(inset, 0, size.width, size.height)];
        photo.tag = item.id+1000;
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
//    index = (index-(currentPart*40));
//    //    index = (index<0) ? index+1 : index;
//    if (index == currentIndex) return;
//    NSLog(@"currentIndex is %i",(currentIndex+(currentPart*40)));
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
    //    index = (index-(currentPart*40));
    //    NSLog(@"index = %i",index);
    //    if(lastCurrentIndex-(currentPart*40) < index)
    //    {
    //        NSLog(@"vpered!!");
    //        if((index)==40)
    //        {
    //            NSLog(@"scrollvisable");
    //            [self.mainScroll setScrollEnabled:NO];
    //        }
    //    }
    //    else if(lastCurrentIndex-(currentPart*40) > index)
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
    
    
    
    index = (index-(activePart*40));
    
    if (index == currentIndex) return;
    
    
    //    if(index <= 0)
    //    {
    //        shiftIndex = index;
    //        index = 0;
    //    }
    //    else if(index >= 40)
    //    {
    //        shiftIndex = index-40;
    //        index = 40;
    //    }
    lastCurrentIndex = currentIndex;
    currentIndex = index;
    
    [self sayDelegateIndexChanged];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    NSLog(@"scrollViewDidEndDragging");
    //    int plus_k_part = (int)ceil((float)shiftIndex/40);
    //    NSLog(@"plus_k_part %f",ceil((float)shiftIndex/40));
    
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
    
    if((currentIndex+(activePart*40)) > index)
        counter = index + 1;
    else if((currentIndex+(activePart*40)) < index)
        counter = index - 1;
    
    CGFloat offset = index * size.width;
    CGPoint point = CGPointMake(offset, 0);
    if (animated){
        [UIView animateWithDuration:0.1 animations:^{
            [self.mainScroll setContentOffset:point];
        }];
    } else {
        [self.mainScroll setContentOffset:point];
    }
    
    lastCurrentIndex = currentIndex;
    currentIndex = index;
    
//    counter = index;
    shiftIndex = index;
//    [self sayDelegateIndexChanged];
    
}

-(void)sayDelegateIndexChanged{
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoViewer:positionChangedAtIndex:)]){
        [self.delegate photoViewer:self positionChangedAtIndex:currentIndex];
        

        
        
        
        
//        BOOL SCROLL_TO_RIGHT = NO;
//        NSLog(@"%i > %i",(currentIndex+(activePart*40)), counter);
        if((currentIndex+(activePart*40)) > counter)
        {
//            NSLog(@"NEXT LISTAEM");
            shiftIndex = counter - lastCounter;
            
            lastCounter = counter;
            counter++;
            
            activePart = (int)floor((float)counter/40.f);
            [self makeNextSlide];
//            SCROLL_TO_RIGHT = YES;
        }
        else if((currentIndex+(activePart*40)) < counter)
        {
//            NSLog(@"PREV LISTAEM");
            
            
            lastCounter = counter;
            counter--;
            
            activePart = (int)floor((float)counter/40.f);
            [self makePrevSlide];
        }
        NSLog(@"subviews is %lu", (unsigned long)[[self.mainScroll subviews] count]);
        NSLog(@"counter is %li",counter);
        [self retrieveImageDataWithIndexPhoto:counter];
        
        
    }
}

-(void)makeNextSlide{
    
    //    int n = (currentIndex==40) ? 0 : currentIndex;
    int next_index = counter+15;
    if( (next_index) >= ((currentPart+1)*40) )
    {
//        NSLog(@"%i >= %li", next_index, ((currentPart+1)*40));
        if((currentPart+1) <= partsCount)
        {
           
//            shiftIndex = shiftIndex +15;
//            int plus_k_part = (int)ceil((float)shiftIndex/40);
//            if(plus_k_part==0) currentPart= activePart+1;
            
//            shiftParts = (currentPart+plus_k_part)-currentPart;
            
//            currentPart=activePart;

//            int plus_k_part = (int)ceil((float)shiftIndex/40);
//            if(plus_k_part==0) plus_k_part++;
//            
//            shiftParts = (currentPart+plus_k_part)-currentPart;
//            
//            currentPart+=plus_k_part;
            
            currentPart = (int)ceil(((float)counter+15.f+1.f)/40.f)-1;

            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //Do background work
                
                
                [self loadPart];
                dispatch_async(dispatch_get_main_queue(), ^{
//                    NSMutableDictionary *gotResult
                    NSLog(@"%li == %li",(long)[[self.items objectForKey:@"returnPart"] integerValue], (long)currentPart );
                    if([[self.items objectForKey:@"returnPart"] integerValue] == currentPart)
                    {
                        gotItemsFromCD = nil;
                        gotItemsFromCD = [NSMutableDictionary dictionaryWithDictionary:[self.items objectForKey:@"values"]];
                        self.items = nil;
//                        NSLog(@"%@",gotItemsFromCD);
                        IS_LOADING = NO;
                        shiftIndex = 0;
                        
                        [self.mainScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
                        leftScrollHistory = [NSMutableArray array];
                        rightScrollHistory = [NSMutableArray array];
                        [self prepareLoadRightImage];
                        [self prepareLoadLeftImage];
                        [self sayDelegateIndexChanged];
                    }
                    
                });
            });
            
        }
    }
    
    

    
    
    
    [self prepareLoadRightImage];

    
    
    int current_id_remove_view = (self.suffleArrayKeys) ? [[self.suffleArrayKeys objectAtIndex:counter] integerValue] : counter;
    [rightScrollHistory removeObject:@(current_id_remove_view)];
    
    if([leftScrollHistory count] > 0)
    {
        int id_remove_view = [leftScrollHistory[0] integerValue];
        NSLog(@"remove id %i",id_remove_view);
        MRPhoto* view = (MRPhoto *)[self.mainScroll viewWithTag:id_remove_view+1000];
        [view removeFromSuperview];
        [leftScrollHistory removeObjectAtIndex:0];
//        [rightScrollHistory removeObject:leftScrollHistory[0]];
    }
    
    int id_item_prev = (self.suffleArrayKeys) ? [[self.suffleArrayKeys objectAtIndex:counter-1] integerValue] : counter-1;
    [leftScrollHistory addObject:@(id_item_prev)];
    
    NSLog(@"left");
    NSLog(@"%@",leftScrollHistory);
    NSLog(@"right");
    NSLog(@"%@",rightScrollHistory);
}

-(void)prepareLoadRightImage
{
    int next_slide = counter + 1;
    if( next_slide < itemsCount )
    {
        int id_item_next = (self.suffleArrayKeys) ? [[self.suffleArrayKeys objectAtIndex:counter+1] integerValue] : counter+1;
        [rightScrollHistory addObject:@(id_item_next)];
        
        [self retrieveImageDataWithIndexPhoto:next_slide];
    }
}

-(void)prepareLoadLeftImage
{
    int next_slide = counter-1;
    if( next_slide >= 0 )
    {
        int id_item_prev = (self.suffleArrayKeys) ? [[self.suffleArrayKeys objectAtIndex:counter-1] integerValue] : counter-1;
        [leftScrollHistory addObject:@(id_item_prev)];
        
        [self retrieveImageDataWithIndexPhoto:next_slide];
    }
}

-(void)makePrevSlide{
    
    
    int next_index = counter-15;
    if( next_index <= (currentPart*40)-15 )
    {
        NSLog(@"%i >= %li", next_index, (currentPart*40)-15);
        if(currentPart > 0)
        {
            
            currentPart = (int)ceil( ( fabsf((float)counter-15.f-1.f) ) / 40.f )-1;

            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                //Do background work
                
                
                [self loadPart];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"%li == %li",(long)[[self.items objectForKey:@"returnPart"] integerValue], (long)currentPart );
                    if([[self.items objectForKey:@"returnPart"] integerValue] == currentPart)
                    {
                        gotItemsFromCD = nil;
                        gotItemsFromCD = [NSMutableDictionary dictionaryWithDictionary:[self.items objectForKey:@"values"]];
                        self.items = nil;
//                        NSLog(@"%@",gotItemsFromCD);
                        IS_LOADING = NO;
                        shiftIndex = 0;
                        
                        [self.mainScroll.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
                        leftScrollHistory = [NSMutableArray array];
                        rightScrollHistory = [NSMutableArray array];
                        [self prepareLoadRightImage];
                        [self prepareLoadLeftImage];
                        [self sayDelegateIndexChanged];
                    }
                });
            });
            
        }
    }
    

    
    
    
    
    [self prepareLoadLeftImage];
    
    

    int current_id_remove_view = (self.suffleArrayKeys) ? [[self.suffleArrayKeys objectAtIndex:counter] integerValue] : counter;
    [leftScrollHistory removeObject:@(current_id_remove_view)];
    
    if([rightScrollHistory count] > 0)
    {
        id last_object = [rightScrollHistory lastObject];
        int id_remove_view = [last_object integerValue];
        NSLog(@"remove id %i",id_remove_view);
        MRPhoto* view = (MRPhoto *)[self.mainScroll viewWithTag:id_remove_view+1000];
        [view removeFromSuperview];
        [leftScrollHistory removeObject:last_object];
        [rightScrollHistory removeObject:last_object];
    }
    
    int id_item_next = (self.suffleArrayKeys) ? [[self.suffleArrayKeys objectAtIndex:counter+1] integerValue] : counter+1;
    [rightScrollHistory addObject:@(id_item_next)];
    
    NSLog(@"left");
    NSLog(@"%@",leftScrollHistory);
    NSLog(@"right");
    NSLog(@"%@",rightScrollHistory);
    
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
