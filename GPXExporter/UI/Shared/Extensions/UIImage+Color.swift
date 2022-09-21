//
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

extension UIImage {
    func colorized(color: UIColor) -> UIImage? {
        guard let cgImage = cgImage else { return nil }
        let rect = CGRectMake(0, 0, self.size.width, self.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.setBlendMode(.multiply)
        context.draw(cgImage, in: rect)
        context.clip(to: rect, mask: cgImage)
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let colorizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return colorizedImage
    }
}
