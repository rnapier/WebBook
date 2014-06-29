//
//  ViewController.swift
//  WebBook
//
//  Created by Rob Napier on 6/29/14.
//  Copyright (c) 2014 Rob Napier. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
                            
  @IBOutlet var webView: UIWebView
  
  override func viewDidLoad() {
    super.viewDidLoad()
    webView.scrollView.pagingEnabled = true
    webView.scrollView.alwaysBounceHorizontal = true
    webView.scrollView.alwaysBounceVertical = false
    

    let path = NSBundle.mainBundle().pathForResource("Simple", ofType: "html")
    let htmlData = NSData(contentsOfFile:path)
    webView.loadData(htmlData, MIMEType: nil, textEncodingName: nil, baseURL: nil)

    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


}

