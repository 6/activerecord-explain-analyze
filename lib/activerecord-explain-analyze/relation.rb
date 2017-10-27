module ActiveRecordExplainAnalyze
  module Relation
    EXPLAIN_FORMATS = [
      "JSON",
      "TEXT",
      "XML",
      "YAML",
    ].freeze

    original_explain = instance_method(:explain)

    def explain(analyze: false, format: :text)
      format = format.to_s.upcase
      unless EXPLAIN_FORMATS.include?(format)
        raise ArgumentError, "format must be one of: #{EXPLAIN_FORMATS.join(', ')}"
      end

      if analyze || format != "TEXT"
        exec_explain_with_options(collecting_queries_for_explain { exec_queries }, analyze: analyze, format: format)
      else
        original_explain
      end
    end
  end
end
