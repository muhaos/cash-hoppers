//
//  CHGalleryVC.h
//  CashHoppers
//
//  Created by Balazh Vasyl on 8/13/13.
//  Copyright (c) 2013 swanteams.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CHGalleryVC : UIViewController <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) IBOutlet UICollectionView *photoCollectionView;
@property (strong, nonatomic) NSMutableArray *imagesMutArray;

- (IBAction)settingsButtonTapped:(id)sender;

@end
