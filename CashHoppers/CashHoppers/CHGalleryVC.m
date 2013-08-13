//
//  CHGalleryVC.m
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/13/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import "CHGalleryVC.h"
#import "CHAppDelegate.h"
#import "MFSideMenuContainerViewController.h"
#import "CHGalleryCell.h"

@interface CHGalleryVC ()

@end

@implementation CHGalleryVC
@synthesize imagesMutArray;


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.photoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gallery_cell"];
    
    imagesMutArray = [@[@"image_avatar.png",
                      @"gp_icon.png",
                      @"gp_icon.png",
                      @"image_avatar.png",
                      @"photo_brian.png",
                      @"photo_brian.png",
                      @"image_avatar.png",
                      @"gp_icon.png",
                      @"photo_brian.png",
                      @"photo_brian.png",
                      @"gp_icon.png",
                      @"image_avatar.png",
                      @"gp_icon.png",
                      @"image_avatar.png",
                      @"photo_brian.png"] mutableCopy];
}


- (IBAction)settingsButtonTapped:(id)sender
{
    [DELEGATE.menuContainerVC toggleLeftSideMenuCompletion:nil];
}


#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return imagesMutArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHGalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gallery_cell" forIndexPath:indexPath];
    
    int row = [indexPath row];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagesMutArray[row]]];
    cell.backgroundView = bg;
    return cell;
}


#pragma mark -
#pragma mark UICollectionViewDelegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}


#pragma mark - CollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 8, 8, 8);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}


#pragma mark -
#pragma mark UICollectionViewFlowLayoutDelegate

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(65, 65);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)viewDidUnload {
    [self setPhotoCollectionView:nil];
    [super viewDidUnload];
}


@end
