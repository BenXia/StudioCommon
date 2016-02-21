//
//  UILabel+Size.m
//  QQing
//
//  Created by 郭晓倩 on 15/9/16.
//
//

#import "UILabel+Size.h"

@implementation UILabel (Size)


-(CGFloat)heightWithLimitWidth:(CGFloat)width{
   CGSize size = [self.text textSizeWithFont:self.font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    return ceil(size.height);
}

-(int)lineNumWithLimitWidth:(CGFloat)width{
    int lineNum = [self.text textLineNumWithFont:self.font constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    return lineNum;
}


-(void)ajustHeightWithLimitWidth:(CGFloat)width{
    CGFloat height = [self heightWithLimitWidth:width];
    self.height = height;
}

@end
