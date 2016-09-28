//
//  EditDayViewController.swift
//  Runner
//
//  Created by Igor Sinyakov on 19/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit
import Firebase

   

class EditDayViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    
    // MARK: - controller
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // PickerKm.delegate = self
       // PickerKm.dataSource = self
        // Do any additional setup after loading the view.
        timeView.isHidden = true
        pickerTime.delegate = self
        pickerTime.dataSource = self
        
        trainTypeView.isHidden = true
        pickerTrainType.delegate = self
        pickerTrainType.dataSource = self
        
        distanceView.isHidden = true
        pickerDistance.delegate = self
        pickerDistance.dataSource = self
        
        UpdateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func UpdateUI(){
        let df = DateFormatter()
        df.dateFormat = "E, dd MMMM yyyy"
        if let d = day?.dayData {
            trainDataValue?.text = df.string(from: d)
        }
        // convert the model value to the pickview value
        if let newtype = day?.training?.type.rawValue {
            pickerTrainType?.selectRow(newtype, inComponent: 0, animated: true)
            btnTrainType?.setTitle(Traning.trannignTypeConstants[newtype], for: .normal)
        }
        if let dis =  day?.training?.distance{
            pickerDistance?.selectRow(Int(dis), inComponent: 0, animated: true)
            let hundred = Int(dis*10) % 10
            pickerDistance?.selectRow(hundred, inComponent: 1, animated: true)
            let tens = Int(dis*100) % 10
            pickerDistance?.selectRow(tens, inComponent: 2, animated: true)
            btnDistance?.setTitle("\(dis.to2dig()) km", for: .normal)
       }
        if let tm = day?.training?.time{
            let hours = tm / 3600
            let min = (tm/60) % 60
            let sec = tm % 60
            pickerTime?.selectRow(hours, inComponent: 0, animated: true)
            pickerTime?.selectRow(min, inComponent: 2, animated: true)
            pickerTime?.selectRow(sec, inComponent: 4, animated: true)
            
            btnTime?.setTitle("\(hours.to2dig()):\(min.to2dig()):\(sec.to2dig())", for: .normal)
        }
        
        
       
    }
    
    // add animation for show/hide pickers
    private var oldView : UIStackView?
    private var newView : UIStackView?
    
    private var currentPickerView: UIStackView? {
        willSet{
            oldView = currentPickerView
            newView = newValue
            
            // newValue?.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.oldView?.isHidden = true
                UIView.animate(withDuration: 0.5) {
                    self.newView?.isHidden = false}
            }
        }
    }
    
    
    // MARK: - Model
    var day : CalendarDay?  {
        didSet{
            if day?.training != nil {
                current_distance = day!.training!.distance
                current_type = day!.training!.type
                current_time = day!.training!.time
            }
            UpdateUI()
        }
    }
    // Firebase
    var dayRootRef : FIRDatabaseReference? = nil
    
    var current_distance : Double = 0.0
    var current_type : TraningTypeEnum = .custom
    var current_time : Int = 0
    
    // MARK: - PickerView Functions
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
       let width = pickerView.bounds.width
        if pickerView == pickerTrainType {
            return pickerView.bounds.width
        }
        if pickerView == pickerDistance {
            switch component {
            case 0:
                return width*2/7
            case 4:
                return width*3/8
            default:
                return width/7
            }
        }
        if pickerView == pickerTime{
            switch component {
            case 1:
                return width/9
            case 3:
                return width/9
            default:
                return width*2/9
            }
        }
        
        return CGFloat(25.0)
        
    }
    
    
    // 5 rows : [km][.][hundred][ten][label]
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickerTrainType {
               return 1
        }
        if pickerView == pickerDistance{
            return 4
        }
        if pickerView == pickerTime {
            return 5
        }
        return 0
    }
    
    // return component count
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerTrainType {
            return Traning.trannignTypeConstants.count
        }
        if pickerView == pickerDistance {
            switch component {
            case 0:
                return 100
            case 1:
                return 1
            case 4:
                return 1
            default:
                return 10
            }
        }
        if pickerView == pickerTime {
            switch component {
            case 0:
                return 10
            case 1:
                return 1
            case 2:
                return 60
            case 3:
                return 1
            case 4:
                return 60
            default:
                return 1
            }
        }
        return 0
    }
    // return component rows values
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == pickerTrainType {
            return Traning.trannignTypeConstants[row]
        }
        
        if pickerView == pickerDistance {
            switch component {
            case 1:
                return "."
            case 4:
                return "Km"
            default:
                return "\(row)"
            }
        }
        if pickerView == pickerTime{
            switch component {
            case 1:
                return ":"
            case 3:
                return ":"
            case 5:
                return "HH:MM:SS"
            default:
                return "\(row.to2dig())"
            }
        }
        return "\(row)"
        
    }
   
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerTrainType {
            btnTrainType.setTitle(Traning.trannignTypeConstants[row], for: UIControlState.normal )
            current_type = TraningTypeEnum(rawValue: row)!
        }
        if pickerView == pickerDistance {
            let ind1 = pickerView.selectedRow(inComponent: 0)
            let ind2 = pickerView.selectedRow(inComponent: 2)
            let ind3 = pickerView.selectedRow(inComponent: 3)
            let str = "\(ind1).\(ind2)\(ind3) Km"
            
            current_distance = Double(ind1) + Double(ind2)/10 + Double(ind3)/100
            
            btnDistance.setTitle(str, for: .normal)
        }
        if pickerView == pickerTime {
            let ind1 = pickerView.selectedRow(inComponent: 0)
            let ind2 = pickerView.selectedRow(inComponent: 2)
            let ind3 = pickerView.selectedRow(inComponent: 4)
            let str =  "\(ind1.to2dig()):\(ind2.to2dig()):\(ind3.to2dig())"
            btnTime.setTitle(str, for: .normal)
            current_time = ind1*3600+ind2*60+ind3
        }
    }
    // MARK: - Navigation
    @IBAction func SaveTraine(_ sender: UIButton) {
        
        let userref1 = dayRootRef?.child("distance")
        userref1?.setValue( current_distance)
        
        let userref2 = dayRootRef?.child("type")
        userref2?.setValue( current_type.rawValue)
        
        let userref3 = dayRootRef?.child("time")
        userref3?.setValue( current_time)
        
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func CancelTrain(_ sender: UIButton) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    // MARK : GUI outlets
    
    // toolbar buttons
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var CancelButton: UIButton!
    // toolbar text
    @IBOutlet weak var toolbarTitleLabel: UILabel!
    
    // train date :
    @IBOutlet weak var trainDataTitle: UILabel!
    @IBOutlet weak var trainDataValue: UILabel!
    // train type:
    @IBOutlet weak var btnTrainType: UIButton!
    @IBOutlet weak var pickerTrainType: UIPickerView!
    // distance
    @IBOutlet weak var btnDistance: UIButton!
    @IBOutlet weak var pickerDistance: UIPickerView!
    // time
    @IBOutlet weak var btnTime: UIButton!
    @IBOutlet weak var pickerTime: UIPickerView!
    
    
    @IBAction func clickSetTime(_ sender: UIButton) {
        currentPickerView = timeView
    }
    @IBAction func clickSetDistance(_ sender: UIButton) {
        currentPickerView = distanceView
    }
    
    @IBAction func clickSelectTrainType(_ sender: UIButton) {
        currentPickerView = trainTypeView
        let row = pickerTrainType.selectedRow(inComponent: 0)
        btnTrainType.setTitle(Traning.trannignTypeConstants[row], for: UIControlState.normal )
    }
    
    @IBOutlet weak var trainTypeView: UIStackView!
    
    @IBOutlet weak var distanceView: UIStackView!
    
    @IBOutlet weak var timeView: UIStackView!
    /*
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension Int {
    func to2dig() -> String {
        return String(format: "%02d",self)
    }
}

extension Double {
    func to2dig() -> String {
       return String(format: "%0.2f",self)
    }
}

