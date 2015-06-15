//
//  DisplayViewController.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 04.06.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "DisplayViewController.h"
#import "UIView+REUIKitAdditions.h"
#import "SHK.h"
#import "SHKFacebook.h"
#import "SHKVkontakte.h"
#import "SHKTwitter.h"

@interface DisplayViewController ()

@end

@implementation DisplayViewController

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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
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
	// Do any additional setup after loading the view.
    isFullScreen = NO;
    currentIndex = 0;
    isShuffled = NO;
    [self setWantsFullScreenLayout:YES];
    [self initViewPositions];
    [self initPhotoViewer];
    [self initTopBar];
    [self initBottomButtons];
}

-(void)initBottomButtons{
    [self.shuffleButton setImage:[UIImage imageNamed:@"shuffle_off.png"] forState:UIControlStateNormal];
    [self.shuffleButton setImage:[UIImage imageNamed:@"shuffle_on.png"] forState:UIControlStateSelected];
    [self.shuffleButton setSelected:NO];
}

-(void)initTopBar{
    
}

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
    [photoViewer setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    [self.view insertSubview:photoViewer atIndex:0];
    self.photor = photoViewer;
    [self.photor reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - photo viewer data source methods

-(NSUInteger)numberOfPhotosInPhotoViewer:(MRPhotoViewer *)photoViewer{
    return self.block.items.count;
}

-(UIImage *)photoViewer:(MRPhotoViewer *)photoViewer imageAtIndex:(NSUInteger)index{
    MRItem *item = [self.block.items objectAtIndex:index];
    return item.image;
}

#pragma mark - photo viewer delegate methods

-(void)photoViewer:(MRPhotoViewer *)photoViewer positionChangedAtIndex:(NSUInteger)index{
    int count = self.block.items.count;
    currentIndex = index;
    if (!isShuffled)
        [self.topLabel setText:[NSString stringWithFormat:@"Страница %d из %d", index + 1,count]];
}

-(void)photoViewerTaped:(MRPhotoViewer *)photoViewer{
    if (!isFullScreen)
        [self enterFullscreen];
    else
        [self exitFullscreen];
}

-(void)enterFullscreen{
    isFullScreen = YES;
    
    [self disableApp];
    
    UIApplication* application = [UIApplication sharedApplication];
    if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
        [[UIApplication sharedApplication] setStatusBarHidden: YES withAnimation: UIStatusBarAnimationFade]; // 3.2+
    } else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        [[UIApplication sharedApplication] setStatusBarHidden: YES animated:YES]; // 2.0 - 3.2
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.view.height+10;
        self.topView.y = - self.topView.height;
        [self.bottomView setAlpha:0];
        [self.topView setAlpha:0];
    } completion:^(BOOL finished) {
        [self enableApp];
    }];
    
}

- (void)exitFullscreen
{
	isFullScreen = NO;
    
	[self disableApp];
    
	UIApplication* application = [UIApplication sharedApplication];
	if ([application respondsToSelector: @selector(setStatusBarHidden:withAnimation:)]) {
		[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade]; // 3.2+
	} else {
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
		[[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO]; // 2.0 - 3.2
#pragma GCC diagnostic warning "-Wdeprecated-declarations"
	}
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.y = self.view.height - self.bottomView.height;
        self.topView.y = 21;
        [self.bottomView setAlpha:1];
        [self.topView setAlpha:1];
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

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"shared");
//    MRItem *currentItem = [self.block.items objectAtIndex:currentIndex];
//    UIImage *image = currentItem.image;
//    SHKItem *item = [SHKItem image:image title:@"Картинка отправлена через приложение Мобильный развлекатор"];
//    switch (buttonIndex) {
//        case 0:
//            [SHKVkontakte shareItem:item];
//            break;
//        case 1:
//            [SHKFacebook shareItem:item];
//            break;
//        case 2:
//            [SHKTwitter shareItem:item];
//            break;
//        default:
//            break;
//    }
}

#pragma mark - thumb view delegate methods

-(void)thumbViewItemDidSelectAtIndex:(NSUInteger)index{
    [self.photor moveAtIndex:index animated:NO];
}

#pragma mark - actions

-(IBAction)onBackButtonClick:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)onInfoButtonClick:(id)sender{
    [self performSegueWithIdentifier:@"ToAbout" sender:self];
}

- (IBAction)onShareButtonClick:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Поделиться" delegate:self cancelButtonTitle:@"Отмена" destructiveButtonTitle:nil otherButtonTitles:@"ВКонтакте",@"Facebook",@"Twitter",nil];
    [actionSheet showInView:self.view];
}

- (IBAction)onShuffleButtonClick:(id)sender {
    isShuffled = !isShuffled;
    [self.shuffleButton setSelected:isShuffled];
    if (isShuffled)
        [self.topLabel setText:@"Случайный порядок"];
    [self.block setShuffled:!self.block.shuffled];
    [self.photor reloadData];
}

- (IBAction)onDocumentsButtonClick:(id)sender {
    ThumbsViewController *controller = [[ThumbsViewController alloc] init];
    controller.block = self.block;
    [controller setDelegate:self];
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:controller animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}

@end
