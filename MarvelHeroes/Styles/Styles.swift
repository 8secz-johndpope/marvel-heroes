//
//  Created by Pablo Balduz on 13/08/2020.
//  Copyright © 2020 Pablo Balduz. All rights reserved.
//

import UIKit

// These are simple view styles but just to demonstrate the approach

// UILabel

let multipleLinesLabelStyle: (UILabel) -> Void = { label in
    label.numberOfLines = 0
}

let textColorLabelStyle: (UIColor) -> (UILabel) -> Void = { color in
    return { label in
        label.textColor = color
    }
}

let titleLabelStyle: (UILabel) -> Void =
    textColorLabelStyle(.darkGray) <>
        multipleLinesLabelStyle <> { label in
            label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
}

let bodyLabelStyle: (UILabel) -> Void =
    textColorLabelStyle(.lightGray) <>
        multipleLinesLabelStyle <> { label in
            label.font = UIFont.preferredFont(forTextStyle: .body)
}

// UIButton

let tintColorStyle: (UIColor) -> (UIButton) -> Void = { color in
    return { button in
        button.tintColor = color
    }
}

let imageButtonStyle: (String) -> (UIButton) -> Void = { imageName in
    return { button in
        button.setImage(UIImage(named: imageName), for: .normal)
    }
}

let closeButtonStyle: (UIButton) -> Void =
    imageButtonStyle("close") <>
        tintColorStyle(.black)

// UIView

let backgroundColorStyle: (UIColor) -> (UIView) -> Void = { color in
    return { view in
        view.backgroundColor = color
    }
}

let roundedCornersStyle: (CGFloat) -> (UIView) -> Void = { cornerRadius in
    return { view in
        view.layer.cornerRadius = cornerRadius
        view.layer.masksToBounds = true
    }
}

let heroDetailContentViewStyle: (UIView) -> Void =
    roundedCornersStyle(20) <>
        backgroundColorStyle(.white) <> { view in
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
}

let heroListCellBackgroundStyle: (UIView) -> Void =
    roundedCornersStyle(10) <>
        backgroundColorStyle(UIColor(r: 26, g: 70, b: 128, alpha: 0.5))

// UIImageView

let contentModeImageViewStyle: (UIImageView.ContentMode) -> (UIImageView) -> Void = { contentMode in
    return { imageView in
        imageView.contentMode = contentMode
        imageView.clipsToBounds = true
    }
}
