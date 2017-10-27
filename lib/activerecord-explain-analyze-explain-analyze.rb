require "active_record"
require "activerecord-explain-analyze/version"
require "activerecord-explain-analyze/exec_explain"
require "activerecord-explain-analyze/relation"
require "activerecord-explain-analyze/postgresql_adapter"

ActiveRecord::Base.extend(ActiveRecordExplainAnalyze::ExecExplain)
ActiveRecord::Relation.extend(ActiveRecordExplainAnalyze::Relation)
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.extend(ActiveRecordExplainAnalyze::PostgreSQLAdapter)
