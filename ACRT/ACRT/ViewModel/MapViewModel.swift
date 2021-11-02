//
//  MapViewModel.swift
//  ACRT

//        _         ____
//       / \      |  __  \
//      / _ \     | |   \ \      ____     _______
//     / / \ \    | |___/ /    /  ___ \ / __   __ \
//    / /___\ \   |  ___ \    / /          / /
//   / /     \ \  | |   \ \   \ \ ___     / /
//  / /       \ \ | |    \ \   \ ____ /  / /          Team
 
//  Created by ARCT_ZJU_Lab509 on 2021/7/5.

//  Copyright © 2021 Augmented City Reality Toolkit. All rights reserved.

// [MapCoordinateFix] reference: https://cloud.tencent.com/developer/article/1524369?from=article.detail.1524393
//

import SwiftUI
import MapKit
import CoreMotion

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate{
    @Published var mapView = MKMapView()
    
    @Published var region: MKCoordinateRegion!
    
    // MARK: User Authorization
    @Published var permissionDenied = true
    
    @Published var locationManager = CLLocationManager()
    
    @Published var capabilitySatisfied = "requireNotDetermine"
    
    //MARK: For prepareView
    let indicatorImageName = "LocateRequire"
    let indicatorTitle = "Open Map Service"
    let indicatorDescription = "ARCT will use your position to minimize the locate process time."
    
    // MARK: Coordinate Fix Section
    // WGS-84：international standard，GPS from Google Earth Apple Map
    // GCJ-02：Chinese standard，GPS from Google Map、Gaode、Tensen
    let  a = 6378245.0;
    let  ee = 0.00669342162296594323;
    let  pi = 3.14159265358979324;
    let  xPi = .pi  * 3000.0 / 180.0;
    // WGS-84 -> GCJ-02
    func transformFromWGSToGCJ(wgsLoc:CLLocationCoordinate2D)->CLLocationCoordinate2D{
        var adjustLoc=CLLocationCoordinate2D();
        if( isLocationOutOfChina(location: wgsLoc))
        {
            adjustLoc = wgsLoc;
        }
        else
        {
            var adjustLat = transformLatWithX(x: wgsLoc.longitude - 105.0 ,
                                              y: wgsLoc.latitude - 35.0);
            var adjustLon = transformLonWithX(x: wgsLoc.longitude - 105.0 ,
                                              y: wgsLoc.latitude - 35.0);
            let radLat = wgsLoc.latitude / 180.0 * pi;
            var magic = sin(radLat);
            magic = 1 - ee * magic * magic;
            let sqrtMagic = sqrt(magic);
            adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
            adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
            adjustLoc.latitude = wgsLoc.latitude + adjustLat;
            adjustLoc.longitude = wgsLoc.longitude + adjustLon;
        }
        return adjustLoc;
    }
    
    // is Locate out of China
    func isLocationOutOfChina(location:CLLocationCoordinate2D) -> Bool{
        if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271){
            return true;
        }else{
            return false;
        }
    }
    
    // Calculate Latitude
    func transformLatWithX(x:Double,y:Double)->Double{
        var lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y ;
        lat += 0.2 * sqrt(fabs(x));
        
        lat += (20.0 * sin(6.0 * x * pi)) * 2.0 / 3.0;
        lat += (20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
        lat += (20.0 * sin(y * pi)) * 2.0 / 3.0;
        lat += (40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
        lat += (160.0 * sin(y / 12.0 * pi)) * 2.0 / 3.0;
        lat += (320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
        return lat;
     }
    
    func transformLonWithX(x:Double,y:Double)->Double{
        var lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y ;
        lon +=  0.1 * sqrt(fabs(x));
        lon += (20.0 * sin(6.0 * x * pi)) * 2.0 / 3.0;
        lon += (20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
        lon += (20.0 * sin(x * pi)) * 2.0 / 3.0;
        lon += (40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
        lon += (150.0 * sin(x / 12.0 * pi)) * 2.0 / 3.0;
        lon += (300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
        return lon;
    }
    
    override init(){
        super.init()
        locationManager.delegate = self
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .notDetermined:
                // print("The User is not determined yet")
                permissionDenied = true
                capabilitySatisfied = "requireNotDetermine"
                manager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse:
                permissionDenied = false
                capabilitySatisfied = "satisfied"
                manager.requestLocation()
                // print("The User authorized when the App in use")
            case .authorizedAlways:
                permissionDenied = false
                capabilitySatisfied = "satisfied"
                // print("The User authorized Always")
            case.denied:
                permissionDenied = true
                // print("Authorized fail or Never")/// 这种情况下你可以判断是定位关闭还是拒绝,根据locationServicesEnabled方法
            case .restricted:
                permissionDenied = true
                // print("Restricted")
            @unknown default:
                permissionDenied = true
                // print("Unknow error")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    // MARK: Get User Region
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else { return }
        let acculateLocation = transformFromWGSToGCJ(wgsLoc: location.coordinate)
        self.region = MKCoordinateRegion(center: acculateLocation, latitudinalMeters: 1000, longitudinalMeters: 1000)
        // Update the Map
        self.mapView.setRegion(self.region, animated: true)
        // Smooth Animations
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
        
        // create a 3D Camera
        // reference: https://stackoverflow.com/questions/39112250/how-to-enable-mkmapview-3d-view/39246883
        let mapCamera = MKMapCamera()
        mapCamera.centerCoordinate = acculateLocation
        mapCamera.pitch = 60
        mapCamera.centerCoordinateDistance = 500
        mapCamera.heading = 0
        
        mapView.setCamera(mapCamera, animated: true)
        
    }
    
    // MARK: Focus Location
    func focusLocation(){
        guard let _ = region else { return }
        
        mapView.setRegion(region, animated: true)
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
    }
}

