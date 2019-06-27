//
//  PianoKey.swift
//  vid and ui
//
//  Created by Eric Dolecki on 6/27/19.
//  Copyright © 2019 Eric Dolecki. All rights reserved.
//

import UIKit

class PianoKey: UIView {

    var iAmAMainKey: Bool = true
    
    init(isAMainKey: Bool) {
        iAmAMainKey = isAMainKey
        var frame: CGRect
        if isAMainKey {
            frame = CGRect(x: 0, y: 0, width: 30, height: 150)
        } else {
            frame = CGRect(x: 0, y: 0, width: 14, height: 100)
        }
        super.init(frame: frame)
        styleMe()
    }
    
    init(frame: CGRect, isAMainKey: Bool) {
        super.init(frame: frame)
    }
    
    private func styleMe() {
        if iAmAMainKey {
            self.backgroundColor = UIColor.white
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.layer.borderWidth = 4.0
        } else {
            self.backgroundColor = UIColor.lightGray
            self.layer.borderColor = UIColor.lightGray.cgColor
            self.layer.borderWidth = 4.0
        }
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
}
