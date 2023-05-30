//
//  CarritoCell.swift
//  AMaldonadoECommerceVenta
//
//  Created by MacBookMBA15 on 26/05/23.
//

import UIKit
import SwipeCellKit

class CarritoCell: SwipeTableViewCell {

    @IBOutlet weak var ivProducto: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var stpCantidad: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
