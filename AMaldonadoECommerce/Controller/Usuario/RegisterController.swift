//
//  RegisterController.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 22/05/23.
//

import UIKit
import Firebase

class RegisterController: UIViewController {

    // Outlet Text Field
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtContraseña: UITextField!
    @IBOutlet weak var txtConfirmar: UITextField!
    @IBOutlet weak var btnRegistrar: UIButton!
    
    // Outlet Label 
    @IBOutlet weak var lblCorreo: UILabel!
    @IBOutlet weak var lblContraseña: UILabel!
    @IBOutlet weak var lblConfirmar: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OcultarLabel()
        txtConfirmar.delegate = self
        
        btnRegistrar.isEnabled = false
        
        // Do any additional setup after loading the view.
    }
  
    @IBAction func Registrar() {
        
        guard txtCorreo.text! != "" else {
            txtCorreo.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblCorreo.isHidden = false
            return
        }
        txtCorreo.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblCorreo.isHidden = true
        
        guard txtContraseña.text! != "" else {
            txtContraseña.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblContraseña.isHidden = false
            return
        }
        txtContraseña.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblContraseña.isHidden = true
        
        guard txtConfirmar.text! != "" else {
            txtConfirmar.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblConfirmar.isHidden = false
            lblConfirmar.text = "Debes ingresar de nuevo tu contraseña!!"
            return
        }
        txtConfirmar.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblConfirmar.isHidden = true
        
//        guard txtConfirmar.text! == txtCorreo.text! else {
//            txtConfirmar.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
//        }

        let correo = txtCorreo.text!
        let contraseña = txtContraseña.text!
        
        Auth.auth().createUser(withEmail: correo, password: contraseña) { authResult, error in
            
            if let ex = error {
                let alert = UIAlertController(title: "Notificacion", message: error?.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default)
                alert.addAction(action)
                self.present(alert, animated: true)
                return
            }
            if let result = authResult {
                self.performSegue(withIdentifier: "registerUsuario", sender: self)
            }
        }
    }
    
    private func OcultarLabel() {
        lblCorreo.isHidden = true
        lblContraseña.isHidden = true
        lblConfirmar.isHidden = true
    }
}


// MARK: Delegado y protocolos para UITextField
extension RegisterController: UITextFieldDelegate {
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if txtConfirmar.text! != txtContraseña.text! {
            txtConfirmar.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblConfirmar.isHidden = false
            lblConfirmar.text = "Deben coincidir la contraseña en ambos campos!!"
            txtContraseña.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
        } else if txtConfirmar.text! != "" && txtContraseña.text! != "" && txtConfirmar.text! == txtContraseña.text! {
            txtConfirmar.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
            txtContraseña.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
            lblConfirmar.isHidden = true
            btnRegistrar.isEnabled = true
        }
    }
}
