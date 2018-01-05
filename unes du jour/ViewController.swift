//
//  ViewController.swift
//  unes du jour
//
//  Created by BOURGEOIS Mathieu on 27/12/2017.
//  Copyright © 2017 BOURGEOIS Mathieu. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var slideshow: ImageSlideshow!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let todayString: String = getTodayString()
        let todayUrls: Array<String> = [
            "http://img.kiosko.net/\(todayString)/fr/liberation.750.jpg",
            "http://img.kiosko.net/\(todayString)/fr/lemonde.750.jpg",
            "http://img.kiosko.net/\(todayString)/fr/lefigaro.750.jpg",
            "http://img.kiosko.net/\(todayString)/fr/parisien.750.jpg",
            "http://img.kiosko.net/\(todayString)/fr/l_equip.750.jpg"
        ]
        
        let yesterdayString: String = getYesterdayString()
        let yesterdayUrls: Array<String> = [
            "http://img.kiosko.net/\(yesterdayString)/fr/liberation.750.jpg",
            "http://img.kiosko.net/\(yesterdayString)/fr/lemonde.750.jpg",
            "http://img.kiosko.net/\(yesterdayString)/fr/lefigaro.750.jpg",
            "http://img.kiosko.net/\(yesterdayString)/fr/parisien.750.jpg",
            "http://img.kiosko.net/\(yesterdayString)/fr/l_equip.750.jpg"
        ]
        
        var usedUrls: Array<String> = todayUrls

        let dg = DispatchGroup()
        
        var urlsToRemove: Set<String> = []
        
        for (index, todayUrl) in todayUrls.enumerated() {
            dg.enter()
            
            Alamofire.request(todayUrl).response { ddr in
                if ddr.response!.statusCode >= 400 {
                    Alamofire.request(yesterdayUrls[index]).response { ddr2 in
                        if ddr2.response!.statusCode >= 400 {
                            urlsToRemove.insert(todayUrl)
                        } else {
                            usedUrls[index] = yesterdayUrls[index]
                        }
                        dg.leave()
                    }
                } else {
                    dg.leave()
                }
            }
        }
        
        dg.notify(queue: .main) {
            if !urlsToRemove.isEmpty {
                usedUrls = usedUrls.filter{!urlsToRemove.contains($0)}
            }
            
            var alamofireSource = [InputSource]()
            for url in usedUrls {
                alamofireSource.append(AlamofireSource(urlString: url)!)
                print("used:"+url)
            }
            
            self.slideshow.backgroundColor = UIColor.black
            self.slideshow.slideshowInterval = 0.0
            self.slideshow.pageControlPosition = PageControlPosition.underScrollView
            self.slideshow.pageControl.currentPageIndicatorTintColor = UIColor.white
            self.slideshow.pageControl.pageIndicatorTintColor = UIColor.darkGray
            self.slideshow.contentScaleMode = UIViewContentMode.scaleAspectFit
            self.slideshow.zoomEnabled = true
            
            // optional way to show activity indicator during image load (skipping the line will show no activity indicator)
            self.slideshow.activityIndicator = DefaultActivityIndicator()
            self.slideshow.currentPageChanged = { page in
                print("current page:", page)
            }
            
            // can be used with other sample sources as `afNetworkingSource`, `alamofireSource` or `sdWebImageSource` or `kingfisherSource`
            self.slideshow.setImageInputs(alamofireSource)
            
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.didTap))
            self.slideshow.addGestureRecognizer(recognizer)
        }
    }
    
    @objc func didTap() {
        let fullScreenController = slideshow.presentFullScreenController(from: self)
        // set the activity indicator for full screen controller (skipping the line will show no activity indicator)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    func getTodayString() -> String {
        return getDateString(date: Date())
    }
    
    func getYesterdayString() -> String {
        let now = Date()
        let date = Calendar.current.date(byAdding: .day, value: -1, to: now)!
        return getDateString(date: date)
    }
    
    func getDateString(date: Date) -> String {
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let monthInt: Int = calendar.component(.month, from: date)
        let dayInt: Int = calendar.component(.day, from: date)
        let month: String = monthInt < 10 ? "0\(monthInt)" : String(monthInt)
        let day: String = dayInt < 10 ? "0\(dayInt)" : String(dayInt)
        return "\(year)/\(month)/\(day)"
    }
}

