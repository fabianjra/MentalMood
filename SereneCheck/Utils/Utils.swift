//
//  Utils.swift
//  SereneCheck
//
//  Created by Fabian Josue Rodriguez Alvarez on 15/3/23.
//

import Foundation

struct Utils {
    /**
     Detects if the app is running on the canvas preview. Mostly used when the code is funcional only when running on device or simulator
     
     **Example:**
     ```swift
     if Utils.isRunningOnCanvas() == false {
         //Do somenthing only when the canvas preview crashes.
     }
     ```
     
     - Returns: true if is running on canvas
     
     - Authors: Fabian Rodriguez
     
     - Version: 1.0
     
     - Date: March 2023
     */
    static func isRunningOnCanvas() -> Bool {
        
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            return true
        } else {
            return false
        }
    }
}
