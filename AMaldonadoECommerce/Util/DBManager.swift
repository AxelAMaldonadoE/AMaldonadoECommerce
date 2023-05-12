//
//  DBManager.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 28/04/23.
//

import Foundation
import SQLite3

class DBManager {
    
    var db: OpaquePointer?
    let dbPath: String = "Document.AMaldonadoECommerce.sqlite"
    
    init() {
        self.db = Get() //Cambiar su nombre
    }
    
    func Get() -> OpaquePointer?
    {
        let filePath = try! FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(dbPath)
        
//        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        var db: OpaquePointer? = nil
        if sqlite3_open(filePath.path, &db) != SQLITE_OK
        {
            debugPrint("can't open database")
            return nil
        }
        else
        {
            print("Successfully created connection to database at \(filePath)")
            return db
        }
    }

    	
}
