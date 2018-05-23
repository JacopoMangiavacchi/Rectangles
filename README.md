# Rectangles

iPhone Swift app which displays 2 resizable and movable rectangles.  
Whenever the rectangles overlap, notify the user.  
Goal: do not use existing rectangle intersection API such as CGRectIntersectsRect or any open source code.

- The project has a pure Foundation (no UIKit) Rectangle.swift file to describe the custom Rectangle data structure and to implement the custom Intersection/Overlap algorithm as a failable init method.
- Rectangle.swift also declare a Protocol that is implemented on a UIView Extension in UIView-Rectangle.swift in order to map bidirectional this Rectangle data structure with CGRect UIView internal data structures.
- Rectangle.swift finally also implement an Array Extension for calculating an array of intersections from an array of Rectangle.  This is useful to scale the example to support overlap even between more than 2 views.
- The file RectanglesTests.swift implement functional XCTest on the Rectangle data structure and the Intersection/Overlap algorithm
- ViewController.swift implement the UI for letting the user design the rectangles one at a time with touch interface. Once the rectangles are designed the UI allow the user to resize and move the rectangles at anytime using UIGestureRecognizers (Pan&Pinch):
  * The UI is minimal and has no frame, toolbar or button to add new rectangles
  * Shake gesture is implemented to clean all rectangles and reset the user experience
  * The code support 2 rectangles as from requirement but it could scale to a infinite number of rectangles just changing the maxRectView constant at the top of the file
  * Rectangles are rendered using simple UIViews with different background colors (yellow and red for the first two plus eventually random colors for other rectangles)
  * Rectangles have a minimum dimension value currently set to 100x100 for width height
  * Rectangles intersection is calculated mapping the UIView to an Array of Rectangle elements and than calling the intersection method implemented in the Array Extension
  * Intersection is notified to the user with a third optional UIView with different background color (orange)
  

