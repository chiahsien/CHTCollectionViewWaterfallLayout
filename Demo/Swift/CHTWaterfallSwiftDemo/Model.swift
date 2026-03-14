//
//  Model.swift
//  CHTWaterfallSwiftDemo
//
//  Created by Sophie Fader on 3/21/15.
//  Copyright (c) 2015 Sophie Fader. All rights reserved.
//

import UIKit

struct Model {

    let images: [UIImage] = {
        let sources = (1...7).map { UIImage(named: "image\($0)")! }
        return Array(repeating: sources, count: 5).flatMap { $0 }
    }()
}
