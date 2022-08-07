//
//  AddViewController.swift
//  alaermTable
//
//  Created by maya on 2022/07/24.
//

import UIKit

class AddViewController: UIViewController {
    
    //クロージャを保持するためのプロパティ
    var childCallBack: (() -> Void)?
    
    let userDefault: UserDefaults = UserDefaults.standard
    
    var timeArray = [String]()
    var memoArray = [String]()
    
    var tempTime: String = "00:00"
    
    @IBOutlet var myDPvar: UIDatePicker!
    @IBOutlet var memoTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userDefault.object(forKey: "time") != nil  && userDefault.object(forKey: "memo") != nil{
            
        timeArray = userDefault.object(forKey: "time") as! [String]
        memoArray = userDefault.object(forKey: "memo") as! [String]
        }
        
        // DatePickerのstyleをホイールにする
        myDPvar.preferredDatePickerStyle = .wheels
    }
    
    @IBAction func myDPfunc(){
        // DPの値を成形
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        // 一時的にDPの値を保持
        tempTime = format.string(from: myDPvar.date)
        
        print(tempTime)
    }
    
    @IBAction func saveTime() {
        timeArray.append(tempTime)
        memoArray.append(memoTextField.text ?? "")
        
        userDefault.set(timeArray, forKey: "time")
        userDefault.set(memoArray, forKey: "memo")
        
        //転移先に戻る
        dismiss(animated: true, completion: nil)
        self.childCallBack?()
    }
    
    
    


}
