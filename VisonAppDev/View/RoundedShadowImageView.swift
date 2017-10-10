//
//  RoundedShadowImageView.swift
//  VisonAppDev
//
//  Created by Matt Tripodi on 10/10/17.
//  Copyright © 2017 Matthew Tripodi. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedShadowImageView: UIImageView {

	override func awakeFromNib() {
		super.awakeFromNib()
		self.layer.shadowColor = UIColor.darkGray.cgColor
		self.layer.shadowRadius = 15
		self.layer.shadowOpacity = 0.75
		self.layer.cornerRadius = 15
	}

}
