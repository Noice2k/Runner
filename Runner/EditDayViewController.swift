//
//  EditDayViewController.swift
//  Runner
//
//  Created by Igor Sinyakov on 19/09/16.
//  Copyright © 2016 Igor Sinyakov. All rights reserved.
//

import UIKit

class EditDayViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    // MARK: - constants
    let  KmData  = ["0","1","2","3","4","5","6","7","8","9"]
    let trannignTypeComstant = ["Отдых","Востановление","Темповая","Интервальная","Дистанция","Произвольная"]
    
    // MARK: - controller
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateUI()
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
            UpdateUI()
        }
    }
    
    
    // MARK - PickerView Functions
    
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
            return trannignTypeComstant.count
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
            return trannignTypeComstant[row]
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
            btnTrainType.setTitle(trannignTypeComstant[row], for: UIControlState.normal )
        }
        if pickerView == pickerDistance {
            let ind1 = pickerView.selectedRow(inComponent: 0)
            let ind2 = pickerView.selectedRow(inComponent: 2)
            let ind3 = pickerView.selectedRow(inComponent: 3)
            let str = "\(ind1).\(ind2)\(ind3) Km"
            btnDistance.setTitle(str, for: .normal)
        }
        if pickerView == pickerTime {
            let ind1 = pickerView.selectedRow(inComponent: 0)
            let ind2 = pickerView.selectedRow(inComponent: 2)
            let ind3 = pickerView.selectedRow(inComponent: 4)
            let str =  "\(ind1.to2dig()):\(ind2.to2dig()):\(ind3.to2dig())"
            btnTime.setTitle(str, for: .normal)
        }
        
    }
    // MARK: - Navigation
    @IBAction func SaveTraine(_ sender: UIButton) {
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
        btnTrainType.setTitle(trannignTypeComstant[row], for: UIControlState.normal )
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



