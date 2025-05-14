
//
//  CircularProgressBar.swift
//  iosApp
//
//  Created by Vitaly on 20220721.
//  Copyright © 2022 orgName. All rights reserved.
//

import SwiftUI

/**
 # ``CircularProgressBar`` is a circle shaped progress bar.
  ``progress``  progress value with a range from 0 to 1
  ``text``  text that displayed inside of the circle

 # Example of usage:
 ```swift
     CircularProgressBar(progress: $progress, text: $text)
 ```
 */

struct CircularProgressBar: View {

    @Binding var progress: Float
    @Binding var text: String

    var body: some View {
        ZStack {
            CircularTimer(interval: TimeInterval(20), progress: CGFloat(0.5))

        }
        .frame(width: 234.0, height: 234.0)
    }
}
