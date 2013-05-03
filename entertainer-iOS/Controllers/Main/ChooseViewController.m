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
    [self initBackButton];
    [self initInfoButtonWithTarget:self];
    [self initContent];
    [self initUI];
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

    MRChooseCollectionViewItem *item = [[MRChooseCollectionViewItem alloc] initWithReuseIdentifier:itemIdentifier];
    [item setDelegate:self];
    MRBlock *block = [blocks objectAtIndex:indexPath.row];
    
    [item.nameLabel setText:block.name];
    NSURL *imageUrl = [NSURL URLWithString:block.imagePath];
    [item.icon setImageWithURL:imageUrl placeholderImage:[[UIImage alloc] init]];
    [item.removeButton addTarget:self action:@selector(removeItem:) forControlEvents:UIControlEventTouchUpInside];
    if (self.shaking){
        [item.removeButton setHidden:NO];
        [self startShakingView:item.icon];
    }
    return item;
}

#pragma mark - SSCollectionViewDelegate

- (CGSize)collectionView:(SSCollectionView *)aCollectionView itemSizeForSection:(NSUInteger)section {
    return CGSizeMake(125.0f, 145.0f);
}

-(void)collectionView:(SSCollectionView *)aCollectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    selected = [blocks objectAtIndex:indexPath.row];
    FGalleryViewController *controller = [[FGalleryViewController alloc] initWithPhotoSource:self];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)removeItem:(UIButton *)sender{
    MRChooseCollectionViewItem *item = (MRChooseCollectionViewItem *)[sender superview];
    NSIndexPath *indexPath = [self.collectionView indexPathForItem:item];
    removingPath = indexPath;
    [self showAlert];
}

-(void)showAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Удаление блока" message:@"Вы точно уверены, что хотите удалить блок?" delegate:self cancelButtonTitle:@"Отмена" otherButtonTitles:@"Да", nil];
    [alert show];
}

#pragma mark - alert view delegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1){
        MRBlock *removing = [blocks objectAtIndex:removingPath.row];
        [removing removeFromDataBase];
        [blocks removeObject:removing];
        [self.collectionView reloadData];
    }
}

#pragma mark - FGalleryViewControllerDelegate Methods


- (int)numberOfPhotosForPhotoGallery:(FGalleryViewController *)gallery{
	return selected.items.count;
}

- (FGalleryPhotoSourceType)photoGallery:(FGalleryViewController *)gallery sourceTypeForPhotoAtIndex:(NSUInteger)index{
    return FGalleryPhotoSourceTypeImage;
}

- (NSString*)photoGallery:(FGalleryViewController *)gallery captionForPhotoAtIndex:(NSUInteger)index{
	return @"";
}

-(UIImage *)photoGallery:(FGalleryViewController *)gallery imageForPhotoSize:(FGalleryPhotoSize)size atIndex:(NSUInteger)index{
    MRItem *item = [selected.items objectAtIndex:index];
    UIImage *image = item.image;
    return image;
}

- (void)handleTrashButtonTouch:(id)sender {
    // here we could remove images from our local array storage and tell the gallery to remove that image
    // ex:
    //[localGallery removeImageAtIndex:[localGallery currentIndex]];
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
    blocks = [NSMutableArray arrayWithArray:[NSArray arrayWithShuffledContentOfArray:blocks]];
    [self.collectionView reloadData];
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
        if (shaking){
            [self startShakingView:colItem.icon];
        } else {
            [colItem.icon.layer removeAllAnimations];
        }
    }
}

#pragma mark - getters

-(BOOL)shaking{
    return _shaking;
}

@end
