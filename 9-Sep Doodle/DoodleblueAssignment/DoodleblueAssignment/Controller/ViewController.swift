//
//  ViewController.swift
//  DoodleblueAssignment
//
//  Created by Pavan Kalyan Jonnadula on 09/09/20.
//  Copyright © 2020 Pavan Kalyan Jonnadula. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var dataTablaView: UITableView!
    
    var unorderstatements : [UnorderedStatements] = []
    var orderStatements : [UnorderedStatements] = []
    var positions : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataTablaView.delegate = self
        dataTablaView.dataSource = self
        readLocalFile()
    }
    @IBAction func deleteBtnAction(_ sender: UIButton) {
        let orderStatementAtTheIndex = orderStatements[sender.tag]
        orderStatements.remove(at: sender.tag)
        positions.append("\(orderStatementAtTheIndex.position ?? 0)")
        var index = 0
        unorderstatements.filter { (iterator) -> Bool in
            if iterator.position == orderStatementAtTheIndex.position ?? 0{
                var dulicateIterator = iterator
                unorderstatements.remove(at: index)
                dulicateIterator.position = nil
                unorderstatements.insert(dulicateIterator, at: index)
                return true
            }
            index = index + 1
            return false
        }
        dataTablaView.reloadData()
    }
    func readLocalFile(){
        do {
            if let bundlePath = Bundle.main.path(forResource: "PAGE1",ofType: "json"),let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                let decodedData = try JSONDecoder().decode(MainModel.self,from: jsonData)
                self.unorderstatements += decodedData.unorderedStatements
                self.dataTablaView.reloadData()
                self.fillPositonsArrayAccordingToCount()
            }
        } catch {
            print(error)
        }
    }
    
    func fillPositonsArrayAccordingToCount(){
        for index in 0..<unorderstatements.count{
            positions.append("\(index + 1)")
        }
        print("the postions are",positions)
    }
    
}
//MARK: TableView Delegates
extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return unorderstatements.count
        }
        return orderStatements.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0{
            return "Irregular Order"
        }
        return "Sequence Order"
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1{
            let sequenceCells = tableView.dequeueReusableCell(withIdentifier: "cell2") as!
            SequenceCells
            sequenceCells.staementLabel.text = "\(orderStatements[indexPath.row].position ?? 0) - \(orderStatements[indexPath.row].statement)"
            sequenceCells.deletaBtn.tag = indexPath.row
            return sequenceCells
        }
        let unorderCell = tableView.dequeueReusableCell(withIdentifier: "cells") as! UnOrderedCells
        unorderCell.statementLabel.text = unorderstatements[indexPath.row].statement
        unorderCell.postionSelecteddropDown.items = positions
        unorderCell.postionSelecteddropDown.delegate = self
        unorderCell.postionSelecteddropDown.tag = indexPath.row
        unorderCell.bgView.layer.cornerRadius = 16
        if unorderstatements[indexPath.row].position == nil{
            unorderCell.postionSelecteddropDown.title = ""
        }else{
            unorderCell.postionSelecteddropDown.title = "\(unorderstatements[indexPath.row].position ?? 0)"

        }
        return unorderCell
    }
}
//MARK: DropDown Delegate
extension ViewController : HADropDownDelegate{
    
    func didSelectItem(dropDown: HADropDown, at index: Int) {
        let dropDownIndex = dropDown.tag
        print("tgheh ",dropDownIndex)
        var dropDownStatement = unorderstatements[dropDownIndex]
        dropDownStatement.position = Int(positions[index])
        self.unorderstatements.remove(at: dropDownIndex)
        self.unorderstatements.insert(dropDownStatement, at: dropDownIndex)
        self.orderStatements.append(dropDownStatement)
        self.positions.remove(at: index)
        dataTablaView.reloadData()
    }
    
}
