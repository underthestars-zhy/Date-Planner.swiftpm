/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI
import Friendly
import SwiftUIX

struct EventDetail: View {
    @Binding var event: Event
    let isEditing: Bool

    @Environment(\.colorScheme) var colorScheme

    @Binding var hideEx: Bool

    @FocusState var focused: Bool

    @StateObject var speechManager = SpeechManager.shared

    @State var visibleRows: Set<Int> = []
    @State var shouldSpeech = false
    
    var body: some View {
        FriendlyList("EventDetail", items: 4 + event.tasks.count, visibleRows: $visibleRows, ex: hideEx) {
            HStack {
                FriendlyButton("Icon-Button", ignore: isEditing) {
                    FriendlySheet {
                        SymbolPicker(event: $event)
                            .frame(width: 541 / 918 * Screen.main.width, height: 573 / 641 * Screen.main.height)
                            .onAppear {
                                hideEx = false
                                print(hideEx)
                            }
                            .onDisappear {
                                hideEx = true
                            }
                    }.present("Icon-picker-view")
                } label: {
                    Image(systemName: event.symbol)
                        .sfSymbolStyling()
                        .foregroundColor(event.color)
                        .opacity(isEditing ? 0.3 : 1)
                }
                .hideExclusion(hideEx)
                .buttonStyle(.plain)
                .padding(.horizontal, 5)

                if isEditing {
                    FriendlyTextField("EventDetail-title-tf", "New Event", text: $event.title, focused: _focused, shouldSpeech: $shouldSpeech)
                        .hideExclusion(hideEx)
                        .font(.title2)
                        .onChange(of: speechManager.mainText) { value in
                            if speechManager.onRecord == "EventDetail-title-tf" {
                                event.title = value
                            }
                        }
                        .id(1)
                        .onAppear {
                            visibleRows.insert(1)
                        }
                        .onDisappear {
                            visibleRows.remove(1)
                        }
                } else {
                    Text(event.title)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
            .listRowBackground(colorScheme == .light ? Color(hexadecimal: "FFFFFF") : Color(hexadecimal: "2C2C2E"))
            .id(0)
            .onAppear {
                visibleRows.insert(0)
            }
            .onDisappear {
                visibleRows.remove(0)
            }

            if isEditing {
                FriendlyDatePicker("Date-Picker", date: $event.date, ex: hideEx, hideEx: $hideEx)
                    .listRowSeparator(.hidden)
                    .listRowBackground(colorScheme == .light ? Color(hexadecimal: "FFFFFF") : Color(hexadecimal: "2C2C2E"))
                    .id(1)
                    .onAppear {
                        visibleRows.insert(1)
                    }
                    .onDisappear {
                        visibleRows.remove(1)
                    }
            } else {
                HStack {
                    Text(event.date, style: .date)
                    Text(event.date, style: .time)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(colorScheme == .light ? Color(hexadecimal: "FFFFFF") : Color(hexadecimal: "2C2C2E"))
                .id(1)
                .onAppear {
                    visibleRows.insert(1)
                }
                .onDisappear {
                    visibleRows.remove(1)
                }
            }

            Text("Tasks")
                .fontWeight(.bold)
                .listRowBackground(colorScheme == .light ? Color(hexadecimal: "FFFFFF") : Color(hexadecimal: "2C2C2E"))
                .id(2)
                .onAppear {
                    visibleRows.insert(2)
                }
                .onDisappear {
                    visibleRows.remove(2)
                }

            ForEach($event.tasks) { $item in
                TaskRow(task: $item, isEditing: isEditing, ex: hideEx)
                    .listRowBackground(colorScheme == .light ? Color(hexadecimal: "FFFFFF") : Color(hexadecimal: "2C2C2E"))
                    .modifier(EventDetailTask(event: event, item: item, visibleRows: $visibleRows))
            }
            .onDelete(perform: { indexSet in
                event.tasks.remove(atOffsets: indexSet)
            })

            FriendlyButton("Add Task", ignore: DataManager.shared.edited.contains(event.id)) {
                event.tasks.append(EventTask(text: "", isNew: true))
            } label: {
                HStack {
                    Image(systemName: "plus")
                    Text("Add Task")
                }
            }
            .hideExclusion(hideEx)
            .buttonStyle(.borderless)
            .listRowBackground(colorScheme == .light ? Color(hexadecimal: "FFFFFF") : Color(hexadecimal: "2C2C2E"))
            .id(3 + event.tasks.count)
            .onAppear {
                visibleRows.insert(3 + event.tasks.count)
            }
            .onDisappear {
                visibleRows.remove(3 + event.tasks.count)
            }
        }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

struct EventDetailTask: ViewModifier {
    let event: Event
    let item: EventTask
    @Binding var visibleRows: Set<Int>

    func body(content: Content) -> some View {
        content
            .id(3 + (event.tasks.firstIndex(of: item) ?? 0))
            .onAppear {
                visibleRows.insert(3 + (event.tasks.firstIndex(of: item) ?? 0))
            }
            .onDisappear {
                visibleRows.remove(3 + (event.tasks.firstIndex(of: item) ?? 0))
            }
    }
}
