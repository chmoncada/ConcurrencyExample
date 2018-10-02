//
//  ViewController.swift
//  ConcurrencyExample
//
//  Created by Charles Moncada on 01/10/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import UIKit

let imageURL01 = "https://image.tmdb.org/t/p/original/cezWGskPY5x7GaglTTRN4Fugfb8.jpg"
let imageURL02 = "https://image.tmdb.org/t/p/original/t90Y3G8UGQp0f0DrP60wRu9gfrH.jpg"
let imageURL03 = "https://image.tmdb.org/t/p/original/7WsyChQLEftFiDOVTGkv3hFpyyt.jpg"
let imageURL04 = "https://image.tmdb.org/t/p/original/uxzzxijgPIY7slzFvMotPv8wjKA.jpg"
let imageURL05 = "https://image.tmdb.org/t/p/original/rv1AWImgx386ULjcf62VYaW8zSt.jpg"
let imageURL06 = "https://image.tmdb.org/t/p/original/uB1k7XsHvjjJXSAwur37wttrzpJ.jpg"


class ViewController: UIViewController {

	@IBOutlet weak var image01: UIImageView!
	@IBOutlet weak var image02: UIImageView!
	@IBOutlet weak var image03: UIImageView!
	@IBOutlet weak var image04: UIImageView!
	@IBOutlet weak var image05: UIImageView!
	@IBOutlet weak var image06: UIImageView!

	@IBOutlet weak var syncFilterButton: UIButton!

	override func viewDidLoad() {
		super.viewDidLoad()
		syncFilterButton.isEnabled = false
	}

	@IBAction func resetImages(_ sender: UIButton) {
		image01.image = UIImage(named: "Placeholder")
		image02.image = UIImage(named: "Placeholder")
		image03.image = UIImage(named: "Placeholder")
		image04.image = UIImage(named: "Placeholder")
		image05.image = UIImage(named: "Placeholder")
		image06.image = UIImage(named: "Placeholder")
	}


	@IBAction func privateQueueDownload(_ sender: Any) {
		let mySerialQueue = DispatchQueue(label: "io.keepcoding.serial")

		mySerialQueue.async {
			let data1 = try! Data(contentsOf: URL(string: imageURL01)!)

			DispatchQueue.main.async { [weak self] in
				self?.image01.image = UIImage(data: data1)
			}
		}

		mySerialQueue.async {
			let data2 = try! Data(contentsOf: URL(string: imageURL02)!)
			DispatchQueue.main.async { [weak self] in
				guard let `self` = self else { return }
				self.image02.image = UIImage(data: data2)
			}
		}

		mySerialQueue.async {
			let data3 = try! Data(contentsOf: URL(string: imageURL03)!)
			DispatchQueue.main.async {
				self.image03.image = UIImage(data: data3)
			}
		}
		mySerialQueue.async {
			let data4 = try! Data(contentsOf: URL(string: imageURL04)!)
			DispatchQueue.main.async {
				self.image04.image = UIImage(data: data4)
			}
		}
		mySerialQueue.async {
			let data5 = try! Data(contentsOf: URL(string: imageURL05)!)
			DispatchQueue.main.async {
				self.image05.image = UIImage(data: data5)
			}
		}
		mySerialQueue.async {
			let data6 = try! Data(contentsOf: URL(string: imageURL06)!)
			DispatchQueue.main.async {
				self.image06.image = UIImage(data: data6)
			}
		}
	}

