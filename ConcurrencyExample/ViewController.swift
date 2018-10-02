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
	}

	@IBAction func privateQueueConcurrentDownload(_ sender: Any) {
	}

	
	@IBAction func asyncDataDownload(_ sender: Any) {
	}

	@IBAction func SyncFilter(_ sender: Any) {
	}
}

