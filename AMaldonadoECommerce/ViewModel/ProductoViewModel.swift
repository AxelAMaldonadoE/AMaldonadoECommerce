//
//  ProductoViewModel.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 16/05/23.
//

import Foundation
import SQLite3

class ProductoViewModel {
    
    static func Add(producto: Producto) -> Result {
        let dbManager = DBManager()
        let result = Result()
        let insertStatementString = "INSERT INTO Producto (Nombre, PrecioUnitario, Stock, Descripcion, Imagen, IdProveedor, IdDepartamento) VALUES (?, ?, ?, ?, ?, ?, ?)"
        var insertStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(dbManager.db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(insertStatement, 1, (producto.Nombre as! NSString).utf8String, -1, nil)
                sqlite3_bind_double(insertStatement, 2, Double(producto.PrecioUnitario!))
                sqlite3_bind_int(insertStatement, 3, Int32(producto.Stock!))
                sqlite3_bind_text(insertStatement, 4, (producto.Descripcion as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(insertStatement, 5, (producto.Imagen as! NSString).utf8String, -1, nil)
                sqlite3_bind_int(insertStatement, 6, Int32(producto.Proveedor!.Id!))
                sqlite3_bind_int(insertStatement, 7, Int32(producto.Departamento!.Id!))
                
                if try sqlite3_step(insertStatement) == SQLITE_DONE {
                    result.Correct = true
                } else {
                    result.Correct = false
                    result.ErrorMessage = "Ocurrio un error al insertar los datos del producto"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al verificar la conexion con la base de datos"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(insertStatement)
        sqlite3_close(dbManager.db)
        return result
    }
    
    static func Update(producto: Producto) -> Result {
        let dbManager = DBManager()
        let result = Result()
        let updateStatementString = "UPDATE Producto SET Nombre = ?, Descripcion = ?, Stock = ?, PrecioUnitario = ?, IdProveedor = ?, IdDepartamento = ?, Imagen = ? WHERE Id = ?"
        
        var updateStatement: OpaquePointer? = nil
        do {
            if try sqlite3_prepare_v2(dbManager.db, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
                sqlite3_bind_text(updateStatement, 1, (producto.Nombre as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(updateStatement, 2, (producto.Descripcion as! NSString).utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 3, Int32(producto.Stock!))
                sqlite3_bind_double(updateStatement, 4, Double(producto.PrecioUnitario!))
                sqlite3_bind_int(updateStatement, 5, Int32(producto.Proveedor!.Id!))
                sqlite3_bind_int(updateStatement, 6, Int32(producto.Departamento!.Id!))
                sqlite3_bind_text(updateStatement, 7, (producto.Imagen as! NSString).utf8String, -1, nil)
                sqlite3_bind_int(updateStatement, 8, Int32(producto.Id!))
                
                if try sqlite3_step(updateStatement) == SQLITE_DONE {
                    result.Correct = true
                } else {
                    result.Correct = false
                    result.ErrorMessage = "Ocurrio un error al actualizar la informacion del producto"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al comprobar la conexion con la base de datos!!"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(updateStatement)
        sqlite3_close(dbManager.db)
        return result
    }
    
    static func Delete(idProducto: Int) -> Result {
        let dbManager = DBManager()
        let result = Result()
        let deleteStatementString = "DELETE FROM Producto WHERE Id = \(idProducto)"
        
        var deleteStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(dbManager.db, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
                if try sqlite3_step(deleteStatement) == SQLITE_DONE {
                    result.Correct = true
                } else {
                    result.Correct = false
                    result.ErrorMessage = "Ocurrio un error al eliminar los datos del producto"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al comprobar la conexion con la base de datos!!"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(deleteStatement)
        sqlite3_close(dbManager.db)
        
        return result
    }
    
    static func GetById(idProducto: Int) -> Result {
        let dbManager = DBManager()
        let result = Result()
        let getbyidStatementString = "SELECT Producto.Id, Producto.Nombre, PrecioUnitario, Stock, Descripcion, Imagen, IdProveedor, Proveedor.Nombre, Proveedor.Telefono, IdDepartamento, Departamento.Nombre, Departamento.IdArea, Area.Nombre FROM Producto INNER JOIN Proveedor ON Producto.IdProveedor = Proveedor.Id INNER JOIN Departamento ON Producto.IdDepartamento = Departamento.Id INNER JOIN Area ON Departamento.IdArea = Area.Id WHERE Producto.Id = \(idProducto)"
        
        var getbyidStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(dbManager.db, getbyidStatementString, -1, &getbyidStatement, nil) == SQLITE_OK {
                if try sqlite3_step(getbyidStatement) == SQLITE_ROW {
                    let producto = Producto()
                    producto.Id = Int(sqlite3_column_int(getbyidStatement, 0))
                    producto.Nombre = String(cString: sqlite3_column_text(getbyidStatement, 1))
                    producto.PrecioUnitario = Float(sqlite3_column_double(getbyidStatement, 2))
                    producto.Stock = Int(sqlite3_column_int(getbyidStatement, 3))
                    producto.Descripcion = String(describing: String(cString: sqlite3_column_text(getbyidStatement, 4)))
                    producto.Imagen = String(describing: String(cString: sqlite3_column_text(getbyidStatement, 5)))
                    
                    producto.Proveedor = Proveedor()
                    producto.Proveedor?.Id = Int(sqlite3_column_int(getbyidStatement, 6))
                    producto.Proveedor?.Nombre = String(describing: String(cString: sqlite3_column_text(getbyidStatement, 7)))
                    producto.Proveedor?.Telefono = String(describing: String(cString: sqlite3_column_text(getbyidStatement, 8)))
                    
                    producto.Departamento = Departamento()
                    producto.Departamento?.Id = Int(sqlite3_column_int(getbyidStatement, 9))
                    producto.Departamento?.Nombre = String(describing: String(cString: sqlite3_column_text(getbyidStatement, 10)))
                    
                    producto.Departamento?.Area = Area()
                    producto.Departamento?.Area?.Id = Int(sqlite3_column_int(getbyidStatement, 11))
                    producto.Departamento?.Area?.Nombre = String(describing: String(cString: sqlite3_column_text(getbyidStatement, 12)))
                    
                    result.Object = producto
                    result.Correct = true
                } else {
                    result.Correct = false
                    result.ErrorMessage = "Ocurrio un error, no se encontro el id del producto!"
                }
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al comprobar la conexion con la base de datos!!"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(getbyidStatement)
        sqlite3_close(dbManager.db)
        return result
    }
    
    
    static func GetAll() -> Result {
        let dbManager = DBManager()
        let result = Result()
        let getallStatementString = "SELECT Producto.Id, Producto.Nombre, PrecioUnitario, Stock, Descripcion, Imagen, IdProveedor, Proveedor.Nombre, Proveedor.Telefono, IdDepartamento, Departamento.Nombre, Departamento.IdArea, Area.Nombre FROM Producto INNER JOIN Proveedor ON Producto.IdProveedor = Proveedor.Id INNER JOIN Departamento ON Producto.IdDepartamento = Departamento.Id INNER JOIN Area ON Departamento.IdArea = Area.Id"
        var getallStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(dbManager.db, getallStatementString, -1, &getallStatement, nil) == SQLITE_OK {
                result.Objects = []
                while try (sqlite3_step(getallStatement) == SQLITE_ROW) {
                    let producto = Producto()
                    producto.Id = Int(sqlite3_column_int(getallStatement, 0))
                    producto.Nombre = String(describing: String(cString: sqlite3_column_text(getallStatement, 1)))
                    producto.PrecioUnitario = Float(sqlite3_column_double(getallStatement, 2))
                    producto.Stock = Int(sqlite3_column_int(getallStatement, 3))
                    producto.Descripcion = String(describing: String(cString: sqlite3_column_text(getallStatement, 4)))
                    producto.Imagen = String(describing: String(cString: sqlite3_column_text(getallStatement, 5)))
                    
                    producto.Proveedor = Proveedor()
                    producto.Proveedor?.Id = Int(sqlite3_column_int(getallStatement, 6))
                    producto.Proveedor?.Nombre = String(describing: String(cString: sqlite3_column_text(getallStatement, 7)))
                    producto.Proveedor?.Telefono = String(describing: String(cString: sqlite3_column_text(getallStatement, 8)))
                    
                    producto.Departamento = Departamento()
                    producto.Departamento?.Id = Int(sqlite3_column_int(getallStatement, 9))
                    producto.Departamento?.Nombre = String(describing: String(cString: sqlite3_column_text(getallStatement, 10)))
                    
                    producto.Departamento?.Area = Area()
                    producto.Departamento?.Area?.Id = Int(sqlite3_column_int(getallStatement, 11))
                    producto.Departamento?.Area?.Nombre = String(describing: String(cString: sqlite3_column_text(getallStatement, 12)))
                    
                    result.Objects?.append(producto)
                }
                result.Correct = true
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al traer la informacion de los productos!!"
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
    
    static func GetByDep(idDepartamento: Int) -> Result{
        let dbManager = DBManager()
        let result = Result()
        let getStatementString = "SELECT Id, Nombre, PrecioUnitario, Descripcion, Stock, Imagen FROM Producto WHERE IdDepartamento = \(idDepartamento)"
        
        var getStatement: OpaquePointer? = nil
        do {
            if try sqlite3_prepare_v2(dbManager.db, getStatementString, -1, &getStatement, nil) == SQLITE_OK {
                result.Objects = []
                while try sqlite3_step(getStatement) == SQLITE_ROW {
                    let producto = Producto()
                    producto.Id = Int(sqlite3_column_int(getStatement, 0))
                    producto.Nombre = String(describing: String(cString: sqlite3_column_text(getStatement, 1)))
                    producto.PrecioUnitario = Float(sqlite3_column_double(getStatement, 2))
                    producto.Descripcion = String(cString: sqlite3_column_text(getStatement, 3))
                    producto.Stock = Int(sqlite3_column_int(getStatement, 4))
                    producto.Imagen = String(cString: sqlite3_column_text(getStatement, 5))
                    
                    result.Objects?.append(producto)
                }
                result.Correct = true
            } else {
                result.Correct = false
                result.ErrorMessage = "Ocurrio un error al traer los productos!!"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(getStatement)
        sqlite3_close(dbManager.db)
        
        return result
    }
    
    static func GetByBusqueda(strBusqueda: String) -> Result {
        let dbManager = DBManager()
        let result = Result()
        let getStatementString = "SELECT Id, Nombre, PrecioUnitario, Descripcion, Stock, Imagen FROM Producto WHERE Nombre LIKE '%\(strBusqueda)%'"
        var getStatement: OpaquePointer? = nil
        
        do {
            if try sqlite3_prepare_v2(dbManager.db, getStatementString, -1, &getStatement, nil) == SQLITE_OK {
                result.Objects = []
                while try sqlite3_step(getStatement) == SQLITE_ROW {
                    let producto = Producto()
                    producto.Id = Int(sqlite3_column_int(getStatement, 0))
                    producto.Nombre = String(describing: String(cString: sqlite3_column_text(getStatement, 1)))
                    producto.PrecioUnitario = Float(sqlite3_column_double(getStatement, 2))
                    producto.Descripcion = String(cString: sqlite3_column_text(getStatement, 3))
                    producto.Stock = Int(sqlite3_column_int(getStatement, 4))
                    producto.Imagen = String(cString: sqlite3_column_text(getStatement, 5))
                    
                    result.Objects?.append(producto)
                }
                result.Correct = true
            } else {
                result.Correct = false
                result.ErrorMessage = "No fue posible traer los datos de los productos!!"
            }
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        sqlite3_finalize(getStatement)
        sqlite3_close(dbManager.db)
        
        return result
    }
}
