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
       backgroundColor = .lightGray
       image =  #imageLiteral(resourceName: "avaUser0").withRenderingMode(.alwaysOriginal)
       clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
