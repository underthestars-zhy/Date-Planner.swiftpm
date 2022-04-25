/*
 See the License.txt file for this sample’s licensing information.
 */

import SwiftUI
import Friendly

struct TaskRow: View {
    @Binding var task: EventTask
    var isEditing: Bool
    @FocusState private var isFocused: Bool

    @StateObject var speechManager = SpeechManager.shared

    let ex: Bool

    @State var shouldSpeech = false

    var body: some View {
        HStack {
            FriendlyButton("TaskRowButton - \(task.id.uuidString)") {
                task.isCompleted.toggle()
                if !isEditing {
                    guard let originalEventIndex = EventData.shared.events.firstIndex(where: { event in
                        event.tasks.contains { _task in
                            task.id == _task.id
                        }
                    }) else {
                        return
                    }

                    guard let index = EventData.shared.events[originalEventIndex].tasks.firstIndex (where: { _task in
                        task.id == _task.id
                    }) else {
                        return
                    }

                    EventData.shared.events[originalEventIndex].tasks[index].isCompleted.toggle()
                }
            } label: {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
            }
            .buttonStyle(.plain)

            if isEditing || task.isNew {
                FriendlyTextField("TaskRow - \(task.id.uuidString)", "Task description", text: $task.text, focused: _isFocused, shouldSpeech: $shouldSpeech)
                    .hideExclusion(ex)
                    .onChange(of: isFocused) { newValue in
                        if newValue == false {
                            task.isNew = false
                        }
                    }
                    .onChange(of: speechManager.mainText) { value in
                        if speechManager.onRecord == "TaskRow - \(task.id.uuidString)" {
                            task.text = value
                        }
                    }
            } else {
                Text(task.text)
            }

            Spacer()
        }
        .padding(.vertical, 10)
        .task {
            print(DeviceState.shared.state, DeviceState.shared.state != .connect)
            if task.isNew && DeviceState.shared.state != .connect {
                isFocused.toggle()
            }
        }
    }

}
