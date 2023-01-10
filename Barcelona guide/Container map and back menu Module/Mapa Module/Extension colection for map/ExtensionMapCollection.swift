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
        return obgects.count//self.presenter.nearbysObjects?.count ?? 0
    }
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CellObectsFavorit
       // cell.backgroundColor = UIColor.rgb(red: 81, green: 107, blue: 103).withAlphaComponent(0.5)
        cell.backgroundColor = UIColor.appColor(.bluePewter)!.withAlphaComponent(0.7)
        cell.layer.cornerRadius = 20
        cell.object = obgects[indexPath.row]//presenter.nearbysObjects?[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print("обновлен cell -", indexPath.item)
      //  guard let cell = cell as? CellObectsFavorit else { return }
    }
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        presenter.putCellColectionObject(index: indexPath)
    }
}
