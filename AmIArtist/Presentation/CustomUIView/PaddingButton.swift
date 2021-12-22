//
//  PaddingButton.swift
//  AmIArtist
//
//  Created by su on 2021/12/23.
//

import UIKit

@IBDesignable class PaddingButotn: UIButton {

    @IBInspectable var topInset: CGFloat = 3.0
    @IBInspectable var bottomInset: CGFloat = 3.0
    @IBInspectable var leftInset: CGFloat = 6.0
    @IBInspectable var rightInset: CGFloat = 6.0
    
    override func draw(_ rect: CGRect) {
        let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.draw(rect.inset(by: insets))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset, height: size.height + topInset + bottomInset)
    }
}
