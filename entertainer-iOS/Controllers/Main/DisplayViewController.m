//
//  DisplayViewController.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "DisplayViewController.h"
#import "UIView+REUIKitAdditions.h"
#import "SHKItem.h"
#import "SHKFacebook.h"
#import "SHKTwitter.h"
//#import "SHKInstagram.h"
#import "SHKVkontakte.h"
#import "SVProgressHUD.h"
#import "NSArray+Shuffling.h"

#import "SHKActionSheet.h"
#import "SHKAlertController.h"


@interface DisplayViewController ()

@end

@implementation DisplayViewController
{
    BOOL _statusBarHidden;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent];
    //    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self enterFullscreen];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    //    [UIViewController setNeedsStatusBarAppearanceUpdate];
    [self setNeedsStatusBarAppearanceUpdate];
    // Do any additional setup after loading the view.
    isFullScreen = NO;
    currentIndex = 0;
    isShuffled = NO;
    [self initBackButton];
    [self initInfoButtonWithTarget:self];
    
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    //    [self setWantsFullScreenLayout:YES];
    [self initViewPositions];
    [self initPhotoViewer];
    //    [self initTopBar];
    [self initBottomButtons];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        thumbs = [NSMutableArray arrayWithArray:[MRItem allItemsWithSelectedBlockId:self.block.id]];
        [SVProgressHUD dismiss];
    });
    
    //    [SVProgressHUD dismiss];
}

-(void)initBottomButtons{
    [self.shuffleButton setImage:[UIImage imageNamed:@"shuffle_off.png"] forState:UIControlStateNormal];
    [self.shuffleButton setImage:[UIImage imageNamed:@"shuffle_on.png"] forState:UIControlStateSelected];
    [self.shuffleButton setSelected:NO];
}

//-(void)initTopBar{
////    [super initTop];
//}

-(void)rightItemClick:(id)sender{
    [self performSegueWithIdentifier:@"ToAbout" sender:self];
}

-(void)initViewPositions{
    [self.navigationController.view setFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
    [self.view setFrame:[[[UIApplication sharedApplication] keyWindow] bounds]];
    self.bottomView.y = self.view.height - self.bottomView.height;
    self.topView.y = self.view.frame.origin.y + 21;
}

-(void)initPhotoViewer{
    MRPhotoViewer *photoViewer = [[MRPhotoViewer alloc] initWithFrame:self.view.bounds];
    [photoViewer setDataSource:self];
    [photoViewer setDelegate:self];
    photoViewer.selectedBlock = self.block;
    [photoViewer setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view insertSubview:photoViewer atIndex:0];
    self.photor = photoViewer;
    [self.photor reloadData];
}

- (void)didReceiveMemoryWarning
{
    //    [self.photor relo]
    //    self.photor.items = nil;
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - photo viewer data source methods

-(NSUInteger)numberOfPhotosInPhotoViewer:(MRPhotoViewer *)photoViewer{
    //    ////NSLog(@"all counts is %lu",(unsigned long)self.block.items.count);
    return self.itemsCount;
}

//-(UIImage *)photoViewer:(MRPhotoViewer *)photoViewer imageAtIndex:(NSUInteger)index{
//    MRItem *item = [self.block.items objectAtIndex:index];
////    ////NSLog(@"%@",item.image);
//    return item.image;
//}

#pragma mark - photo viewer delegate methods

-(void)photoViewer:(MRPhotoViewer *)photoViewer positionChangedAtIndex:(NSUInteger)index{
    int count = self.itemsCount;
    currentIndex = index;
    if (!isShuffled)
        [self.topLabel setText:[NSString stringWithFormat:@"Страница %d из %d", index + 1,count]];
}

-(void)photoViewerTaped:(MRPhotoViewer *)photoViewer{
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (!isFullScreen)
        [self enterFullscreen];
    else
        [self exitFullscreen];
}

- (BOOL)prefersStatusBarHidden {
    return _statusBarHidden;
}

- (void)showStatusBar:(BOOL)show {
    [UIView animateWithDuration:0.3 animations:^{
        _statusBarHidden = !show;
        
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

-(void)enterFullscreen{
    isFullScreen = YES;
    
    [self disableApp];
    
    
    //    UIApplication* application = [UIApplication sharedApplication];
    //    if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
    //        [[UIApplication sharedApplication] setStatusBarHidden: YES withAnimation: UIStatusBarAnimationFade]; // 3.2+
    //    } else {
    //#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    //        [[UIApplication sharedApplication] setStatusBarHidden: YES animated:YES]; // 2.0 - 3.2
    //#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    //    }
    [self showStatusBar:NO];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.view.height+10;
        //        self.topView.y = - self.topView.height;
        [self.bottomView setAlpha:0];
        //        [self.topView setAlpha:0];
    } completion:^(BOOL finished) {
        [self enableApp];
        
        //        [self.photor.mainScroll setCenter:CGPointMake(10, 10)];
    }];
    
}

- (void)exitFullscreen
{
    isFullScreen = NO;
    
    [self disableApp];
    
    //  UIApplication* application = [UIApplication sharedApplication];
    //  if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
    //      [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade]; // 3.2+
    //  } else {
    //#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    //      [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO]; // 2.0 - 3.2
    //#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    //  }
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self showStatusBar:YES];
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.view.height - self.bottomView.height;
        //        self.topView.y = 21;
        [self.bottomView setAlpha:1];
        //        [self.topView setAlpha:1];
    } completion:^(BOOL finished) {
        [self enableApp];
    }];
}

