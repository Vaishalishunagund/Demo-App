//
//  AppModel.swift
//  Demo-App
//
//  Created by Apple on 12/11/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class theAppModel{
// static variables ...
static let sharedInstance = theAppModel()
    
    //Array for data
    var months : [String] = [""]
    var stats : [Int] = [0]

    //Stats Data URL
    let urlString = "https://demo5636362.mockable.io/stats"
    
    
    var xAxisDataSet = [String]() // for displaying string value in Barchart in X Axis -> upadte following Collection..
    
    // setter and getter for xAxisDataSet ....
    func setXAxisDataSet(dataSet:[String]){
        self.xAxisDataSet = dataSet
    }
    
    func getXaxisDataSet()->[String]{
        return self.xAxisDataSet
    }
    
    func modelInit()
    {
        self.requestURL()
    }
    
    //function to request for URL
    func requestURL()
    {
        self.loadJson(fromURLString: urlString) { (result) in
            switch result {
            case .success(let data):
                self.parse(jsonData: data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    //To fetch data from CoreData
    func fetchRecord()
    {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
           let context = appDelegate.persistentContainer.viewContext

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "StatsData")
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                print( [data.value(forKey: "months") as! String])
                print([data.value(forKey: "stats") as! Int])
            }

        } catch {

            print("Failed")
        }

    }
    
    //Function to load JSON from internet
    private func loadJson(fromURLString urlString: String,
                          completion: @escaping (Result<Data, Error>) -> Void) {
        if let url = URL(string: urlString) {
            let urlSession = URLSession(configuration: .default).dataTask(with: url) { (data, response, error) in
                if let error = error {
                    completion(.failure(error))
                }
                
                if let data = data {
                    completion(.success(data))
                }
            }
            
            urlSession.resume()
        }
    }
    
    //Function to parse the json data
    private func parse(jsonData: Data) {
        let jsonData: Data = jsonData/* get your json data */
        var stat = ""
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "StatsData", in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        typealias JSONDictionary = [String:Any]
        do{
        let jsonDict = try JSONSerialization.jsonObject(with: jsonData) as? JSONDictionary
            months.removeAll()
            stats.removeAll()
            if let arry = jsonDict!["data"] as? [[String:AnyObject]] {
                     for dictionary in arry {
                        print("Res:\(arry)")
                        newUser.setValue(dictionary["month"] as! String, forKey: "months")
                        stat = dictionary["stat"] as! String
                        newUser.setValue(Int(stat) ?? 0, forKey: "stats")
                        
                        do {
                            try context.save()
                            months.append(dictionary["month"] as! String)
                            stat = dictionary["stat"] as! String
                            stats.append(Int(stat) ?? 0 )
                        } catch {
                            
                            print("Failed saving")
                        }                        }
            }
            
        }
        catch {
            print("decode error")
        }
        
    }
    

}
