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

        context "when called with urls" do

            let(:batch) { Batch.create(:urls => ENV["valid_google_doc_links"]) }

            it "creates record" do
                expect { batch }.to change { Batch.count }.by 1
            end

        end

    end

    describe ".split_urls" do

        context "when called" do

            let(:batch) { Batch.create(:urls => ENV["valid_google_doc_links"]) }

            it "extracts correct number of urls" do
                expect(batch.split_urls.count).to eql 5
            end

            it "extracts first url correctly" do
                expect(batch.split_urls.first).to eql ENV["first_google_doc_link"]
            end

            it "extracts second url correctly" do
                expect(batch.split_urls[1]).to eql ENV["second_google_doc_link"]
            end

            it "extracts third url correctly" do
                expect(batch.split_urls[2]).to eql ENV["third_google_doc_link"]
            end

            it "extracts fourth url correctly" do
                expect(batch.split_urls[3]).to eql ENV["fourth_google_doc_link"]
            end

            it "extracts fifth url correctly" do
                expect(batch.split_urls[4]).to eql ENV["fifth_google_doc_link"]
            end

        end

    end

end