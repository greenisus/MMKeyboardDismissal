MMKeyboardDismissal
===================

UITextField only provides one way to dismiss the keyboard: -resignFirstResponder.  This dismisses the keyboard at a constant speed and isn't easily configured.  

Many apps have scroll views full of content (such as comments or messages) with a text field at the bottom.  When the text field is in focus, many of these apps place an invisible button over the scroll view that dismisses focus on the text field.

However, if you look at the built in Messages app on your iPhone, you'll notice that instead of immediately dismissing the text field, it instead scrolls the keyboard away by tracking your movement of the scroll view.  You can see this in action by going to a long conversation in Messages, focusing on the text field, and then slowly start scrolling to the top.

Unfortunately, there's no built in way to do this in Cocoa Touch, so I've written this tool to help you do it in your own apps.

How it Works
------------

When you start scrolling, Messages appears to take a screen shot of the keyboard, and show you that screen shot scrolling away as you track your finger.  You can see this by paying attention to the blinking cursor when you start scrolling.  The cursor will appear frozen in whatever state it was when you start scrolling.

So, this tool takes a screenshot of the keyboard, places it over everything else, dismisses the real keyboard behind the scenes, and moves the screenshot keyboard as you track your finger.

How to Use
----------

1. Add QuartzCore.framework to your target's Build Phases -> Link Binary With Libraries
2. Drag the following files into your Xcode project:
  - UIScreen+MMKeyboardDismissal.h
  - UIScreen+MMKeyboardDismissal.m
  - NSObject+MMKeyboardDismissal.h
  - NSObject+MMKeyboardDismissal.m
3. In your UIScrollViewDelegate, import UIScreen+MMKeyboardDismissal.h and NSObject+MMKeyboardDismissal.h
4. In your UIScrollViewDelegate, call the scroll view helper methods for scrollViewDidScroll and scrollViewDidEndDragging, like so:

    - (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
        [self scrollViewDidScroll:scrollView forDismissableTextField:self.textField];
        
    }

    - (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
        [self scrollViewDidEndDragging:scrollView forDismissableTextField:self.textField];
        
    }

