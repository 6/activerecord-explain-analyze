require "active_record"

module ActiveRecord
  class ConnectionAdapters::PostgreSQLAdapter
    def explain_with_options(arel, binds = [], analyze, format)
      options = []
      options.concat(["ANALYZE", "COSTS", "VERBOSE", "BUFFERS"]) if analyze
      options << "FORMAT #{format}" unless format == "TEXT"
      options_sql = options.size > 0 ? "(#{options.join(', ')})" : ""

      sql = "EXPLAIN #{options_sql} #{to_sql(arel, binds)}"
      result = exec_query(sql, "EXPLAIN", binds)

      if format == "TEXT" && explain_pretty_printer
        explain_pretty_printer.new.pp(result)
      else
        result.rows.map(&:first).join("\n")
      end
    end

    private

    def explain_pretty_printer
      if defined?(ExplainPrettyPrinter)
        # Rails 4:
        ExplainPrettyPrinter
      elsif defined?(PostgreSQL::ExplainPrettyPrinter)
        # Rails 5:
        PostgreSQL::ExplainPrettyPrinter
      else
        nil
      end
    end
  end

  module Explain
    def exec_explain_with_options(queries, analyze:, format:)
      str = queries.map do |sql, binds|
        msg = "EXPLAIN ("
        msg << "ANALYZE COSTS VERBOSE BUFFERS " if analyze
        msg << "FORMAT #{format})"
        msg << " for: #{sql}".dup
        unless binds.empty?
          msg << " "
          msg << binds.map { |attr| render_bind(attr) }.inspect
        end
        msg << "\n"
        msg << connection.explain_with_options(sql, binds, analyze, format)
      end.join("\n")

      # Overriding inspect to be more human readable, especially in the console.
      def str.inspect
        self
      end

      str
    end
  end

  class Relation
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
