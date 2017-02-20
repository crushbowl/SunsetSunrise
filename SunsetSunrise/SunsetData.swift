//
//  SunsetData.swift
//  SunsetSunrise
//
//  Created by joy on 2/20/17.
//  Copyright © 2017 JanL. All rights reserved.
//

import Foundation


struct SunsetData {
   let sunsetTime: String  // avoid shared mutuable state by using 'let'
   
   // take the JSON and get to the String
   //failable initializer - depending on something that is outside of our control (i.e. the server)
   init?(json: Any) {
      guard
         let json = json as? [String: Any],
         let sunsetDictionary = json["results"] as? [String: String],
         let sunsetTime = sunsetDictionary["sunset"]
      else {
         return nil
      }
      
      self.sunsetTime = sunsetTime
   }
}

