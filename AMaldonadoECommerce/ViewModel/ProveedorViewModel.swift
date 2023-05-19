//
//  ProveedorViewModel.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 17/05/23.
//

import Foundation
import SQLite3

class ProveedorViewModel {
    
    static func GetAll() -> Result {
        let dbManager = DBManager()
        let result = Result()
        let getallStatementString = "SELECT Id, Nombre FROM Proveedor"
        
        var getallStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(dbManager.db, getallStatementString, -1, &getallStatement, nil) == SQLITE_OK {
                result.Objects = []
                while try sqlite3_step(getallStatement) == SQLITE_ROW {
                    let proveedor = Proveedor()
                    proveedor.Id = Int(sqlite3_column_int(getallStatement, 0))
                    proveedor.Nombre = String(describing: String(cString: sqlite3_column_text(getallStatement, 1)))
                    
                    result.Objects?.append(proveedor)
                }
                result.Correct = true
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al traer la informacion de los proveedores!!"
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
