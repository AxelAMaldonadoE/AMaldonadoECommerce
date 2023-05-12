//
//  AlumnoViewModel.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 04/05/23.
//

import Foundation
import SQLite3

class UsuarioViewModel {
    
    static func Add(usuario: Usuario) -> Result {
        let DbManager = DBManager()
        let result = Result()
        let insertStatementString = """
        INSERT INTO Usuario (Nombre, ApellidoPaterno, ApellidoMaterno, Username, Password, FechaNacimiento, IdRol)
        VALUES (?, ?, ?, ?, ?, ?, \(usuario.Rol!.Id!));
        """
        var insertStatement: OpaquePointer? = nil
        do {
            if try sqlite3_prepare_v2(DbManager.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(insertStatement, 1, (usuario.Nombre as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 2, (usuario.ApellidoPaterno as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 3, (usuario.ApellidoMaterno as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 4, (usuario.Username as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, (usuario.Password as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 6, (usuario.FechaNacimiento as! NSString).utf8String, -1, nil)
                
                if try sqlite3_step(insertStatement) == SQLITE_DONE {
                    result.Correct = true
                } else {
                    result.Correct = false
                    result.ErrorMessage = "Ocurrio un error al insertar los datos"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al comprobar la conexion con la base de datos!!"
            }
            sqlite3_finalize(insertStatement)
            sqlite3_close(DbManager.db)
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        return result
    }
    // Emilio Garcia
    // Digis01
    // pass@word1
    static func Update(usuario: Usuario) -> Result{
        let DbManager = DBManager()
        let result = Result()
        let updateStatementString = """
        UPDATE Usuario SET Nombre = ?, ApellidoPaterno = ?, ApellidoMaterno = ?,
        Username = ?, Password = ?, FechaNacimiento = ?, IdRol = \(usuario.Rol!.Id!)
        WHERE Id = \(usuario.Id!)
        """
        var updateStatement: OpaquePointer? = nil
        do {
            if try sqlite3_prepare_v2(DbManager.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(updateStatement, 1, (usuario.Nombre! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 2, (usuario.ApellidoPaterno! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 3, (usuario.ApellidoMaterno! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 4, (usuario.Username! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 5, (usuario.Password! as NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 6, (usuario.FechaNacimiento! as NSString).utf8String, -1, nil)
//                sqlite3_bind_int(updateStatement, 7, Int32(usuario.Id!))
                
                if try sqlite3_step(updateStatement) == SQLITE_DONE {
                    result.Correct = true
                } else {
                    print(sqlite3_extended_errcode(updateStatement))
                    result.Correct = false
                    result.ErrorMessage = "No se pudo actualizar la informacion"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error!!"
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
    
    static func Delete(idUsuario: Int) -> Result {
        let DbManager = DBManager()
        let result = Result()
        let deleteStatementString = "DELETE FROM Usuario WHERE Id = ?"
        var deleteStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(DbManager.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK   {
                sqlite3_bind_int(deleteStatement, 1, Int32(idUsuario))
                
                if try sqlite3_step(deleteStatement) == SQLITE_DONE {
                    result.Correct = true
                } else {
                    result.Correct = false
                    result.ErrorMessage = "Ocurrio un error al eliminar los datos del usuario"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error!!"
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
    
    static func GetAll() -> Result {
        let DbManager = DBManager()
        var result = Result()
        let getAllStatementString = "SELECT Usuario.Id, Usuario.Nombre, ApellidoPaterno, ApellidoMaterno, Username, Password, FechaNacimiento, IdRol, Rol.Nombre FROM Usuario INNER JOIN Rol ON Usuario.IdRol = Rol.Id"
        var getAllStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(DbManager.db, getAllStatementString, -1, &getAllStatement, nil) == SQLITE_OK {
                result.Objects = []
                while try (sqlite3_step(getAllStatement) == SQLITE_ROW) {
                    var usuario = Usuario()
                    usuario.Id = Int(sqlite3_column_int(getAllStatement, 0))
                    usuario.Nombre = String(describing: String(cString: sqlite3_column_text(getAllStatement, 1)))
                    usuario.ApellidoPaterno = String(describing: String(cString: sqlite3_column_text(getAllStatement, 2)))
                    usuario.ApellidoMaterno = String(describing: String(cString: sqlite3_column_text(getAllStatement, 3)))
                    usuario.Username = String(describing: String(cString: sqlite3_column_text(getAllStatement, 4)))
                    usuario.Password = String(describing: String(cString: sqlite3_column_text(getAllStatement, 5)))
                    usuario.FechaNacimiento = String(describing: String(cString: sqlite3_column_text(getAllStatement, 6)))
                    
                    usuario.Rol = Rol()
                    usuario.Rol?.Id = Int(sqlite3_column_int(getAllStatement, 7))
                    usuario.Rol?.Nombre = String(describing: String(cString: sqlite3_column_text(getAllStatement, 8)))
                    
                    result.Objects?.append(usuario)
                }
                result.Correct = true
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al traer la informacion de los usuarios!!"
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
    
    static func GetById(idUsuario: Int) -> Result {
        let DbManager = DBManager()
        let result = Result()
        let getByIdStatementString = "SELECT Usuario.Id, Usuario.Nombre, ApellidoPaterno, ApellidoMaterno, Username, Password, FechaNacimiento, IdRol, Rol.Nombre FROM Usuario INNER JOIN Rol ON Usuario.IdRol = Rol.Id WHERE Usuario.Id = \(idUsuario)"
        var getByIdStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(DbManager.db, getByIdStatementString, -1, &getByIdStatement, nil) == SQLITE_OK {
                if try sqlite3_step(getByIdStatement) == SQLITE_ROW{
                    let usuario = Usuario()
                    usuario.Id = Int(sqlite3_column_int(getByIdStatement, 0))
                    usuario.Nombre = String(describing: String(cString: sqlite3_column_text(getByIdStatement, 1)))
                    usuario.ApellidoPaterno = String(describing: String(cString: sqlite3_column_text(getByIdStatement, 2)))
                    usuario.ApellidoMaterno = String(describing: String(cString: sqlite3_column_text(getByIdStatement, 3)))
                    usuario.Username = String(describing: String(cString: sqlite3_column_text(getByIdStatement, 4)))
                    usuario.Password = String(describing: String(cString: sqlite3_column_text(getByIdStatement, 5)))
                    usuario.FechaNacimiento = String(describing: String(cString: sqlite3_column_text(getByIdStatement, 6)))
                    
                    usuario.Rol = Rol()
                    usuario.Rol?.Id = Int(sqlite3_column_int(getByIdStatement, 7))
                    usuario.Rol?.Nombre = String(describing: String(cString: sqlite3_column_text(getByIdStatement, 8)))
                    
                    result.Object = usuario
                    result.Correct = true
                } else {
                    result.Correct = false
                    result.ErrorMessage = "No se encontro el id del usuario!"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error!!"
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
    
}
