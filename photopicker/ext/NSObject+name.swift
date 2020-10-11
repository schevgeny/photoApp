//
//  NSObject+ext.swift
//
//  Created by Valik Kuchinsky on 29.03.17.
//  Copyright © 2017 Valik. All rights reserved.
//

import Foundation

extension NSObject {
	var className: String {
        return NSStringFromClass(type(of: self)).components(separatedBy: ".").last ?? ""
	}
	
	@nonobjc class var className: String {
		return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
	}
}
