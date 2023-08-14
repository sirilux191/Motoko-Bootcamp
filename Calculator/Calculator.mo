import Float "mo:base/Float";

// Define an actor class named "Calculator"
actor class Calculator() {

  // Initialize the counter variable with a Float value of 0
  var counter : Float = 0;

  // Function to add a value to the counter
  public func add(x : Float) : async Float {
    counter := counter + x;
    return counter;
  };

  // Function to subtract a value from the counter
  public func sub(x : Float) : async Float {
    counter := counter - x;
    return counter;
  };

  // Function to multiply the counter by a value
  public func mul(x : Float) : async Float {
    counter := counter * x;
    return counter;
  };

  // Function to divide the counter by a value
  public func div(x : Float) : async ?Float {
    if (x == 0) {
      return null;  // Return null if division by zero is attempted
    } else {
      counter := counter / x;
    };
    return ?counter;  // Return the new counter value wrapped in an optional
  };

  // Function to reset the counter to 0
  public func reset() : async () {
    counter := 0;
    return ();
  };

  // Query function to retrieve the current value of the counter
  public query func see() : async Float {
    return counter;
  };

  // Function to calculate the power of the counter with a given exponent
  public func power(x : Float) : async Float {
    counter := counter ** x;
    return counter;
  };

  // Function to calculate the square root of the counter's value
  public func sqrt() : async Float {
    counter := Float.sqrt(counter);
    return counter;
  };

  // Function to calculate the floor value of the counter and convert it to an Integer
  public func floor() : async Int {
    counter := Float.floor(counter);
    return Float.toInt(counter);
  };
};
