
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
            Circle()
                .stroke(lineWidth: 8.0)
                .foregroundColor(Color(0xFF323333 as! CGColor))

            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 8.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color(0xFFe1ad01 as! CGColor))
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)

            Text(text)
                .foregroundColor(Color(0xFF011e41 as! CGColor))
                .font(.custom("MetricLight", size: 46))
        }
        .frame(width: 234.0, height: 234.0)
    }
}
