//
//  GrayActivityIndicator.swift
//  Runner
//
//  Created by Igor Sinyakov on 26/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit

class GrayActivityIndicator: UIView
{
    
    var indicator : UIActivityIndicatorView?
    
    // show
    func Show(){
        
        frame = super.frame
        center = super.center
        alpha = 0.8
        backgroundColor = UIColor.black
        
        indicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        indicator!.center = center
        addSubview(indicator!)
        indicator?.startAnimating()
        
       super.bringSubview(toFront: self)
        
    }
    
    func Hide(){
        indicator?.stopAnimating()
        indicator = nil
        self.removeFromSuperview()
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
