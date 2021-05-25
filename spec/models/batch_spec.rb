require 'rails_helper'

RSpec.describe Batch, :type => :model do

    describe "#create" do

        context "when called without urls" do

            let(:batch) { Batch.create }

            it "doesn't create record" do
                expect { batch }.to_not change { Batch.count }
            end

            it "returns one error" do
                expect(batch.errors.count).to eql 1
            end

            it "returns urls blank error" do
                expect(batch.errors[:urls].first).to eql "can't be blank"
            end

        end

    end

end