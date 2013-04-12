//
//  UIScreen+MMKeyboardDismissal.m
//  MMKeyboardDismissal
//
//  Created by Mike Mayo on 4/12/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import "UIScreen+MMKeyboardDismissal.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIScreen (MMKeyboardDismissal)

// taken from SSToolkit's UIScreen category.  Renamed to avoid conflicts
- (BOOL)_mm_isRetinaDisplay {
    static dispatch_once_t predicate;
    static BOOL answer;
    
    dispatch_once(&predicate, ^{
        answer = ([self respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2);
    });
    return answer;
}

+ (UIImage *)keyboardScreenshot {
    
    return [self keyboardScreenshot:0];
    
}

+ (UIImage*)keyboardScreenshot:(CGFloat)extraHeight {
    
    UIImage *screenshot = [self screenshot];
    
    CGRect cropRect;
    
    if ([[UIScreen mainScreen] _mm_isRetinaDisplay]) {
        cropRect = CGRectMake(0, (screenshot.size.height - kKeyboardHeight - extraHeight) * 2,
                              screenshot.size.width * 2, (kKeyboardHeight + extraHeight) * 2);
    } else {
        cropRect = CGRectMake(0, screenshot.size.height - kKeyboardHeight - extraHeight,
                              screenshot.size.width, kKeyboardHeight + extraHeight);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([screenshot CGImage], cropRect);
    UIImage *keyboardScreenshot = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return keyboardScreenshot;
    
}

+ (UIImage*)screenshot {
    
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
    if (NULL != UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    else
        UIGraphicsBeginImageContext(imageSize);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Iterate over every window from back to front
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen])
        {
            // -renderInContext: renders in the coordinate space of the layer,
            // so we must first apply the layer's geometry to the graphics context
            CGContextSaveGState(context);
            // Center the context around the window's anchor point
            CGContextTranslateCTM(context, [window center].x, [window center].y);
            // Apply the window's transform about the anchor point
            CGContextConcatCTM(context, [window transform]);
            // Offset by the portion of the bounds left of and above the anchor point
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            // Render the layer hierarchy to the current context
            [[window layer] renderInContext:context];
            
            // Restore the context
            CGContextRestoreGState(context);
        }
    }
    
    // Retrieve the screenshot image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

@end
