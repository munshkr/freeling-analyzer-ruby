# encoding: utf-8
require "test_helper"

class AnalyzerTest < MiniTest::Unit::TestCase
  def setup
    @a = "El gato come pescado y bebe agua."
    @b = "Yo bajo con el hombre bajo a tocar el bajo bajo la escalera."
    @c = "Mi amigo Juan Mesa se mesa la barba al lado de la mesa."
  end

  def test_token_attributes
    expected_token = { form: "El", lemma: "el", prob: 1, tag: "DA0MS0" }

    analyzer = FreeLing::Analyzer.new(@a, :language => :es)
    token = analyzer.tokens.first

    [:form, :lemma, :prob, :tag].each do |key|
      assert_equal expected_token[key], token[key]
    end
  end

  def test_token_list
    expected_tokens = [
      { form: "El",      lemma: "el",      tag: "DA0MS0"  },
      { form: "gato",    lemma: "gato",    tag: "NCMS000" },
      { form: "come",    lemma: "comer",   tag: "VMIP3S0" },
      { form: "pescado", lemma: "pescado", tag: "NCMS000" },
      { form: "y",       lemma: "y",       tag: "CC"      },
      { form: "bebe",    lemma: "beber",   tag: "VMIP3S0" },
      { form: "agua",    lemma: "agua",    tag: "NCCS000" },
      { form: ".",       lemma: ".",       tag: "Fp"      },
    ]

    analyzer = FreeLing::Analyzer.new(@a, :language => :es)
    analyzer.tokens.each.with_index do |token, i|
      [:form, :lemma, :tag].each do |key|
        assert_equal expected_tokens[i][key], token[key]
      end
    end
  end
end
