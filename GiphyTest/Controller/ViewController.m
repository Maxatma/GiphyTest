//
//  ViewController.m
//  GiphyTest
//
//  Created by Alexander on 6/24/15.
//  Copyright (c) 2015 Alexander. All rights reserved.
//

#import "ViewController.h"
#import "AXCGiphy.h"
#import "GTCollectionCell.h"
#import "KRLCollectionViewGridLayout.h"
#import "AFNetworking.h"
#import "GTAPI.h"
#import <AnimatedGIFImageSerialization/AnimatedGIFImageSerialization.h>

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *progressIndicator;
@property (strong, nonatomic) AFHTTPRequestOperationManager *httpRequestManager;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSArray *images;

@end

static CGFloat const kImageInsetSide = 10.0f;
@implementation ViewController
#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName: NSStringFromClass(GTCollectionCell.class) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass(GTCollectionCell.class)];
    [self configureColllectionViewLayout];
    [self hideIndicator];
}


- (void)searchWithString:(NSString*)string
{
    [AXCGiphy searchGiphyWithTerm:string limit:10 offset:0 completion:^(NSArray *results, NSError *error) {
         if (results.count == 0)
         {
             [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                 [self presentAlertWithTitle:@"No search result"];
                 [self hideIndicator];
             }];
             return;
         }
        
        self.searchResults = [results mutableCopy];
        [[GTAPI apiManager]loadImagesGiphyArray:results response:^(NSArray *responseObjects, NSError *error) {
            self.images = responseObjects;
            [self hideIndicator];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self.collectionView reloadData];
            }];
        }];
    }];
}

#pragma mark - CollectionView Datasource
- (void)configureColllectionViewLayout {
    KRLCollectionViewGridLayout *resultsLayout = [KRLCollectionViewGridLayout new];
    resultsLayout.aspectRatio                  = 1.0;
    resultsLayout.interitemSpacing             = kImageInsetSide;
    resultsLayout.lineSpacing                  = kImageInsetSide;
    resultsLayout.numberOfItemsPerLine         = 1;
    self.collectionView.collectionViewLayout   = resultsLayout;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _searchResults.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GTCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(GTCollectionCell.class)
                                                                       forIndexPath:indexPath];
    cell.imageView.image = _images[indexPath.row];
    return cell;
}

#pragma mark - IBActions
- (IBAction)searchButtonPressed:(id)sender
{
    [self.view endEditing:YES];
    [self.searchResults removeAllObjects];
    [self.collectionView reloadData];
    
    if ([_searchTextField.text isEqual:@""])
        [self presentAlertWithTitle:@"Enter what you search for"];
    else
    {
        [self searchWithString: self.searchTextField.text];
        [self showIndicator];
    }
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self hideIndicator];
}

- (void)hideIndicator {
    [self.progressIndicator stopAnimating];
    self.progressIndicator.hidden = YES;
}

- (void)showIndicator {
    [self.progressIndicator startAnimating];
    self.progressIndicator.hidden = NO;
}

- (void)presentAlertWithTitle:(NSString *)title {
    UIAlertController *alert    = [UIAlertController alertControllerWithTitle:@"¯\\_(ツ)_/¯" message:title preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
