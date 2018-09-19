public protocol PetriNet {

  associatedtype MarkingType
  associatedtype PlaceType: Hashable
  associatedtype TransitionType: Transition where TransitionType.MarkingType == MarkingType

  var places     : Set<PlaceType>      { get }
  var transitions: Set<TransitionType> { get }

  func simulate(steps: Int, from: MarkingType) -> MarkingType

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
