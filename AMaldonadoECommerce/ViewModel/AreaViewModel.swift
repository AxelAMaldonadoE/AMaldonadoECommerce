//
//  AreaViewModel.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 18/05/23.
//

import Foundation
import SQLite3

class AreaViewModel {
    
    static func GetAll() -> Result {
        let dbManager = DBManager()
        let result = Result()
        let getallStatementString = "SELECT Id, Nombre FROM Area"
        
        var getallStatement: OpaquePointer? = nil
        do {
            if try sqlite3_prepare_v2(dbManager.db, getallStatementString, -1, &getallStatement, nil) == SQLITE_OK {
                result.Objects = []
                while try sqlite3_step(getallStatement) == SQLITE_ROW {
                    let area = Area()
                    area.Id = Int(sqlite3_column_int(getallStatement, 0))
                    area.Nombre = String(describing: String(cString: sqlite3_column_text(getallStatement, 1)))
                    
                    result.Objects?.append(area)
                }
                result.Correct = true
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al acceder a la base de datos!!"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(getallStatement)
        sqlite3_close(dbManager.db)
        
        return result
    }
}
