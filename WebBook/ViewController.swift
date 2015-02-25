//
//  ViewController.swift
//  WebBook
//
//  Created by Rob Napier on 6/29/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, UIWebViewDelegate {
    @IBOutlet var webView: UIWebView?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView?.scrollView.pagingEnabled = true
        self.webView?.scrollView.alwaysBounceHorizontal = true
        self.webView?.scrollView.alwaysBounceVertical = false
        self.webView?.delegate = self

        if let path = NSBundle.mainBundle().pathForResource("Simple", ofType: "html") {
            let htmlData = NSData(contentsOfFile:path)
            self.webView?.loadData(htmlData, MIMEType: nil, textEncodingName: nil, baseURL: nil)
        }
    }

    func rectForElement(elementID: String) -> CGRect {
        // This and other functions could of course be put inside the HTML, 
        // which would make writing and testing them simpler. But this
        // shows how it could work even on existing HTML.
        let js = "function f(){ var r = document.getElementById('%@').getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();";
        let result = webView?.stringByEvaluatingJavaScriptFromString(String(format:js, elementID))
        let rect = CGRectFromString(result)
        return rect;
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        self.insertCustomView(webView)
    }

    // Whatever you want. This is just a silly toy that you can drag
    // a rotating box around. The point is that it's a totally arbitrary
    // view with its own gesture recognizers, buttons, etc.
    func insertCustomView(webView: UIWebView) {
        let r = rectForElement("embed1")
        let v = UIView(frame:r)
        v.backgroundColor = UIColor.redColor()
        let b = UIButton.buttonWithType(.ContactAdd) as! UIButton
        b.frame = CGRectMake(50, 50, 100, 100)
        b.backgroundColor = UIColor.blueColor()
        b.addTarget(self, action: Selector("click:"), forControlEvents: .TouchUpInside)
        v.addSubview(b)

        let l = UILabel()
        l.text = "I'm a UIView. Drag the box."
        l.sizeToFit()
        l.center = CGPointMake(CGRectGetMidX(v.bounds), CGRectGetMidY(v.bounds))
        v.addSubview(l)

        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = 0
        anim.toValue = 2 * M_PI
        anim.repeatCount = HUGE
        anim.duration = 5
        b.layer.addAnimation(anim, forKey: "rotate")

        let g = UIPanGestureRecognizer(target: self, action: Selector("drag:"))
        b.addGestureRecognizer(g)

        webView.scrollView.addSubview(v)
    }


    // Silly helper for the custom view
    func drag(g: UIPanGestureRecognizer) {
        func boundBy(x: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
            if x > max { return max }
            if x < min { return min }
            return x
        }

        let dragLocation = g.locationInView(g.view?.superview)
        let box = g.view?.superview?.bounds ?? CGRectZero
        let finalLocation = CGPointMake(
            boundBy(dragLocation.x, CGRectGetMinX(box), CGRectGetMaxX(box)),
            boundBy(dragLocation.y, CGRectGetMinY(box), CGRectGetMaxY(box)))
        g.view?.center = finalLocation
    }

    // And we can handle click events too. What more could you want?
    func click(b: UIButton) {
        if b.backgroundColor == UIColor.blueColor() {
            b.backgroundColor = UIColor.greenColor()
        } else {
            b.backgroundColor = UIColor.blueColor()
        }
    }
}

