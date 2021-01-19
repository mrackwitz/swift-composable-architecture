import ComposableArchitecture
import Foundation
import SwiftUI

struct Todo: Equatable, Identifiable {
  var description = ""
  let id: UUID
  var isComplete = false
}

enum TodoAction: Equatable {
  case checkBoxToggled
  case textFieldChanged(String)
}

struct TodoEnvironment {}

let todoReducer = Reducer<Todo, TodoAction, TodoEnvironment> { todo, action, _ in
  switch action {
  case .checkBoxToggled:
    todo.isComplete.toggle()
    return .none

  case let .textFieldChanged(description):
    todo.description = description
    return .none
  }
}

struct TodoView: View {
  let store: Store<Todo, TodoAction>

  @State private var isPrioritized: Bool = false

  var body: some View {
    WithViewStore(self.store) { viewStore in
      HStack {
        Button(action: { viewStore.send(.checkBoxToggled) }) {
          Image(systemName: viewStore.isComplete ? "checkmark.square" : "square")
        }
        .buttonStyle(PlainButtonStyle())

        TextField(
          "Untitled Todo",
          text: viewStore.binding(get: { $0.description }, send: TodoAction.textFieldChanged)
        )

        Button(action: { isPrioritized = !isPrioritized }) {
          Image(systemName: isPrioritized ? "flag.fill" : "flag")
            .foregroundColor(isPrioritized ? Color.red : Color.gray)
        }
        .buttonStyle(PlainButtonStyle())
      }
      .foregroundColor(viewStore.isComplete ? .gray : nil)
    }
  }
}
