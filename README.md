Expanding Button Bar
=========

Expanding Button Bar is a simple iOS widget created by Ryan Nystrom. The widget is designed to be highly portable and customizable. There are no default images or buttons. Everything that you want to use as buttons should be customly made.

Inspiration for this button bar came from the app Path in which they practically removed the need for a UITabBar by adding a button in the bottom left. The goal with this widget is to replicate that functionality and give you the option of using buttons that animate in and out to reclaim some much needed UI space.

<iframe width="420" height="315" src="http://www.youtube.com/embed/zOimiztCycY" frameborder="0" allowfullscreen></iframe>

<img src="https://github.com/rnystrom/ExpandingButtonBar/raw/master/images/base.png" width="200" style="box-shadow: 2px 2px 5px #000; margin: 0 15px;" />
<img src="https://github.com/rnystrom/ExpandingButtonBar/raw/master/images/expanded.png" width="200" style="box-shadow: 2px 2px 5px #000; margin: 0 15px;" />
<img src="https://github.com/rnystrom/ExpandingButtonBar/raw/master/images/table.png" width="200" style="box-shadow: 2px 2px 5px #000; margin: 0 15px;" />

### Installation

Just drag and drop the ExpandingButtonBar.h and ExpandingButtonBar.m files into your project and you are ready to go. Both files were designed to use ARC technologies so you will need to use this widget in an ARC enabled environment, which requires iOS SDK 5+.

### Usage

The widget is customizable using the following methods:

    - (id) initWithImage:(UIImage*)image 
           selectedImage:(UIImage*)selectedImage 
            toggledImage:(UIImage*)toggledImage 
    toggledSelectedImage:(UIImage*)toggledSelectedImage 
                 buttons:(NSArray*)buttons 
                  center:(CGPoint)center;

Creates and returns the instance of ExpandingButtonBar. Pass it four images for the normal and toggled buttons. You can also pass selected images for each state. Next you pass an NSArray of buttons that you want to be animated into view. This can be any type of button that responds to any method that you wish. Finally, send a coordinate for the center of the view.

Then, since ExpandingButtonBar is a subclass of UIView, add the bar to your view with a simple <code>-addSubview</code> from your main view controller. To show or hide the buttons that were passed after initialization, call:

    -showButtonsAnimated:(BOOL)animated
    -hideButtonsAnimated:(BOOL)animated

### Customizing

There are many properties of the ExpandingButtonBar that are customizable. 

    - (void) setAnimationTime:(float)time;

Change the total time that buttons take to animate. Default is 0.4f.

    - (void) setFadeTime:(float)time;

Change the time that it takes for the main and toggle button to switch. Default is 0.2f.

    - (void) setPadding:(float)padding;

Set the padding in between buttons. Default is 15.0f.

    - (void) setSpin:(BOOL)b;

If you want the buttons to spin as they animate out and back. Default to NO.

    - (void) setHorizontal:(BOOL)b;

If the animations should be horizontal. Default to NO.

    - (void) setFar:(float)num;

Set the distance from the final position that the buttons should bounce above. Default is 15.0f.

    - (void) setNear:(float)num;

Set the distance from the final position that the buttons should bounce below. Default is 7.0f.

    - (void) setDelay:(float)num;

Set the delay in between buttons appearing and animating. Default is 0.1f.

### License

Copyright (C) 2012 Ryan Nystrom

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software" ), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

http://www.opensource.org/licenses/Mopyright
