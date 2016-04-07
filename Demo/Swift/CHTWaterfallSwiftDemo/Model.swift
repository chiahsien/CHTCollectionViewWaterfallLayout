//
//  Model.swift
//  CHTWaterfallSwift
//
//  Created by Sophie Fader on 3/21/15.
//  Copyright (c) 2015 Sophie Fader. All rights reserved.
//

import UIKit

class Model: NSObject {
    
    var images : [UIImage] = []
    
    
    // Assemble an array of images to use for sample content for the collectionView
    func buildDataSource(){
        
        let image1 = UIImage(named: "image1")
        let image2 = UIImage(named: "image2")
        let image3 = UIImage(named: "image3")
        let image4 = UIImage(named: "image4")
        let image5 = UIImage(named: "image5")
        let image6 = UIImage(named: "image6")
        let image7 = UIImage(named: "image7")
        
        images.append(image1!)
        images.append(image2!)
        images.append(image3!)
        images.append(image4!)
        images.append(image5!)
        images.append(image6!)
        images.append(image7!)
        
  
    }
    
    
}
