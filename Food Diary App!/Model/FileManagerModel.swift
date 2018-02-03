//
//  FileManagerModel.swift
//  Food Diary App!
//
//  Created by Ben Shih on 18/01/2018.
//  Copyright © 2018 BenShih. All rights reserved.
//

import Foundation
import UIKit

struct FileManagerModel
{
    func lookupImage(fileNames: [String]) -> [UIImage]
    {
        var images: [UIImage] = []
        let fileManager = FileManager.default
        for imageName in fileNames
        {
            let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(imageName)
            if fileManager.fileExists(atPath: imagePath){
                if let outputImage = UIImage(contentsOfFile: imagePath)
                {
                    images.append(outputImage)
                }else
                {
                    print("cannot find \(imagePath)")
                }
            }else{
                print("Panic! No Image!")
            }
        }
        return images
    }
}
