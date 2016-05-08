//
//  ViewController.m
//  GiphyTest
//
//  Created by Alexander on 6/24/15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "GTCollectionCell.h"
#import "KRLCollectionViewGridLayout.h"
#import "GTAPI.h"
#import <AnimatedGIFImageSerialization/AnimatedGIFImageSerialization.h>

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic  ) IBOutlet                     UICollectionView        *collectionView;
@property (weak, nonatomic  ) IBOutlet                     UITextField             *searchTextField;
@property (weak, nonatomic  ) IBOutlet                     UIActivityIndicatorView *progressIndicator;

@property (nonatomic, strong) NSMutableArray          *searchResults;
@property (nonatomic, strong) NSArray                 *images;

@end

static CGFloat const kImageInsetSide = 10.0f;

@implementation ViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureColllectionViewLayout];
    [self hideIndicator];
}

- (void)searchWithString:(NSString *)string
{
    [[GTAPI apiManager] getImagesWithTerm:string
                                 response:^(NSArray *responseObjects, NSError *error) {
                                     
                                     if (error) {
                                         [self presentAlertWithTitle:error.localizedDescription];
                                     }
                                     
                                     if (responseObjects.count == 0)
                                     {
                                         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                             [self presentAlertWithTitle:@"No search result"];
                                             [self hideIndicator];
                                         }];
                                         return;
                                     }
                                     
                                     _images = responseObjects;
                                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                         [self hideIndicator];
                                         [_collectionView reloadData];
                                     }];
                                 }];
}

#pragma mark - Configurations

- (void)configureColllectionViewLayout
{
    KRLCollectionViewGridLayout *resultsLayout = [KRLCollectionViewGridLayout new];
    resultsLayout.aspectRatio                  = 1.0;
    resultsLayout.interitemSpacing             = kImageInsetSide;
    resultsLayout.lineSpacing                  = kImageInsetSide;
    resultsLayout.numberOfItemsPerLine         = 1;
    _collectionView.collectionViewLayout       = resultsLayout;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return _images.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GTCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([GTCollectionCell class])
                                                                       forIndexPath:indexPath];
    cell.imageView.image   = _images[indexPath.row];
    
    return cell;
}

#pragma mark - Buttons

- (IBAction)searchButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    
    if ([_searchTextField.text isEqual:@""]) {
        [self presentAlertWithTitle:@"Enter what you search for"];
    }
    else
    {
        [self searchWithString:_searchTextField.text];
        [self showIndicator];
    }
}

- (IBAction)cancelButtonPressed:(id)sender
{
    _images = [NSArray new];
    [_collectionView reloadData];
    [self hideIndicator];
}

#pragma mark - Private

- (void)hideIndicator
{
    [_progressIndicator stopAnimating];
    _progressIndicator.hidden = YES;
}

- (void)showIndicator
{
    [_progressIndicator startAnimating];
    _progressIndicator.hidden = NO;
}

- (void)presentAlertWithTitle:(NSString *)title
{
    UIAlertController *alert    = [UIAlertController alertControllerWithTitle:@"¯\\_(ツ)_/¯"
                                                                      message:title
                                                               preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert
                       animated:YES
                     completion:nil];
}

@end
