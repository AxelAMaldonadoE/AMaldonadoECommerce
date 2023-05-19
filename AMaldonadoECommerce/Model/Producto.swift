//
//  Producto.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 16/05/23.
//

import Foundation

class Producto {
    
    var Id : Int? = 0
    var Nombre : String? = nil
    var PrecioUnitario : Float? = 0.0
    var Stock : Int? = 0
    var Descripcion : String? = nil
    var Imagen : String? = nil
    
    // Propiedades de navegacion de mi clase producto
    var Proveedor : Proveedor? = nil
    var Departamento : Departamento? = nil
}
