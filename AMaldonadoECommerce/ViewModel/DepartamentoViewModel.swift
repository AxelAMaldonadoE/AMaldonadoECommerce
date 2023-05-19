//
//  DepartamentoViewModel.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 17/05/23.
//

import Foundation
import SQLite3

class DepartamentoViewModel {
    
    static func GetByIdArea(idArea: Int) -> Result {
        let dbManager = DBManager()
        let result = Result()
        let getbyareaStatementString = "SELECT Id, Nombre FROM Departamento WHERE IdArea = \(idArea)"
        
        var getbyareaStatement: OpaquePointer? = nil
        do {
            if try sqlite3_prepare_v2(dbManager.db, getbyareaStatementString, -1, &getbyareaStatement, nil) == SQLITE_OK {
                result.Objects = []
                while try sqlite3_step(getbyareaStatement) == SQLITE_ROW {
                    let departamento = Departamento()
                    departamento.Id = Int(sqlite3_column_int(getbyareaStatement, 0))
                    departamento.Nombre = String(describing: String(cString: sqlite3_column_text(getbyareaStatement, 1)))
                    
                    result.Objects?.append(departamento)
                }
                result.Correct = true
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al buscar la informacion de los departamentos"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(getbyareaStatement)
        sqlite3_close(dbManager.db)
        
        return result
    }
    
    static func GetAll() -> Result {
        let dbManager = DBManager()
        let result = Result()
        let getallStatementString = "SELECT Id, Nombre FROM Departamento"
        
        var getallStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(dbManager.db, getallStatementString, -1, &getallStatement, nil) == SQLITE_OK {
                result.Objects = []
                while try sqlite3_step(getallStatement) == SQLITE_ROW {
                    let departamento = Departamento()
                    departamento.Id = Int(sqlite3_column_int(getallStatement, 0))
                    departamento.Nombre = String(describing: String(cString: sqlite3_column_text(getallStatement, 1)))
                    
                    result.Objects?.append(departamento)
                }
                result.Correct = true
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al traer la informacion de los departamentos!!"
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
