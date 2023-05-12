//
//  RolViewModel.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 09/05/23.
//

import Foundation
import SQLite3

class RolViewModel {
    
    static func Add(rol: Rol) -> Result {
        let DbManager = DBManager()
        let result = Result()
        let insertStatementString = """
        INSERT INTO Rol (Nombre) VALUES (?)
        """
        var insertStatement: OpaquePointer? = nil
        do {
            if try sqlite3_prepare_v2(DbManager.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(insertStatement, 1, (rol.Nombre as! NSString).utf8String, -1, nil)
                if try sqlite3_step(insertStatement) == SQLITE_DONE {
                    result.Correct = true
                } else {
                    result.Correct = false
                    result.ErrorMessage = "Ocurrio un error al insertar los datos"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al comprobar la conexion a la base de datos"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(insertStatement)
        sqlite3_close(DbManager.db)
        return result
    }
    
    static func Update(rol: Rol) -> Result {
        let DbManager = DBManager()
        let result = Result()
        
        let updateStatementString = """
        UPDATE Rol SET Nombre = ? WHERE Id = \(rol.Id!)
        """
        
        var updateStatement: OpaquePointer? = nil
        do {
            if try sqlite3_prepare_v2(DbManager.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(updateStatement, 1, (rol.Nombre as! NSString).utf8String, -1, nil)
                
                if try sqlite3_step(updateStatement) == SQLITE_DONE {
                    result.Correct = true
                } else {
                    result.Correct = false
                    result.ErrorMessage = "Ocurrio un error al actualizar los datos"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al combrobar la conexion con la base de datos"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(updateStatement)
        sqlite3_close(DbManager.db)
        return result
    }
    
    static func Delete(idRol: Int) -> Result {
        let DbManager = DBManager()
        let result = Result()
        let deleteStatementString = "DELETE FROM Rol WHERE Id = \(idRol)"
        
        var deleteStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(DbManager.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                if try sqlite3_step(deleteStatement) == SQLITE_DONE {
                    result.Correct = true
                } else {
                    result.Correct = false
                    result.ErrorMessage = "Ocurrio un error al eliminar lso datos del rol"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al comprobar la conexion con la base de datos"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(deleteStatement)
        sqlite3_close(DbManager.db)
        
        return result
    }
    
    static func GetById(idRol: Int) -> Result{
        let DbManager = DBManager()
        let result = Result()
        let getByIdStatementString = "SELECT Id, Nombre FROM Rol WHERE Id = \(idRol)"
        var getByIdStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(DbManager.db, getByIdStatementString, -1, &getByIdStatement, nil) == SQLITE_OK {
                if try sqlite3_step(getByIdStatement) == SQLITE_ROW {
                    let rol = Rol()
                    rol.Id = Int(sqlite3_column_int(getByIdStatement, 0))
                    rol.Nombre = String(describing: String(cString: sqlite3_column_text(getByIdStatement, 1)))
                    
                    result.Object = rol
                    result.Correct = true
                } else {
                    result.Correct = false
                    result.ErrorMessage = "No se encontro el id del rol"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al comprobar la conexion con la base de datos"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        sqlite3_finalize(getByIdStatement)
        sqlite3_close(DbManager.db)
        return result
    }
    
    static func GetAll() -> Result {
        let DbManager = DBManager()
        let result = Result()
        let getAllStatementString = "SELECT Id, Nombre FROM Rol"
        
        var getAllStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(DbManager.db, getAllStatementString, -1, &getAllStatement, nil) == SQLITE_OK {
                result.Objects = []
                while try sqlite3_step(getAllStatement) == SQLITE_ROW {
                    let rol = Rol()
                    rol.Id = Int(sqlite3_column_int(getAllStatement, 0))
                    rol.Nombre = String(describing: String(cString: sqlite3_column_text(getAllStatement, 1)))
                    
                    result.Objects?.append(rol)
                }
                result.Correct = true
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al traer la informacion de los roles!!"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(getAllStatement)
        sqlite3_close(DbManager.db)
        
        return result
    }
    
}
