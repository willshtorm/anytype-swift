
import Foundation
import UIKit

protocol ObjectIconImagePainterProtocol {
    
    func todoImage(isChecked: Bool, imageGuideline: ImageGuideline) -> UIImage
    func staticImage(name: String, imageGuideline: ImageGuideline) -> UIImage
    func image(
        with string: String,
        font: UIFont,
        textColor: UIColor,
        imageGuideline: ImageGuideline,
        backgroundColor: UIColor
    ) -> UIImage
    
}