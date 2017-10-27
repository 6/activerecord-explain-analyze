require "active_record"
require "active_record/connection_adapters/postgresql_adapter"

require "activerecord-explain-analyze/version"
require "activerecord-explain-analyze/relation"
require "activerecord-explain-analyze/postgresql_adapter"

ActiveRecord::Relation.extend(ActiveRecordExplainAnalyze::Relation)
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.extend(ActiveRecordExplainAnalyze::PostgreSQLAdapter)
