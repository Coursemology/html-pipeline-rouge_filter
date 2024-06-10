# frozen_string_literal: true

require "test_helper"
require "html_pipeline/node_filter/rouge_filter"

RougeFilter = HTMLPipeline::NodeFilter::RougeFilter

class HTMLPipeline::RougeFilterTest < Minitest::Test
  def setup
  end

  def test_highlight_default
    result = RougeFilter.call(
      "<pre>hello</pre>", context: { highlight: "coffeescript" }
    )

    doc = Nokogiri.parse(result)
    refute_empty(doc.css(".highlight-coffeescript"))
  end

  def test_highlight_default_will_not_override
    result = RougeFilter.call(
      "<pre lang='ruby'>hello</pre>", context: { highlight: "coffeescript" }
    )
    
    doc = Nokogiri.parse(result)
    assert_empty(doc.css(".highlight-coffeescript"))
    refute_empty(doc.css(".highlight-ruby"))
  end

  def test_unrecognized_lexer_will_not_raise_error
    filter = RougeFilter.new()

    assert_nothing_raised do
      filter.lexer_for("not_exist")
    end
  end

  def test_highlight_with_ruby
    filter = RougeFilter.new

    result = filter.highlight_with(Rouge::Lexers::Ruby, "hello").chomp

    assert_equal <<-EXPECTED.rstrip, result
<div class="highlight"><pre class="highlight"><code><span class="n">hello</span></code></pre></div>
    EXPECTED
  end

  def test_default_css_class
    filter = RougeFilter.new

    assert_equal("highlight", filter.default_css_class)
  end

  def test_default_css_class_can_be_specified_by_context
    filter = RougeFilter.new(context: {css_class: "superlight"})

    assert_equal("superlight", filter.default_css_class)
  end

  def test_line_numbers
    filter = RougeFilter.new

    assert_equal(false, filter.line_numbers)
  end

  def test_line_numbers_can_be_specified_by_context
    filter = RougeFilter.new(context: {line_numbers: true})

    assert_equal(true, filter.line_numbers)
  end

  def test_default_formatter
    filter = RougeFilter.new

    assert_kind_of(Rouge::Formatters::HTMLLegacy, filter.formatter)
  end

  def test_default_lexer
    filter = RougeFilter.new

    assert_equal(Rouge::Lexers::PlainText, filter.lexer_for("not-exist"))
  end

  def test_lexer_can_be_specified
    filter = RougeFilter.new

    assert_kind_of(Rouge::Lexers::Shell, filter.lexer_for("shell"))
  end

  def test_replacing_br_and_default_css_class
    result = RougeFilter.call(
      "<pre lang='ruby'>hello<br>world</pre>", context: {replace_br: true, css_class: 'codehilite'}
    )

    assert_equal(<<-EXPECTED.rstrip, result
<pre lang='ruby' class=\"highlight codehilite-ruby\"><div class=\"highlight\"><pre class=\"codehilite\"><code><span class=\"n\">hello</span></code></pre></div>
world</pre>
    EXPECTED
    )
  end
end
