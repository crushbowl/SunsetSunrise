

//
//  SunsetGetter.swift
//  SunsetSunrise
//
//  Created by joy on 11/17/16.
//  Copyright © 2016 JanL. All rights reserved.
//
import Foundation
import CoreLocation

//needs to return a SunsetTime object
class  SunsetGetter {
   
   var sunsetTimes :Dictionary<String, Any>?
   
   var location: CLLocation
   var date: Date
   
   init(location: CLLocation, date: Date) {
      self.location = location
      self.date = date
   }
   
   // URL Life Cycle of a URL Session - URL Session Programming Guide
   // NSURLComponents - wondering if this is the best way to concatenate
   // Building URLs with NSURLComponents and NSURLQueryItems
   // Write a Blog post on URLComponents - why they are safer than String concatenation
   
   //Why am I using a static function?
   func createURLcomponents(location: CLLocation, date: Date) -> URL {
      
      let urlString = "http://api.sunrise-sunset.org/json?lat=\(location.coordinate.latitude)&lng=\(location.coordinate.longitude)&date=\(dateToString(date: date))"
      
      return URL(string: urlString)!
      
      //        var someComponents = URLComponents(string:"http://api.sunrise-sunset.org/json")
      //        let latQueryItem = URLQueryItem(name: "lat", value: "\(location.coordinate.latitude)")
      //        let lngQueryItem = URLQueryItem(name: "lng", value: "\(location.coordinate.longitude)")
      //        let dateQueryItem = URLQueryItem(name: "date", value: dateToString(date: date))
      //        let queryArray = [latQueryItem, lngQueryItem, dateQueryItem]
      //        someComponents?.queryItems = queryArray
      
      
      //        print("\n*****\n\(string)\n *****\n")
      //        print("\n*****\n\(someComponents!.url!)\n *****\n")
      //        return (someComponents?.url)!
   }
   
   func dateToString(date: Date) -> String {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "yyyy-MM-dd"
      dateFormatter.timeZone = TimeZone(identifier:"UTC")
      return dateFormatter.string(from: date)
   }
   
   // Making a Network Request Swift
   // http://blog.teamtreehouse.com/making-network-request-swift
   // https://www.udacity.com/course/ios-networking-with-swift--ud421
   // https://cocoacasts.com/networking-with-urlsession-meet-the-urlsession-family/
   
   func nextSunset(dataReturnedFromNet: @escaping (String) -> ()){
      //Pull the URL from createURLcomponents
      let pingEndpointURL = createURLcomponents(location: location, date: date)
      let urlRequest = URLRequest(url: pingEndpointURL)
      // Set up session configuration
      let config = URLSessionConfiguration.default // Session Configuration
      let session = URLSession(configuration: config) // Load configuration into Session
      
      DispatchQueue.main.async(execute: { _ in //  launch URL request
         //this TASK - url session - making a request over the 'net to the URL (go out to the 'net)- retrieve the JSON
         // When is this coming back? Ans: Later - we don't have to wait for it 'async'
         let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // (data, response, error) are the parameters the completion handler receives
            if error != nil { print(error!.localizedDescription) ; return }
            do {
               if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any] {
                  let sunsetDictionary = json["results"] as! [String:String]
                  let sunsetTime = sunsetDictionary["sunset"]
                  dataReturnedFromNet(sunsetTime!)
                  print("----------\nHere goes the JSON:\n\(json)\n-----------\n")
               }
            } catch { print("error in JSONSerialization") }
         })
         task.resume()
      })
      
   }
   
}
