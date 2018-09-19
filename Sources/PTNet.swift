public struct PTNet: PetriNet {

    public let places: Set<PTPlace>
    public let transitions: Set<PTTransition>

    public init(places: Set<PTPlace>, transitions: Set<PTTransition>) {
        self.places      = places
        self.transitions = transitions
    }

    public func simulate(steps: Int, from marking: PTMarking) -> PTMarking {
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

public typealias PTMarking = [PTPlace: UInt]

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

    public static func ==(lhs: PTPlace, rhs: PTPlace) -> Bool {
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
        for arc in self.preconditions {
            if marking[arc.place]! < arc.tokens {
                return false
            }
        }

        return true
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

    public var hashValue: Int {
        var hasher = Hasher()
        hasher.combine(self.preconditions.hashValue)
        hasher.combine(self.postconditions.hashValue)
        hasher.combine(self.name.hashValue)
        return hasher.finalize()
    }

    public static func ==(lhs: PTTransition, rhs: PTTransition) -> Bool {
        return (lhs.preconditions  == rhs.preconditions)  &&
               (lhs.postconditions == rhs.postconditions) &&
               (lhs.name           == rhs.name)
    }

}

extension PTTransition: CustomStringConvertible {

    public var description: String {
        return self.name
    }

}

// ---------------------------------------------------------------------------

public struct PTArc {

    public let place : PTPlace
    public let tokens: UInt

    public init(place: PTPlace, tokens: UInt = 1) {
        self.place  = place
        self.tokens = tokens
    }

}

extension PTArc: Hashable {

    public var hashValue: Int {
      var hasher = Hasher()
      hasher.combine(self.place.hashValue)
      hasher.combine(self.tokens.hashValue)
      return hasher.finalize()
    }

    public static func ==(lhs: PTArc, rhs: PTArc) -> Bool {
        return (lhs.place == rhs.place) && (lhs.tokens == rhs.tokens)
    }

}