- (void)enableApp
{
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
}


- (void)disableApp
{
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
}

- (void)viewDidUnload {
    [self setBottomView:nil];
    [self setTopLabel:nil];
    [self setShuffleButton:nil];
    [super viewDidUnload];
}

#pragma mark - action sheet delegate methods

//-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//
////
////    switch (buttonIndex) {
////        case 0:
//////            [SHKVkontakte shareItem:item];
////                ////NSLog(@"shareVK");
////                [SHKVkontakte shareItem:sharerItem];
////            break;
////        case 1:
////            ////NSLog(@"shareFB");
////
////            [NSClassFromString([NSString stringWithFormat:@"SHKFacebook"])
////             performSelector:@selector(shareItem:) withObject:sharerItem];
////            break;
////        case 2:
////            ////NSLog(@"shareTW");
////                [SHKTwitter shareItem:sharerItem];
////            break;
////        default:
////            break;
////    }
//}

#pragma mark - thumb view delegate methods

-(void)thumbViewItemDidSelectAtIndex:(NSUInteger)index{
//    self.photor.currentIndex = -100;
    [self.photor moveAtIndex:index animated:NO];
}

#pragma mark - actions

-(IBAction)onBackButtonClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onInfoButtonClick:(id)sender{
    [self performSegueWithIdentifier:@"ToAbout" sender:self];
}

-(void)showLoader:(NSString*)titleLoader
{
//     [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD showWithStatus:titleLoader maskType:SVProgressHUDMaskTypeGradient];
}

-(void)hideLoader
{
    [SVProgressHUD dismiss];
}

