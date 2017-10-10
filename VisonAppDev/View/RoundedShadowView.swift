//
//  RoundedShadowView.swift
//  VisonAppDev
//
//  Created by Matt Tripodi on 10/10/17.
//  Copyright © 2017 Matthew Tripodi. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedShadowView: UIView {

	override func awakeFromNib() {
		super.awakeFromNib()
		self.layer.shadowColor = UIColor.darkGray.cgColor
		self.layer.shadowRadius = 15
		self.layer.shadowOpacity = 0.75
		self.layer.cornerRadius = self.frame.height / 2 
	}

}
