//
//  DetailViewController.swift
//  CountryBorders
//
//  Created by Yossi Michaeli on 06/09/2017.
//  Copyright © 2017 Yossi Michaeli. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var borderingCountryLabel: UILabel!
    
    var selectedCountry = Country()
    var borderingCountries = [Country]()
    
    func configureView() {
        if let detail = detailItem {
            if let label = detailDescriptionLabel {
                label.text = detail.name
            }
            if selectedCountry.borderingCountries?.count == 0 {
                borderingCountryLabel.text = "No bordering countries"
            } else {
                borderingCountryLabel.text = String(format:"%d", (selectedCountry.borderingCountries?.count)!) + " bordering countries"
            }
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    var detailItem: Country? {
        didSet {
            selectedCountry = detailItem!
            
            selectedCountry.borderingCountries?.forEach { code in
                Country.fetchCountryByCode(baseUrlString: RestServices.baseUrl as! String, countryCode: code, completionHandler: { (country) -> () in
                    self.borderingCountries.append(country)
                    self.configureView()
                })
            }
        }
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (borderingCountries.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let currentCountry = self.borderingCountries[indexPath.row]
        
        var titleText: String?
        if (currentCountry.nativeName != nil) {
            titleText = currentCountry.name! + " (" + currentCountry.nativeName! + ")"
        } else {
            titleText = currentCountry.name!
        }
        
        cell.textLabel?.text = titleText
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}

