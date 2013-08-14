//
//  CHGalleryVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/13/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface CHGalleryVC : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (nonatomic, strong) NSArray *photos;

- (IBAction)settingsButtonTapped:(id)sender;
+ (ALAssetsLibrary *)defaultAssetsLibrary;

@end
