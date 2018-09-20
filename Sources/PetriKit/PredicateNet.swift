public struct PredicateTransition<Place, Term>: TransitionProtocol
  where Place: CaseIterable & Hashable
{

  public typealias PlaceContent = UInt
  public typealias Arc = PredicateArc<Place, Term>
  public typealias FireResult = Marking<Place, PlaceContent>?

  public let name: String
  public let preconditions: Set<Arc>
  public let postconditions: Set<Arc>

}

public struct PredicateArc<Place, Term>: ArcProtocol
  where Place: CaseIterable & Hashable,
        Term: Hashable
{

  public let place: Place
  public let label: PredicateLabel<Term>

  public init(place: Place, label: PredicateLabel<Term>) {
    self.place = place
    self.label = label
  }

}

public enum PredicateLabel<Term> {

  case variable(name: String)
  case function(([String: Term]) -> Term)

}
