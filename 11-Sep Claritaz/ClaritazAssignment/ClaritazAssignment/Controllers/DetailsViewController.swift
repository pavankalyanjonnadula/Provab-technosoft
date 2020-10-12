//
//  DetailsViewController.swift
//  ClaritazAssignment
//
//  Created by Pavan Kalyan Jonnadula on 11/09/20.
//  Copyright © 2020 Pavan Kalyan Jonnadula. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    //MARK: Outlets
    @IBOutlet weak var topNavigationOverlapView: UIView!
    @IBOutlet weak var doctorsDetailView: UIView!
    @IBOutlet weak var datesCollection: UICollectionView!
    @IBOutlet weak var doctorsImage: UIImageView!
    @IBOutlet weak var doctorName: UILabel!
    @IBOutlet weak var doctorDegree: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var bookAppointmentBtn: UIButton!
    @IBOutlet weak var selectedDateLabel: UILabel!
    @IBOutlet weak var time3Btn: UIButton!
    @IBOutlet weak var time2Btn: UIButton!
    @IBOutlet weak var time1Btn: UIButton!
    @IBOutlet weak var stackViewOfTimings: UIStackView!
    //MARK: Properties
    var doctorDetais : DoctorDetails?
    var slotTimings : [SlotTimings] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        getDoctorDetails()
    }
    
    func setUpUI(){
        topNavigationOverlapView.layer.cornerRadius = 20
        doctorsDetailView.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor.black, radius: 2.0, opacity: 0.35)
        bookAppointmentBtn.addShadow(offset: CGSize.init(width: 0, height: 0), color: UIColor.black, radius: 2.0, opacity: 0.35)
        self.datesCollection.delegate = self
        self.datesCollection.dataSource = self
        bookAppointmentBtn.layer.cornerRadius = 25
        selectedDateLabel.text = ""
    }
    
    func getDoctorDetails(){
        SKProgressView.shared.showProgressView(self.view)

        WebService.shared.getRequest(urlString: "https://run.mocky.io/v3/5814c040-2f93-42ff-a219-f0c4a68076cd") { (responseData, httpResponse, error) in
            SKProgressView.shared.hideProgressView()
            let decoder = JSONDecoder()
            do {
                let model = try decoder.decode(MainModel.self, from: responseData ?? Data())
                self.doctorDetais = model.data?.doctorDetails
                self.slotTimings = model.data?.slotTimings ?? []
                self.initializeDoctorDetails()
            }  catch {
                print("error: ", error.localizedDescription)
            }

        }
    }
    func initializeDoctorDetails(){
        let doctorFullName = "\(doctorDetais?.firstName ?? "") \(doctorDetais?.lastName ?? "")"
        let doctorDegrees = doctorDetais?.degreeDetails ?? ""
        doctorName.text = doctorFullName + "\n" + doctorDegrees
        doctorDegree.text = doctorDetais?.specialist ?? ""
        milesLabel.text = doctorDetais?.milesAway ?? ""
        self.datesCollection.reloadData()
    }
}

extension DetailsViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let timmigCell = collectionView.dequeueReusableCell(withReuseIdentifier: "time", for: indexPath) as! TimingCell
        let slot = slotTimings[indexPath.item]
        timmigCell.dateLabel.text = slot.date
        timmigCell.slotsLabel.text = "\(slot.availableSlots ?? 0) Slots Available"
        timmigCell.contentView.layer.borderWidth = 1
        timmigCell.contentView.layer.borderColor = UIColor.lightGray.cgColor
        timmigCell.contentView.layer.cornerRadius = 3
        if selectedDateLabel.text ?? "" == slot.date ?? ""{
            timmigCell.contentView.backgroundColor = UIColor.cyan.withAlphaComponent(0.5)
        }
        else{
            timmigCell.contentView.backgroundColor = UIColor.white
        }
        return timmigCell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slotTimings.count
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let slot = slotTimings[indexPath.item]
        let cell = collectionView.cellForItem(at: indexPath) as! TimingCell
        if cell.contentView.backgroundColor == UIColor.white{
            cell.contentView.backgroundColor = UIColor.cyan.withAlphaComponent(0.5)
            selectedDateLabel.text = slot.date ?? ""
            let currentContentOffSet = collectionView.contentOffset
            if #available(iOS 12.0, *) {
                UIView.animate(withDuration: 0) {
                    collectionView.reloadData()
                    collectionView.performBatchUpdates(nil, completion: { _ in
                        collectionView.contentOffset = currentContentOffSet
                    })
                }
            }

            if slot.scheduleTimings?.count ?? 0 > 0{
                timigsOfSlot(timings: slot.scheduleTimings ?? [])
            }else{
                emptyTheBtns()
            }
        }else{
            cell.contentView.backgroundColor = UIColor.white
            selectedDateLabel.text = ""
            emptyTheBtns()
        }
    }
    
    func timigsOfSlot(timings : [ScheduleTimings]){
        if timings.count == 3{
            time1Btn.setTitle(timings[0].time ?? "", for: .normal)
            time2Btn.setTitle(timings[1].time ?? "", for: .normal)
            time3Btn.setTitle(timings[2].time ?? "", for: .normal)
        }else if timings.count == 2{
            time1Btn.setTitle(timings[0].time ?? "", for: .normal)
            time2Btn.setTitle(timings[1].time ?? "", for: .normal)
            time3Btn.setTitle("", for: .normal)
        }else{
            time1Btn.setTitle(timings[0].time ?? "", for: .normal)
            time2Btn.setTitle("", for: .normal)
            time3Btn.setTitle("", for: .normal)
        }

    }
    
    func emptyTheBtns(){
        time1Btn.setTitle("", for: .normal)
        time2Btn.setTitle("", for: .normal)
        time3Btn.setTitle("", for: .normal)
    }
    
}


class TimingCell: UICollectionViewCell {
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var slotsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
