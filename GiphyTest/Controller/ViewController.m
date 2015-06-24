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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) NSArray *searchResults;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName: NSStringFromClass(GTCollectionCell.class) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:NSStringFromClass(GTCollectionCell.class)];
}

- (void)searchWithString:(NSString*)string
{
    [AXCGiphy searchGiphyWithTerm:string limit:100 offset:0 completion:^(NSArray *results, NSError *error) {
        self.searchResults = results;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self.collectionView reloadData];
        }];
    }];
}

#pragma mark - IBActions
- (IBAction)searchButtonPressed:(id)sender
{
    [self searchWithString:self.searchTextField.text];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    
}

#pragma mark - CollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _searchResults.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GTCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(GTCollectionCell.class)
                                                                     forIndexPath:indexPath];
//    cell.imageView.image = _searchResults[indexPath.section];
    AXCGiphy * gif         = self.searchResults[indexPath.section];
    NSURLRequest * request = [NSURLRequest requestWithURL:gif.originalImage.url];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage * image = [UIImage imageWithData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.imageView.image = image;
        }];
    }] resume];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size    = CGSizeMake(100, 100);
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
