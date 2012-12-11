require "test_helper"
require "freeling/analyzer/dependency_tree_parser"

class DependencyTreeParserTest < MiniTest::Unit::TestCase
  def setup
    @parser = FreeLing::Analyzer::DependencyTreeParser.new
  end

  def test_empty_tree
    res = parse("")
    assert_equal("", res)
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
    tree = <<-TREE
      sn/obj-prep/(nacionalidad nacionalidad NCFS000 -) [
        s-a-fs/adj-mod/(argentina argentino AQ0FS0 -)
      ]
    TREE
    res = parse(tree)
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
    tree = <<-TREE
      s-adj/adj-mod/(, , Fc -) [
        s-a-ms/modnomatch/(casado casar VMP00SM -)
        s-a-ms/modnomatch/(nacido nacer VMP00SM -)
      ]
    TREE
    res = parse(tree)
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

  def test_tree_within_a_tree
    tree = <<-TREE
      grup-verb/top/(es ser VSIP3S0 -) [
        interjeccio/ador/(Hola hola I -) [
          Fc/modnomatch/(, , Fc -)
        ]
      ]
    TREE
    res = parse(tree)
    assert_equal({
      ancestor_label: "grup-verb",
      dependence_label: "top",
      token: {
        form: "es",
        lemma: "ser",
        tag: "VSIP3S0",
        coref_group: "-"
      },
      children: {
        ancestor_label: "interjeccio",
        dependence_label: "ador",
        token: {
          form: "Hola",
          lemma: "hola",
          tag: "I",
          coref_group: "-"
        },
        children: {
          ancestor_label: "Fc",
          dependence_label: "modnomatch",
          token: {
            form: ",",
            lemma: ",",
            tag: "Fc",
            coref_group: "-"
          }
        }
      }
    }, res)
  end

  def test_tree_with_a_tree_and_a_node
    tree = <<-TREE
      grup-verb/top/(es ser VSIP3S0 -) [
        interjeccio/ador/(Hola hola I -) [
          Fc/modnomatch/(, , Fc -)
        ]
        sn/att/(Juan juan NP00SP0 -)
      ]
    TREE
    res = parse(tree)
    assert_equal({
      ancestor_label: "grup-verb",
      dependence_label: "top",
      token: {
        form: "es",
        lemma: "ser",
        tag: "VSIP3S0",
        coref_group: "-"
      },
      children: [{
          ancestor_label: "interjeccio",
          dependence_label: "ador",
          token: {
            form: "Hola",
            lemma: "hola",
            tag: "I",
            coref_group: "-"
          },
          children: {
            ancestor_label: "Fc",
            dependence_label: "modnomatch",
            token: {
              form: ",",
              lemma: ",",
              tag: "Fc",
              coref_group: "-"
            }
          }
        }, {
          ancestor_label: "sn",
          dependence_label: "att",
          token: {
            form: "Juan",
            lemma: "juan",
            tag: "NP00SP0",
            coref_group: "-"
          },
        }
      ]
    }, res)
  end

private
  def parse(string)
    @parser.parse(string)
  rescue Parslet::ParseFailed => error
    print_text(string)
    raise error.cause.ascii_tree
  end

  def print_text(string)
    puts
    string.split("\n").each.with_index do |line, index|
      puts "#{(index + 1).to_s.rjust(4)}_#{line}"
    end
    puts
  end
end
