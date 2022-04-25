/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI
import Friendly

struct SymbolPicker: View {
    @Binding var event: Event
    @State private var selectedColor: Color = ColorOptions.default
    @Environment(\.dismiss) private var dismiss
    @State private var symbolNames = EventSymbols.symbolNames
    @State private var searchInput = ""
    
    var columns = Array(repeating: GridItem(.flexible()), count: 6)

    var body: some View {
        VStack {
            HStack {
                Spacer()

                FriendlyButton("Icon-picker-sheet-dismiss") {
                    FriendlyDismiss().dismiss()
                } label: {
                    Text("Done")
                }
                .hideExclusion(true)
                .padding()

            }
            HStack {
                Image(systemName: event.symbol)
                    .font(.title)
                    .imageScale(.large)
                    .foregroundColor(selectedColor)

            }
            .padding()

            HStack {
                ForEach(ColorOptions.all, id: \.self) { color in
                    FriendlyButton("\(color)") {
                        selectedColor = color
                        event.color = color
                    } label: {
                        Circle()
                            .foregroundColor(color)
                    }
                    .hideExclusion(true)
                }
            }
            .padding(.horizontal)
            .frame(height: 40)

            Divider()

            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(symbolNames, id: \.self) { symbolItem in
                        FriendlyButton("\(symbolItem)") {
                            event.symbol = symbolItem
                        } label: {
                            Image(systemName: symbolItem)
                                .sfSymbolStyling()
                                .foregroundColor(selectedColor)
                                .padding(5)
                        }
                        .hideExclusion(true)
                        .buttonStyle(.plain)
                    }
                }
                .drawingGroup()
            }

            FriendlyButton("Icon-picker-sheet-dismiss-2") {
                FriendlyDismiss().dismiss()
            } label: {
                Text("Done")
                    .padding()
            }
            .hideExclusion(true)
            .padding()

            Spacer()
        }
        .onAppear {
            selectedColor = event.color
        }
    }
}

struct SFSymbolBrowser_Previews: PreviewProvider {
    static var previews: some View {
        SymbolPicker(event: .constant(Event.example))
    }
}
