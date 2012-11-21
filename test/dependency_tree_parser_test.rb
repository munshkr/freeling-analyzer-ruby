require "test_helper"
require "freeling/analyzer/dependency_tree_parser"

class DependencyTreeParserTest < MiniTest::Unit::TestCase
  def setup
    @parser = FreeLing::Analyzer::DependencyTreeParser.new
  end

  def test_single_node
    res = parse("")
    assert_equal "", res
  end

  def test_multiple_nodes
    skip
  end

  def test_single_tree
    skip
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
