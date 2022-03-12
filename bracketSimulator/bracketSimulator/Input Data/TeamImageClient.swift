//
//  TeamImageClient.swift
//  bracketSimulator
//
//  Created by Kevin Niu on 3/12/22.
//

import Foundation
import UIKit

class TeamImageClient {
    // FIXME: Update this to cache an image. Always check to see if the image exists
    //        in cache before trying to download it. If you download it, then make sure
    //        to add it to the cache.
    static func getImage(url: String, completion: @escaping (UIImage?, Error?) -> Void) {
//        guard let teamID = teamID, let teamName = teamName else{
//            print("Error with team ID or team name!")
//            return
//        }
        let url=URL(string: url)!
        let session = URLSession.shared
        let task=session.dataTask(with: url as URL,completionHandler:{(data,response,error)->Void in
        
            guard let data = data, error == nil else {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    completion(image, nil)
                }
            } else{
            DispatchQueue.main.async {completion(nil, error)}}
        })
    task.resume()
    }
}
