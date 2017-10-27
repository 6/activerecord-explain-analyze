module ActiveRecordExplainAnalyze
  module ExecExplain
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
end
