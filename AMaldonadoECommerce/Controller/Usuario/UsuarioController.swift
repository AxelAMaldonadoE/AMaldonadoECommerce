//
//  ViewController.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 27/04/23.
//

import UIKit
import DropDown

class UsuarioController: UIViewController {

    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtApellidoPaterno: UITextField!
    @IBOutlet weak var txtApellidoMaterno: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var dpFechaNacimiento: UIDatePicker!
    @IBOutlet weak var txtIdRol: UITextField!
    @IBOutlet weak var lbNombre: UILabel!
    @IBOutlet weak var lbApellidoPaterno: UILabel!
    @IBOutlet weak var lbApellidoMaterno: UILabel!
    @IBOutlet weak var lbUsername: UILabel!
    @IBOutlet weak var lbPassword: UILabel!
    @IBOutlet weak var lbIdRol: UILabel!
    @IBOutlet weak var btnActions: UIButton!
    
    let dropDown = DropDown()
    
    
    var IdUsuario : Int = 0
    var IdRol : Int = 0
    var ListaRoles : [Rol]? = nil
    
    let db = DBManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        btnGetAll()
        
        OcultarLabel()
        ConfigurarDropDown()
        print("El id del usuario es \(IdUsuario)")
        if IdUsuario != 0 {
            GetById(idUsuario: IdUsuario)
            btnActions.setTitle("Actualizar", for: .normal)
        } else {
            print("No debo llenar el formulario")
            btnActions.setTitle("Agregar", for: .normal)
            btnActions.tintColor = UIColor(red: 55/255, green: 146/255, blue: 55/255, alpha: 1.0)
        }

    }

    
    @IBAction func actionIdRol(_ sender: UITextField) {
        dropDown.show()
    }
    
    @IBAction func ActionButtons(_ sender: UIButton) {
        
        guard txtNombre.text != "" else {
            txtNombre.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lbNombre.isHidden = false
            return
        }
        txtNombre.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lbNombre.isHidden = true
        
        guard txtApellidoPaterno.text != "" else {
            txtApellidoPaterno.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lbApellidoPaterno.isHidden = false
            return
        }
        txtApellidoPaterno.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lbApellidoPaterno.isHidden = true
        
        guard txtApellidoMaterno.text != "" else {
            txtApellidoMaterno.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lbApellidoMaterno.isHidden = false
            return
        }
        txtApellidoMaterno.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lbApellidoMaterno.isHidden = true
        
        guard txtUsername.text != "" else {
            txtUsername.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lbUsername.isHidden = false
            return
        }
        txtUsername.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lbUsername.isHidden = true
        
        guard txtPassword.text != "" else {
            txtPassword.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lbPassword.isHidden = false
            return
        }
        txtPassword.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lbPassword.isHidden = true
        
        guard txtIdRol.text != "" else {
            txtIdRol.backgroundColor = UIColor(red: 211/255, green: 10/255, blue: 4/255, alpha: 0.20)
            lbIdRol.isHidden = false
            return
        }
        txtIdRol.backgroundColor = UIColor(red: 156/255, green: 255/255, blue: 46/255, alpha: 0.20)
        lbIdRol.isHidden = true
        
        let opcion = btnActions.titleLabel?.text
        if opcion == "Agregar" {
            let usuario = Usuario()
            usuario.Nombre = txtNombre.text!
            usuario.ApellidoPaterno = txtApellidoPaterno.text!
            usuario.ApellidoMaterno = txtApellidoMaterno.text!
            usuario.Username = txtUsername.text!
            usuario.Password = txtPassword.text!
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd/MM/yyyy"
            usuario.FechaNacimiento = dateFormater.string(from: dpFechaNacimiento.date)
            
            usuario.Rol = Rol()
            usuario.Rol?.Id = IdRol
    //        usuario.FechaNacimiento = dpFechaNacimiento.date.formatted(date: .abbreviated, time: .omitted)
            let result = UsuarioViewModel.Add(usuario: usuario)
            if (result.Correct == true) {
                let alert = UIAlertController(title: "Notificacion", message: "El usuario se agrego correctamente", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                    print("Me regreso a la lista!!")
                    //self.dismiss(animated: true)
                    self.performSegue(withIdentifier: "unwindFromFormUsuario", sender: self)
                }
                alert.addAction(action)
                present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Notificacion", message: result.ErrorMessage!, preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                    print("Me regreso a la lista!!")
                }
                alert.addAction(action)
                present(alert, animated: true)
                print(result.ErrorMessage!)
            }
            
        } else if opcion == "Actualizar" {
            let usuario = Usuario()
            usuario.Nombre = txtNombre.text!
            usuario.ApellidoPaterno = txtApellidoPaterno.text!
            usuario.ApellidoMaterno = txtApellidoMaterno.text!
            usuario.Username = txtUsername.text!
            usuario.Password = txtPassword.text!
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd/MM/yyyy"
            usuario.FechaNacimiento = dateFormater.string(from: dpFechaNacimiento.date)
    //        usuario.FechaNacimiento = dpFechaNacimiento.date.formatted(date: .long, time: .omitted)
            
            usuario.Rol = Rol()
            usuario.Rol?.Id = IdRol
            
            usuario.Id = IdUsuario
            let result = UsuarioViewModel.Update(usuario: usuario)
            if (result.Correct == true) {
                print("Los datos fueron actualizados correctamente!")
                let alert = UIAlertController(title: "Notificacion", message: "El usuario se actualizo correctamente", preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                    print("Me regreso a la lista!!")
                    //self.dismiss(animated: false)
                    self.performSegue(withIdentifier: "unwindFromFormUsuario", sender: self)
                }
                alert.addAction(action)
                present(alert, animated: true)
            } else {
                let alert = UIAlertController(title: "Notificacion", message: result.ErrorMessage!, preferredStyle: .alert)
                let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                    print("Me regreso a la lista!!")
                }
                alert.addAction(action)
                present(alert, animated: true)
                print(result.ErrorMessage!)
            }
        }
    }

    private func ConfigurarDropDown() {
        dropDown.anchorView = txtIdRol
//        dropDown.dataSource = ["Administrador", "Cliente", "Vendedor"]
        let result = RolViewModel.GetAll()
        if result.Correct! {
            
            ListaRoles = []
            
            for objRol in result.Objects! {
                let rol = objRol as! Rol
                ListaRoles?.append(rol)
            }
            
            for obj in ListaRoles! {
                dropDown.dataSource.append(obj.Nombre!)
            }
            
            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
                txtIdRol.text = item
                IdRol = ListaRoles![index].Id!
                print("El Id del Rol es \(IdRol)")
                
            }
        } else {
            let alert = UIAlertController(title: "Notificacion", message: result.ErrorMessage!, preferredStyle: .alert)
            let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                self.performSegue(withIdentifier: "unwindFromFormUsuario", sender: self)
                print("Me regreso a la lista!!")
            }
            alert.addAction(action)
            present(alert, animated: true)
            
        }
    }
        
    func GetById(idUsuario: Int) {
        let result = UsuarioViewModel.GetById(idUsuario: idUsuario)
        if (result.Correct == true) {
            let usuario = result.Object as! Usuario
            txtNombre.text = usuario.Nombre!
            txtApellidoPaterno.text = usuario.ApellidoPaterno
            txtApellidoMaterno.text = usuario.ApellidoMaterno
            txtUsername.text = usuario.Username!
            txtPassword.text = usuario.Password!
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd/MM/yyyy"
            dpFechaNacimiento.date = dateFormater.date(from: usuario.FechaNacimiento!)!
            IdRol = usuario.Rol!.Id!
            txtIdRol.text = usuario.Rol!.Nombre!
            
            //dpFechaNacimiento.date = usuario.FechaNacimiento!
        } else {
            let alert = UIAlertController(title: "Notificacion", message: result.ErrorMessage!, preferredStyle: .alert)
            let action = UIAlertAction(title: "Aceptar", style: .default) { (action) -> Void in
                self.performSegue(withIdentifier: "unwindFromFormUsuario", sender: self)
                print("Me regreso a la lista!!")
            }
            alert.addAction(action)
            present(alert, animated: true)
        }
    }
    
    func OcultarLabel() {
        lbNombre.isHidden = true
        lbApellidoPaterno.isHidden = true
        lbApellidoMaterno.isHidden = true
        lbUsername.isHidden = true
        lbPassword.isHidden = true
        lbIdRol.isHidden = true
    }
    
//    @IBAction func accionButtons(_ sender: UIButton) {
//
//    }
    
    
}

