//
//  GetDepartamentosController.swift
//  AMaldonadoECommerce
//
//  Created by MacBookMBA15 on 24/05/23.
//

import UIKit

class GetDepartamentosController: UIViewController {

    //Outlet
    @IBOutlet weak var cvDepartamentos: UICollectionView!
    
    // Variables
    var departamentos: [Departamento] = []
    var IdDepartamento: Int = 0
    var IdArea: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UpdateData()
        
        cvDepartamentos.dataSource = self
        cvDepartamentos.delegate = self
        registerCelda()
        
        // Do any additional setup after loading the view.
    }

    private func UpdateData() {
        let result = DepartamentoViewModel.GetByIdArea(idArea: IdArea)
        
        departamentos.removeAll()
        if result.Correct! {
            for objDep in result.Objects! {
                let dep = objDep as! Departamento
                departamentos.append(dep)
            }
        }
    }
}

extension GetDepartamentosController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.departamentos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "AreaDepCell", for: indexPath) as? AreaDepCell {
            celda.lblNombre.text = departamentos[indexPath.row].Nombre!
            celda.ivIcono.image = UIImage(named: departamentos[indexPath.row].Nombre!)
            return celda
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selecciono la celda #\(indexPath.item)!")
        IdDepartamento = departamentos[indexPath.row].Id!
        print("El id del departamento es #\(IdDepartamento)")
        
        performSegue(withIdentifier: "toProductosByDep", sender: self)
    }
    
    private func registerCelda() {
        let celda = UINib(nibName: "AreaDepCell", bundle: nil)
        
        self.cvDepartamentos.register(celda, forCellWithReuseIdentifier: "AreaDepCell")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let segue = segue.destination as! GetProductosByDepController
        segue.IdDepartamento = self.IdDepartamento
    }
}
