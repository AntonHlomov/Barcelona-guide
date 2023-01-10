//
//  LoadAndCacheImageUser.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import UIKit

var imageCache = [String: UIImage]()//Cache

extension UIImageView {
func loadImage(with urlString: String)  {
    // проверка есть ли в кеше фото
    if let cachedImage = imageCache[urlString] {
        self.image = cachedImage
        return
    }
    //определяем ссылку фото в базе
    guard let url = URL(string: urlString) else {return}
    //вытаскиваем фото из базы
    URLSession.shared.dataTask(with: url) { (data, response, err) in
        if let err = err {
            print("Failed to load image: ",err.localizedDescription)
            return
        }
        guard let imageData = data else {return}
        let profileImage =  UIImage(data: imageData)
        imageCache[url.absoluteString] = profileImage
        DispatchQueue.main.async {
            self.image = profileImage
        }
    }.resume() // если запрос подвис запрос повториться
  }
    
    
}

class CustomUIimageView: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    private func configure(){
       contentMode = .scaleAspectFill
        backgroundColor = UIColor.appColor(.grayPlatinum)
        image =  #imageLiteral(resourceName: "avaUser2").withRenderingMode(.alwaysOriginal)
       clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// circle image for anatacion at map
extension UIImage {
    var isPortrait:  Bool    { size.height > size.width }
    var isLandscape: Bool    { size.width > size.height }
    var breadth:     CGFloat { min(size.width, size.height) }
    var breadthSize: CGSize  { .init(width: breadth, height: breadth) }
    var breadthRect: CGRect  { .init(origin: .zero, size: breadthSize) }
    var circleMasked: UIImage? {
        guard let cgImage = cgImage?
            .cropping(to: .init(origin: .init(x: isLandscape ? ((size.width-size.height)/2).rounded(.down) : 0,
                                              y: isPortrait  ? ((size.height-size.width)/2).rounded(.down) : 0),
                                size: breadthSize)) else { return nil }
        let format = imageRendererFormat
        format.opaque = false
        return UIGraphicsImageRenderer(size: breadthSize, format: format).image { _ in
            UIBezierPath(ovalIn: breadthRect).addClip()
            UIImage(cgImage: cgImage, scale: format.scale, orientation: imageOrientation)
            .draw(in: .init(origin: .zero, size: breadthSize))
        }
    }
}
