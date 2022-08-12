//
//  Copyright © Aelptos. All rights reserved.
//

import SwiftUI

struct MessageCellView: View {
    let message: String

    var body: some View {
        HStack {
            Spacer()
            Text(message)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }
}

struct MessageCellView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            MessageCellView(message: "Hello world")
            MessageCellView(message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Aenean eget mauris quis dui convallis bibendum. Nam mauris est, semper ut risus at, commodo vulputate nulla. Maecenas placerat dapibus nisl eget malesuada. Fusce a auctor justo. Mauris placerat, ante dapibus feugiat fringilla, nisi leo scelerisque massa, id mollis sem odio id lacus. Nullam non magna et est finibus luctus. Ut malesuada tincidunt mollis. Mauris a viverra arcu. Phasellus porta mauris in congue eleifend. Donec maximus erat pulvinar quam varius, quis commodo nunc porttitor. Sed dapibus ante eu molestie dapibus. Cras semper ligula eu fringilla porttitor. Quisque feugiat sed sem non congue. Maecenas eu massa et ligula rutrum suscipit a sed eros. ")
        }
        .previewLayout(.sizeThatFits)
    }
}
