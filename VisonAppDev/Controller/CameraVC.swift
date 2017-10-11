//
//  CameraVC.swift
//  VisonAppDev
//
//  Created by Matt Tripodi on 10/10/17.
//  Copyright © 2017 Matthew Tripodi. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
	
	// Variables
	var captureSession: AVCaptureSession!
	var cameraOutput: AVCapturePhotoOutput!
	var previewLayer: AVCaptureVideoPreviewLayer!
	
	var photoData: Data?
	
	// Outlets
	@IBOutlet weak var cameraView: UIView!
	@IBOutlet weak var captureImageView: UIImageView!
	@IBOutlet weak var flashBtn: RoundedShadowView!
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
		let previewPixelType = settings.__availablePreviewPhotoPixelFormatTypes.first!
		let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType, kCVPixelBufferWidthKey as String: 160, kCVPixelBufferHeightKey as String: 160]
		
		settings.previewPhotoFormat = previewFormat
		
		cameraOutput.capturePhoto(with: settings, delegate: self)
	}
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
	func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
		if let error = error {
			debugPrint(error)
		} else {
			photoData = photo.fileDataRepresentation()
			
			let image = UIImage(data: photoData!)
			self.captureImageView.image = image
		}
	}
}



























