//
//  ViewController.swift
//  MarketSimplifiedAssignment
//
//  Created by Pavan Kalyan Jonnadula on 15/09/20.
//  Copyright © 2020 Pavan Kalyan Jonnadula. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var contactTableView: UITableView!
    
    var allContacts : [Contacts] = []
    var duplicateAllContacts : [Contacts] = []
    let search = UISearchController(searchResultsController: nil)
    var cache : NSCache<AnyObject, AnyObject>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contactTableView.delegate = self
        contactTableView.dataSource = self
        getAllContacts()
        addSearch()
        self.cache = NSCache()
    }
    
    func addSearch(){
        search.searchResultsUpdater = self
        search.searchBar.placeholder = "Search"
        search.searchBar.backgroundColor = UIColor.clear
        search.obscuresBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        self.contactTableView.tableHeaderView = search.searchBar
    }
    //MARK: API Call
    func getAllContacts(){
        let url = "https://5e53a76a31b9970014cf7c8c.mockapi.io/msf/getContacts"
        SKProgressView.shared.showProgressView(self.view)
        WebService().getRequest(urlString: url) { (data, response, error) in
            SKProgressView.shared.hideProgressView()
            let decoder = JSONDecoder()
            do{
                self.allContacts = try decoder.decode([Contacts].self, from: data ?? Data())
                self.duplicateAllContacts = self.allContacts
                self.contactTableView.reloadData()
            }  catch {
                print("error: ", error.localizedDescription)
            }
        }
    }
}
//MARK: TableView Delegate
extension ViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContactCell
        var contactDetails = allContacts[indexPath.row]
        cell.contactName.text = contactDetails.name
        cell.contactNumber.text = contactDetails.Contacts
        cell.contactImage.image = UIImage(named: "Place-holder-Image")
        if (self.cache.object(forKey: indexPath.row as AnyObject) != nil){
            cell.contactImage.image = self.cache.object(forKey: indexPath.row as AnyObject) as? UIImage
        }else if contactDetails.downloadingImage == nil{
            downloadImageFrom(link: contactDetails.url, contentMode: .scaleToFill, imageView: cell.contactImage, index: indexPath)
            contactDetails.downloadingImage = true
        }
        return cell
        
    }
    
    func downloadImageFrom(link:String, contentMode: UIView.ContentMode, imageView : UIImageView , index : IndexPath) {
        guard let linkURL = URL(string: link) else {
            imageView.image = UIImage(named: "placeholder")
            return
        }
        URLSession.shared.dataTask(with: linkURL) {(data, response, error) -> Void in
            DispatchQueue.main.async {
                imageView.contentMode =  contentMode
                if let imgdata = data {
                    if self.contactTableView.cellForRow(at: index) != nil {
                        imageView.image = UIImage(data: imgdata)
                        self.cache.setObject(UIImage(data: imgdata)!, forKey: index.row as AnyObject)
                    }
                }else{
                    imageView.image = UIImage(named: "placeholder")
                }
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allContacts.count
    }
}


//MARK: Searching for contacts
extension ViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            filterContactsAccordingToSearchText(text: text)
        }else{
            self.allContacts = duplicateAllContacts
            self.contactTableView.reloadData()
        }
    }
    func filterContactsAccordingToSearchText(text : String){
        let filterContacs = duplicateAllContacts.filter { (iteratorContact) -> Bool in
            if iteratorContact.name.lowercased().contains(text.lowercased()){
                return true
            }
            return false
        }
        self.allContacts = filterContacs
        self.contactTableView.reloadData()
    }
}
