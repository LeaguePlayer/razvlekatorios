//
//  ChooseViewController.m
//  entertainer-iOS
//
//  Created by Салахутдинов Данияр on 21.03.13.
//  Copyright (c) 2013 Danyar Salahutdinov. All rights reserved.
//

#import "ChooseViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MRItem.h"
#import "NSArray+Shuffling.h"
#import <QuartzCore/QuartzCore.h>
#import "DisplayViewController.h"
#import "SVProgressHUD.h"

@interface ChooseViewController ()

@end

@implementation ChooseViewController

@synthesize shaking = _shaking;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _shaking = NO;
    countItemsBySelectedBlock = 0;
    [self initBackButton];
    [self initInfoButtonWithTarget:self];
    [self initContent];
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didGetMyNotification)
                                                 name:@"MyNotification"
                                               object:nil];
    
}

- (void)didGetMyNotification {
    NSLog(@"Hello!");
    blocks = [NSMutableArray arrayWithArray:[MRBlock allBlocks]];
    [self.collectionView reloadData];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)rightItemClick:(id)sender{
    [self performSegueWithIdentifier:@"About" sender:self];
}

-(void)initContent{
    blocks = [NSMutableArray arrayWithArray:[MRBlock allBlocks]];
}

-(void)initUI{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"fon.png"]]];
    [self initTitle];
    [self initCollectionView];
}

-(void)initCollectionView{
    self.collectionView = [[SSCollectionView alloc] init];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.frame = CGRectMake(0,5,self.view.frame.size.width,self.view.frame.size.height - 5 - self.bottomView.frame.size.height);
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    [self.view insertSubview:self.collectionView atIndex:0];
    recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(collectionViewTouched:)];
    self.collectionView.userInteractionEnabled = YES;
}

-(void)collectionViewTouched:(UITapGestureRecognizer *)sender{
    if (self.shaking){
        [self setShaking:NO];
    }
}

-(void)initTitle{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 140, 48)];
    label.numberOfLines = 1;
    [label setFont:[UIFont systemFontOfSize:17.0f]];
    [label setText:@"Выбрать развлекатор"];
    [label setBackgroundColor:[UIColor clearColor]];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:[UIColor whiteColor]];
    [label sizeToFit];
    [self.navigationItem setTitleView:label];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSCollectionViewDataSource

-(CGFloat)collectionView:(SSCollectionView *)aCollectionView heightForHeaderInSection:(NSUInteger)section{
    return 10;
}

-(UIView *)collectionView:(SSCollectionView *)aCollectionView viewForHeaderInSection:(NSUInteger)section{
    return [[UIView alloc] init];
}

- (NSUInteger)numberOfSectionsInCollectionView:(SSCollectionView *)aCollectionView {
    return 1;
}

- (NSUInteger)collectionView:(SSCollectionView *)aCollectionView numberOfItemsInSection:(NSUInteger)section {
    return blocks.count;
}

- (SSCollectionViewItem *)collectionView:(SSCollectionView *)aCollectionView itemForIndexPath:(NSIndexPath *)indexPath {
    static NSString *const itemIdentifier = @"itemIdentifier";

    __block MRChooseCollectionViewItem *item = [[MRChooseCollectionViewItem alloc] initWithReuseIdentifier:itemIdentifier];
    [item setDelegate:self];
    MRBlock *block = [blocks objectAtIndex:indexPath.row];
    
    [item.nameLabel setText:block.name];
//    [item.nameLabel sizeToFit];
//    CGRect frame = item.nameLabel.frame;NSLog(@"%f",frame.size.height);
//    frame.origin.y = item.icon.frame.origin.y - frame.size.height;
//    [item.nameLabel setFrame:frame];
    
    [item.icon setImage:block.image];
    [item.removeButton addTarget:self action:@selector(removeItem:) forControlEvents:UIControlEventTouchUpInside];
    [item.infoButton addTarget:self action:@selector(infoBlock:) forControlEvents:UIControlEventTouchUpInside];
    
    if (self.shaking){
        [item.removeButton setHidden:NO];
        [item.removeImage setHidden:NO];
        [item.infoImage setHidden:NO];
        [item.infoButton setHidden:NO];
        [self startShakingView:item.icon];
    }
    return item;
}

#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
    return CGSizeMake(125.0f, 160.0f);
}

-(void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    selected = [blocks objectAtIndex:indexPath.row];
    [SVProgressHUD showWithStatus:@"Загружаю блок" maskType:SVProgressHUDMaskTypeGradient];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Do background work
        countItemsBySelectedBlock = [MRItem allItemsByBlockId:selected.id];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"ToDisplay" sender:self];
        });
    });
    
}

