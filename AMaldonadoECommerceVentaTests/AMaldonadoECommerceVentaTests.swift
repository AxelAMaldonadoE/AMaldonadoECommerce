//
//  AMaldonadoECommerceVentaTests.swift
//  AMaldonadoECommerceVentaTests
//
//  Created by MacBookMBA15 on 29/05/23.
//

import XCTest
@testable import AMaldonadoECommerceVenta

final class AMaldonadoECommerceVentaTests: XCTestCase {
    
    let carritoViewModel = CarritoViewModel()
//
//    func testGetAll() throws {
//
//        let result = carritoViewModel.GetAll()
//
//        XCTAssertTrue(result.Correct!)
//        // No se inicializo el objects
//        XCTAssertNotNil(result.Objects)
//    }
//
//    func testGetById() throws {
//        // Comprobar si existe el producto en el carrito
//
//        let result = carritoViewModel.GetById(idProducto: 2)
//
//        XCTAssertTrue(result.Correct!)
//        XCTAssertNotNil(result.Object)
//    }
//
    func testUpdateCantidad() throws {
        
        let result = carritoViewModel.UpdateCantidad(idProducto: 10, cantidad: 10)
        
        XCTAssertFalse(result.Correct!)
        XCTAssertNotNil(result.ErrorMessage)
    }
    
    func testAdd() throws {
        let result = carritoViewModel.Add(10)
        
        XCTAssertTrue(result.Correct!)
    }
}
