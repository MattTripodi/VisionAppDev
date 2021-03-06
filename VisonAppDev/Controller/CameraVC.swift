//
//  CameraVC.swift
//  VisonAppDev
//
//  Created by Matt Tripodi on 10/10/17.
//  Copyright © 2017 Matthew Tripodi. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

enum FlashState {
	case off
	case on
}

class CameraVC: UIViewController {
	
	// Variables
	var captureSession: AVCaptureSession!
	var cameraOutput: AVCapturePhotoOutput!
	var previewLayer: AVCaptureVideoPreviewLayer!
	
	var photoData: Data?
	
	var flashControlState: FlashState = .off
	
	// Outlets
	@IBOutlet weak var cameraView: UIView!
	@IBOutlet weak var captureImageView: UIImageView!
	@IBOutlet weak var flashBtn: UIButton!
	@IBOutlet weak var identificationLbl: UILabel!
	@IBOutlet weak var confidenceLbl: UILabel!
	@IBOutlet weak var roundedLblView: RoundedShadowView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		previewLayer.frame = cameraView.bounds
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
		tap.numberOfTapsRequired = 1
		
		captureSession = AVCaptureSession()
		captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
		
		let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
		
		do {
			let input = try AVCaptureDeviceInput(device: backCamera!)
			if captureSession.canAddInput(input) == true {
				captureSession.addInput(input)
			}
			
			cameraOutput = AVCapturePhotoOutput()
			
			if captureSession.canAddOutput(cameraOutput) == true {
				captureSession.addOutput(cameraOutput)
				
				previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
				previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
				previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
				
				cameraView.layer.addSublayer(previewLayer!)
				cameraView.addGestureRecognizer(tap)
				captureSession.startRunning()
			}
		} catch {
			debugPrint(error)
		}
	}
	
	@objc func didTapCameraView() {
		let settings = AVCapturePhotoSettings()
		settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
		
		if flashControlState == .off {
			settings.flashMode = .off
		} else {
			settings.flashMode = .on
		}
		
		cameraOutput.capturePhoto(with: settings, delegate: self)
	}
	
	func resultsMethod(request: VNRequest, error: Error?) {
		guard let results = request.results as? [VNClassificationObservation] else { return }
		
		for classification in results {
			print(classification.identifier)
			if classification.confidence < 0.5 {
				self.identificationLbl.text = "I'm not sure what this is. Please try again."
				self.confidenceLbl.text = ""
				break
			} else {
				self.identificationLbl.text = classification.identifier
				self.confidenceLbl.text = "CONFIDENCE: \(Int(classification.confidence * 100))%"
				break
			}
		}
	}
	
	@IBAction func flashBtnWasPressed(_ sender: Any) {
		switch flashControlState {
		case .off:
			flashBtn.setTitle("FLASH ON", for: .normal)
			flashControlState = .on
		case .on:
			flashBtn.setTitle("FLASH OFF", for: .normal)
			flashControlState = .off
		}
	}
	
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		if let error = error {
			debugPrint(error)
		} else {
			photoData = photo.fileDataRepresentation()
			
			do {
				let model = try VNCoreMLModel(for: SqueezeNet().model)
				let request = VNCoreMLRequest(model: model, completionHandler: resultsMethod)
				let handler = VNImageRequestHandler(data: photoData!)
				try handler.perform([request])
			} catch {
				debugPrint(error)
			}
			
			let image = UIImage(data: photoData!)
			self.captureImageView.image = image
		}
	}
}



























