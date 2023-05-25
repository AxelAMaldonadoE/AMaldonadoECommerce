//
//  GetAllAreaController.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 23/05/23.
//

import UIKit

class GetAllAreaController: UIViewController {

    // Outlets
    @IBOutlet weak var cvAreas: UICollectionView!
    @IBOutlet weak var txtBusqueda: UITextField!
    
    // Variables
    let reuseIdentifier = "AreaDepCell"
    var areas: [Area] = []
    var IdArea: Int = 0
    
    var strBuscar: String? = nil
    var Buscar: Bool = false// Bandera para saber si se prepara segue para departamento o busqueda
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateData()
        
        cvAreas.dataSource = self
        cvAreas.delegate = self
        registerCelda()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        txtBusqueda.text = ""
    }
    
    @IBAction func btnBuscar() {
        guard txtBusqueda.text! != "" else {
            let alert = UIAlertController(title: "Notificacion", message: "Debes ingresar al menos una letra en el campo!!", preferredStyle: .alert)
            let action = UIAlertAction(title: "Aceptar", style: .default)
            
            alert.addAction(action)
            self.present(alert, animated: true)
            return
        }
        
        strBuscar = txtBusqueda.text!
        Buscar = true
        performSegue(withIdentifier: "toProductoByBuscar", sender: self)
    }
    
    @IBAction func unwindToGetAreas(_ unwindSegue: UIStoryboardSegue) {
        let _ = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
    
    private func UpdateData() {
        let result = AreaViewModel.GetAll()
        areas.removeAll()
        if result.Correct! {
            for objArea in result.Objects! {
                let area = objArea as! Area
                areas.append(area)
            }
        }
    }
    
}

// MARK: Extension UICollectionView

extension GetAllAreaController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.areas.count
    }
    
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as? AreaDepCell {
            cell.lblNombre.text = self.areas[indexPath.row].Nombre
            cell.ivIcono.image = UIImage(named: self.areas[indexPath.row].Nombre!)
            return cell
        }
        
        return UICollectionViewCell()
        
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // handle tap events
        print("You selected cell #\(indexPath.item)!")
        IdArea = areas[indexPath.row].Id!
        print("El id del Area es #\(IdArea)")
        Buscar = false
        performSegue(withIdentifier: "toDepartamentos", sender: self)
    }
    
    private func registerCelda() {
        let celda = UINib(nibName: "AreaDepCell", bundle: nil)
        cvAreas.register(celda, forCellWithReuseIdentifier: "AreaDepCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if Buscar {
            let segue = segue.destination as! GetProductosByDepController
            segue.strBusqueda = self.strBuscar!
        } else {
            let segue = segue.destination as! GetDepartamentosController
            segue.IdArea = self.IdArea
        }
    }
}
