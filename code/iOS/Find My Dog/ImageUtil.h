//
//  ImageUtil.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 01/07/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageUtil : NSObject

+ (UIImage *)resizeImage:(UIImage *)sourceImage toSize:(CGSize)targetSize;

@end
