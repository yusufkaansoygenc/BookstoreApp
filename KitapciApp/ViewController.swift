//
//  ViewController.swift
//  KitapciApp
//
//  Created by Yusuf Kaan Soygenç on 3.06.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var idDizisi = [UUID]()
    var kitapAdiDizisi = [String]()
    var secilenKitap = ""
    var secilenUUID : UUID?
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        self.title = "Kitaplık"
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(eklemeButtonTiklandi))
        
        verileriAl()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(verileriAl), name: NSNotification.Name("veriGirildi"), object: nil)
    }
    

    
    @objc func verileriAl() {
        
        kitapAdiDizisi.removeAll()
        idDizisi.removeAll()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Kitapci")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let sonuclar = try context.fetch(fetchRequest)
            if sonuclar.count > 0 {
                
                for sonuc in sonuclar as! [NSManagedObject] {
                    
                    if let kitapAdi = sonuc.value(forKey: "kitapAdi") as? String {
                        kitapAdiDizisi.append(kitapAdi)
                    }
                    
                    if let id = sonuc.value(forKey: "id") as? UUID {
                        idDizisi.append(id)
                    }
                }
                
                tableView.reloadData()
                
            }
            
        } catch {
            print("Hata")
        }
        
        
    }
    

    
    @objc func eklemeButtonTiklandi() {
        
        performSegue(withIdentifier: "toKayitVC", sender: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return kitapAdiDizisi.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = UITableViewCell()
        cell.textLabel?.text = kitapAdiDizisi[indexPath.row]
        return cell
    }
    
 
      
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toKitapVC" {
            let destinationVC = segue.destination as! KitapViewController
            destinationVC.secilenKitapAdi = secilenKitap
            destinationVC.secilenKitapUUID = secilenUUID
        }
            
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        secilenKitap = kitapAdiDizisi[indexPath.row]
        secilenUUID = idDizisi[indexPath.row]
        performSegue(withIdentifier: "toKitapVC", sender: nil)
        
    }
    
    
    
    
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Kitapci")
            let uuidString = idDizisi[indexPath.row].uuidString
            
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let sonuclar = try context.fetch(fetchRequest)
                if sonuclar.count > 0 {
                    
                    for sonuc in sonuclar as! [NSManagedObject] {
                        
                        if let id = sonuc.value(forKey: "id") as? UUID {
                            if id == idDizisi[indexPath.row] {
                                
                                context.delete(sonuc)
                                kitapAdiDizisi.remove(at: indexPath.row)
                                idDizisi.remove(at: indexPath.row)
                                
                                self.tableView.reloadData()
                                do {
                                    try context.save()
                                } catch {
                                    
                                }
                                
                                break
                            }
                        }
                        
                    }
                }
                
            } catch {
                print("Hata Var")
                
            }
            
        }
            
            
    }


}

