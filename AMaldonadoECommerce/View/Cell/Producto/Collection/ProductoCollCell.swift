//
//  ProductoCollCell.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 24/05/23.
//

import UIKit

class ProductoCollCell: UICollectionViewCell {

    @IBOutlet weak var ivProducto: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
