//
//  ViewController.swift
//  alaermTable
//
//  Created by maya on 2022/07/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    let userDefault: UserDefaults = UserDefaults.standard
    
    @IBOutlet var table: UITableView!
    
    var timeArray = [String]()
    var memoArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadData()
        print(timeArray)
        print(memoArray)
    }
    
    func loadData() {
        if userDefault.object(forKey: "time") != nil  && userDefault.object(forKey: "memo") != nil{
            timeArray = userDefault.object(forKey: "time") as! [String]
            memoArray = userDefault.object(forKey: "memo") as! [String]

        } else {
            timeArray.append("時間")
            memoArray.append("メモ")
        }
        table.reloadData()
    }
    
    @IBAction func addButton() {
        let childVC = self.storyboard?.instantiateViewController(identifier: "addView") as! AddViewController
        
        childVC.childCallBack = { self.loadData() }
        present(childVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! customCell
        cell.delegate = self //必要
        
        //セルにメモを表示させる
        cell.memoLabel?.text = memoArray[indexPath.row]
        //セルに時間を表示させる
        cell.timeLabel?.text = timeArray[indexPath.row]
        
        return cell
    }
    
    
}


class customCell:UITableViewCell {
    var indexPath = IndexPath()
    var onoff:Bool = true
    var tempTime: String!
    var setTime: String = "00:00"
    var timer: Timer?
    var delegate: UIViewController?
    var alart: UIAlertController!
    
    @IBOutlet var onoffbutton: UIButton!
    @IBOutlet weak var memoLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBAction func onoffbuttonaction(){
        if onoff == true{
            onoffbutton.setTitle("OFF", for: .normal)
            onoff = false
            myButtonfunc()
        }else{
            onoff = true
            onoffbutton.setTitle("ON", for: .normal)
            //タイマーを止める
            timer?.invalidate()
            //タイマーにnil代入
            timer = nil
            
        }
        
    }
    
    func myButtonfunc() {
        // アラームをセット
        setTime = timeLabel.text ?? "10:00"
        // 表示
        timeLabel.text = setTime
        update()
    }
    
    @objc func getNowTime()-> String {
        // 現在時刻を取得
        let nowTime: NSDate = NSDate()
        // 成形する
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        let nowTimeStr = format.string(from: nowTime as Date)
        print(nowTimeStr)
        // アラーム鳴らすか判断
        myAlarm(str: nowTimeStr)
        // 成形した時刻を文字列として返す
        return nowTimeStr
    }
    
    @objc func update() {
        if timer == nil && onoff == false{
            timer = Timer.scheduledTimer(timeInterval: 1, target: self,selector: #selector(getNowTime), userInfo: nil, repeats: true)
        }
        // 現在時刻を取得
        //let str = getNowTime()
        
    }
    
    func myAlarm(str: String) {
        // 現在時刻が設定時刻と一緒なら
        if str == setTime && onoff == false{
            alert()
        }
    }
    // アラートの表示
    func alert() {
        let myAlert = UIAlertController(title: "アラーム", message: "", preferredStyle: .alert)
        let myAction = UIAlertAction(title: "OK", style: .default) {
            action in print("foo!!")
        }
        myAlert.addAction(myAction)
        onoff = true
        onoffbutton.setTitle("ON", for: .normal)
        //タイマーを止める
        timer?.invalidate()
        //タイマーにnil代入
        timer = nil
        delegate!.present(myAlert, animated: true, completion: nil)
        
    }
}

