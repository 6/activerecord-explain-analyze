module ActiveRecordExplainAnalyze
  module Relation
    EXPLAIN_FORMATS = [
      "JSON",
      "TEXT",
      "XML",
      "YAML",
    ].freeze

    def explain(analyze: false, format: :text)
      format = format.to_s.upcase
      unless EXPLAIN_FORMATS.include?(format)
        raise ArgumentError, "format must be one of: #{EXPLAIN_FORMATS.join(', ')}"
      end

      queries = collecting_queries_for_explain { exec_queries }
      if analyze || format != "TEXT"
        exec_explain_with_options(queries, analyze: analyze, format: format)
      else
        exec_explain(queries)
      end
    end

    def exec_explain_with_options(queries, analyze:, format:)
      str = queries.map do |sql, binds|
        msg = "EXPLAIN for: #{sql}\n".dup
        msg << connection.explain_with_options(sql, binds, analyze, format)
      end.join("\n")

      # Overriding inspect to be more human readable, especially in the console.
      def str.inspect
        self
      end

      str
    end
  end
end