- (IBAction)onShareButtonClick:(id)sender {
    //    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Поделиться" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"ВКонтакте",@"Facebook",@"Twitter",nil];
    //    [actionSheet showInView:self.view];
    
    // Create the item to share (in this example, a url)
    //    NSURL *url = [NSURL URLWithString:@"http://getsharekit.com"];
    //    SHKItem *item = [SHKItem URL:url title:@"ShareKit is Awesome!" contentType:SHKURLContentTypeWebpage];
    
    ////NSLog(@"shared");
    int shareImageID = (self.photor.suffleArrayKeys) ? [[self.photor.suffleArrayKeys objectAtIndex:currentIndex] integerValue] : currentIndex;
    MRItem *gotModel = (MRItem *)[self.photor.gotItemsFromCD objectForKey:@(shareImageID)];
    
    //    MRItem *currentItem = [self.block.items objectAtIndex:currentIndex];
    UIImage *image = [UIImage imageWithData:gotModel.imageData];
    //    UIImageView *b = [[UIImageView alloc] initWithImage:image];
    //    [self.view addSubview:b];
    NSString *title = @"Картинка отправлена через приложение Мобильный развлекатор";
    SHKItem * item = [SHKItem image:image title:title];
    
    
    // Get the ShareKit action sheet
    //    SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
    
    // ShareKit detects top view controller (the one intended to present ShareKit UI) automatically,
    // but sometimes it may not find one. To be safe, set it explicitly
    [SHK setRootViewController:self];
    [SHK setFavorites:@[@"SHKVkontakte",@"SHKiOSFacebook",@"SHKiOSTwitter", @"SHKInstagram"] forItem:item];
    //    [SHK set]
    
    // Display the action sheet
    if (NSClassFromString(@"UIAlertController")) {
        
        //iOS 8+
        SHKAlertController *alertController = [SHKAlertController actionSheetForItem:item];
        alertController.title = @"Поделиться";
        alertController.shareDelegate = self;
        
        for(id btn in [alertController actions])
        {
            if([btn isKindOfClass:[UIAlertAction class]])
            {
                UIAlertAction *gotButton = (UIAlertAction *)btn;
                
                
                if([gotButton.title isEqualToString:@"Vkontakte"])
                {
                    UIImage *accessoryImage = [UIImage imageNamed:@"i_vk"];
                    [gotButton setValue:accessoryImage forKey:@"image"];
                }
                else if([gotButton.title isEqualToString:@"Facebook"])
                {
                    UIImage *accessoryImage = [UIImage imageNamed:@"i_fb"];
                    [gotButton setValue:accessoryImage forKey:@"image"];
                }
                else if([gotButton.title isEqualToString:@"Instagram"])
                {
                    UIImage *accessoryImage = [UIImage imageNamed:@"i_insta"];
                    [gotButton setValue:accessoryImage forKey:@"image"];
                }
                else if([gotButton.title isEqualToString:@"Twitter"])
                {
                    UIImage *accessoryImage = [UIImage imageNamed:@"i_tw"];
                    [gotButton setValue:accessoryImage forKey:@"image"];
                    
                }
            }
        }
        
        //        UIActionSheet * action = [[UIActionSheet alloc]
        //                                  initWithTitle:@"Title"
        //                                  delegate:self
        //                                  cancelButtonTitle:@"Cancel"
        //                                  destructiveButtonTitle:nil
        //                                  otherButtonTitles:@"",nil];
        
        
        
        [alertController setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alertController popoverPresentationController];
        popPresenter.barButtonItem = self.toolbarItems[1];
        
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            alertController.popoverPresentationController.sourceView = self.view;
            
            alertController.popoverPresentationController.sourceRect = CGRectMake(55, self.view.bounds.size.height -alertController.popoverPresentationController.frameOfPresentedViewInContainerView.size.height - 40.f, 1.0, 1.0);
            alertController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
            //            alertController.popoverPresentationController.
        }
        
        // this is the center of the screen currently but it can be any point in the view
        
        //        self.presentViewController(shareMenu, animated: true, completion: nil);
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        //deprecated
        SHKActionSheet *actionSheet = [SHKActionSheet actionSheetForItem:item];
        [actionSheet showFromToolbar:self.navigationController.toolbar];
    }
}

