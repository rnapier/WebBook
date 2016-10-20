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
        self.webView?.scrollView.isPagingEnabled = true
        self.webView?.scrollView.alwaysBounceHorizontal = true
        self.webView?.scrollView.alwaysBounceVertical = false
        self.webView?.delegate = self

        if let path = Bundle.main.path(forResource: "Simple", ofType: "html") {
            let url = URL(fileURLWithPath: path)
            let htmlData = try! Data(contentsOf: url)
            self.webView?.load(htmlData, mimeType: "text/html", textEncodingName: "utf-8", baseURL: url)
        }
    }

    // =====
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.insertCustomView(webView)
    }

    // Whatever you want. This is just a silly toy that you can drag
    // a rotating box around. The point is that it's a totally arbitrary
    // view with its own gesture recognizers, buttons, etc.
    func insertCustomView(_ webView: UIWebView) {
        let r = rectForElement("embed1")

        let v = UIView(frame:r)
        v.backgroundColor = UIColor.red
        let b = UIButton(type: .contactAdd)
        b.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        b.backgroundColor = UIColor.blue
        b.addTarget(self, action: #selector(ViewController.click(_:)), for: .touchUpInside)
        v.addSubview(b)

        let l = UILabel()
        l.text = "I'm a UIView. Drag the box."
        l.sizeToFit()
        l.center = CGPoint(x: v.bounds.midX, y: v.bounds.midY)
        v.addSubview(l)

        let anim = CABasicAnimation(keyPath: "transform.rotation.z")
        anim.fromValue = 0
        anim.toValue = 2 * M_PI
        anim.repeatCount = HUGE
        anim.duration = 5
        b.layer.add(anim, forKey: "rotate")

        let g = UIPanGestureRecognizer(target: self, action: #selector(ViewController.drag(_:)))
        b.addGestureRecognizer(g)

        webView.scrollView.addSubview(v)
    }

    func rectForElement(_ elementID: String) -> CGRect {
        // This and other functions could of course be put inside the HTML,
        // which would make writing and testing them simpler. But this
        // shows how it could work even on existing HTML.
        let js = "function f(){ var r = document.getElementById('%@').getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();";
        let result = webView?.stringByEvaluatingJavaScript(from: String(format:js, elementID))
        let rect = CGRectFromString(result!)
        return rect;
    }
    // =====

    // Silly helper for the custom view
    func drag(_ g: UIPanGestureRecognizer) {
        func boundBy(_ x: CGFloat, min: CGFloat, max: CGFloat) -> CGFloat {
            if x > max { return max }
            if x < min { return min }
            return x
        }

        let dragLocation = g.location(in: g.view?.superview)
        let box = g.view?.superview?.bounds ?? CGRect.zero
        let finalLocation = CGPoint(
            x: boundBy(dragLocation.x, min: box.minX, max: box.maxX),
            y: boundBy(dragLocation.y, min: box.minY, max: box.maxY))
        g.view?.center = finalLocation
    }

    // And we can handle click events too. What more could you want?
    func click(_ b: UIButton) {
        if b.backgroundColor == UIColor.blue {
            b.backgroundColor = UIColor.green
        } else {
            b.backgroundColor = UIColor.blue
        }
    }
}

