//
//  LoginController.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 22/05/23.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    // Text Field Outlet
    @IBOutlet weak var txtCorreo: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    // Label Outlet
    @IBOutlet weak var lblCorreo: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OcultarLabel()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func Login() {
        guard txtCorreo.text! != "" else {
            txtCorreo.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblCorreo.isHidden = false
            return
        }
        txtCorreo.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblCorreo.isHidden = true
        
        guard txtPassword.text! != "" else {
            txtPassword.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblPassword.isHidden = false
            return
        }
        txtPassword.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblPassword.isHidden = true
        
        let correo = txtCorreo.text!
        let password = txtPassword.text!
        
        Auth.auth().signIn(withEmail: correo, password: password) { authResult, error in
//            var pruebaError = error
//            var pruebaExito = authResult
            
            if let ex = error {
                let alert = UIAlertController(title: "Notifiacion", message: ex.localizedDescription, preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                    self.txtCorreo.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
                    self.txtPassword.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
                }
                alert.addAction(action)
                self.present(alert, animated: true)
                return
            }
            if let result = authResult {
                self.performSegue(withIdentifier: "loginUsuario", sender: self)
            }
            
        }
    }
    
    private func OcultarLabel() {
        lblCorreo.isHidden = true
        lblPassword.isHidden = true
    }
}
