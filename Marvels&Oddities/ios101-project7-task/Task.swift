//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable, Equatable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date
    
    var id: String = UUID().uuidString
    var userId: String
    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date(), userId: String) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
        self.userId = userId
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    var createdDate: Date = Date()

}

// MARK: - Task + UserDefaults
extension Task {
    
    static var tasksKey: String {
        return "Tasks"
    }
    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        
        // TODO: Save the array of tasks
        let defaults = UserDefaults.standard
        if let encodedData = try? JSONEncoder().encode(tasks) {
                defaults.set(encodedData, forKey: tasksKey)
        } else {
                print("Failed to encode tasks")
        }
    }
    
    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks(forUserId userId: String) -> [Task] {
        let defaults = UserDefaults.standard
        let entriesKey = "\(tasksKey)_\(userId)"
        // 2.
        if let data = defaults.data(forKey: tasksKey) {
            // 3.
            let decodedMovies = try? JSONDecoder().decode([Task].self, from: data)
            // 4.
            return decodedMovies ?? []
        } else {
            // TODO: Get the array of saved tasks from UserDefaults
            return [] // 👈 replace with returned saved tasks
        }
    }
        // Add a new task or update an existing task with the current task.
        func save() {
            var tasks = Task.getTasks(forUserId: self.userId)
            // 2.
            if let index = tasks.firstIndex(where: { $0.id == self.id }) { // 2. Check for an existing task
                        tasks[index] = self
                        tasks.remove(at: index)
                        tasks.insert(self, at: index) 
                    } else {
                        tasks.append(self) // 3. Add the new task
                    }
            Task.save(tasks)
            // TODO: Save the current task
        }
    }

