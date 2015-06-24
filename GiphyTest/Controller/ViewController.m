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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic, strong) NSArray *searchResults;
@end

static CGFloat const kImageInsetSide = 10.0f;

@implementation ViewController
#pragma mark - LifeCycle
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
- (void)configureEmoticonColllectionViewLayout {
    KRLCollectionViewGridLayout *emoji_layout    = [KRLCollectionViewGridLayout new];
    [self configureTypeCollectionViewLayout:emoji_layout];
    emoji_layout.numberOfItemsPerLine            = 7;
    self.collectionView.collectionViewLayout = emoji_layout;
}

- (void)configureTypeCollectionViewLayout:(KRLCollectionViewGridLayout*)layout {
    layout.aspectRatio      = 1.0;
    layout.interitemSpacing = kImageInsetSide;
    layout.lineSpacing      = kImageInsetSide;
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
//    cell.imageView.image = _searchResults[indexPath.section];
    AXCGiphy * gif         = self.searchResults[indexPath.row];
    NSURLRequest * request = [NSURLRequest requestWithURL:gif.originalImage.url];
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        UIImage * image = [UIImage imageWithData:data];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            cell.imageView.image = image;
        }];
    }] resume];
    return cell;
}


//- (CGSize)collectionView:(UICollectionView *)collectionView
//                  layout:(UICollectionViewLayout*)collectionViewLayout
//  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGSize size    = CGSizeMake(100, 100);
//    return size;
//}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

@end
