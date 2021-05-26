require 'rails_helper'

RSpec.describe GuestPost, type: :model do

    describe "#create" do

        context "when called with no url" do

            let(:guest_post) { GuestPost.create }

            it "doesn't create record" do
                expect { guest_post }.to_not change { GuestPost.count }
            end

            it "returns three errors" do
                expect(guest_post.errors.count).to eql 3
            end

            it "returns url blank error" do
                expect(guest_post.errors[:url].first).to eql "can't be blank"
            end

            it "returns invalid url error" do
                expect(guest_post.errors[:url].last).to eql "not a valid URL"
            end

            it "returns batch blank error" do
                expect(guest_post.errors[:batch].first).to eql "must exist"
            end

        end

        context "when called with valid url" do

            let(:batch) { Batch.create(:urls => ENV["valid_google_doc_links"]) }

            let(:guest_post) { batch.guest_posts.create(:url => ENV["first_google_doc_link"]) }

            it "creates record" do
                expect { guest_post }.to change { GuestPost.count }.by 1
            end

        end

        context "when called with invalid url" do

            let(:batch) { Batch.create(:urls => ENV["valid_google_doc_links"]) }

            let(:guest_post) { batch.guest_posts.create(:url => "!@#$%^&*()") }

            it "doesn't create record" do
                expect { guest_post }.to_not change { GuestPost.count }
            end

            it "returns one error" do
                expect(guest_post.errors.count).to eql 1
            end

            it "returns invalid url error" do
                expect(guest_post.errors[:url].first).to eql "not a valid URL"
            end

        end

        context "when called with url that isn't google doc" do

            let(:batch) { Batch.create(:urls => ENV["valid_google_doc_links"]) }

            let(:guest_post) { batch.guest_posts.create(:url => "https://www.youtube.com/") }

            it "doesn't create record" do
                expect { guest_post }.to_not change { GuestPost.count }
            end

            it "returns one error" do
                expect(guest_post.errors.count).to eql 1
            end

            it "returns not found in google drive error" do
                expect(guest_post.errors[:url].first).to eql "not found in Google Drive"
            end

        end

        context "when called with locked url" do

            let(:batch) { Batch.create(:urls => ENV["valid_google_doc_links"]) }

            let(:guest_post) { batch.guest_posts.create(:url => ENV["private_google_doc_link"]) }

            it "doesn't create record" do
                expect { guest_post }.to_not change { GuestPost.count }
            end

            it "returns one error" do
                expect(guest_post.errors.count).to eql 1
            end

            it "returns check permissions error" do
                expect(guest_post.errors[:url].first).to eql "not found (check file permissions)"
            end

        end

    end

    describe ".get_links" do

        let(:batch) { Batch.create(:urls => ENV["valid_google_doc_links"]) }

        let(:guest_post) { batch.guest_posts.create(:url => ENV["sample_guest_post"]) }

        it "identifies number of links correctly" do
            expect(guest_post.get_links.count).to eql 4
        end

        it "identifies correct links" do
            expect(guest_post.get_links.values).to eql ENV["sample_guest_post_urls"].split(" ")
        end

        it "identifies correct anchors" do
            expect(guest_post.get_links.keys).to eql ["Click here", "Formica", "outdoor kitchen.", "uses for epoxy"]
        end

    end

end
