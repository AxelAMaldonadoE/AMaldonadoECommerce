//
//  CarritoCell.swift
//  AMaldonadoECommerceVenta
//
//  Created by MacBookMBA15 on 26/05/23.
//

import UIKit

class CarritoCell: UITableViewCell {

    @IBOutlet weak var ivProducto: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblCantidad: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
