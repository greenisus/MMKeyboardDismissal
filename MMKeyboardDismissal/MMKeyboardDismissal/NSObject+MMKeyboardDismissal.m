//
//  NSObject+MMKeyboardDismissal.m
//  MMKeyboardDismissal
//
//  Created by Mike Mayo on 4/12/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import "NSObject+MMKeyboardDismissal.h"
#import "UIScreen+MMKeyboardDismissal.h"
#import <objc/runtime.h>

@implementation NSObject (MMKeyboardDismissal)

- (UIImageView *)_mm_keyboardScreenshotImageView {
    return objc_getAssociatedObject(self, @"_mm_keyboardScreenshotImageView");
}

- (void)_mm_setKeyboardScreenshotImageView:(UIImageView *)imageView {
    objc_setAssociatedObject(self, @"_mm_keyboardScreenshotImageView", imageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)_mm_keyboardScreenshotStartOffsetY {
    return [objc_getAssociatedObject(self, @"_mm_keyboardScreenshotStartOffsetY") floatValue];
}

- (void)_mm_setKeyboardScreenshotStartOffsetY:(CGFloat)offsetY {
    objc_setAssociatedObject(self, @"_mm_keyboardScreenshotStartOffsetY", @(offsetY), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView forDismissableTextField:(UITextField *)textField {
    
    if ([textField isFirstResponder] && ![self _mm_keyboardScreenshotImageView]) {
        
        UIImageView *keyboardScreenshotImageView = [[UIImageView alloc] initWithImage:[UIScreen keyboardScreenshot]];
        keyboardScreenshotImageView.frame = CGRectMake(0, 480 - kKeyboardHeight, keyboardScreenshotImageView.frame.size.width, kKeyboardHeight);
        
        // not using the main window because we need this view to live in front of the keyboard
        UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
        [tempWindow addSubview:keyboardScreenshotImageView];
        
        [self _mm_setKeyboardScreenshotImageView:keyboardScreenshotImageView];
        [self _mm_setKeyboardScreenshotStartOffsetY:scrollView.contentOffset.y];
        
    } else {
        
        [self _mm_keyboardScreenshotImageView].frame = CGRectMake(0, MAX(480 - kKeyboardHeight, 480 - kKeyboardHeight + ([self _mm_keyboardScreenshotStartOffsetY] - scrollView.contentOffset.y)), 320, kKeyboardHeight);
        
    }
    
    [textField resignFirstResponder];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView forDismissableTextField:(UITextField *)textField {
    
    if ([self _mm_keyboardScreenshotImageView].frame.origin.y > 480) {
        
        [[self _mm_keyboardScreenshotImageView] removeFromSuperview];
        [self _mm_setKeyboardScreenshotImageView:nil];
        
    } else if ([self _mm_keyboardScreenshotImageView].frame.origin.y > 480 - kKeyboardHeight + kKeyboardScrollDismissalBoundaryOffset) {
        
        [UIView animateWithDuration:0.25 animations:^{
            [self _mm_keyboardScreenshotImageView].frame = CGRectMake(0, 480, [self _mm_keyboardScreenshotImageView].frame.size.width, kKeyboardHeight);
        } completion:^(BOOL finished) {
            [[self _mm_keyboardScreenshotImageView] removeFromSuperview];
            [self _mm_setKeyboardScreenshotImageView:nil];
        }];
        
    } else if ([self _mm_keyboardScreenshotImageView]) {
        
        [UIView animateWithDuration:0.25 animations:^{
            
            [self _mm_keyboardScreenshotImageView].frame = CGRectMake(0, 480 - kKeyboardHeight, [self _mm_keyboardScreenshotImageView].frame.size.width, kKeyboardHeight);
            
        } completion:^(BOOL finished) {
            if (finished) {
                
                // become first responder instantly
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:0.0];
                [UIView setAnimationDelay:0.0];
                [UIView setAnimationCurve:UIViewAnimationCurveLinear];
                [textField becomeFirstResponder];
                [UIView commitAnimations];
                
                [[self _mm_keyboardScreenshotImageView] removeFromSuperview];
                [self _mm_setKeyboardScreenshotImageView:nil];
                
            }
        }];
        
    }
    
}

@end
