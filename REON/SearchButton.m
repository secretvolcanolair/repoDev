//
//  SearchButton.m
//  REON
//
//  Created by Robert Kehoe on 8/20/14.
//  Copyright (c) 2014 OWWS. All rights reserved.
//

#import "SearchButton.h"

@implementation SearchButton

-(id) initWithCoder:(NSCoder *)aDecoder{
    self  = [super initWithCoder:aDecoder];
    [self addTarget:self action:@selector(buttonHighlight) forControlEvents:UIControlEventTouchDown];
    return self;
}

-(void)buttonHighlight{
    [self setBackgroundImage:[SearchButton imageWithColor:[UIColor colorWithRed:32.0/255.0 green:150.0/255.0 blue:165.0/255.0 alpha:1]] forState:UIControlStateHighlighted];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
