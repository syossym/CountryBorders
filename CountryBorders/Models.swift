//
//  Models.swift
//  CountryBorders
//
//  Created by Yossi Michaeli on 08/09/2017.
//  Copyright © 2017 Yossi Michaeli. All rights reserved.
//

import UIKit

class Country: NSObject {
    
    var id: String?
    var name: String?
    var nativeName: String?
    var flagUrl: URL?
    var borderingCountries: [String]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "borders" {
            super.setValue(value, forKey: "borderingCountries")
        } else if key == "alpha3Code" {
            super.setValue(value, forKey: "id")
        } else if key == "flag" {
            super.setValue(URL(string: value as! String), forKey: "flagUrl")
        } else if key == "name" {
            let strVal = value as! String
            super.setValue(strVal, forKey: "name")
        }  else if key == "nativeName" {
            let strVal = value as! String
            super.setValue(strVal, forKey: "nativeName")
        }
    }
    
    static func fetchCountryByCode(baseUrlString: String, countryCode: String, completionHandler: @escaping (Country) -> ()) {
        
        let allCoutnriesUrl = baseUrlString + "/alpha/" + countryCode
        
        RestServices.getData(urlString: allCoutnriesUrl, completionHandler: { (dataArray: NSDictionary) -> Void in
            
            let country = Country()
            country.setValuesForKeys(dataArray as! [String: AnyObject])
            print(country.name ?? "")
            
            DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(country)
            })
        })
    }
    
    static func fetchAllCountries(baseUrlString: String, completionHandler: @escaping ([Country]) -> ()) {
        
        let allCoutnriesUrl = baseUrlString + "/all"
        
        RestServices.getData(urlString: allCoutnriesUrl, completionHandler: { (dataArray: NSArray) -> Void in
            var countries = [Country]()
            
            dataArray.forEach { dict in
                let country = Country()
                country.setValuesForKeys(dict as! [String: AnyObject])
                print(country.name ?? "")
                countries.append(country)
            }
            
            DispatchQueue.main.async(execute: { () -> Void in
                completionHandler(countries)
            })
        })
        
    }
}
