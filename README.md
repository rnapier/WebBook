This is just a toy project to show how you can easily stick a fully-functional `UIView` into an arbitrary `UIWebView`, along 
with book-style paging. The interesting pieces are:

* The `<style>` block in Simple.html
* The "embed" `<div>` in Simple.html (line 125)
* `ViewController.swift` and particularly `rectForElement`.

If you drag the box outside its view, you may not be able to drag it back, but that would easily be preventable in a real
project.
