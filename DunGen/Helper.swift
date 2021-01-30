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
    
        let parsedCSV: [[String]] = content.components(separatedBy: "\r\n").map{ $0.components(separatedBy: ",") }
        
        return parsedCSV
        
    }
    
    
    static func aggregateStringArray (array: [String], usePlural: Bool) -> [String] {
        
        var item = [String]()
        var itemCount = [Int]()
        
        if (array.count > 0) {
            item.append(array[0])
            itemCount.append(1)
            
            for i in 1..<array.count {
                
                if let index = item.firstIndex(of: array[i] ) {
                    itemCount[index] += 1
                } else {
                    item.append(array[i])
                    itemCount.append(1)
                }
            }
        }
        
        //Build string:
        var str = [String]()
        
        for i in 0..<item.count {
            if (usePlural) {
                str.append("\(itemCount[i]) " + item[i] +  (itemCount[i] > 1 ? "s" : "") )
            } else {
                //use $ x #  pattern
                str.append("\(item[i])" + (itemCount[i] > 1 ? " x \(itemCount[i])" : ""))
            }
        }
        
        return str
    }

    
}
