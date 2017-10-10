//
//  CameraVC.swift
//  VisonAppDev
//
//  Created by Matt Tripodi on 10/10/17.
//  Copyright © 2017 Matthew Tripodi. All rights reserved.
//

import UIKit

class CameraVC: UIViewController {
	
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


}

