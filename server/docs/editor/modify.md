Modifying a widget's code
===

Compared to traditional IDEs, the Widget editor has an unsual way of displaying and saving code.

Firstly, there aren't separate windows per code element, just 4 tabs that you click to switch between the code elements.

Secondly, there is no save button. The code is saved in its state as you switch between tabs, or close the editor. The reason for this is two-fold.

1. iOS style of saving document changes

  With Apple's iOS, there is a move towards having documents saved in their current state, without having to rely on clicking the save button. When an application opens after being closed, it resumes from the point where you closed the application. The save button is redundant.

  Personally, I find this concept appealing, and so I've decided to try and adopt it with how the editor works.

2. Minimalism

  I have a belief (rightly or wrongly) that the less that you are presented with visually, the easier it is for you to disseminate the information that you wish to see, and therefore the quicker it is for you to perform a given task at hand. I've tried to apply that to the design of the widget editor, and so not displaying a save button (because we've effectively made it redundant) was a step towards a minimal design.

I may change this in the future, if users are unhappy with using the editor in this way.