//	
//  Copyright © Aelptos. All rights reserved.
//

import UIKit

extension UIView {
    func constraintToAllSides(of parent: UIView) {
        topAnchor.constraint(equalTo: parent.topAnchor).isActive = true
        trailingAnchor.constraint(equalTo: parent.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: parent.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: parent.leadingAnchor).isActive = true
    }
}
