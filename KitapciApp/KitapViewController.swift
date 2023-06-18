//
//  KitapViewController.swift
//  KitapciApp
//
//  Created by Yusuf Kaan Soygenç on 3.06.2023.
//

import UIKit
import CoreData

class KitapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var kitapAdiLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var yazarAdiLbl: UILabel!
    @IBOutlet weak var yayineviLbl: UILabel!
    @IBOutlet weak var fiyatLbl: UILabel!
    @IBOutlet weak var sayfaSayisiLbl: UILabel!
    @IBOutlet weak var kategoriLbl: UILabel!
    @IBOutlet weak var dilLbl: UILabel!
    @IBOutlet weak var basimYiliLbl: UILabel!
    @IBOutlet weak var barkodLbl: UILabel!
    
    var secilenKitapAdi = ""
    var secilenKitapUUID : UUID?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let uuidString = secilenKitapUUID?.uuidString {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Kitapci")
            fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let sonuclar = try context.fetch(fetchRequest)
                if sonuclar.count > 0 {
                    for sonuc in sonuclar as! [NSManagedObject] {
                        
                        if let kitapAdi = sonuc.value(forKey: "kitapAdi") as? String {
                            kitapAdiLbl.text = kitapAdi
                        }
                        
                        if let yazarAdi = sonuc.value(forKey: "yazarAdi") as? String {
                            yazarAdiLbl.text = yazarAdi
                        }
                        
                        if let yayinevi = sonuc.value(forKey: "yayinevi") as? String {
                            yayineviLbl.text = yayinevi
                        }
                        
                        if let sayfaSayisi = sonuc.value(forKey: "sayfaSayisi") as? String {
                            sayfaSayisiLbl.text = ": " + sayfaSayisi
                        }
                        
                        if let kategori = sonuc.value(forKey: "kategori") as? String {
                            kategoriLbl.text = ": " + kategori
                        }
                        
                        if let dil = sonuc.value(forKey: "dil") as? String {
                            dilLbl.text = ": " + dil
                        }
                        
                        if let baskiYili = sonuc.value(forKey: "baskiYili") as? String {
                            basimYiliLbl.text = ": " + baskiYili
                        }
                        
                        if let barkod = sonuc.value(forKey: "barkod") as? String {
                            barkodLbl.text = ": " + barkod
                        }
                        
                        if let fiyat = sonuc.value(forKey: "fiyat") as? Int {
                            fiyatLbl.text = String(fiyat) + " TL"
                        }
                        
                        if let gorselData = sonuc.value(forKey: "kitapResmi") as? Data {
                            let image = UIImage(data: gorselData)
                            imageView.image = image
                        }
                        
                    }
                }
            } catch {
                print("hata var")
            }
            
        }
        
    }
    



}
