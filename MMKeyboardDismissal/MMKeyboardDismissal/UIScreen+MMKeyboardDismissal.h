//
//  UIScreen+MMKeyboardDismissal.h
//  MMKeyboardDismissal
//
//  Created by Mike Mayo on 4/12/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import <UIKit/UIKit.h>

// TODO: put this elsewhere
#define kKeyboardHeight 216.0
#define kKeyboardScrollDismissalBoundaryOffset 37.0

@interface UIScreen (MMKeyboardDismissal)

// taken from http://developer.apple.com/library/ios/#qa/qa1703/_index.html
+ (UIImage*)screenshot;

+ (UIImage*)keyboardScreenshot;
+ (UIImage*)keyboardScreenshot:(CGFloat)extraHeight;

@end