-(void)removeItem:(UIButton *)sender{
   
    
    MRChooseCollectionViewItem *item = (MRChooseCollectionViewItem *)[sender superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForItem:item];
    removingPath = indexPath;
    
     MRBlock *block = [blocks objectAtIndex:indexPath.row];
    NSLog(@"%i",block.slidesInBlock);
     NSLog(@"%@",block.sizeBlock);
    [self showAlert];
}

-(void)infoBlock:(UIButton *)sender{
    
    
    MRChooseCollectionViewItem *item = (MRChooseCollectionViewItem *)[sender superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForItem:item];
    removingPath = indexPath;
    
    MRBlock *block = [blocks objectAtIndex:indexPath.row];
  
    
    NSString *messageAlert = [NSString stringWithFormat:@"Количество слайдов в блоке %i. \nРазмер блока %@.", block.slidesInBlock, block.sizeBlock];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Информация о блоке" message:messageAlert delegate:nil cancelButtonTitle:@"Отмена" otherButtonTitles:nil];
    
    
    
    [alert show];
    //    [self showAlert];
}

-(void)showAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Удаление блока" message:@"Вы точно уверены, что хотите удалить блок?" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Да", nil];
    [alert show];
}

#pragma mark - alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            //Do background work
//            MRBlock *removing = [blocks objectAtIndex:removingPath.row];
//            [removing removeFromDataBase];
//            [blocks removeObject:removing];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.collectionView reloadData];
//                [SVProgressHUD dismiss];
//            });
//        });
//        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
//        dispatch_async(dispatch_get_main_queue(), ^{
        
            MRBlock *removing = [blocks objectAtIndex:removingPath.row];
            [removing removeFromDataBase];
            [blocks removeObject:removing];
            [self.collectionView reloadData];
//            [SVProgressHUD dismiss];
//        });
        
        
        
    }
}

-(void)photoGalleryShuffleItems{
    [selected setShuffled:!selected.shuffled];
}

- (void)handleEditCaptionButtonTouch:(id)sender {
    // here we could implement some code to change the caption for a stored image
}

-(void)startShakingView:(UIView *)view{
    CGAffineTransform leftWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(-1.5));
    CGAffineTransform rightWobble = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(1.5));
    
    view.transform = leftWobble;  // starting point
    
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
        view.transform = rightWobble;
    } completion:^(BOOL finished){
        view.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Choose Collection view item delegate methods

-(void)itemLongPressed:(MRChooseCollectionViewItem *)item{
    if (self.shaking) return;
    self.shaking = YES;
}

- (IBAction)shuffleButtonClicked:(id)sender {
    if (blocks.count == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка" message:@"У Вас нет загруженных развлекаторов" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
        return;
    }
    MRBlock *all = [[MRBlock alloc] init];
//    NSMutableArray *items = [NSMutableArray array];
//    for (MRBlock *block in blocks){
//        [items addObjectsFromArray:block.items];
//    }
//    = [NSArray arrayWithShuffledContentOfArray:items];
    selected = all;
    
    [SVProgressHUD showWithStatus:@"Загружаю блоки" maskType:SVProgressHUDMaskTypeGradient];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Do background work
        countItemsBySelectedBlock = [MRItem allItemsByBlockId:selected.id];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"ToDisplay" sender:self];
        });
    });
    
    
}

- (void)viewDidUnload {
    [self setBottomView:nil];
    [super viewDidUnload];
}

#pragma mark - setters

-(void)setShaking:(BOOL)shaking{
    if (_shaking == shaking) return;
    _shaking = shaking;
    if (shaking){
        [self.collectionView addGestureRecognizer:recognizer];
    } else {
        [self.collectionView removeGestureRecognizer:recognizer];
    }
    for (int i = 0; i < blocks.count; i++){
        NSIndexPath *path = [NSIndexPath indexPathForRow:i inSection:0];
        MRChooseCollectionViewItem *colItem = (MRChooseCollectionViewItem *)[self.collectionView itemForIndexPath:path];
        [colItem.removeButton setHidden:!shaking];
        [colItem.removeImage setHidden:!shaking];
        [colItem.infoButton setHidden:!shaking];
        [colItem.infoImage setHidden:!shaking];
        if (shaking){
            [self startShakingView:colItem.icon];
        } else {
            [colItem.icon.layer removeAllAnimations];
            
        }
    }
}

#pragma mark - segue routines

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ToDisplay"]){
//       [SVProgressHUD showWithStatus:@"Загружаю блок" maskType:SVProgressHUDMaskTypeGradient];
//        dispatch_async(dispatch_get_main_queue(), ^{
//                 [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeGradient];
//            });
        
        NSLog(@"ToDisplay");
            DisplayViewController *controller = (DisplayViewController *)segue.destinationViewController;
            controller.block = selected;
            controller.itemsCount = countItemsBySelectedBlock;
//
//            NSLog(@"%li", (long)controller.itemsCount);
        
       
        

    }
}

#pragma mark - getters

-(BOOL)shaking{
    return _shaking;
}

@end
