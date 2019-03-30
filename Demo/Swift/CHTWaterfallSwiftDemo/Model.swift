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
        images = (1...7).map { UIImage(named: "image\($0)")! }
    }
    
}
