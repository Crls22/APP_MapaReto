//
//  MADatosAlfanumericosViewController.swift
//  APP_MapaReto
//
//  Created by cice on 15/2/17.
//  Copyright © 2017 JC. All rights reserved.
//

import UIKit
import CoreLocation

class MADatosAlfanumericosViewController: UIViewController {
    
    // variables locales
    
    var locationmanager = CLLocationManager()
    
    
    
    // mark : ibotulets
    
    @IBOutlet weak var myLatitudLBL: UILabel!
    @IBOutlet weak var myLongitudLBL: UILabel!
    @IBOutlet weak var myRumboLBL: UILabel!
    @IBOutlet weak var myVelocidadLBL: UILabel!
    @IBOutlet weak var myAltitudLBL: UILabel!
    @IBOutlet weak var myDireccionCercanaLBL: UILabel!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     locationmanager.desiredAccuracy = kCLLocationAccuracyBest
     locationmanager.delegate = self
     locationmanager.requestWhenInUseAuthorization()
     locationmanager.startUpdatingLocation()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


extension MADatosAlfanumericosViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let userLocation = locations.first{
            
            // actualizamos nuestra localización
            
            myLatitudLBL.text = "\(userLocation.coordinate.latitude)"
            myLongitudLBL.text = "\(userLocation.coordinate.longitude)"
            myRumboLBL.text = "\(userLocation.course)"
            myVelocidadLBL.text = "\(userLocation.speed)"
            myAltitudLBL.text = "\(userLocation.altitude)"

           
            // grupo de geocodificacion inversa
            
            CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) in
                if error == nil{
                    if let placemarkData = placemarks?[0]{
                        var direccion = ""
                        direccion += self.addInfoIfExist(placemarkData.thoroughfare)
                        direccion += self.addInfoIfExist(placemarkData.subThoroughfare)
                        direccion += self.addInfoIfExist(placemarkData.subLocality)
                        direccion += self.addInfoIfExist(placemarkData.subAdministrativeArea)
                        direccion += self.addInfoIfExist(placemarkData.postalCode)
                        direccion += self.addInfoIfExist(placemarkData.country)
                        direccion += self.addInfoIfExist(placemarkData.locality)
                        
                        self.myDireccionCercanaLBL.text = direccion
                        
                    }
                    
                }else{
                    
                        print(error?.localizedDescription as Any)
                    
                }
            })
            
            
        }
        
        
    }

   // creamos una funcion para trabajar mejor la gestión de datos
    func addInfoIfExist(_ info: String?) -> String{
        // 
        if info != nil{
            return "\(info!) \n"
        }else{
        return ""
    }
    
        
}
    
    
    
    
}
    

