//
//  ExtensionMapCollection.swift
//  Barcelona guide
//
//  Created by Anton Khlomov on 14/12/2022.
//
import UIKit

let cellId = "apCellId"

extension Mapa:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10 //self.presenter.favoritOjects?.count ?? 10
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CellObectsFavorit
        cell.backgroundColor = UIColor.rgb(red: 81, green: 107, blue: 103).withAlphaComponent(0.5)
        cell.layer.cornerRadius = 20
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("нажал\(indexPath)")
       // vc.starLabel.text = String(indexPath.row)
    }
}
