//
//  LoadAndCacheImage≠.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 08/12/2022.
//

import Foundation
import UIKit


class ObjectUIImagePoint: UIImage {

    convenience init?(image imageObject: UIImage?) {
        guard let image = imageObject,
              nil != image.cgImage else {
                    return nil
        }
        self.init(cgImage: image.cgImage!)
    }
    override func withRenderingMode(_ renderingMode: UIImage.RenderingMode) -> UIImage {
        // both return statements work:
        return self
        // return super.withRenderingMode(.alwaysOriginal)
    }

}

