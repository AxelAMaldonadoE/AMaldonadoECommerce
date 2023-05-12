//
//  Usuario.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 28/04/23.
//

import Foundation
import SQLite3

class Usuario { // Modelo
    
    // PROPIEDADES
    var Id: Int? = 0
    var Nombre: String? = nil
    var ApellidoPaterno: String? = nil
    var ApellidoMaterno: String? = nil
    var Username: String? = nil
    var Password: String? = nil
    var FechaNacimiento: String? = nil
    
    // PROPIEDAD DE NAVEGACION
    var Rol: Rol? = nil
    
//    init(Id: Int, Nombre: String, ApellidoPaterno: String, ApellidoMaterno: String, Username: String, Password: String, FechaNacimiento: Date) {
//        self.Id = Id
//        self.Nombre = Nombre
//        self.ApellidoPaterno = ApellidoPaterno
//        self.ApellidoMaterno = ApellidoMaterno
//        self.Username = Username
//        self.Password = Password
//        self.FechaNacimiento = FechaNacimiento
//    }
    
}
