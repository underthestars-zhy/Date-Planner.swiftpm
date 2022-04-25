//
//  File.swift
//  
//
//  Created by 朱浩宇 on 2022/4/13.
//

import SwiftUI
import Friendly
import SwiftUIX

struct StartView: View {
    var body: some View {
        VStack {
            Text("Friendly Mode")
                .font(.largeTitle.bold())
                .padding()
                .padding()

            HStack {
                Text("State: ")
                FriendlyStateButton()
            }

            VStack(alignment: .leading) {
                Group {
                    Text("0. Stand up your iPad so the camera is facing you")
                    Text("1. Make Sure you iPad supports **FaceId**")
                    Text("2. Connect yoru Airpods **Pro(3)**")
                    Text("3. **Rotate** your head")
                    Text("4. Close your **left** eyes (0.3s) to 'tap' the button")
                    Text("5. Close your right and left eyes (1.5s) and then open to show the menu")
                    Text("6. 'Tap' the Text Field and **speak(wait for 1s than speak) (En-US)** to fill the text filed, when you finish **'tap' again**")
                    Text("7. Repeat if there is a problem, or change the eye closure time, etc.")
                    Text("8. You can change the cursor speed and eye trace sensitivity")
                    Text("9. If you feel that the mouse movement speed is not suitable for you, you can adjust the mouse value")
                }
                .padding(.bottom, 5)
            }
            .lineLimit(2)
            .multilineTextAlignment(.leading)
            .padding()
            .font(.title3)

            Spacer()

            FriendlyButton("StartView-Close") {
                FriendlyDismiss().dismiss()
            } label: {
                Text("Ok")
                    .padding()
                    .foregroundColor(.white)
            }
            .hideExclusion(true)
            .padding(.horizontal, 100)
            .background(.blue)
            .cornerRadius(13)
            .padding()
        }
    }
}
