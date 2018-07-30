//
//  ParserHelper.swift
//  IOSAssessmentApp
//
//  Created by HarithaReddy on 23/07/18.
//  Copyright © 2018 administrator. All rights reserved.
//

import UIKit

//Struct that confirms to decodable protocol , which has attributes same as the result key ..
struct CanadaPlaces : Decodable {
    let title : String
    let rows : [Place]
}

// used in JSonDecoder , which has attributes same as the key values in the json result data..
struct Place : Decodable {
    let title : String?
    let description : String?
    let imageHref : String?
}

class ParserHelper: NSObject {
    
    static func getData(completionHandler : @escaping(_ places : CanadaPlaces? ,_ error : Error?)-> ())
    {
        
        let urlString = "https://dl.dropboxusercontent.com/s/2iodh4vg0eortkl/facts.json"
        guard let url = URL(string: urlString) else {
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else { return }
            
            guard let asciiString = String(data: data, encoding: .ascii) else { return }
            guard let utf8Data = asciiString.data(using: .utf8) else {return}
            do{
                let jsonObj = try JSONDecoder().decode(CanadaPlaces.self, from: utf8Data)
                completionHandler(jsonObj, nil)
              
            }catch let error
            {
               completionHandler(nil , error)
            }
        }.resume()
    }

}

