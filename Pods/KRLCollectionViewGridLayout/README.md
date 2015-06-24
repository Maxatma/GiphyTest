# KRLCollectionViewGridLayout

[![Build Status](http://img.shields.io/travis/klundberg/KRLCollectionViewGridLayout/master.svg?style=flat)](https://travis-ci.org/klundberg/KRLCollectionViewGridLayout)
[![Version](https://img.shields.io/cocoapods/v/KRLCollectionViewGridLayout.svg?style=flat)](http://cocoadocs.org/docsets/KRLCollectionViewGridLayout)
[![License](https://img.shields.io/cocoapods/l/KRLCollectionViewGridLayout.svg?style=flat)](http://cocoadocs.org/docsets/KRLCollectionViewGridLayout)
[![Platform](https://img.shields.io/cocoapods/p/KRLCollectionViewGridLayout.svg?style=flat)](http://cocoadocs.org/docsets/KRLCollectionViewGridLayout)

This layout is an alternative to UICollectionViewFlowLayout that positions and sizes items using a defined number of columns and an aspect ratio property which force the size of cells, rather than the cells' size telling the layout how to position them (in the way UICollectionViewFlowLayout behaves). By default, this will always show the same number of items in a row no matter how large or small the collection view is.

You can specify the number of items per line and the desired aspect ratio of all items (which is always width / height, regardless of scroll direction):

    layout.numberOfItemsPerLine = 5;
    layout.aspectRatio = 16.0/9.0;

You can specify metrics similar to UICollectionViewFlowLayout, like so:

    layout.sectionInset = UIEdgeInsetsMake(10,20,30,40);
    layout.interitemSpacing = 15;
    layout.lineSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

You can also add headers and footers to each section similar to UICollectionViewFlowLayout:

    layout.headerReferenceLength = 44;
    layout.footerReferenceLength = 100;

In vertical scrolling mode, length is the height of the header/footer. In horizontal scrolling mode, length is the width of the header/footer.
A length of 0 in these dimensions will not try to create a view.

All of the above properties (except for `scrollDirection`) can be configured on a per-section basis using `KRLCollectionViewDelegateFlowLayout`. Have your view controller or other object that implements the regular UICollectionViewDelegate also implement this protocol to make these per-section variances on these properties.

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.
You can either run unit tests on the library itself, or run the sample project for a visual demonstration.

## Requirements

iOS 6.0 or greater, and ARC.

Example project requires Xcode 6.3, can only run in iOS 8.0+. 

## Installation

KRLCollectionViewGridLayout is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "KRLCollectionViewGridLayout"

## Author

Kevin Lundberg, kevin at klundberg dot com

## Contributions

Pull requests are welcome! Please include unit tests for any bugfixes or new features.

## License

KRLCollectionViewGridLayout is available under the MIT license. See the LICENSE file for more info.


