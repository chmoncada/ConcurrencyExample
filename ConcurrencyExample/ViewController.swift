//
//  ViewController.swift
//  ConcurrencyExample
//
//  Created by Charles Moncada on 01/10/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import UIKit
import Alamofire

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

		dispatchAsync()
		dispatchSync()
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
//		let asyncData1 = AsyncData(
//			url: URL(string: imageURL01)!,
//			id: "image01",
//			defaultData: UIImage(named: "Placeholder")!.pngData()!)
//		asyncData1.delegate = self
//		asyncData1.execute()

//		let asyncData1: Async<Data> = Async<Data>(
//			url: URL(string: imageURL01)!,
//			id: "image01",
//			defaultData: UIImage(named: "Placeholder")!.pngData()!)
//		asyncData1.load { data in
//			let image = UIImage(data: data)
//			DispatchQueue.main.async { [weak self] in
//				self?.image01.image = image
//			}
//		}

		let asyncData1: Async<AsyncImage> = Async<AsyncImage>(url: URL(string: imageURL01)!,id: "image01", defaultData: #imageLiteral(resourceName: "Placeholder.png"))
		asyncData1.load { image in
			DispatchQueue.main.async { [weak self] in
				self?.image01.image = image
			}
		}

	}

	@IBAction func downloadURLSession(_ sender: Any) {

		let url = URL(string: imageURL01)
		let session = URLSession.shared
		let request = URLRequest(url: url!)

		let task = session.dataTask(with: request) { (data, response, error) in
			guard let data = data else { print("No hay data"); return }
			let image = UIImage(data: data)
			DispatchQueue.main.async { [weak self] in
				self?.image01.image = image
			}
		}

		let task2 = session.dataTask(with: url!) { (data, response, error) in
			guard let data = data else { print("No hay data"); return }
			let image = UIImage(data: data)
			DispatchQueue.main.async { [weak self] in
				self?.image01.image = image
			}
		}

		task2.resume()
//		task.resume()
	}
	@IBAction func SyncFilter(_ sender: Any) {

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

	func dispatchAsync() {
		let serialQueue = DispatchQueue(label: "io.keepcoding.serial")
		var value = 42

		func changeValue() {
			sleep(1)
			value = 0
		}

		serialQueue.async {
			changeValue()
		}

		print("---- Dispatch Async ----")
		print(value)
	}

	func dispatchSync() {
		let serialQueue = DispatchQueue(label: "io.keepcoding.serial")
		var value = 42

		func changeValue() {
			sleep(1)
			value = 0
		}

		print("---- Dispatch Sync ----")

		serialQueue.sync {
			changeValue()
		}
		print(value)
	}
	@IBAction func downloadAlamo(_ sender: Any) {
		let url1 = URL(string: imageURL01)!
		self.image01.setImage(with: url1)
	}
}

extension ViewController: AsyncDataDelegate {
	func asyncData(_ sender: AsyncData, didEndLoadingFrom url: URL) {
		let data = sender.data
		let image = UIImage(data: data)

		switch sender.id {
		case "image01":
			DispatchQueue.main.async {
				self.image01.image = image
			}
		default:
			break
		}
	}
}

private extension UIImageView {
	func setImage(with url: URL) {
		Alamofire.request(url)
			.responseData { (response) in
			let image = UIImage(data: response.data!)
			DispatchQueue.main.async {
				self.image = image
			}
		}
	}
}

