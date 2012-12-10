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
      rule(:label) { match("[\w-]").repeat(1) }
      rule(:ancestor_label)   { nstring }
      rule(:dependence_label) { nstring }

      # Token parts
      rule(:string) { match("[^\s]").repeat(1) }
      rule(:nstring) { match("[A-Za-z0-9.,:;_\\-]").repeat(1) }
      rule(:form)  { nstring }
      rule(:lemma) { string }
      rule(:tag)   { nstring }
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
        node.as(:node) >> (
          spaces >> lbracket >> spaces >> (
            tree >> (spaces >> tree).repeat
          ).maybe.as(:children) >>
          spaces >> rbracket
        ).maybe
      }

      root(:tree)
    end
  end # Analyzer
end # FreeLing
