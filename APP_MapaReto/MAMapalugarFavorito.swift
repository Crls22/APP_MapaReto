//
//  MAMapalugarFavorito.swift
//  APP_MapaReto
//
//  Created by cice on 20/2/17.
//  Copyright © 2017 JC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MAMapalugarFavorito: UIViewController {
    
    
    // mark: variabls locales
    
    var locationManager = CLLocationManager()
    var taskManager = APITaskManager.shared

    
    @IBOutlet weak var myMapViewLugaresFavoritos: MKMapView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
  
        
    if customLugarSeleccionado == -1{
   
            // location manager
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.delegate = self
    locationManager.requestWhenInUseAuthorization()
    locationManager.startUpdatingLocation()
    }else{
    
    let customLat = NSString(string: taskManager.latitud[customLugarSeleccionado] ["latitud"]!).doubleValue
       
    let customLong = NSString(string: taskManager.longitud[customLugarSeleccionado]["longitud"]!).doubleValue
    
    let location = CLLocationCoordinate2D(latitude: customLat, longitude: customLong)
    
    let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
    myMapViewLugaresFavoritos.setRegion(region, animated: true)
            
    let customAnnotation = MKPointAnnotation()
    customAnnotation.coordinate = location
    customAnnotation.title = taskManager.latitud[customLugarSeleccionado]["latitud"]
    myMapViewLugaresFavoritos.addAnnotation(customAnnotation)
            
            
            
        }
        
        
        
        let longPressGR = UILongPressGestureRecognizer(target: self, action: #selector(self.actionCreaChincheta(_:)))
        longPressGR.minimumPressDuration = 2
        myMapViewLugaresFavoritos.addGestureRecognizer(longPressGR)
        
        
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // mark utils
    func actionCreaChincheta(_ gesture: UIGestureRecognizer){
       
        if gesture.state == UIGestureRecognizerState.began{
            
            let puntoTocado = gesture.location(in: myMapViewLugaresFavoritos)
            let nuevaCoordenada = myMapViewLugaresFavoritos.convert(puntoTocado, toCoordinateFrom: myMapViewLugaresFavoritos)
            let customLocation = CLLocation(latitude: nuevaCoordenada.latitude, longitude: nuevaCoordenada.longitude)
            
            
            
            CLGeocoder().reverseGeocodeLocation(customLocation) {
                (placemarks, error) in
                var calle = ""
                var numero = ""
                var customTitle = ""
                
                if let customPlacemarks = placemarks?[0]{
                    if customPlacemarks.thoroughfare != nil{
                        calle = customPlacemarks.thoroughfare!
                    }
                    if customPlacemarks.subThoroughfare != nil{
                        numero = customPlacemarks.subThoroughfare!
                    }
                    customTitle = "\(calle) \(numero)"
                    
                }
                if customTitle == ""{
                    customTitle = "Punto añadido el \(Date())"
                    
                }
                
            
                // creamos la anotacion
                let annotation = MKPointAnnotation()
                annotation.coordinate = nuevaCoordenada
                annotation.title = customTitle
                self.myMapViewLugaresFavoritos.addAnnotation(annotation)
                
                // guardamos en nuestro array de diccionarios
                
                customLugares.append(["name": customTitle,
                                      "lat": "\(nuevaCoordenada.latitude)",
                                      "long": "\(nuevaCoordenada.longitude)"])
                
                APITaskManager.shared.latitud.append(["latitud" : String(nuevaCoordenada.latitude)])
                APITaskManager.shared.longitud.append(["longitud" : String(nuevaCoordenada.longitude)])
                
                APITaskManager.shared.salvarDatos()
                
            }
        }
   
        
    }
}

            



extension MAMapalugarFavorito : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations[0]
        let latitud = userLocation.coordinate.latitude
        let longitud = userLocation.coordinate.longitude
        
        let locationData = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        let region = MKCoordinateRegion(center: locationData, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        myMapViewLugaresFavoritos.setRegion(region, animated: true)
        
        
        
    }
    
    
    
}


