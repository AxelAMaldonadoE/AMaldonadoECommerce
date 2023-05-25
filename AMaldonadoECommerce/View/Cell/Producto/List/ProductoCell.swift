//
//  ProductoCell.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 16/05/23.
//

import UIKit
import SwipeCellKit

class ProductoCell: SwipeTableViewCell {

    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var lblPrecio: UILabel!
    @IBOutlet weak var lblDepartamento: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var imagenView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
