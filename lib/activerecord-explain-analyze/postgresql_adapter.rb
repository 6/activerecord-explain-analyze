module ActiveRecordExplainAnalyze
  module PostgreSQLAdapter
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
end
