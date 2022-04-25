/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI
import Friendly
import Introspect
import SwiftUIX

struct EventList: View {
    @EnvironmentObject var eventData: EventData
    @State private var isAddingNewEvent = false
    @State private var newEvent = Event()

    @State var listVisible = Set<Int>()

    @StateObject private var dataManager = DataManager.shared

    @Environment(\.colorScheme) var colorScheme

    @State var ids = [String : Int]()

    @StateObject var deviceState: DeviceState

    init() {
        _deviceState = StateObject(wrappedValue: DeviceState.shared)
    }

    var body: some View {
        FriendlyList("EventList", items: eventData.events.count + 1, visibleRows: $listVisible) {
            Section {
                HStack {
                    Label {
                        switch deviceState.state {
                        case .connect:
                            Text("Your AirPods is connected")
                        case .disconnect:
                            Text("Your AirPods is disconnected")
                        case .ignore:
                            Text("We ignore your motion")
                        case .notSupport:
                            Text("Your iPad or AirPods isn't support our App. Please use iPad with faceid and AirPods Pro or 3")
                        }
                    } icon: {
                        FriendlyStateButton()
                    }

                    Spacer()

                    if deviceState.state == .connect {
                        FriendlyButton("FriendlyPreferenceView - Button") {
                            FriendlySheet {
                                FriendlyPreferenceView()
                            }.present("FriendlyPreferenceView - sheet")
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
                .id(0)
                .onAppear { listVisible.insert(0) }
                .onDisappear { listVisible.remove(0) }
            }

            ForEach(Period.allCases) { period in
                if !eventData.sortedEvents(period: period).isEmpty {
                    Section(content: {
                        ForEach(eventData.sortedEvents(period: period)) { $event in
                            FriendlyWrappedView("\(event.id.uuidString)") {
                                NavigationLink(isActive: Binding(get: {
                                    dataManager.activeList == event
                                }, set: { newValue in
                                    if newValue {
                                        dataManager.activeList = event
                                    } else {
                                        dataManager.activeList = nil
                                    }
                                })) {
                                    EventEditor(event: $event)
                                } label: {
                                    EventRow(event: event)
                                }
                            }
                            .onRight {
                                dataManager.activeList = event
                            }
                            .modifier(EventListModifier(ids: ids, event: event, listVisible: $listVisible))
                        }
                    }, header: {
                        Text(period.name)
                            .font(.callout)
                            .foregroundColor(.secondary)
                            .fontWeight(.bold)
                    })
                }
            }
        }
        .onAppear {
            var index = 1
            for period in Period.allCases {
                for item in EventData.shared.sortedEvents(period: period) {
                    ids[item.id.uuidString] = index

                    index += 1
                }
            }
        }
        .navigationTitle("Date Planner")
        .toolbar {
            ToolbarItem {
                FriendlyButton("Date Planner-add") {
                    newEvent = Event()
                    FriendlySheet {
                        NavigationView {
                            EventEditor(event: $newEvent, isNew: true)
                                .environmentObject(eventData)
                                .introspectTableView { tableView in
                                    tableView.backgroundColor = Color("List").toUIColor()
                                }
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                        .frame(width: 541 / 918 * Screen.main.width, height: 573 / 641 * Screen.main.height)
                    }
                    .present("Date Planner-add-view")
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

struct EventListModifier: ViewModifier {
    let ids: [String : Int]
    let event: Event

    @Binding var listVisible: Set<Int>

    func body(content: Content) -> some View {
        content
            .id(ids[event.id.uuidString] ?? 0)
            .onAppear {
                listVisible.insert(ids[event.id.uuidString] ?? 0)
            }
            .onDisappear {
                listVisible.remove(ids[event.id.uuidString] ?? 0)
            }
    }
}

struct EventList_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EventList().environmentObject(EventData())

        }
    }
}
