import Time "mo:base/Time";
import Buffer "mo:base/Buffer";
import Array "mo:base/Array";
import Result "mo:base/Result";

// Define an actor class named "HomeworkDiarySchool"
actor class HomeworkDiarySchool() {

  // Define the Time type
  public type Time = Time.Time;

  // Define the Homework record type
  public type Homework = {
    title: Text;
    description: Text;
    dueDate: Time;
    completed: Bool;
  };
  
  // Initialize the homework diary buffer
  let homeworkDiary = Buffer.Buffer<Homework>(0);

  // Function to add a new homework task
  public func addHomework(homework: Homework) : async Nat {
    homeworkDiary.add(homework);
    return homeworkDiary.size() - 1;  // Return the index (ID) of the added homework
  };

  // Query function to retrieve a specific homework task by ID
  public query func getHomework(id: Nat) : async Result.Result<Homework, Text> {
    if (id >= homeworkDiary.size()) {
      return #err("ID is not found, enter a valid id");
    } else {
      return #ok(homeworkDiary.get(id));
    }
  };

  // Function to update details of a homework task
  public func updateHomework(id: Nat, homework: Homework) : async Result.Result<(), Text> {
    if (id >= homeworkDiary.size()) {
      return #err("ID is not found, enter a valid id");
    } else {
      homeworkDiary.put(id, homework);
      return #ok();
    }
  };

  // Function to mark a homework task as completed
  public func markAsComplete(id: Nat) : async Result.Result<(), Text> {
    if (id >= homeworkDiary.size()) {
      return #err("ID is not found, enter a valid id");
    } else {
      let homework = homeworkDiary.get(id);
      let newHomework : Homework = {
        title = homework.title;
        completed = true;
        description = homework.description;
        dueDate = homework.dueDate;
      };
      homeworkDiary.put(id, newHomework);
      return #ok();
    }
  };

  // Function to delete a homework task by ID
  public func deleteHomework(homeworkID: Nat) : async Result.Result<(), Text> {
    if (homeworkID >= homeworkDiary.size()) {
      return #err("ID is not found, enter a valid id");
    } else {
      let temp = homeworkDiary.remove(homeworkID);
    };
    return #ok();
  };

  // Query function to retrieve a list of all homework tasks
  public query func getAllHomework() : async [Homework] {
    return Buffer.toArray(homeworkDiary);
  };

  // Query function to retrieve pending (uncompleted) homework tasks
  public query func getPendingHomework() : async [Homework] {
    let testHomeworkDiary = Buffer.clone(homeworkDiary);
    testHomeworkDiary.filterEntries(func(_, x) = (x.completed == false));
    return Buffer.toArray(testHomeworkDiary);
  };

  // Query function to search for homework tasks based on a search term
  public query func searchHomework(searchTerm: Text) : async [Homework] {
    let testHomeworkDiary = Buffer.clone(homeworkDiary);
    testHomeworkDiary.filterEntries(func(_, x) = (x.title == searchTerm) or (x.description == searchTerm));
    return Buffer.toArray(testHomeworkDiary);
  }
}
