//
//  KayitViewController.swift
//  KitapciApp
//
//  Created by Yusuf Kaan Soygenç on 3.06.2023.
//

import UIKit
import CoreData

class KayitViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var kitapAdiTextField: UITextField!
    @IBOutlet weak var yazarAdiTextField: UITextField!
    @IBOutlet weak var sayfaSayisiTextField: UITextField!
    @IBOutlet weak var yayineviTextField: UITextField!
    @IBOutlet weak var kategoriTextField: UITextField!
    @IBOutlet weak var dilTextField: UITextField!
    @IBOutlet weak var barkodTextField: UITextField!
    @IBOutlet weak var baskiYiliTextField: UITextField!
    @IBOutlet weak var fiyatTextField: UITextField!
    @IBOutlet weak var imageViewKitap: UIImageView!
    
    
    
    @IBOutlet weak var kitapResimLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Kitap Ekle"

        // Do any additional setup after loading the view.
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(klavyeKapat))
        view.addGestureRecognizer(gestureRecognizer)
        
        imageViewKitap.isUserInteractionEnabled = true
        
        
        let imageKitapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gorselSec))
        imageViewKitap.addGestureRecognizer(imageKitapGestureRecognizer)
        
        }
    
    
    
    
    
   func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let kitapImage = info[.originalImage] as? UIImage
        imageViewKitap.image = kitapImage
        print("kitap resmi seçilmiştir")
        kitapResimLabel.text = "✓"
        kitapResimLabel.textColor = .systemGreen
        kitapResimLabel.font = .preferredFont(forTextStyle: .title1)
            
        self.dismiss(animated: true)
        
    }
    

    
    @objc func gorselSec() {
        
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true)
        
    }
    
    
    
    @objc func klavyeKapat() {
        
        view.endEditing(true)
    }
    
    
    @IBAction func ekleButton(_ sender: Any) {
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let contex = appDelegate.persistentContainer.viewContext
        
        let kitapci = NSEntityDescription.insertNewObject(forEntityName: "Kitapci", into: contex)
        
        kitapci.setValue(kitapAdiTextField.text, forKey: "kitapAdi")
        kitapci.setValue(yazarAdiTextField.text, forKey: "yazarAdi")
        kitapci.setValue(sayfaSayisiTextField.text, forKey: "sayfaSayisi")
        kitapci.setValue(kategoriTextField.text, forKey: "kategori")
        kitapci.setValue(yayineviTextField.text, forKey: "yayinevi")
        kitapci.setValue(dilTextField.text, forKey: "dil")
        kitapci.setValue(barkodTextField.text, forKey: "barkod")
        kitapci.setValue(baskiYiliTextField.text, forKey: "baskiYili")
        kitapci.setValue(UUID(), forKey: "id")
        
        if let fiyat = Int(fiyatTextField.text!) {
            kitapci.setValue(fiyat, forKey: "fiyat")
            }
        
        let kitapGorselData = imageViewKitap.image?.jpegData(compressionQuality: 0.5)
        kitapci.setValue(kitapGorselData, forKey: "kitapResmi")
        
        
        do {
            try contex.save()
            print("Veri tabanına kaydedildi")
            
        } catch {
            print("hata var")
        }
        
        
        
        NotificationCenter.default.post(name: NSNotification.Name("veriGirildi"), object: nil)
        
        alertOlustur(titleGirdisi: "Kaydedildi", messageGirdisi: "Kitap Başarılı Bir Şekilde Kütüphaneye Eklendi")
            
        
    }
    
    func alertOlustur(titleGirdisi: String, messageGirdisi: String) {
        
        let uyariMesaji = UIAlertController(title: titleGirdisi, message: messageGirdisi, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default) {
            UIAlertAction in self.navigationController?.popViewController(animated: true)
        }
        
        uyariMesaji.addAction(okButton)
        self.present(uyariMesaji, animated: true)
    }
    

}












