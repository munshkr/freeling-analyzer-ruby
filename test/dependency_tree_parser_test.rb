require "test_helper"
require "freeling/analyzer/dependency_tree_parser"

class DependencyTreeParserTest < MiniTest::Unit::TestCase
  def setup
    @parser = FreeLing::Analyzer::DependencyTreeParser.new
  end

  def test_single_node
    res = parse("s-a-fs/adj-mod/(argentina argentino AQ0FS0 -)")
    assert_equal({
      ancestor_label: "s-a-fs",
      dependence_label: "adj-mod",
      token: {
        form: "argentina",
        lemma: "argentino",
        tag: "AQ0FS0",
        coref_group: "-"
      }
    }, res)
  end

  def test_single_node_with_empty_attributes
    res = parse("Fc/term/(, , Fc -)")
    assert_equal({
      ancestor_label: "Fc",
      dependence_label: "term",
      token: {
        form: ",",
        lemma: ",",
        tag: "Fc",
        coref_group: "-"
      }
    }, res)
  end

  def test_date_node
    res = parse("data/modnomatch/(6_de_abril_de_1929 [??:6/4/1929:??.??:??] W -)")
    assert_equal({
      ancestor_label: "data",
      dependence_label: "modnomatch",
      token: {
        form: "6_de_abril_de_1929",
        lemma: "[??:6/4/1929:??.??:??]",
        tag: "W",
        coref_group: "-",
      }
    }, res)
  end

  def test_tree_with_single_node
    res = parse("sn/obj-prep/(nacionalidad nacionalidad NCFS000 -) [\n" \
                  "s-a-fs/adj-mod/(argentina argentino AQ0FS0 -)\n" \
                "]")
    assert_equal({
      ancestor_label: "sn",
      dependence_label: "obj-prep",
      token: {
        form: "nacionalidad",
        lemma: "nacionalidad",
        tag: "NCFS000",
        coref_group: "-"
      },
      children: {
        ancestor_label: "s-a-fs",
        dependence_label: "adj-mod",
        token: {
          form: "argentina",
          lemma: "argentino",
          tag: "AQ0FS0",
          coref_group: "-"
        }
      }
    }, res)
  end

  def test_tree_with_multiple_nodes
    res = parse("s-adj/adj-mod/(, , Fc -) [\n" \
                  "s-a-ms/modnomatch/(casado casar VMP00SM -)\n" \
                  "s-a-ms/modnomatch/(nacido nacer VMP00SM -)\n" \
                "]")
    assert_equal({
      ancestor_label: "s-adj",
      dependence_label: "adj-mod",
      token: {
        form: ",",
        lemma: ",",
        tag: "Fc",
        coref_group: "-"
      },
      children: [{
          ancestor_label: "s-a-ms",
          dependence_label: "modnomatch",
          token: {
            form: "casado",
            lemma: "casar",
            tag: "VMP00SM",
            coref_group: "-"
          }
        }, {
          ancestor_label: "s-a-ms",
          dependence_label: "modnomatch",
          token: {
            form: "nacido",
            lemma: "nacer",
            tag: "VMP00SM",
            coref_group: "-"
          }
        }
      ]
    }, res)
  end

  def test_empty_tree
    res = parse("")
    assert_equal("", res)
  end

private
  def parse(string)
    @parser.parse(string)
  rescue Parslet::ParseFailed => error
    print_text(string)
    raise error.cause.ascii_tree
  end

  def print_text(string)
    string.split("\n").each.with_index do |line, index|
      puts "#{(index + 1).to_s.rjust(4)}_#{line}"
    end
  end
end
