//
//  PointObject.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 26/12/2022.
//

import Foundation
import MapKit

class PointObject: MKAnnotationView {
  override var annotation: MKAnnotation? {
    willSet {
      guard let objectImage = newValue as? Object else {
        return
      }
     let imageView = CustomUIimageView(frame: .zero)
     imageView.loadImage(with: objectImage.objectImage ?? "")
        
        canShowCallout = true
        calloutOffset = CGPoint(x: -5, y: 5)
        let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero,size: CGSize(width: 48, height: 48)))
        mapsButton.setBackgroundImage(imageView.image, for: .normal)
        rightCalloutAccessoryView = mapsButton
        
        let detailLabel =  UILabel ()
        detailLabel.numberOfLines =  0
        detailLabel.font = detailLabel.font.withSize( 12 )
        detailLabel.text = objectImage.subtitle
        detailCalloutAccessoryView = detailLabel
        
        let imPoint = UIImage.circle(diameter: 50, color: .clear)
       
        image = imPoint
    

     //   let size = CGSize(width: 60, height: 60)
     //   let pathRect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
     //   UIGraphicsBeginImageContext(size)
     //    imageView.image!.draw(in: pathRect)
     //    var resizedImage = UIGraphicsGetImageFromCurrentImageContext()
     // // let imagePoint = ObjectUIImagePoint(image: imageView.image)
     //    image = resizedImage
    }
  }
}
extension UIImage {
    class func circle(diameter: CGFloat, color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: diameter, height: diameter), false, 0)
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()

        let rect = CGRect(x: 0, y: 0, width: diameter, height: diameter)
        ctx.setFillColor(color.cgColor)
        ctx.fillEllipse(in: rect)

        ctx.restoreGState()
        var img = UIGraphicsGetImageFromCurrentImageContext()!
        img  =  #imageLiteral(resourceName: "icons8-центральное-направление-50").withRenderingMode(.alwaysOriginal)
        UIGraphicsEndImageContext()

        return img
    }
}
/*
class PointObject: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            // Resize image
            let pinImage = UIImage(named: "avaUser1")
        
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            
            // Add Image
            self.image = resizedImage
            
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        // Enable callout
        canShowCallout = true
        
        // Move the image a little bit above the point.
        centerOffset = CGPoint(x: 0, y: -20)
    }
}
*/