	@IBAction func privateQueueConcurrentDownload(_ sender: Any) {

//		let myConcurrentQueue = DispatchQueue(label: "io.keepcoding.concurrent", attributes: .concurrent)

		let myConcurrentQueue = DispatchQueue.global(qos: .userInitiated)

		let group = DispatchGroup()

		group.enter()
		myConcurrentQueue.async {
			let data1 = try! Data(contentsOf: URL(string: imageURL01)!)

			DispatchQueue.main.async { [weak self] in
				self?.image01.image = UIImage(data: data1)
				group.leave()
			}
		}

		group.enter()
		myConcurrentQueue.async {
			let data2 = try! Data(contentsOf: URL(string: imageURL02)!)
			DispatchQueue.main.async { [weak self] in
				guard let `self` = self else { return }
				self.image02.image = UIImage(data: data2)
				group.leave()
			}
		}

		group.enter()
		myConcurrentQueue.async {
			let data3 = try! Data(contentsOf: URL(string: imageURL03)!)
			DispatchQueue.main.async {
				self.image03.image = UIImage(data: data3)
				group.leave()
			}
		}

		group.enter()
		myConcurrentQueue.async {
			let data4 = try! Data(contentsOf: URL(string: imageURL04)!)
			DispatchQueue.main.async {
				self.image04.image = UIImage(data: data4)
				group.leave()
			}
		}

		group.enter()
		myConcurrentQueue.async {
			let data5 = try! Data(contentsOf: URL(string: imageURL05)!)
			DispatchQueue.main.async {
				self.image05.image = UIImage(data: data5)
				group.leave()
			}
		}

		group.enter()
		myConcurrentQueue.async {
			let data6 = try! Data(contentsOf: URL(string: imageURL06)!)
			DispatchQueue.main.async {
				self.image06.image = UIImage(data: data6)
				group.leave()
			}
		}

		group.notify(queue: DispatchQueue.main) { [weak self] in
			self?.syncFilterButton.isEnabled = true
		}

	}

	
	@IBAction func asyncDataDownload(_ sender: Any) {
	}

	@IBAction func SyncFilter(_ sender: Any) {
		print("Deberia aplicar el filtro")

		let sepiaOp1 = SepiaFilterOperation()
		sepiaOp1.inputImage = self.image01.image
		let sepiaOp2 = SepiaFilterOperation()
		sepiaOp2.inputImage = self.image02.image
		let sepiaOp3 = SepiaFilterOperation()
		sepiaOp3.inputImage = self.image03.image
		let sepiaOp4 = SepiaFilterOperation()
		sepiaOp4.inputImage = self.image04.image
		let sepiaOp5 = SepiaFilterOperation()
		sepiaOp5.inputImage = self.image05.image
		let sepiaOp6 = SepiaFilterOperation()
		sepiaOp6.inputImage = self.image06.image

		let serialFilterQueue = OperationQueue()
		serialFilterQueue.maxConcurrentOperationCount = 1

		sepiaOp1.completionBlock = { [weak self] in
			guard let output = sepiaOp1.outputImage else { return }
			DispatchQueue.main.async(execute: {
				self?.image01.image = output
			})
		}

		sepiaOp2.completionBlock = { [weak self] in
			guard let output = sepiaOp2.outputImage else { return }
			DispatchQueue.main.async {
				self?.image02.image = output
			}
		}
		sepiaOp3.completionBlock = { [weak self] in
			guard let output = sepiaOp3.outputImage else { return }
			DispatchQueue.main.async {
				self?.image03.image = output
			}
		}
		sepiaOp4.completionBlock = { [weak self] in
			guard let output = sepiaOp4.outputImage else { return }
			DispatchQueue.main.async {
				self?.image04.image = output
			}
		}
		sepiaOp5.completionBlock = { [weak self] in
			guard let output = sepiaOp5.outputImage else { return }
			DispatchQueue.main.async {
				self?.image05.image = output
			}
		}
		sepiaOp6.completionBlock = { [weak self] in
			guard let output = sepiaOp6.outputImage else { return }
			DispatchQueue.main.async {
				self?.image06.image = output
			}
		}

		serialFilterQueue.addOperation(sepiaOp1)
		serialFilterQueue.addOperation(sepiaOp2)
		serialFilterQueue.addOperation(sepiaOp3)
		serialFilterQueue.addOperation(sepiaOp4)
		serialFilterQueue.addOperation(sepiaOp5)
		serialFilterQueue.addOperation(sepiaOp6)
	}
}

