//
//  PhotoMapViewController.swift
//  Photo Map
//
//  Created by Luis Mendez on 10/16/18.
//  Copyright © 2018 Luis Mendez. All rights reserved.
//

import UIKit
import MapKit

class PhotoMapViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LocationsViewControllerDelegate, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cameraBtn: UIButton!
    
    var imageToUse: UIImage! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTitleInNavBar()
        
        /*********To be able to call its functions*******/
        mapView.delegate = self
        
        //one degree of latitude is approximately 111 kilometers (69 miles) at all times.
        let sfRegion = MKCoordinateRegion(center: CLLocationCoordinate2DMake(37.783333, -122.416667), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(sfRegion, animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /************************
     * MY CREATED FUNCTIONS *
     ************************/
    func setTitleInNavBar(){
        
        let titleLabel = UILabel()//for the title of the page
        
        //set some attributes for the title of this controller
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
            .strokeColor : UIColor.white,
            .foregroundColor : UIColor(cgColor: #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)),  /*UIColor(red: 0.5, green: 0.25, blue: 0.15, alpha: 0.8)*/
            .strokeWidth : -1,
            .font : UIFont.boldSystemFont(ofSize: 23)
        ]
        
        //NSMutableAttributedString(string: "0", attributes: strokeTextAttributes)
        //set the name and put in the attributes for it
        let titleText = NSAttributedString(string: "Photo Map", attributes: strokeTextAttributes)
        
        //adding the titleText
        titleLabel.attributedText = titleText
        titleLabel.sizeToFit()
        navigationItem.titleView = titleLabel
    }
    
    private func resize(image: UIImage, newSize: CGSize) -> UIImage {
        
        let resizeImageView = UIImageView(frame: CGRect(x:0, y:0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIView.ContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /****************************
     * PICKERDELEGATE FUNCTIONS *
     ****************************/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // Get the image captured by the UIImagePickerController
        //Set image as UIImage if all good then set it to our image variable
        if let editedImage = info[.editedImage] as? UIImage {
            print("editedImage was taken")
            //set the image size in terms of width and height, will be equal to almost 5MB, what I want
            let size = CGSize(width: 1000, height: 1000)
            
            //resize image to be less than 1MB
            let imageEdited = resize(image: editedImage, newSize: size)
            imageToUse = imageEdited
            
        } else if let image = info[.originalImage] as? UIImage {
            print("Original Image was taken")
            
            //set the image size in terms of width and height, will be equal to almost 1MB, what I want
            let size = CGSize(width: 1000, height: 1000)
            
            //resize image to be less than 1MB
            let img = resize(image: image, newSize: size)
            
            //put it in the image view
            imageToUse = img
            
        } else {
            //Error Message
            print("There was an error uploading image to VC")
        }
        
        // Do something with the images (based on your use case)
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true){
            self.performSegue(withIdentifier: "tagSegue", sender: nil)
        }
    }
    
    @IBAction func showCamera(_ sender: Any) {
        
        let vc = UIImagePickerController()
        vc.delegate = self
        vc.allowsEditing = false
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            print("Camera is available 📸")
            vc.sourceType = .camera
        } else {
            print("Camera 🚫 available so we will use photo library instead")
            //image will be dragged from photoLibrary
            vc.sourceType = .photoLibrary
        }
        
        self.present(vc, animated: true, completion: nil)
    }
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        
        //to get location to tag image with
        if segue.identifier == "tagSegue"  {
            let destinationVC = segue.destination as! LocationsViewController
            destinationVC.delegate = self
            
        } else  {//to see full image size
            let destinationVC = segue.destination as! FullImageViewController
            print("In PhotoVC: \(String(describing: imageToUse))")
            destinationVC.imageToUse = self.imageToUse
        }
    }
    
    func locationsPickedLocation(controller: LocationsViewController, latitude: NSNumber, longitude: NSNumber) {
        
        self.navigationController?.popToViewController(self, animated: true)
        
        let locationCoordinate = CLLocationCoordinate2DMake(CLLocationDegrees(truncating: latitude), CLLocationDegrees(truncating: longitude))
        
        let annotation = PhotoAnnotation()
        annotation.coordinate = locationCoordinate
        annotation.photo = imageToUse
        mapView.addAnnotation(annotation)
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseID = "myAnnotationView"

        // custom view annotation
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID)
        
        let label = UILabel(frame: CGRect(x:0, y:0, width:500, height:50))
        label.backgroundColor = .red
        annotationView?.addSubview(label)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView?.backgroundColor = .red

            let resizeRenderImageView = UIImageView(frame: CGRect(x:0, y:0, width:50, height:50))
            resizeRenderImageView.layer.borderColor = #colorLiteral(red: 0.8153101802, green: 0.8805506825, blue: 0.8921775818, alpha: 0.92)
            resizeRenderImageView.layer.borderWidth = 3.0
            resizeRenderImageView.contentMode = UIView.ContentMode.scaleAspectFill
            resizeRenderImageView.image = imageToUse

            annotationView!.leftCalloutAccessoryView = resizeRenderImageView

            let detailBtn = UIButton(type: UIButton.ButtonType.detailDisclosure)
            detailBtn.frame = CGRect(x:0, y:0, width: 50, height: 50)
            detailBtn.tintColor = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
            detailBtn.backgroundColor = #colorLiteral(red: 0.8153101802, green: 0.8805506825, blue: 0.8921775818, alpha: 0.92)
            annotationView!.rightCalloutAccessoryView = detailBtn
            detailBtn.addTarget(self, action: #selector(goToFullImage), for: .touchUpInside)
        }
        else {
            annotationView!.annotation = annotation
        }
        
        // Resize image
        let pinImage = imageToUse
        let size = CGSize(width: 40, height: 40)
        UIGraphicsBeginImageContext(size)
        pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        annotationView?.image = resizedImage
        
        return annotationView
    }
    
    @objc func goToFullImage(){
        performSegue(withIdentifier: "fullImageSegue", sender: nil)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        // do something
    }
    
}
