//
//  ApiTaskManager.swift
//  APP_MapaReto
//
//  Created by cice on 22/2/17.
//  Copyright © 2017 JC. All rights reserved.
//

import Foundation
import UIKit


class APITaskManager{
    
    let prefs = UserDefaults.standard
    static let shared = APITaskManager()
    
    
    
    var longitud : [diccionario] = [[:]]
    var latitud : [diccionario] = [[:]]
    
    func salvarDatos(){
        prefs.set(latitud, forKey: "latitud")
        prefs.set(longitud, forKey: "longitud")
        
    }
    
    func cargarDatos(){
        if let myArrayLat = prefs.array(forKey: "latitud") as? [diccionario]{
            latitud = myArrayLat
        }
        if let myArrayLon = prefs.array(forKey: "longitud") as? [diccionario]{
            longitud = myArrayLon
        }
        
    }
    
    
    
    
    
}
