describe ActiveRecordExplainAnalyze do
  it "has a version number" do
    expect(described_class::VERSION).not_to be nil
  end

  describe "#explain" do
    before do
      Car.create!(model: "tesla")
      Car.create!(model: "bmw")
    end

    context "without any args" do
      it "returns normal explain output" do
        output = Car.where(model: "bmw").explain
        # AR 7.1+ has slightly different output:
        if ActiveRecord::VERSION::MAJOR >= 7 && ActiveRecord::VERSION::MINOR >= 1
          expect(output).to start_with(%{EXPLAIN SELECT "cars"})
        else
          expect(output).to start_with(%{EXPLAIN for: SELECT "cars"})
        end
        expect(output).not_to include("actual time")
      end
    end

    context "with analyze: true" do
      it "returns EXPLAIN ANALYZE output" do
        output = Car.where(model: "bmw").explain(analyze: true)
        expect(output).to start_with(%{EXPLAIN for: SELECT "cars"})
        expect(output).to include("actual time")
      end
    end

    context "with analyze: true, format: :json" do
      it "returns EXPLAIN ANALYZE output in JSON format" do
        output = Car.where(model: "bmw").explain(analyze: true, format: :json)
        json = JSON.parse(output.lines[1..-1].join)
        expect(json).to be_a(Array)
        expect(json.first["Plan"]).to include("Node Type" => "Seq Scan")
      end
    end
  end
end
