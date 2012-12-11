#GSBookShelf

An iBooks-inspired bookshelf control.

Supports animated deletion, reordering, and addition.

---

Attention:

1. This code should be compiled with ARC turned on;

---

Features:

1. drag & drop
2. scroll up/down while draging
3. add & remove animation
4. custom header (add a search bar or anything you want)5. 
5. **[Update 12.08.26]** support orientation change now and the cell has a simple animtaion when orientation change make this more similar to iBooks, to get more info, take a look at the demo 

---

How To:

1. Just take a look at the demo.
2. bookView and shelfCell are just UIViews. So you can cutomize them almost whatever you want. But the frame of each view is fixed, if you want to have different size of bookView, you can try adding your content on a transparent UIView.
3. To enable reusing for bookViews and cells, add the "GSBookView" / "GSBookShelfCell" protocols. (You'd better do this, perfromance will be a lot better).
4. **[NEW 12.04.03]** To support oritation change, you should call the reload method and return different values (if necessary) in the delegate method with different orientation.
5. **[NEW 12.04.03]** For more information about the data GSBookShelf need for layout, take a look at the "[comments.png](https://github.com/ultragtx/GSBookShelf/blob/ReadyTo/BookShelf/comments.png?raw=true)" (also available in the project).
6. **[NEW 12.05.18]** The books are center-aligend when there are more than one books in a row. If you only have one per row, it's left-aligend, you can set the "cellMargin" to make it center-aligend manually.

---

WARNING:

1. **[12.08.26]** Some of the images came from iBooks (a little change to the color). Just to show how the code works. PLEASE use your own image in your project. Check [this](http://www.psawesome.com/tutorials/create-an-i-pad-inspired-bookshelf-using-photoshop) and learn how to draw a bookshelf using Photoshop, if you are not good at this.


---

TODO:

1. **[Done]** ~~does not support orientation change now, it's fixed Portrait or landscape (doesn't have a convenient method to reload the parameters which was set in the init method.)~~ 

2. **[Done]** ~~the init method need too many parameters now. I will move all of them to GSBookShelfViewDataSource protocol methods, and this will help a lot when orientation changes, but maybe there'll be too many protocol methods.~~

3. **[NEW 12.04.03]** ~~Need some animation for cell when the orientation change.~~ Go to 6.

4. **[NEW 12.05.14]** Go to a proper row when orientation change. (Always go to top currently)

5. **[NEW 12.05.18]** Maybe it's better to support left-aligend center-aligend and right-aligend.

6. **[NEW 12.08.22]** ~~Recently I realized that using autoresizingMask can make GSBookShelf much more similar to iBooks when the orientation change. But I'm facing some "strange"(for me) problems and still don't know what to do after a few days work on it.I have few experience on autoresizingMask and orientation, so it may cost me a long time to figure out how to solve these.If anybody want's to help, I'll appreciate that.~~

---

Updates:

1. **[12.08.24]** merge to master
2. **[12.08.24]** enhance orientation change support
3. **[12.08.24]** bug fix when delete one which index is bigger than the visibles
4. **[12.08.26]** orientation change with cell animation(like what iBooks do to the shelf when orientation change).
5. **[12.08.26]** demo updated

---

Demo:

(Be Patient, some gifs' size > 1M)

![image](https://github.com/ultragtx/ultragtx.github.com/blob/master/images/Move_s.gif?raw=true)
![image](https://github.com/ultragtx/ultragtx.github.com/blob/master/images/Add_s.gif?raw=true)
![image](https://github.com/ultragtx/ultragtx.github.com/blob/master/images/Delete_s.gif?raw=true)

---
Please support if you like it!

<a href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=ultragtx%40gmail%2ecom&lc=US&item_name=GSBookShelf%20Improve%20Fund&no_note=0&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHostedGuest">
<img src="https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="PayPal - The safer, easier way to pay online!" />
</a>
