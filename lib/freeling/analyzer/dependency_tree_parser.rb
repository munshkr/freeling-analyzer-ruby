require "parslet"

module FreeLing
  class Analyzer
    class DependencyTreeParser < Parslet::Parser
      # Single character and basic elements
      rule(:lparen) { str('(') }
      rule(:rparen) { str(')') }
      rule(:lbracket) { str('[') }
      rule(:rbracket) { str(']') }
      rule(:slash) { str('/') }
      rule(:spaces)  { match("[\s\n]").repeat(1) }
      rule(:spaces?)  { spaces.maybe }

      # Labels
      rule(:label_string) { match("[^/]").repeat(1) }
      rule(:ancestor_label)   { label_string }
      rule(:dependence_label) { label_string }

      # Token parts
      rule(:token_string) { match("[^\s]").repeat(1) }
      rule(:form)  { token_string }
      rule(:lemma) { token_string }
      rule(:tag)   { token_string }
      # FIXME describe coref_group correctly
      rule(:coref_group) { str('-') }

      rule(:token) {
        lparen >>
        form.as(:form) >> spaces >>
        lemma.as(:lemma) >> spaces >>
        tag.as(:tag) >> spaces >>
        coref_group.as(:coref_group) >>
        rparen
      }

      rule(:node) {
        ancestor_label.as(:ancestor_label) >> slash >>
        dependence_label.as(:dependence_label) >> slash >>
        token.as(:token)
      }

      rule(:tree) {
        (node >> spaces >> lbracket >> spaces >> (
            tree >> (spaces >> tree).repeat
          ).maybe.as(:children) >>
          spaces >> rbracket) | node
      }

      rule(:top) {
        spaces? >> tree.maybe >> spaces?
      }

      root(:top)
    end
  end # Analyzer
end # FreeLing
