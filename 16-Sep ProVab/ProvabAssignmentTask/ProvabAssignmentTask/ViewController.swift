//
//  ViewController.swift
//  ProvabAssignmentTask
//
//  Created by Pavan Kalyan Jonnadula on 16/09/20.
//  Copyright © 2020 Pavan Kalyan Jonnadula. All rights reserved.
//
enum CellTypes : String{
      case CheckBox = "Check"
      case Radio = "Radio"
      case TextBox = "Text"
  }
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var questionsTableView: UITableView!
    var dataStore : [DataStore] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataStore.append(DataStore(typeOfCell: .CheckBox, answers: []))
        dataStore.append(DataStore(typeOfCell: .Radio, answers: []))
        dataStore.append(DataStore(typeOfCell: .TextBox, answers: []))
        questionsTableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        let decoded  = UserDefaults.standard.object(forKey: "provab") as? Data
        do{
            let decodedData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(decoded ?? Data()) as? [NSDictionary] ?? []
            if decodedData.count > 0{
                dataStore.removeAll()
                for element in decodedData{
                    let stringCellType = element.object(forKey: "cellType") as? String ?? ""
                    dataStore.append(DataStore(typeOfCell: CellTypes.init(rawValue: stringCellType) ?? CellTypes.CheckBox, answers: element.object(forKey: "answers") as? [Any] ?? []))
                }
            }
            self.questionsTableView.reloadData()
        }catch{
            print(error.localizedDescription)
        }
    }
    //MARK: KeyBoard Controls
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            self.questionsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight-50, right: 0)
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.2, animations: {
            // For some reason adding inset in keyboardWillShow is animated by itself but removing is not, that's why we have to use animateWithDuration here
            self.questionsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        })
    }
    //MARK: IBActions
    @IBAction func saveChanges(_ sender: Any) {
        var dict = [NSDictionary]()
        for element in dataStore{
            dict.append(["answers" : element.answers ?? [] , "cellType" : element.typeOfCell?.rawValue ?? ""])
        }
        do{
            let encodedData = try NSKeyedArchiver.archivedData(withRootObject: dict, requiringSecureCoding: false)
            let userDefaults = UserDefaults.standard
            userDefaults.set(encodedData, forKey: "provab")
            // create the alert
            let alert = UIAlertController(title: "Sucess", message: "Details saved sucessfully", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func addBtnAction(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Please Select an Option", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Add check box cell", style: .default , handler:{ (UIAlertAction)in
            self.dataStore.append(DataStore(typeOfCell: .CheckBox, answers: []))
            self.questionsTableView.reloadData()
            self.questionsTableView.scrollToRow(at: IndexPath(row: self.dataStore.count - 1, section: 0), at: .bottom, animated: false)

        }))
        alert.addAction(UIAlertAction(title: "Add radio cell", style: .default , handler:{ (UIAlertAction)in
            self.dataStore += [DataStore(typeOfCell: CellTypes.Radio, answers: [])]
            self.questionsTableView.reloadData()
            self.questionsTableView.scrollToRow(at: IndexPath(row: self.dataStore.count - 1, section: 0), at: .bottom, animated: false)

        }))
        alert.addAction(UIAlertAction(title: "Add text cell", style: .default , handler:{ (UIAlertAction)in
            self.dataStore.append(DataStore(typeOfCell: .TextBox, answers: []))
            self.questionsTableView.reloadData()
            self.questionsTableView.scrollToRow(at: IndexPath(row: self.dataStore.count - 1, section: 0), at: .bottom, animated: false)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion : nil)
    }
    @IBAction func radioBtnActions(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview?.superview as? RadioCell else{
            return
        }
        let indexPath = questionsTableView.indexPath(for: cell)
        if sender.currentImage == UIImage(systemName: "circle"){
            sender.setImage(UIImage(systemName: "stop.circle"), for: .normal)
            let dataAtIndex = dataStore[indexPath?.row ?? 0]
            dataAtIndex.answers = [sender.tag]
            dataStore.remove(at: indexPath?.row ?? 0)
            dataStore.insert(dataAtIndex, at: indexPath?.row ?? 0)
        }else{
            sender.setImage(UIImage(systemName: "circle"), for: .normal)
            let dataAtIndex = dataStore[indexPath?.row ?? 0]
            dataAtIndex.answers?.removeAll()
            dataStore.remove(at: indexPath?.row ?? 0)
            dataStore.insert(dataAtIndex, at: indexPath?.row ?? 0)
        }
        if sender.tag == 20{
            cell.radioBtn2.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.radioBtn3.setImage(UIImage(systemName: "circle"), for: .normal)
        }else if sender.tag == 21{
            cell.radioBtn1.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.radioBtn3.setImage(UIImage(systemName: "circle"), for: .normal)
        }else if sender.tag == 22{
            cell.radioBtn1.setImage(UIImage(systemName: "circle"), for: .normal)
            cell.radioBtn2.setImage(UIImage(systemName: "circle"), for: .normal)

        }
    }
    
    @IBAction func checkBtnActions(_ sender: UIButton) {
        guard let cell = sender.superview?.superview?.superview?.superview as? CheckBoxCell else{
            return
        }
        let indexPath = questionsTableView.indexPath(for: cell)
        if sender.currentImage == UIImage(systemName: "square"){
            sender.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            let dataAtIndex = dataStore[indexPath?.row ?? 0]
            dataAtIndex.answers?.append(sender.tag)
            dataStore.remove(at: indexPath?.row ?? 0)
            dataStore.insert(dataAtIndex, at: indexPath?.row ?? 0)
        }else{
            sender.setImage(UIImage(systemName: "square"), for: .normal)
            let dataAtIndex = dataStore[indexPath?.row ?? 0]
            var perviousAnswers = dataAtIndex.answers as? [Int] ?? []
            for index in 0..<perviousAnswers.count{
                if perviousAnswers[index] == sender.tag{
                    perviousAnswers.remove(at: index)
                    break
                }
                
            }
            dataAtIndex.answers = perviousAnswers
            
            dataStore.remove(at: indexPath?.row ?? 0)
            dataStore.insert(dataAtIndex, at: indexPath?.row ?? 0)

        }
    }
}

//MARK: TableView Delegates
extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataAtIndex = dataStore[indexPath.row]
        
        if dataAtIndex.typeOfCell == CellTypes.CheckBox{
            let checkCell = tableView.dequeueReusableCell(withIdentifier: "checkcell") as! CheckBoxCell
            checkCell.questionNumber.text = "Q\(indexPath.row + 1)"
            let answers = dataAtIndex.answers as? [Int] ?? []
            checkCell.checkBtn1.setImage(UIImage(systemName: "square"), for: .normal)
            checkCell.checkBtn2.setImage(UIImage(systemName: "square"), for: .normal)
            checkCell.checkBtn3.setImage(UIImage(systemName: "square"), for: .normal)
            if answers.count > 0{
                if answers.contains(10){
                    checkCell.checkBtn1.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                }
                if answers.contains(11){
                    checkCell.checkBtn2.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                }
                if answers.contains(12){
                    checkCell.checkBtn3.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
                }
            }
            return checkCell
        }else if dataAtIndex.typeOfCell == CellTypes.Radio{
            let radioCell = tableView.dequeueReusableCell(withIdentifier: "radiocell") as! RadioCell
            radioCell.questionNumber.text = "Q\(indexPath.row + 1)"
            let answers = dataAtIndex.answers as? [Int] ?? []
            if answers.count > 0{
                let index = answers.first
                if index == 20{
                    radioCell.radioBtn1.setImage(UIImage(systemName: "stop.circle"), for: .normal)
                    radioCell.radioBtn2.setImage(UIImage(systemName: "circle"), for: .normal)
                    radioCell.radioBtn3.setImage(UIImage(systemName: "circle"), for: .normal)
                }else if index == 21{
                    radioCell.radioBtn1.setImage(UIImage(systemName: "circle"), for: .normal)
                    radioCell.radioBtn2.setImage(UIImage(systemName: "stop.circle"), for: .normal)
                    radioCell.radioBtn3.setImage(UIImage(systemName: "circle"), for: .normal)
                }else{
                    radioCell.radioBtn1.setImage(UIImage(systemName: "circle"), for: .normal)
                    radioCell.radioBtn2.setImage(UIImage(systemName: "circle"), for: .normal)
                    radioCell.radioBtn3.setImage(UIImage(systemName: "stop.circle"), for: .normal)
                }
            }else{
                radioCell.radioBtn1.setImage(UIImage(systemName: "circle"), for: .normal)
                radioCell.radioBtn2.setImage(UIImage(systemName: "circle"), for: .normal)
                radioCell.radioBtn3.setImage(UIImage(systemName: "circle"), for: .normal)
            }
            return radioCell
        }else {
            let textCell = tableView.dequeueReusableCell(withIdentifier: "textcell") as! TextCell
            textCell.answerTF.delegate = self
            textCell.questionNumber.text = "Q\(indexPath.row + 1)"
            textCell.answerTF.tag = indexPath.row
            let answers = dataAtIndex.answers as? [String] ?? []
            if answers.count > 0{
                let textString = answers.first ?? ""
                textCell.answerTF.text = textString
            }else{
                textCell.answerTF.text = ""
            }
            return textCell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataStore.count
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
          return true
      }
    

    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let removeAction = UITableViewRowAction(style: .destructive, title: "Delete") { (_, _) in
            self.dataStore.remove(at: indexPath.row)
            self.questionsTableView.reloadData()
        }
        return [removeAction]
    }
    
}
//MARK: TextFiled Delegates
extension ViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.isEmpty == false{
            let dataIndex = dataStore[textField.tag]
            dataIndex.answers = [textField.text]
            dataStore.remove(at: textField.tag)
            dataStore.insert(dataIndex, at: textField.tag)
        }
        textField.resignFirstResponder()
        return true
    }
}

