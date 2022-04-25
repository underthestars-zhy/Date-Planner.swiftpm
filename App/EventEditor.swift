/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI
import Friendly

struct EventEditor: View {
    @Binding var event: Event
    var isNew = false
    
    @State private var isDeleted = false
    @EnvironmentObject var eventData: EventData
    @Environment(\.dismiss) private var dismiss
    
    // Keep a local copy in case we make edits, so we don't disrupt the list of events.
    // This is important for when the date changes and puts the event in a different section.
    @State private var eventCopy = Event()
    @State private var isEditing = false
    
    private var isEventDeleted: Bool {
        !eventData.exists(event) && !isNew
    }

    @Environment(\.colorScheme) var colorScheme

    @State var hideEx = true

    @State var refresh = UUID()

    @State var eventsBack = [Event]()
    
    var body: some View {
        if isEventDeleted {
            ZStack {
                Color(UIColor.systemBackground)
                    .edgesIgnoringSafeArea(.all)
                Text("Event Deleted. Select an Event.")
                    .foregroundStyle(.secondary)
            }
        } else {
            VStack {
                EventDetail(event: $eventCopy, isEditing: isNew ? true : isEditing, hideEx: $hideEx)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            if isNew {
                                FriendlyButton("EventEditor-Toolbar-left") {
                                    FriendlyDismiss().dismiss()
                                } label: {
                                    Text("Cancel")
                                }
                                .hideExclusion(hideEx)
                            }
                        }
                        ToolbarItem {
                            FriendlyButton("EventEditor-Toolbar-right") {
                                if isNew {
                                    eventData.events.append(eventCopy)
                                    FriendlyDismiss().dismiss()
                                } else {
                                    if isEditing && !isDeleted {
                                        print("Done, saving any changes to \(event.title).")
                                        withAnimation {
                                            event = eventCopy // Put edits (if any) back in the store.
                                        }
                                    }
                                    isEditing.toggle()
                                }
                            } label: {
                                Text(isNew ? "Add" : (isEditing ? "Done" : "Edit"))
                            }
                            .hideExclusion(hideEx)
                        }
                    }
                    .onAppear {
                        eventCopy = event // Grab a copy in case we decide to make edits.
                    }
                    .disabled(isEventDeleted)

                if isEditing && !isNew {
                    FriendlyButton("Delete Event - Button") {
                        isDeleted = true
                        FriendlyDismiss().dismiss()
                        eventData.delete(event)
                    } label: {
                        Label("Delete Event", systemImage: "trash.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    .padding()
                }

                if !isNew {
                    FriendlyButton("EventEditor-Toolbar-bottom") {
                        if isEditing && !isDeleted {
                            print("Done, saving any changes to \(event.title).")
                            withAnimation {
                                event = eventCopy // Put edits (if any) back in the store.
                            }
                        }
                        isEditing.toggle()
                    } label: {
                        Text((isEditing ? "Done" : "Edit"))
                    }
                    .hideExclusion(hideEx)
                    .padding()

                    Spacer()
                }
            }
            .onAppear {
                hideEx = isNew
                eventsBack = eventData.events
            }
        }

    }
}

struct EventEditor_Previews: PreviewProvider {
    static var previews: some View {
        EventEditor(event: .constant(Event()))
    }
}
