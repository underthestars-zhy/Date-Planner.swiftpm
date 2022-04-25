/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI
import Friendly
import Introspect
import SwiftUIX

@main
struct DatePlannerApp: App {
    @StateObject private var eventData = EventData.shared
    @State var splitViewController: UISplitViewController? = nil
    @State var isShowSiderBar = true
    @State var isShowText = true

    @Environment(\.colorScheme) var colorScheme

    @State var refresh = UUID()

    @State var periods = [Period : Int]()

    var body: some Scene {
        WindowGroup {
            Friendly {
                NavigationView {
                    EventList()
                        .onAppear {
                            isShowSiderBar = true
                        }
                        .onDisappear {
                            isShowSiderBar = false
                        }
                    Text("Select an Event")
                        .foregroundStyle(.secondary)
                        .onAppear {
                            isShowText = true
                        }
                        .onDisappear {
                            isShowText = false
                        }

                }
                .id(refresh)
                .introspectSplitViewController { view in
                    splitViewController = view
                }
                .environmentObject(eventData)
                .onChange(of: eventData.events) { _ in
                    if !periodsCal() {
                        Task {
                            try? await Task.sleep(nanoseconds: NSEC_PER_SEC)
                            PositionManager.shared.reset()
                            refresh = UUID()
                        }
                    }
                }
                .onAppear {
                    for period in Period.allCases {
                        periods[period] = eventData.sortedEvents(period: period).wrappedValue.count
                    }
                }
            }
            .commandView {
                CommandGroup {
                    CommandItem(name: "Toggle SideBar", image: Image(systemName: "sidebar.left")) {
                        if isShowSiderBar {
                            splitViewController?.hide(.primary)
                        } else {
                            splitViewController?.show(.primary)

                            refresh = UUID()
                        }
                    }

                    CommandItem(name: "Refresh Cursor", image: Image(systemName: "circle")) {
                        refresh = UUID()
                        FriendlyManager.shared.refreshCursorData()
                    }
                }
            }
            .onAppear {
                Task {
                    try? await Task.sleep(nanoseconds: NSEC_PER_SEC)
                    FriendlySheet {
                        StartView()
                            .frame(width: 541 / 918 * Screen.main.width, height: 573 / 641 * Screen.main.height)
                    }.present("StartView-sheet")
                }
            }
        }
    }

    func periodsCal() -> Bool {
        let last = periods
        for period in Period.allCases {
            periods[period] = eventData.sortedEvents(period: period).wrappedValue.count
        }

        var state = true

        let lastAll = last.map(\.value)
        let currentAll = periods.map(\.value)

        for value in zip(lastAll, currentAll) {
            state = value.0 == value.1
        }

        return state
    }
}
