# activerecord-explain-analyze [![CircleCI](https://circleci.com/gh/6/activerecord-explain-analyze.svg?style=svg)](https://circleci.com/gh/6/activerecord-explain-analyze)

Extends ActiveRecord#explain with support for EXPLAIN ANALYZE and output formats of JSON, XML, and YAML.

It currently supports ActiveRecord 4 and 5, and PostgreSQL only.

### Examples:

```ruby
Wallet.where(base_currency: "USD").explain(analyze: true)
```
Results in:

```sql
EXPLAIN for: SELECT "wallets".* FROM "wallets" WHERE "wallets"."deleted_at" IS NULL AND "wallets"."base_currency" = $1
Bitmap Heap Scan on public.wallets  (cost=4.16..9.50 rows=1 width=164) (actual time=0.008..0.012 rows=30 loops=1)
  Output: id, canonical_id, client_id, wallet_type, base_currency, created_at, updated_at, deleted_at
  Recheck Cond: (wallets.deleted_at IS NULL)
  Filter: ((wallets.base_currency)::text = 'USD'::text)
  Heap Blocks: exact=1
  Buffers: shared hit=2
  ->  Bitmap Index Scan on index_wallets_on_deleted_at  (cost=0.00..4.16 rows=2 width=0) (actual time=0.003..0.003 rows=32 loops=1)
        Index Cond: (wallets.deleted_at IS NULL)
        Buffers: shared hit=1
Planning time: 0.041 ms
Execution time: 0.026 ms
```

```ruby
Wallet.where(base_currency: "USD").explain(analyze: true, format: :json)
```

Results in:

```json
[
  {
    "Plan": {
      "Node Type": "Bitmap Heap Scan",
      "Parallel Aware": false,
      "Relation Name": "wallets",
      "Schema": "public",
      "Alias": "wallets",
      "Startup Cost": 4.16,
      "Total Cost": 9.50,
      "Plan Rows": 1,
      "Plan Width": 164,
      "Actual Startup Time": 0.008,
      "Actual Total Time": 0.013,
      "Actual Rows": 30,
      ...
```

You can then paste this JSON output into [PEV](http://tatiyants.com/pev/) or similar tools to get a visualization of the EXPLAIN query output:

<img width="673" alt="screen shot 2017-10-27 at 4 24 38 pm" src="https://user-images.githubusercontent.com/158675/32123765-6b4938ae-bb33-11e7-80b6-7d9ceac013e2.png">


## Installation

Add this line to your application's Gemfile and run `bundle` to install:

```ruby
gem 'activerecord-explain-analyze'
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).
