public protocol PetriNet {

  associatedtype MarkingType
  associatedtype PlaceType: Hashable
  associatedtype TransitionType: Transition where TransitionType.MarkingType == MarkingType

  var places     : Set<PlaceType>      { get }
  var transitions: Set<TransitionType> { get }

  func simulate(steps: Int, from: MarkingType) -> MarkingType

}

extension PetriNet {

  public func simulate(steps: Int, from marking: MarkingType) -> MarkingType {
    var m = marking

    for _ in 0 ..< steps {
      let fireable = self.transitions.filter{ $0.isFireable(from: m) }
      if fireable.isEmpty {
        return m
      }
      m = Random.choose(from: fireable).fire(from: m)!
    }

    return m
  }

}

// ---------------------------------------------------------------------------

public protocol Transition: Hashable {

  associatedtype ArcType: Hashable
  associatedtype MarkingType

  var preconditions : Set<ArcType> { get }
  var postconditions: Set<ArcType> { get }

  func isFireable(from marking: MarkingType) -> Bool
  func fire(from marking: MarkingType) -> MarkingType?

}
