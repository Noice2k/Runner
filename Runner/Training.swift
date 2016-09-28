//
//  Training.swift
//  Runner
//
//  Created by Igor Sinyakov on 22/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import Foundation
import Firebase

enum TraningTypeEnum: Int {
    case rest = 0, recover, pace, interval, distance, custom
}

open class Traning
{
    // MARK: - constants
    static let trannignTypeConstants = ["Отдых","Востановление","Темповая","Интервальная","Дистанция","Произвольная"]
    
    static func getTimePerKmSped(time: Int, dis : Double) -> String {
        let timed = Double(time)
        let speed = timed / dis
        let min = Int(speed/60)
        let sec = Int(speed) % 60
        return "\(min.to2dig()):\(sec.to2dig())"
    }
    
    init(dictFromFB : [String:AnyObject]?)
    {
        // initial values
        self.distance = 0
        self.time = 0
        self.type = .custom
        //  if dictionary not null - try get data
        if dictFromFB != nil {
            if let protoTime = dictFromFB!["time"] as? Int {
                self.time = protoTime
            }
            if let protoType = dictFromFB!["type"] as? Int {
                self.type = TraningTypeEnum(rawValue: protoType)!
            }
            if let protoDistance = dictFromFB!["distance"] as? Double {
                self.distance = protoDistance
            }
        }
    }
    
    // save data to the DB
    func saveToDB(fbref : FIRDatabaseReference) {
        let prototime = fbref.child("time")
        prototime.setValue(time)
      
        let prototype = fbref.child("type")
        prototype.setValue(type)
      
        let protodistance = fbref.child("distance")
        protodistance.setValue(time)
    }
    
    // the type of the current train
    var type : TraningTypeEnum
    // the distance of the train
    var distance : Double
    // the time of running this distance
    var time : Int
    
}
