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
    var caption: [String] = []
    var fileImage: [UIImage] = []
    var fileName: [String] = []
   // var notes: [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
        request.returnsObjectsAsFaults = false
        
        do
        {
            let results = try context.fetch(request)
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let imageName = result.value(forKey: "imageName") as? String
                    {
                        fileName.append(imageName)
                        if let note = result.value(forKey: "note") as? String
                        {
                           // notes.append(note)
                            caption.append(note)
                        }
                    }
                }
            }
        }catch
        {
            print("Retrieving core data error")
        }
        
        if fileName.count != 0
        {
            let fileManager = FileManager.default
            for imageName in fileName
            {
                let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
                if fileManager.fileExists(atPath: imagePath){
                    if let outputImage = UIImage(contentsOfFile: imagePath)
                    {
                        fileImage.append(outputImage)
                    }
                }else{
                    print("Panic! Image not found --> \(imageName)")
                }
            }
        }
        // Static setup
        SKPhotoBrowserOptions.displayAction = true
        SKPhotoBrowserOptions.displayStatusbar = false
        SKPhotoBrowserOptions.displayDeleteButton = true
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
    
    func removePhoto(_ browser: SKPhotoBrowser, index: Int, reload: @escaping (() -> Void))
    {
        print("remove photo")
/*
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntries")
        request.predicate = NSPredicate(format: "imageName = %@", "\(fileName[index])")
        request.returnsObjectsAsFaults = false
        do
        {
            let result = try context.fetch(request)
            
            if result.count > 0
            {
                for name in result as! [NSManagedObject]
                {
                    if let Imagename = name.value(forKey: "imageName") as? String
                    {
                        print("\(Imagename) deleted complete")
                        context.delete(name)
                        do {
                            try context.save()
                        } catch  {
                            print("Delete Failed")
                        }
                    }
                }
            }else
            {
            }
            
            
        }catch
        {
            
        }
        
        let fileManager = FileManager.default
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName[index])
        if fileManager.fileExists(atPath: imagePath)
        {
            do
            {
                try fileManager.removeItem(atPath: imagePath)
            }catch
            {
                print("error on filemanager remove")
            }
            print("image deleted from \(imagePath)")
        }else{
            print("Panic! No Image!")
        }
        images.remove(at: index)
        caption.remove(at: index)
        fileName.remove(at: index)
        
        browser.reloadData()
        
        
        */
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
//        for note in notes
//        {
//            caption.append(note)
//        }
        
        return (0..<fileImage.count).map { (i: Int) -> SKPhotoProtocol in
            let photo = SKPhoto.photoWithImage(fileImage[i])
            photo.caption = caption[i]
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


