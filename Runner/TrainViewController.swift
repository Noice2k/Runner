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

class TrainViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var buttonStartTrain: UIButton!
    @IBOutlet weak var buttonStopTrain: UIButton!
    @IBOutlet weak var buttonPauseTrain: UIButton!
    
    @IBOutlet weak var openBoxMapView: OpenBoxMapView!
    
    @IBOutlet weak var heartStatusView: UIView!
    @IBOutlet weak var heartStatusHeigth: NSLayoutConstraint!
    
    var locationMamager = CLLocationManager()
    
    var timer = Timer()
    var totalDistance : Double = 0.0
    
    var beginTime : Date!
    var currentTrack: [CLLocationCoordinate2D] = []
    var lastLoc : CLLocation?
    var paused  : Bool = false
    
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
        buttonStopTrain.isHidden = !show
        buttonPauseTrain.isHidden = !show
        heartStatusView.isHidden = !show
    }
    
    
    @IBOutlet weak var laberTrainDuration: UILabel!
    
    // start tracking
    @IBAction func buttonStartClick(_ sender: UIButton) {
        trackingUser = true
        beginTime = Date()
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: true)
        // new current lap
        currentLap = TrainingLap()
        
        
    }
    
    @IBOutlet weak var labelTrainDistance: UILabel!
    func timerUpdate() {
        let current = Date()
        let time = current.timeIntervalSince(beginTime!)
        let timeInt = Int(time)
        
        laberTrainDuration.text = timeInt.ToTime()
    }
    
    // user click Paused
    @IBAction func buttonPauseClick(_ sender: UIButton) {
        paused = !paused
        
    }
    
    @IBAction func buttonStopClick(_ sender: UIButton) {
    
        // show alert windows 
        
        trackingUser = false
        timer.invalidate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // hide view 
        ShowUI(false)
        
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
        
    }
    // MARK: location manager routing
    
    // processing the location change
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for loc in locations {
            openBoxMapView.longitude = loc.coordinate.longitude
            openBoxMapView.latitude  = loc.coordinate.latitude
            
            // add coordinate to Tracker
            if trackingUser {
                
                if !paused {
                    if distanceForMarker <= totalDistance {
                        // increase distance
                        distanceForMarker += 1000
                        // add  annotation with point
                        let annotation = MGLPointAnnotation()
                        annotation.coordinate =  loc.coordinate
                        annotation.title = "\(Int(distanceForMarker/1000))"
                        openBoxMapView.addAnnotation(annotation)
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
            }
            else {
                lastLoc = nil
                currentTrack = []
            }
            
            // set
        }
    }
    //

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
