//
//  ViewController.swift
//  Mapas
//
//  Created by fran on 24/3/22.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    
    enum TipoMapa: Int {
        case mapa = 0
        case satelite
    }
    
    var pulsacionPin: Int = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*let map = MKMapView(frame:
                                        CGRect(x: 0, y: 0,
                                               width: self.view.frame.width,
                                               height: self.view.frame.height))
        self.view.addSubview(map)
        map.delegate = self*/
        
    }

    @IBOutlet weak var mapView: MKMapView!{
        didSet {
                    mapView.mapType = .standard
                    mapView.delegate = self
                    let alicanteLocation =
                        CLLocationCoordinate2D(latitude: 38.3453,
                                               longitude: -0.4831)
                    
            centerMapOnLocation(mapView: mapView, loc: alicanteLocation)
                }
    }
    
    // Centramos el mapa en la posición pasada por parámetro
        func centerMapOnLocation(mapView: MKMapView, loc: CLLocationCoordinate2D) {
            let regionRadius: CLLocationDistance = 4000
            let coordinateRegion =
            MKCoordinateRegion(center: loc,
                                           latitudinalMeters: regionRadius,
                                           longitudinalMeters: regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
            let pin = Pin(num: pulsacionPin, coordinate: mapView.centerCoordinate)
            mapView.addAnnotation(pin)
            pulsacionPin += 1
        }
    
    @IBAction func seleccion(sender: UISegmentedControl) {
        let tipoMapa = TipoMapa(rawValue: sender.selectedSegmentIndex)!
            switch (tipoMapa) {
                case .mapa:
                    mapView.mapType = MKMapType.standard
                case .satelite:
                    mapView.mapType = MKMapType.satellite
            }
    }
    
    @IBAction func botonPin(_ sender: Any) {
        let pin = Pin(num: pulsacionPin, coordinate: mapView.centerCoordinate)
                mapView.addAnnotation(pin)
        pulsacionPin += 1
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        print("Devolviendo vista para anotación: \(annotation)")
        let pin = annotation as? Pin
        let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)

        view.pinTintColor = UIColor.red
        view.animatesDrop = true
        view.canShowCallout = true
        let thumbnailImageView = UIImageView(frame: CGRect(x:0, y:0, width: 59, height: 59))
        thumbnailImageView.image = pin?.thumbImage
        view.leftCalloutAccessoryView = thumbnailImageView
        view.rightCalloutAccessoryView = UIButton(type:UIButton.ButtonType.detailDisclosure)
        return view;
    }
    
    /*func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            performSegue(withIdentifier: "DetalleImagen", sender: view)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "DetalleImagen" {
                if let pin = (sender as? MKAnnotationView)?.annotation as? Pin {
                    if let vc = segue.destinationViewController as? ImageDetailViewController {
                        // vc.imageDetail = UIImageView(image: pin.thumbImage)
                        vc.imagen = pin.thumbImage
                    }
                }
            }
        }*/
    
}

class Pin:  NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var thumbImage: UIImage
    
    init(num: Int, coordinate: CLLocationCoordinate2D) {
        self.title = "Pin \(num)"
        self.subtitle = "Un bonito lugar"
        self.coordinate = coordinate
        if (num % 2 == 0) {
            self.thumbImage = UIImage(named: "alicante1_par.png")!
        } else {
            self.thumbImage = UIImage(named: "alicante2_impar.png")!
        }
        super.init()
    }
}

