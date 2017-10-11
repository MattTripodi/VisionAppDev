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
				captureSession.startRunning()
			}
		} catch {
			debugPrint(error)
		}
	}

}

