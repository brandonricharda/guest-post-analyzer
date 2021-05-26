require 'rails_helper'

RSpec.describe GuestPost, type: :model do

    describe "#create" do

        context "when called with no url" do

            let(:guest_post) { GuestPost.create }

            it "doesn't create record" do
                expect { guest_post }.to_not change { GuestPost.count }
            end

            it "returns two errors" do
                expect(guest_post.errors.count).to eql 2
            end

            it "returns url blank error" do
                expect(guest_post.errors[:url].first).to eql "can't be blank"
            end

            it "returns invalid url error" do
                expect(guest_post.errors[:url].last).to eql "not a valid URL"
            end

        end

        context "when called with valid url" do

            let(:guest_post) { GuestPost.create(:url => ENV["first_google_doc_link"]) }

            it "creates record" do
                expect { guest_post }.to change { GuestPost.count }.by 1
            end

        end

        context "when called with invalid url" do

            let(:guest_post) { GuestPost.create(:url => "!@#$%^&*()") }

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

            let(:guest_post) { GuestPost.create(:url => "https://www.youtube.com/") }

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

            let(:guest_post) { GuestPost.create(:url => ENV["private_google_doc_link"]) }

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

end
