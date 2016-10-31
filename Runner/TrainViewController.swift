//
//  TrainViewController.swift
//  Runner
//
//  Created by Igor Sinyakov on 30/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit
import CoreLocation
import Mapbox
import AVFoundation

class TrainViewController: UIViewController, CLLocationManagerDelegate, MGLMapViewDelegate {

    // MARK : Outlest
    @IBOutlet weak var buttonStartTrain: UIButton!
    
    @IBOutlet weak var openBoxMapView: OpenBoxMapView!
    
    @IBOutlet weak var labelClimb: UILabel!
    @IBOutlet weak var labelHeartRate: UILabel!
    @IBOutlet weak var labelTrainTime: UILabel!
    @IBOutlet weak var labelTrainDistance: UILabel!
    
    @IBOutlet weak var heartStatusView: UIView!
    @IBOutlet weak var heartStatusHeigth: NSLayoutConstraint!
    
    var locationMamager = CLLocationManager()
    
    var timer = Timer()
   
    var totalDistance : Double = 0.0
    
    var totalTime : Int = 0
    var beginTime : Date!
    
    var currentTrack: [CLLocationCoordinate2D] = []
    var lastLoc : CLLocation?
   
    var distanceForMarker : Double = 0
    
    // the current lap
    var currentLap : TrainingLap?
    
    var trackingUser : Bool = false {
        willSet {
            if  newValue != self.trackingUser {
                if let frame = tabBarController?.tabBar.frame {
                    heartStatusHeigth.constant = frame.height
                  //  heartStatusView.isHidden = newValue
                    //heartStatusView.layoutIfNeeded()
                }
                tabBarController!.setTabBarVisible(visible: !newValue, duration: 0.25, animated: true,view: heartStatusView)
                ShowUI(newValue)
            }
        }
    }
    
    
    func ShowUI(_ show: Bool)
    {
        buttonStartTrain.isHidden = show
        heartStatusView.isHidden = !show
    }
    
    
    
    
    // start tracking
    @IBAction func buttonStartClick(_ sender: UIButton) {
        if trackingUser == false {
            // start tracking
            trackingUser = true
            beginTime = Date()
            timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
            // new current lap
            currentLap = TrainingLap()
            
            let speech = AVSpeechSynthesizer()
            let text = "дистанция 5 after 34 minutes 20 seconds"
            let utterance = AVSpeechUtterance(string: text)
            utterance.voice = AVSpeechSynthesisVoice(language: "ru-RU")
            utterance.rate = 0.3
            speech.speak(utterance)
            
        } else {
            // stop tracking
            trackingUser = false
            let alert = UIAlertController(title: "конец", message: "cjjmotybtui", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "pfrjyxbnm", style: UIAlertActionStyle.default, handler: nil))
            present(alert, animated: false) {
                
            }
            timer.invalidate()
        }
        
    }
    
    func timerUpdate() {
        let current = Date()
        let time = current.timeIntervalSince(beginTime!)
        let timeInt = Int(time)
        
        labelTrainTime.text = timeInt.ToTime()
    }
    
    
    @IBAction func buttonStopClick(_ sender: UIButton) {
    
        // show alert windows 
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide view 
        ShowUI(false)
        // setup location manager
        self.locationMamager.requestAlwaysAuthorization()
        self.locationMamager.requestWhenInUseAuthorization()
        
        openBoxMapView.showsUserLocation = true
        if CLLocationManager.locationServicesEnabled(){
            locationMamager.delegate = self
            locationMamager.desiredAccuracy = kCLLocationAccuracyBest
            locationMamager.startUpdatingLocation()
        }
        // Do any additional setup after loading the view.
        openBoxMapView.setCenter(CLLocationCoordinate2D(latitude: 45.5076, longitude: -122.6736), animated: false)
        openBoxMapView.setZoomLevel(14, animated: false)
        openBoxMapView.delegate = self
        
    }
    // MARK: location manager routing
    
    // processing the location change
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for loc in locations {
            openBoxMapView.longitude = loc.coordinate.longitude
            openBoxMapView.latitude  = loc.coordinate.latitude
            
            // add coordinate to Tracker
            if trackingUser {
                if distanceForMarker <= totalDistance {
                    // add  annotation with point
                    let annotation = MGLPointAnnotation()
                    annotation.coordinate =  loc.coordinate
                    annotation.title = "\(Int(distanceForMarker/1000))"
                    openBoxMapView.addAnnotation(annotation)
                    // increase distance
                    distanceForMarker += 1000
                    
                }
                currentLap?.points += [loc]
                currentTrack += [CLLocationCoordinate2DMake( loc.coordinate.latitude, loc.coordinate.longitude)]
                if lastLoc != nil {
                    let dist = loc.distance(from: lastLoc!)
                    totalDistance += dist
                    labelTrainDistance.text = totalDistance.to2dig()
                    print(dist)
                    print("location : \(loc.coordinate.longitude)-\(loc.coordinate.latitude)")
                }
                // update
                let line = MGLPolyline(coordinates: &currentTrack, count: UInt(currentTrack.count))
                line.title = currentLap?.name
                openBoxMapView.addAnnotation(line)}
                lastLoc = loc
            
            
            // set
        }
    }
    //

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // get image for annotation
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        let title = annotation.title!
        let id = "Pin\(title!)"
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: id)
        //if annotationImage == nil {
            // Leaning Tower of Pisa by Stefan Spieler from the Noun Project.
            var image = UIImage(named: "Pin")!
            image = textToImage(drawText: title!, inImage: image, atPoint: CGPoint(x: 31,y: 0))
            
            // Initialize the ‘pisa’ annotation image with the UIImage we just loaded.
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: id)
      //  }
        return annotationImage
    }
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Utilites
    
    // add text label to image
    func textToImage(drawText: String, inImage: UIImage, atPoint: CGPoint) -> UIImage{
        
        // Setup the font specific variables
        let textColor = UIColor.black
        let textFont = UIFont.systemFont(ofSize: 12.0)
        let textStyle = NSMutableParagraphStyle()
        //let fontHeigth = textFont.pointSize
        textStyle.alignment = .center
        
        // Setup the image context using the passed image
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(inImage.size, false, scale)
        
        // Setup the font attributes that will be later used to dictate how the text should be drawn
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName : textStyle
        ]
        
        // Put the image into a rectangle as large as the original image
        inImage.draw(in: CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height))
        
        // Create a point within the space that is as bit as the image
        //    let rect = CGRect(x: 0, y: 0, width: inImage.size.width, height: inImage.size.height)
        let rect = CGRect(x: 0, y: 2, width: inImage.size.width, height: inImage.size.height)
        
        // Draw the text into an image
        drawText.draw(in: rect, withAttributes:  textFontAttributes)
        
        // Create a new image out of the images we have created
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        // End the context now that we have the image we need
        UIGraphicsEndImageContext()
        
        //Pass the image back up to the caller
        return newImage!
    }

}


extension UITabBarController {
    func setTabBarVisible(visible:Bool, duration: TimeInterval, animated:Bool, view : UIView) {
       // if (tabBarIsVisible() == visible) { return }
        let frame = self.tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)
        
        // animation
        UIView.animate(withDuration: duration) {
            self.tabBar.frame = frame.offsetBy(dx: 0, dy: offsetY)
            let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + offsetY)
           // self.tabBar.isHidden = !visible
            view.isHidden = visible
            self.view.frame = rect
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
            
        }
    }
}
