import Foundation

extension PTNet {

  public func saveAsDot(to url: URL, withMarking: PTMarking? = nil) throws {
    var output = "digraph G {\n"

    // Place subgraph ...
    output += "subgraph place {\n"
    output += "node [shape=circle, width=.5];\n"
    for place in self.places {
      var label = ""
      if let tokens = withMarking?[place] {
        label = String(describing: tokens)
      }

      output += "\"\(place.name)\" [label=\"\(label)\", xlabel=\"\(place.name)\"];\n"
    }
    output += "}\n"

    // Transition subgraph ...
    output += "subgraph transitions {\n"
    output += "node [shape=rect, width=.5, height=.5];\n"
    for transition in self.transitions {
      output += "\"\(transition.name)\";\n"
    }
    output += "}\n"

    // Arcs definitions ...
    for transition in self.transitions {
      for arc in transition.preconditions.filter({ $0.tokens != 0 }) {
        output += "\"\(arc.place.name)\" -> \"\(transition.name)\""
        if arc.tokens == 1 {
          output += ";\n"
        } else {
          output += " [label=\(arc.tokens)];\n"
        }
      }

      for arc in transition.postconditions.filter({ $0.tokens != 0 }) {
        output += "\"\(transition.name)\" -> \"\(arc.place.name)\""
        if arc.tokens == 1 {
          output += ";\n"
        } else {
          output += " [label=\(arc.tokens)];\n"
        }
      }
    }

    output += "}\n"
    try output.write(to: url, atomically: true, encoding: String.Encoding.utf8)
  }

}
