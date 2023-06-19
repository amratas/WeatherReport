//
//  SearchViewController.swift
//  WeatherReport
//
//  Created by Amrata Sharma on 13/06/23.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableview: UITableView!
    weak var homeControllerDelegate: HomeViewControllerProtocol? = nil
    var filteredData: [String]!
    
    let data = ["New York", "Los Angeles", "Chicago", "Houston",
        "Philadelphia", "Phoenix", "San Diego", "San Antonio",
        "Dallas", "Detroit", "San Jose", "Indianapolis",
        "Jacksonville, FL", "San Francisco, CA", "Columbus, OH", "Austin, TX",
        "Memphis, TN", "Baltimore, MD", "Charlotte, ND", "Fort Worth, TX"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        tableview.delegate = self
        searchBar.delegate = self
        filteredData = data
    }
}

extension SearchViewController : UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath) as UITableViewCell
         cell.textLabel?.text = filteredData[indexPath.row]
         return cell
     }

     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return filteredData.count
     }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //calling delegate method t pass selected city...
        homeControllerDelegate?.didGetStateName(filteredData[indexPath.row])
        self.dismiss(animated: true)
    }

     // This method updates filteredData based on the text in the Search Box
     func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
         filteredData = searchText.isEmpty ? data : data.filter { (item: String) -> Bool in
             // If dataItem matches the searchText, return true to include it
             return item.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
         }
         
         tableview.reloadData()
     }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchBar.resignFirstResponder()
        self.dismiss(animated: true)
    }
}

protocol HomeViewControllerProtocol : AnyObject {
    func didGetStateName(_ name : String)
}
