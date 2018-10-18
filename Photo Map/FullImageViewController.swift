//
//  FullImageViewController.swift
//  Photo Map
//
//  Created by Luis Mendez on 10/16/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit

class FullImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    var imageToUse: UIImage! = nil
    @IBOutlet weak var fullImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
  
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 16.0
        
        scrollView.contentSize = fullImageView!.bounds.size
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //scrollView.contentLayoutGuide.trailingAnchor.constraint(equalTo: fullImageView.trailingAnchor).isActive = true
        
        fullImageView.image = imageToUse
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /************************
     * SCROLLING FUNCTIONS *
     ************************/
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullImageView
    }

}
