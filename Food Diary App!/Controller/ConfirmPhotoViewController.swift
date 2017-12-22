//
//  ConfirmPhotoViewController.swift
//  Food Diary App!
//
//  Created by Ben Shih on 21/12/2017.
//  Copyright © 2017 BenShih. All rights reserved.
//

import UIKit

class ConfirmPhotoViewController:UIViewController {
    
    @IBOutlet weak var containerView:UIView!
    @IBOutlet weak var originalImage:UIImageView!
    @IBOutlet weak var imageToFilter:UIImageView!
    @IBOutlet weak var filtersScrollView:UIScrollView!
    @IBOutlet weak var buttonBar:UIView!
    
    var image:UIImage?
    
    // Array of all filters
    var CIFilterNames = [
        "CIPhotoEffectChrome",
        "CIPhotoEffectFade",
        "CIPhotoEffectInstant",
        "CIPhotoEffectNoir",
        "CIPhotoEffectProcess",
        "CIPhotoEffectTonal",
        "CIPhotoEffectTransfer",
        "CISepiaTone"
    ]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //originalImage.image = image
        var XCoord:CGFloat = 5
        let yCoord:CGFloat = 5
        let buttonWidth:CGFloat = 80
        let buttonHeight:CGFloat = 80
        let gapBetweenButtons:CGFloat = 5
        
        buttonBar.alpha = 0
        
        var itemCount = 5
        
        for i in 0..<CIFilterNames.count
        {
            itemCount = i
            let filterButton = UIButton(type:.custom)
            filterButton.frame = CGRect(x: XCoord,y: yCoord,width: buttonWidth,height: buttonHeight)
            filterButton.tag = itemCount
            filterButton.addTarget(self,action:#selector(filterButtonTapped(sender:)),for:.touchUpInside)
            filterButton.layer.cornerRadius = 6
            filterButton.clipsToBounds = true
            
            let ciContext = CIContext(options:nil)
            let coreImage = CIImage(image:originalImage.image!)
            let filter = CIFilter(name:"\(CIFilterNames[i])")
            filter?.setDefaults()
            filter!.setValue(coreImage,forKey:kCIInputImageKey)
            let filteredImageData = filter!.value(forKey:kCIOutputImageKey) as! CIImage
            let filteredImageRef = ciContext.createCGImage(filteredImageData,from:filteredImageData.extent)
            let imageForButton = UIImage(cgImage:filteredImageRef!)
            filterButton.setBackgroundImage(imageForButton,for:.normal)
            XCoord += buttonWidth + gapBetweenButtons
            filtersScrollView.addSubview(filterButton)
        }
        filtersScrollView.contentSize = CGSize(width: buttonWidth * CGFloat(itemCount + 2),height: yCoord)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneTapped(_ sender: Any)
    {
        buttonBar.alpha = 1
    }
    
    @objc func filterButtonTapped(sender:UIButton)
    {
        let button = sender as UIButton
        imageToFilter.image = button.backgroundImage(for: UIControlState.normal)
    }
}
