//
//  ImageFilter.swift
//  Concurrency
//
//  Created by Charles Moncada on 28/08/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {

	func sepiaFilter(intensity: Double = 0.7) -> UIImage? {
		let sepiaFilter = CIFilter(name:"CISepiaTone")
		sepiaFilter?.setValue(CIImage(image: self), forKey: kCIInputImageKey)
		sepiaFilter?.setValue(intensity, forKey: kCIInputIntensityKey)
		return sepiaFilter?.outputImage.map({ UIImage(ciImage: $0) })
	}
}

class SepiaFilterOperation: Operation {
	var inputImage: UIImage?
	var outputImage: UIImage?

	override func main() {
		outputImage = inputImage?.sepiaFilter()
	}
}
