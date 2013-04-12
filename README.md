MMKeyboardDismissal
===================

Dismisses a UITextField's keyboard as you scroll, like the Messages app.

To use:
1. Add QuartzCore.framework to your target's Build Phases -> Link Binary With Libraries
2. Drag the following files into your Xcode project:
  - UIScreen+MMKeyboardDismissal.h
  - UIScreen+MMKeyboardDismissal.m
  - NSObject+MMKeyboardDismissal.h
  - NSObject+MMKeyboardDismissal.m
3. In your UIScrollViewDelegate, call the scroll view helper methods for scrollViewDidScroll and scrollViewDidEndDragging, like so:

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self scrollViewDidScroll:scrollView forDismissableTextField:self.textField];
        
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self scrollViewDidEndDragging:scrollView forDismissableTextField:self.textField];
        
}

