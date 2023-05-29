//
//  VentaProductoViewModel.swift
//  AMaldonadoECommerceVenta
//
//  Created by MacBookMBA15 on 26/05/23.
//

import Foundation
import UIKit
import CoreData

class CarritoViewModel {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    func Add(_ idProducto: Int) ->Result {
        let result = Result()
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let entity = NSEntityDescription.entity(forEntityName: "VentaProducto", in: context)!
            
            let producto = NSManagedObject(entity: entity, insertInto: context)
            
            producto.setValue(idProducto, forKey: "idProducto")
            producto.setValue(1, forKey: "cantidad")
            
            try context.save()
            
            result.Correct = true
            
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        return result
    }
    
    func GetAll() -> Result {
        let result = Result()
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "VentaProducto")
            let resultFetch = try context.fetch(request)
            result.Objects = []
            for obj in resultFetch as! [NSManagedObject] {
//                let idProducto = obj.value(forKey: "idProducto")
//                let cantidad = obj.value(forKey: "cantidad")
//                print("El id del producto guardado es \(idProducto!), con la cantidad \(cantidad!)")
                let carrito = Carrito()
//                carrito.IdProducto = Int(obj.value(forKey: "idProducto") as! String)
//                carrito.Cantidad = Int(obj.value(forKey: "cantidad") as! String)
                carrito.Producto = Producto()
                carrito.Producto?.Id = (obj.value(forKey: "idProducto") as! Int)
                carrito.Cantidad = (obj.value(forKey: "cantidad") as! Int)
                
                let resultProducto = ProductoViewModel.GetById(idProducto: carrito.Producto!.Id!)
                if resultProducto.Correct!{
                    let objProd = resultProducto.Object as! Producto
                    carrito.Producto?.Nombre = objProd.Nombre
                    carrito.Producto?.PrecioUnitario = objProd.PrecioUnitario
                    carrito.Producto?.Imagen = objProd.Imagen
                    result.Objects?.append(carrito)
                } else {
                    result.Correct = false
                    result.ErrorMessage = "Ocurrio un error, intenta de nuevo!"
                    return result
                }
            }
            result.Correct = true
        } catch let ex {
            result.Correct = false
            result.ErrorMessage = ex.localizedDescription
            result.Ex = ex
        }
        
        return result
    }
}
