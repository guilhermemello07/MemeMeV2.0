//
//  MemeCollectionViewController.swift
//  MemeMe -V2.0
//
//  Created by Guilherme Mello on 25/09/23.
//

import UIKit

class MemeCollectionViewController: UICollectionViewController {
    
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    var memes: [Meme]! {
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: K.collectionCellNibName, bundle: nil), forCellWithReuseIdentifier: K.collectionCellID)
        collectionView.reloadData()
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        collectionView.reloadData()
    }

    //MARK: - CollectionView DataSource Methods

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: K.collectionCellID, for: indexPath) as! CollectionCell
    
        cell.collectionCellImageView.image = memes[indexPath.row].memedImage
        cell.backgroundColor = UIColor.clear
        cell.collectionCellLabel.text = memes[indexPath.row].topText + " " + memes[indexPath.row].bottomText
    
        return cell
    }
    
    //MARK: - CollectionView Delegate Methods
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.memeDetailSegue, sender: self)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.memeDetailSegue {
            let destinationVC = segue.destination as! MemeDetailViewController
            if let indexPath = collectionView.indexPathsForSelectedItems {
                destinationVC.selectedIndex = indexPath.first?.row
            }
        }
    }
}

//MARK: - Extenssion UICollectionViewDelegateFlowLayout

extension MemeCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = view.frame.size.height
        let width = view.frame.size.width
        
        return CGSize(width: width * 0.4, height: height * 0.3)
    }
    
}
