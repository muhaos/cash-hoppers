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
#import "CHDetailPhotoVC.h"

@interface CHGalleryVC ()

@end

@implementation CHGalleryVC
@synthesize photos = _photos;


-(void)setPhotos:(NSArray *)photos {
    if (_photos != photos) {
        _photos = photos;
        [self.photoCollectionView reloadData];
    }
}


+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}


- (void)viewWillAppear:(BOOL)animated
{
    [self showAdsWithType:@"RPOU" andHopID:nil];

    NSMutableArray *collector = [[NSMutableArray alloc] initWithCapacity:0];
    ALAssetsLibrary *al = [CHGalleryVC defaultAssetsLibrary];
    
    [al enumerateGroupsWithTypes:ALAssetsGroupAll
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
          {
              
              if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqual:@"CASHHOPPERS"]) {
                  if (asset) {
                      [collector addObject:asset];
                  }
              }
          }];
                  
         self.photos = collector;
     }
                    failureBlock:^(NSError *error) { NSLog(@"Boom!!!");}
     ];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.photoCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"gallery_cell"];

}


- (IBAction)settingsButtonTapped:(id)sender
{
    [DELEGATE.menuContainerVC toggleLeftSideMenuCompletion:nil];
}


#pragma mark -
#pragma mark UICollectionViewDataSource

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.photos.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CHGalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"gallery_cell" forIndexPath:indexPath];
    
    ALAsset *asset = [self.photos objectAtIndex:indexPath.row];
    UIImageView *bg = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[asset thumbnail]]];
    cell.backgroundView = bg;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UIImage * selImage = [UIImage imageWithCGImage:[[self.photos objectAtIndex:indexPath.row] thumbnail]];
    [self performSegueWithIdentifier:@"photo" sender:selImage];
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"photo"]) {
        CHDetailPhotoVC* vc = segue.destinationViewController;
        vc.photoImage  = sender;
    }
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
