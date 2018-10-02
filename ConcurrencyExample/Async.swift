//
//  Async.swift
//  ConcurrencyExample
//
//  Created by Charles Moncada on 02/10/18.
//  Copyright © 2018 Charles Moncada. All rights reserved.
//

import UIKit

protocol AsyncDoable {
	static func instance(with url: URL) -> Self
	func writeTo(_ url: URL) throws -> Void
}

struct Async<T: AsyncDoable> {

	let url: URL
	let id: String
	let defaultData: T

	func load(completion: @escaping (T) -> ()) {
		if !loadLocal(completion: completion) {
			loadAndSaveRemote(completion: completion)
		}
	}

	private func loadLocal(completion: (T) -> ()) ->Bool {
		let fm = FileManager.default
		let local = localURL(forRemoteURL: url)
		if fm.fileExists(atPath: local.path) {
			let t = T.instance(with: local)
			completion(t)
			return true
		} else {
			return false
		}
	}

	private func loadAndSaveRemote(completion: @escaping (T) -> ()) {
		DispatchQueue.global(qos: .default).async {
			let t = T.instance(with: self.url)
			DispatchQueue.main.async {
				completion(t)
				self.saveToLocalStorage(t)
			}
		}
	}

	private func saveToLocalStorage(_ data: T) {
		let local = localURL(forRemoteURL: url)
		do{
			try data.writeTo(local)
		} catch let error as NSError {
			print(error)
		}
	}

	func localURL(forRemoteURL remoteURL: URL)  -> URL {

		// Sind it could happen that 2 images with different URLs
		// might have the same name, we can't save the image with its name.
		// That would cause collissions. Instead, we'll use the full url's
		// hashValue as a file name.
		// That's what core data does, BTW.
		let fileName = String(remoteURL.hashValue)
		return AsyncData.sandboxSubfolderURL().appendingPathComponent(fileName)

	}

	//MARK: - Utils
	static func sandboxSubfolderURL() -> URL {

		let fm = FileManager.default
		let urls = fm.urls(for: .cachesDirectory, in: .userDomainMask)

		guard let url = urls.last?.appendingPathComponent("\(type(of:self))") else {
			fatalError("Unable to create url for local storage at \(urls)")
		}

		// If this folder doesn't exist, we'll create it
		if !fm.fileExists(atPath: url.path){
			do {
				try fm.createDirectory(at: url,
									   withIntermediateDirectories: true,
									   attributes: [:])
			} catch let error as NSError {
				print(error)
			}
		}
		return url
	}
}

extension Data: AsyncDoable {
	static func instance(with url: URL) -> Data {
		return try! Data(contentsOf: url)
	}

	func writeTo(_ url: URL) throws {
		try self.write(to: url, options: .atomic)
	}
}

final class AsyncImage: UIImage {}

extension AsyncImage: AsyncDoable {
	static func instance(with url: URL) -> AsyncImage {
		let data = try! Data(contentsOf: url)
		let image = AsyncImage(data: data)!
		return image
	}

	func writeTo(_ url: URL) throws {
		let data = self.pngData()!
		try data.write(to: url, options: .atomic)
	}


}
