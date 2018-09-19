public typealias PTMarking = [PTPlace: UInt]

public struct PTNet: PetriNet {

  public typealias MarkingType = PTMarking

  public let places: Set<PTPlace>
  public let transitions: Set<PTTransition>

  public init(places: Set<PTPlace>, transitions: Set<PTTransition>) {
    self.places      = places
    self.transitions = transitions
  }

}

// ---------------------------------------------------------------------------

public class PTPlace {

  public let name: String

  public init(named name: String) {
    self.name = name
  }

}

extension PTPlace: Hashable {

  public var hashValue: Int {
    return self.name.hashValue
  }

  public static func == (lhs: PTPlace, rhs: PTPlace) -> Bool {
    return lhs === rhs
  }

}

extension PTPlace: CustomStringConvertible {

  public var description: String {
    return self.name
  }

}

// ---------------------------------------------------------------------------

public struct PTTransition: Transition {

  public let name          : String
  public let preconditions : Set<PTArc>
  public let postconditions: Set<PTArc>

  public init(named name: String, preconditions: Set<PTArc>, postconditions: Set<PTArc>) {
    self.name           = name
    self.preconditions  = preconditions
    self.postconditions = postconditions
  }

  public func isFireable(from marking: PTMarking) -> Bool {
    return !(self.preconditions.contains { arc in marking[arc.place]! < arc.tokens })
  }

  public func fire(from marking: PTMarking) -> PTMarking? {
    guard self.isFireable(from: marking) else {
      return nil
    }

    var result = marking
    for arc in self.preconditions {
      result[arc.place]! -= arc.tokens
    }
    for arc in self.postconditions {
      result[arc.place]! += arc.tokens
    }

    return result
  }

}

extension PTTransition: CustomStringConvertible {

  public var description: String {
    return self.name
  }

}

// ---------------------------------------------------------------------------

public struct PTArc: Hashable {

  public let place : PTPlace
  public let tokens: UInt

  public init(place: PTPlace, tokens: UInt = 1) {
    self.place  = place
    self.tokens = tokens
  }

}
