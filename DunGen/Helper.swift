//
//  Helper.swift
//  DunGen
//
//  Created by Richard Moe on 5/15/20.
//  Copyright © 2020 Richard Moe. All rights reserved.
//

import Foundation

class Helper {
    
    


    static func loadFromResource(fileName: String) -> String {
        let fileContents: String
        let path = Bundle.main.path(forResource: fileName, ofType: nil)
        do {
            fileContents = try String(contentsOfFile:path!, encoding: String.Encoding.utf8)
            //                let lines = fileContents.components(separatedBy: "\n")
            //
            //                for row in 0..<lines.count {
            //                    let items = lines[row].components(separatedBy: " ")
            //                    var str = ""
            //                    for column in 0..<items.count {
            //                        str += items[column] + " "
            //                    }
            //                    print ("row: \(row): \(str)")
            //                }
        } catch {
            fatalError("Error Reading Resource \(fileName)")
        }
        return fileContents
    }

    static func loadFromCSV (fileName: String) -> [[String]] {
    
        let content = Helper.loadFromResource(fileName: fileName)
    
        let parsedCSV: [[String]] = content.components(separatedBy: "\n").map{ $0.components(separatedBy: ",") }
        
        return parsedCSV
        
    }
    

    
}
