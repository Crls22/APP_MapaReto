//
//  MAPrimerDataViewController.swift
//  APP_MapaReto
//
//  Created by cice on 15/2/17.
//  Copyright © 2017 JC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


// creacion enumeracion

enum MapType : Int {
    case standard = 0
    case hibrido = 1
    case satelite = 2
    
}

class MAPrimerDataViewController: UIViewController {
    
    // mark variables locales
    var locationManager = CLLocationManager()
    
    

    
    // mark otlets:
    
    @IBOutlet weak var myMapa: MKMapView!
    @IBOutlet weak var myDirecciónLBL: UILabel!
    
    @IBOutlet weak var mySeleccionTipoMapa: UISegmentedControl!
    
    // MARK: IBACTIONS
    
    
    @IBAction func myVerMapa(_ sender: AnyObject) {
       
        // creamos un punto en el mapa
      /*  let latitud = 40.229925
        let longitud = -3.750911
        
        // creamos el zoom
        let latDelta = 0.001
        let longDelta = 0.001
        
        // unimos la localizacion y el zoom
        
        let location = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
        let region = MKCoordinateRegion(center: location, span: span)*/
        
       let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:40.229925, longitude: -3.750911), span: MKCoordinateSpan(latitudeDelta: 0.001 , longitudeDelta: 0.001))
        
        myMapa.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: 40.229925, longitude: -3.750911)
        annotation.title = "Esta es mi casa"
        annotation.subtitle = "estamos estudiando hasta las 3"
        myMapa.addAnnotation(annotation)
      
      }
    

  
    @IBAction func myTipoMapaCambiadoACTION(_ sender: AnyObject) {
        let mapType = MapType(rawValue: mySeleccionTipoMapa.selectedSegmentIndex)
        switch mapType! {
        case .standard:
            myMapa.mapType = .standard
        case .hibrido:
            myMapa.mapType = .hybrid
        case .satelite:
            myMapa.mapType = .satellite
            break
        }
        
    }
 


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // fase de precision del gps -> CoreLocation
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()

      
        //gesto de reconocimiento
        let longPressGestureRecoignizerCustom = UILongPressGestureRecognizer(target: self, action: #selector(self.actionGestureRecognizer(_:)))
        longPressGestureRecoignizerCustom.minimumPressDuration = 2
        myMapa.addGestureRecognizer(longPressGestureRecoignizerCustom)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // MARK: UTILS
    
     func actionGestureRecognizer(_ gesture : UIGestureRecognizer){
     
        
     if gesture.state == UIGestureRecognizerState.began{
        
     let puntoToquePantalla = gesture.location(in: myMapa)
     let nuevaCoordenada = myMapa.convert(puntoToquePantalla, toCoordinateFrom: myMapa)
     let annotation = MKPointAnnotation()
     annotation.coordinate = nuevaCoordenada
     annotation.title = "Nuevo punto en el mapa"
     annotation.subtitle = "Seguimos currando en ios"
     myMapa.addAnnotation(annotation)
        
    }

}

}




extension MAPrimerDataViewController : CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation = locations.first!
        
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1 , longitudeDelta: 0.1))
        
        myMapa.setRegion(region, animated: true)
        myDirecciónLBL.text = "\(userLocation)"
        
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = userLocation.coordinate
        annotation.title = "Titulo por defecto"
        annotation.subtitle = "Subtitulo por defecto"
        myMapa.addAnnotation(annotation)
        
        
    }
    
    
    
}
