//
//  UsuarioCell.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 03/05/23.
//

import UIKit
import SwipeCellKit

class UsuarioCell: SwipeTableViewCell {

    @IBOutlet weak var txtApellidoPaterno: UILabel!
    @IBOutlet weak var txtNombre: UILabel!
    @IBOutlet weak var txtFechaNacimiento: UILabel!
    @IBOutlet weak var txtRolNombre: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
