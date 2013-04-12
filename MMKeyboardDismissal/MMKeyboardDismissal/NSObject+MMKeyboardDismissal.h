//
//  NSObject+MMKeyboardDismissal.h
//  MMKeyboardDismissal
//
//  Created by Mike Mayo on 4/12/13.
//  Copyright (c) 2013 Mike Mayo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MMKeyboardDismissal)

- (void)scrollViewDidScroll:(UIScrollView *)scrollView forDismissableTextField:(UITextField *)textField;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView forDismissableTextField:(UITextField *)textField;

@end