- (IBAction)onShuffleButtonClick:(id)sender {
    isShuffled = !isShuffled;
    [self.shuffleButton setSelected:isShuffled];
    //    self.tit
    //    NSInteger indexToMove;
    if (isShuffled)
    {
        
        
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Do background work
        self.photor.suffleArrayKeys = [NSArray arrayWithShuffledIds:[thumbs count]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setTitle:@"Случайный порядок"];
            NSMutableArray* new_thumbs = [[NSMutableArray alloc] init];
            for(id index in self.photor.suffleArrayKeys)
            {
                [new_thumbs addObject:[thumbs objectAtIndex:[index integerValue]]];
                //            //NSLog(@"finished!");
            }
            //        [new_thumbs exchangeObjectAtIndex:self.photor.counter withObjectAtIndex:0];
            
            
            thumbsShuffled = [NSMutableArray arrayWithArray:new_thumbs];
            MRItem *tmpObject = (MRItem*)[thumbs objectAtIndex:self.photor.counter];
            //        indexToMove = [thumbsShuffled indexOfObject:[thumbs objectAtIndex:self.photor.currentIndex]];
            
//            NSLog(@"in Display");
//            NSLog(@"%@",self.photor.suffleArrayKeys);
//            NSInteger indexToMove = [[self.photor.suffleArrayKeys objectAtIndex:self.photor.counter] integerValue];
            NSInteger indexToMove = [self.photor.suffleArrayKeys indexOfObject:@(self.photor.counter)];
            new_thumbs = nil;
            //NSLog(@"ON");
            self.photor.FROM_SHUFFLE = YES;
            self.photor.currentIndex = -100;
            //        [self.photor moveImageAtIndex:self.photor.currentIndex ToIndexPhoto:indexToMove];
            NSLog(@"tmpObject.id is %li",(long)tmpObject.id);
            NSLog(@"counter is %li",(long)self.photor.counter);
            NSLog(@"indexToMove is %li",(long)indexToMove);
            
            //        [self.photor moveAtIndexStatic:indexToMove animated:NO];
            [self.photor moveAtIndexStatic:indexToMove andIdPhoto:tmpObject.id animated:NO];
//            [self.photor moveAtIndex:indexToMove animated:NO];
        });
        //        });
        
        
    }
    else
    {
        ////NSLog(@"%@",thumbs);
        //        self.photor.counter = self.photor.counter-1;
        //        indexToMove = [thumbsShuffled indexOfObject:[thumbs objectAtIndex:self.photor.counter]];
        
        //        //NSLog(@"%@",self.photor.suffleArrayKeys);
//                int indexToMove = [self.photor.suffleArrayKeys indexOfObject:@((self.photor.counter-1))];
        int indexToMove = [[self.photor.suffleArrayKeys objectAtIndex:self.photor.counter] integerValue];
        self.photor.currentIndex = -100;
        //        MRItem *tmpObject = [thumbsShuffled objectAtIndex:indexToMove];
        //        indexToMove = self.photor.counter;
        //        //NSLog(@"tmpObject.id is %li",(long)tmpObject.id);
        NSLog(@"counter is %li",(long)self.photor.counter);
                NSLog(@"indexToMove is %li",(long)indexToMove);
        //NSLog(@"OFF");
        [self setTitle:@""];
        self.photor.suffleArrayKeys = nil;
        thumbsShuffled = nil;
        self.photor.FROM_SHUFFLE = YES;
        [self.photor moveAtIndexStatic:indexToMove andIdPhoto:indexToMove animated:NO];
        
        
        //        [self.photor moveImageAtIndex:self.photor.currentIndex ToIndexPhoto:indexToMove];
        
        
        
    }
    //NSLog(@"subviews : %lu",(unsigned long)[[self.photor.mainScroll subviews] count]);
    [self.block setShuffled:!self.block.shuffled];
    
    
    
    
}

- (IBAction)onDocumentsButtonClick:(id)sender {
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
    dispatch_async(dispatch_get_main_queue(), ^{
        ThumbsViewController *controller = [[ThumbsViewController alloc] init];
        controller.block = self.block;
        controller.itemsCount = [thumbs count];
        //        if(self.photor.suffleArrayKeys)
        //        {
        //            controller.thumbs = thumbs;
        //        }
        //        else
        controller.thumbs = (thumbsShuffled) ? thumbsShuffled : thumbs;
        [controller setDelegate:self];
        [UIView  beginAnimations:nil context:NULL];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.75];
        [self.navigationController pushViewController:controller animated:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
        [UIView commitAnimations];
    });
    
    
    
}

@end
