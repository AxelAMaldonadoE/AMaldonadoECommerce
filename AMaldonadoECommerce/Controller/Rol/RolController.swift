//
//  RolController.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 09/05/23.
//

import UIKit

class RolController: UIViewController {

    @IBOutlet weak var btnActions: UIButton!
    @IBOutlet weak var lblNombre: UILabel!
    @IBOutlet weak var txtNombre: UITextField!
    
    var IdRol: Int = 0
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        txtNombre.delegate = self
        self.dismissKeyboard()

        lblNombre.isHidden = true
        if IdRol != 0 {
            GetById(idRol: IdRol)
            btnActions.setTitle("Actualizar", for: .normal)
        } else {
            btnActions.setTitle("Agregar", for: .normal)
            btnActions.tintColor = UIColor(red: 55/255, green: 146/255, blue: 55/255, alpha: 1.0)
        }
        
    }
    
    @IBAction func ActionButton(_ sender: UIButton) {
        guard txtNombre.text != "" else {
            txtNombre.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lblNombre.isHidden = false
            return
        }
        txtNombre.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lblNombre.isHidden = true
        
        let opcion = btnActions.titleLabel?.text
        if opcion == "Agregar" {
            let rol = Rol()
            rol.Nombre = txtNombre.text!
            
            let result = RolViewModel.Add(rol: rol)
            if result.Correct! {
                let alert = UIAlertController(title: "Notificacion", message: "El rol se agrego correctamente", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default) {(action) -> Void in
                    self.performSegue(withIdentifier: "unwindFromFormRol", sender: self)
                }
                alert.addAction(action)
                present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Notificacion", message: result.ErrorMessage!, preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default)
                alert.addAction(action)
                present(alert, animated: true)
            }
        }
        if opcion == "Actualizar" {
            let rol = Rol()
            rol.Nombre = txtNombre.text!
            rol.Id = IdRol
            
            let result = RolViewModel.Update(rol: rol)
            if result.Correct! {
                let alert = UIAlertController(title: "Notificacion", message: "El rol se actualizo correctamente", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                    self.performSegue(withIdentifier: "unwindFromFormRol", sender: self)
                }
                alert.addAction(action)
                present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Notificacion", message: result.ErrorMessage!, preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default)
                alert.addAction(action)
                present(alert, animated: true)
            }
        }
    }
    
    func GetById(idRol: Int) {
        let result = RolViewModel.GetById(idRol: idRol)
        if (result.Correct == true) {
            let rol = result.Object as! Rol
            txtNombre.text = rol.Nombre!
        } else {
            
        }
    }
}

    // MARK: Funcion para hide keyboard

extension UIViewController {
func dismissKeyboard() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer( target:     self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }
}

    //MARK: Extension delegate del UITextFieldDelegate

extension RolController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
        print("Se comenzo a usar el text field")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("Se presiono el boton intro")
        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
         nextField.becomeFirstResponder()
         } else {
         textField.resignFirstResponder()
         }
         return false
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        print("Se dejo de usar el textField")
    }
}
