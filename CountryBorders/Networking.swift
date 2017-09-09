//
//  Networking.swift
//  CountryBorders
//
//  Created by Yossi Michaeli on 09/09/2017.
//  Copyright © 2017 Yossi Michaeli. All rights reserved.
//

import Foundation


class RestServices {
    
    static var baseUrl = NSDictionary(contentsOfFile: Bundle.main.path(forResource: "Config", ofType: "plist")!)?.object(forKey: "API base URL")
    
    enum JSONError: String, Error {
        case NoData = "No data"
        case ConversionFailed = "Conversion failed"
    }
    
    static func getData(urlString: String, completionHandler: @escaping (_ data: NSDictionary) -> Void) -> Void
    {
        let urlPath = urlString
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        
        URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
            print("Data length: " + String(format:"%d",(data?.count)!))
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSDictionary
                completionHandler(json)
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }
    
    static func getData(urlString: String, completionHandler: @escaping (_ data: NSArray) -> Void) -> Void
    {
        let urlPath = urlString
        guard let endpoint = URL(string: urlPath) else {
            print("Error creating endpoint")
            return
        }
        
        URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
            print("Data length: " + String(format:"%d",(data?.count)!))
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! NSArray
                completionHandler(json)
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }

}
