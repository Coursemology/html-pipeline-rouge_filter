# frozen_string_literal: true

require 'html_pipeline/node_filter'

HTMLPipeline.require_dependency("rouge", "RougeFilter")

class HTMLPipeline
  class NodeFilter
    class RougeFilter < NodeFilter
      SELECTOR = Selma::Selector.new(match_element: "pre, br, lang, class", match_text_within: "pre")

      def selector
        SELECTOR
      end

      def handle_element(element)
        default = must_str(context[:highlight])
        @lang = element["lang"] || default

        if replace_br && element.tag_name == "br"
          element.after("\n", as: :html)
          element.remove
        end

        klass = element["class"] || "highlight"
        element["class"] = "#{klass} #{default_css_class}-#{@lang}" if include_lang?
      end

      def handle_text_chunk(text)
        return if @lang.nil?
        return if (lexer = lexer_for(@lang)).nil?

        content = text.to_s

        text.replace(highlight_with(lexer, content), as: :html)
      end

      def highlight_with(lexer, text)
        formatter.format(lexer.lex(text))
      end

      def default_css_class
        must_str(context[:css_class]) || "highlight"
      end

      def line_numbers
        context[:line_numbers] || false
      end

      def replace_br
        context[:replace_br] || false
      end

      def formatter(css_class: default_css_class)
        Rouge::Formatters::HTMLLegacy.new(css_class: css_class,
                                    line_numbers: line_numbers)
      end

      def lexer_for(lang)
        Rouge::Lexer.find_fancy(lang) || Rouge::Lexers::PlainText
      end

      def include_lang?
        !@lang.nil? && !@lang.empty?
      end

      private

      def must_str(text)
        text && text.to_s
      end

      def rename_br(elem)
        elem.sub("br", "\n")
      end
    end
  end
end
