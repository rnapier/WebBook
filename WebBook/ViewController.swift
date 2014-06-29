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
                            
  @IBOutlet var webView: UIWebView
  
  override func viewDidLoad() {
    super.viewDidLoad()
    webView.scrollView.pagingEnabled = true
    webView.scrollView.alwaysBounceHorizontal = true
    webView.scrollView.alwaysBounceVertical = false
    webView.delegate = self

    let path = NSBundle.mainBundle().pathForResource("Simple", ofType: "html")
    let htmlData = NSData(contentsOfFile:path)
    webView.loadData(htmlData, MIMEType: nil, textEncodingName: nil, baseURL: nil)

    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  func rectForElement(elementID: String) -> CGRect {
    let js = "function f(){ var r = document.getElementById('%@').getBoundingClientRect(); return '{{'+r.left+','+r.top+'},{'+r.width+','+r.height+'}}'; } f();";
    let result = webView.stringByEvaluatingJavaScriptFromString(String(format:js, elementID))
    let rect = CGRectFromString(result)
    return rect;
  }

  func webViewDidFinishLoad(webView: UIWebView!) {
    let r = rectForElement("embed1")
    let v = UIView(frame:r)
    v.backgroundColor = UIColor.redColor()
    let b = UIButton.buttonWithType(.ContactAdd) as UIButton
    b.frame = CGRectMake(50, 50, 100, 100)
    b.backgroundColor = UIColor.blueColor()
    v.addSubview(b)

    let anim = CABasicAnimation(keyPath: "transform.rotation.z")
    anim.fromValue = 0
    anim.toValue = 2 * M_PI
    anim.repeatCount = HUGE
    anim.duration = 5
    b.layer.addAnimation(anim, forKey: "rotate")


    webView.scrollView.addSubview(v)
  }
}

