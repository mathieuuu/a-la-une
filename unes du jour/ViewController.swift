//
//  ViewController.swift
//  unes du jour
//
//  Created by BOURGEOIS Mathieu on 27/12/2017.
//  Copyright © 2017 BOURGEOIS Mathieu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var slideshow: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var urls = [String]()
        urls.append("http://www.revue2presse.fr/newspaper/lemonde/lemonde-cover.jpg")
        urls.append("http://www.revue2presse.fr/newspaper/lefigaro/lefigaro-cover.jpg")
        urls.append("http://www.revue2presse.fr/newspaper/liberation/liberation-cover.jpg")
        urls.append("http://www.revue2presse.fr/newspaper/lequipe/lequipe-cover.jpg")
        urls.append("http://www.revue2presse.fr/newspaper/leparisien/leparisien-cover.jpg")
        
        var alamofireSource = [InputSource]()
        for url in urls {
            alamofireSource.append(AlamofireSource(urlString: url)!)
        }
        
        slideshow.backgroundColor = UIColor.black
        slideshow.slideshowInterval = 0.0
        slideshow.pageControlPosition = PageControlPosition.underScrollView
        slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
        slideshow.pageControl.pageIndicatorTintColor = UIColor.darkGray
        slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
        
        // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
        slideshow.activityIndicator = DefaultActivityIndicator()
        slideshow.currentPageChanged = { page in
            print("current page:", page)
        }
        
        // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
        slideshow.setImageInputs(alamofireSource)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
        slideshow.addGestureRecognizer(recognizer)
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
}

