//
//  DescriptionFactory.swift
//  DunGen
//
//  Created by Richard Moe on 3/21/21.
//  Copyright © 2021 Richard Moe. All rights reserved.
//

import Foundation


class DescriptionFactory {
    //Descriptions are listed in CSV files where column 0 is a roll, column 1 is a string. Row 0 is a descriptor row: c0 = roll (Dxx format) and c1 = Description type, e.g. "Room")

    //Files are parsed and stored in a dictionary of table descriptor: array of descriptions
    
    //Templates:
    // Templates use % prefix, where the string after the % is the table name.
    //  if Table Name is capitalized, then the return value from the lookup will be capitalized as well, e.g. %room -> bedroom, %Room -> Bedroom
    //  if Table Name has suffix _s, then the return value from the lookup will be plural
    //  if Table Name has prefix of a_, then the return value will be "a/an" depending on the return value
    
    let validTables = ["room","furn","stuff","adj","smell"]

    static let sharedInstance = DescriptionFactory()

    typealias DescriptionTableEntry = (roll: Int, item: String)
    var descriptionTable  = [String: [DescriptionTableEntry]]()
    
    private init() {
        parseLists()
        
        //Test:
        /*
        print ("Get Test: \(getDescription(type: "a_room", index: getRandomEntry(type: "room")))")
        print ("Get Test: \(getDescription(type: "furn_s", index: getRandomEntry(type: "furn")))")
        print ("Get Test: \(getDescription(type: "A_ROOM", index: getRandomEntry(type: "room")))")
        
        print ("Test temmplate: \(parseTemplate("Hello %Adj% World"))")
        */
        
        for _ in 0...10 {
            print("test Template2: \(parseTemplate(getDescription(type: "template")))")
        }
    }
    
    func parseLists() {

        
        for filename in ["DGTemplates", "DGRoomTypes", "DGAdjectives", "DGFurnishings", "DGSmells", "DGStuff"] {
            let parsedCSV: [[String]] = Helper.loadFromCSV(fileName: "\(filename).csv")
            
            //2d array: [ix, string]
            var dtab = [DescriptionTableEntry]()
            let tableName = parsedCSV[0][1].lowercased()
            dtab.append((roll: 0, item: parsedCSV[0][0]))
            
            for d in parsedCSV[1...] {
                if (d.count < 1) {
                    break
                }
                
                if let roll = Int(d[0]) {
                    dtab.append((roll: roll, item: d[1]))
                }
            }
            
            descriptionTable[tableName] = dtab
        }
    }
    
    func getDescription(type: String, index: Int = -1) -> String {
        
        var aWord = false
        var plural = false
        var ucase = false
        var ix = index
        
        var tableName = type
        //Todo error check
        
        //Uppercase
        if (tableName.first!.isUppercase) {
            ucase = true
            tableName = tableName.lowercased()
        }
        
        
        //parse prefix:
        if (tableName.starts(with: "a_")) {
            aWord = true
            tableName.removeFirst(2)
        }
        
        //parse suffix:
        if (tableName.contains("_s")) {
            plural = true
            tableName.removeLast(2)
            
        }
        
        
        if (ix < 0) {
            ix = getRandomEntry(type: tableName)
        }
        
        if let desTable = descriptionTable[tableName] {
            
            //Simple walk since these are small tables:
            for desc in desTable {
                if (ix <= desc.roll) {
                    var returnString = desc.item
                    if (aWord) {
                        let firstChar = returnString.first!
                        if ("aeiou".contains(firstChar)) {
                            returnString = "an " + returnString
                        } else {
                            returnString = "a " + returnString
                        }
                    }
                    if (plural) {
                        if (returnString.last == "y") {
                            returnString.removeLast()
                            returnString = returnString + "ies"
                        } else if (returnString.last == "s" || returnString.last == "x") {
                            returnString = returnString + "es"
                        } else {
                            returnString = returnString + "s"
                        }
                    }
                    if (ucase) {
                        return returnString.first!.uppercased() + returnString.dropFirst()
                    } else {
                        return returnString
                    }
                }
            }
        }
        
        return "ERROR"
        
    }
    
    func getRandomEntry(type: String) -> Int {
        
        if let desTable = descriptionTable[type.lowercased()] {
         
            let rollStr = desTable[0].item
            
            return GetDiceRoll(rollStr)
        }
        
        //TODO Error
        return -1
    }
    
    
    func parseTemplate(_ template: String) -> String {
        
        //We are assuming templates use "%" so get an array based on that:
        
        //var result = template.split(separator: "%") actually this won't work since I don't know which array elems are templates
        
        
        //char by char technique:
        var inKeyword = false
        var keyword = ""
        var outString = ""
        
        for char in template {
            if (char == "%") {
                if (inKeyword) {
                    //resolve keyword
                    outString = outString + getDescription(type: keyword)
                    
                    //clear
                    keyword = ""
                    inKeyword = false
                } else {
                    inKeyword = true
                }
            } else {
                var ch = char
                if (char == "<") {
                    ch = ","
                }
                
                if (inKeyword) {
                    keyword = keyword + String(ch)
                } else {
                    outString = outString + String(ch)
                }
            }
            
        }
        
        return outString
        
    }
}
