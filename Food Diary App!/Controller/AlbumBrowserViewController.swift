//
//  AlbumBrowserViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 29/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit
import SKPhotoBrowser
import CoreData

class FromLocalViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, SKPhotoBrowserDelegate
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [SKPhotoProtocol]()
    //var caption: [String] = []
    var fileImage: [UIImage] = []
    var fileName: [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Making sure that the arrays are empty
        fileName.removeAll()
        fileImage.removeAll()
        images.removeAll()
        // Accessing Core Data
        var dataHandler = CoreDataHandler()
        fileName = dataHandler.getImageFilename()
        //Get photos
        if fileName.count != 0
        {
            fileImage = FileManagerModel().lookupImage(fileNames: fileName)
        }else
        {
            AlertMessage().displayAlert(title: "Oops".localized(), message: "You don't have any photo yet".localized(), VC: self)
        }
        
        // Static setup
        SKPhotoBrowserOptions.displayAction = true
        SKPhotoBrowserOptions.displayStatusbar = false
        SKPhotoBrowserOptions.displayDeleteButton = false
        
        setupTestData()
        setupCollectionView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden: Bool
    {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle
    {
        return .lightContent
    }
}


// MARK: - UICollectionViewDataSource
extension FromLocalViewController
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return images.count
    }
    
    @objc(collectionView:cellForItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exampleCollectionViewCell", for: indexPath) as? ExampleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.exampleImageView.image = fileImage[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension FromLocalViewController {
    @objc(collectionView:didSelectItemAtIndexPath:) func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let browser = SKPhotoBrowser(photos: images)
        browser.initializePageIndex(indexPath.row)
        browser.delegate = self
        present(browser, animated: true, completion: {})
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: UIScreen.main.bounds.size.width / 2 - 5, height: 300)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width / 2 - 5, height: 200)
        }
    }
}

// MARK: - private

private extension FromLocalViewController {
    
    func setupTestData() {
        images = createLocalPhotos()
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func createLocalPhotos() -> [SKPhotoProtocol]
    {
        return (0..<fileImage.count).map { (i: Int) -> SKPhotoProtocol in
            let photo = SKPhoto.photoWithImage(fileImage[i])
           // photo.caption = caption[i]
            return photo
        }
    }
}

class ExampleCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var exampleImageView: UIImageView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        exampleImageView.image = nil
        layer.cornerRadius = 25.0
        layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        exampleImageView.image = nil
    }
}


