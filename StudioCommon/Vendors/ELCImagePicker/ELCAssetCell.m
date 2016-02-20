//
//  AssetCell.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCConsole.h"
#import "ELCOverlayImageView.h"

static const CGFloat kImageItemPadding = 4;
static const NSInteger kRowImagesCount = 4;

@interface ELCAssetCell ()

@property (nonatomic, strong) NSArray *rowAssets;
@property (nonatomic, strong) NSMutableArray *imageViewArray;
@property (nonatomic, strong) NSMutableArray *overlayViewArray;

@end

@implementation ELCAssetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
	if (self) {
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTapped:)];
        [self addGestureRecognizer:tapRecognizer];
        
        NSMutableArray *mutableArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.imageViewArray = mutableArray;
        
        NSMutableArray *overlayArray = [[NSMutableArray alloc] initWithCapacity:4];
        self.overlayViewArray = overlayArray;
        
        self.alignmentLeft = YES;
	}
	return self;
}

- (void)setAssets:(NSArray *)assets
{
    self.rowAssets = assets;
	for (UIImageView *view in _imageViewArray) {
        [view removeFromSuperview];
	}
    for (ELCOverlayImageView *view in _overlayViewArray) {
        [view removeFromSuperview];
	}
    //set up a pointer here so we don't keep calling [UIImage imageNamed:] if creating overlays
    UIImage *overlayImage = nil;
    for (int i = 0; i < [_rowAssets count]; ++i) {

        ELCAsset *asset = [_rowAssets objectAtIndex:i];

        if (i < [_imageViewArray count]) {
            UIImageView *imageView = [_imageViewArray objectAtIndex:i];
            imageView.image = [UIImage imageWithCGImage:asset.asset.thumbnail];
        } else {
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:asset.asset.thumbnail]];
            [_imageViewArray addObject:imageView];
        }
        
        if (i < [_overlayViewArray count]) {
            ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
            overlayView.hidden = asset.selected ? NO : YES;
            overlayView.labIndex.text = [NSString stringWithFormat:@"%d", asset.index + 1];
        } else {
            if (overlayImage == nil) {
                overlayImage = [UIImage imageNamed:@"selected_photo_overlay"];
            }
            ELCOverlayImageView *overlayView = [[ELCOverlayImageView alloc] initWithImage:overlayImage];
            [_overlayViewArray addObject:overlayView];
            overlayView.hidden = asset.selected ? NO : YES;
            overlayView.labIndex.text = [NSString stringWithFormat:@"%d", asset.index + 1];
        }
    }
}

- (void)cellTapped:(UITapGestureRecognizer *)tapRecognizer
{
    CGFloat kImageItemWidthAndHeight = [ELCAssetCell imageItemWidthAndHeight];
    CGPoint point = [tapRecognizer locationInView:self];
    int c = (int32_t)self.rowAssets.count;
    CGFloat totalWidth = c * kImageItemWidthAndHeight + (c - 1) * kImageItemPadding;
    CGFloat startX;
    
    if (self.alignmentLeft) {
        startX = kImageItemPadding;
    }else {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }
    
	CGRect frame = CGRectMake(startX, 2, kImageItemWidthAndHeight, kImageItemWidthAndHeight);
	
	for (int i = 0; i < [_rowAssets count]; ++i) {
        if (CGRectContainsPoint(frame, point)) {
            ELCAsset *asset = [_rowAssets objectAtIndex:i];
            BOOL originalSelected = asset.selected;
            asset.selected = !asset.selected;
            ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
            overlayView.hidden = !asset.selected;
            
            if (originalSelected != asset.selected) {
                if (asset.selected) {
                    asset.index = [[ELCConsole mainConsole] numOfSelectedElements];
                    [overlayView setIndex:asset.index+1];
                    [[ELCConsole mainConsole] addIndex:asset.index];
                }
                else
                {
                    int lastElement = [[ELCConsole mainConsole] numOfSelectedElements] - 1;
                    [[ELCConsole mainConsole] removeIndex:lastElement];
                }
            }
            break;
        }
        frame.origin.x = frame.origin.x + frame.size.width + kImageItemPadding;
    }
}

- (void)layoutSubviews
{
    CGFloat kImageItemWidthAndHeight = [ELCAssetCell imageItemWidthAndHeight];
    
    int c = (int32_t)self.rowAssets.count;
    CGFloat totalWidth = c * kImageItemWidthAndHeight + (c - 1) * kImageItemPadding;
    CGFloat startX;
    
    if (self.alignmentLeft) {
        startX = kImageItemPadding;
    }else {
        startX = (self.bounds.size.width - totalWidth) / 2;
    }
    
	CGRect frame = CGRectMake(startX, 2, kImageItemWidthAndHeight, kImageItemWidthAndHeight);
	
	for (int i = 0; i < [_rowAssets count]; ++i) {
		UIImageView *imageView = [_imageViewArray objectAtIndex:i];
		[imageView setFrame:frame];
		[self addSubview:imageView];
        
        ELCOverlayImageView *overlayView = [_overlayViewArray objectAtIndex:i];
        [overlayView setFrame:frame];
        [self addSubview:overlayView];
		
		frame.origin.x = frame.origin.x + frame.size.width + kImageItemPadding;
	}
}

+ (CGFloat)cellHeight
{
    static CGFloat kCellHeight;
    if (kCellHeight <= 1e-6) {
        kCellHeight= [ELCAssetCell imageItemWidthAndHeight] + 4;
    }
    return kCellHeight;
}

+ (CGFloat)imageItemWidthAndHeight
{
    static CGFloat kImageItemWidthAndHeight;
    if (kImageItemWidthAndHeight <= 1e-6) {
        kImageItemWidthAndHeight= (kScreenWidth - kImageItemPadding * (kRowImagesCount + 1)) / kRowImagesCount;
    }
    return kImageItemWidthAndHeight;
}


@end
