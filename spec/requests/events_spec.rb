require "rails_helper"

RSpec.describe "Events", type: :request do
  let(:admin) { User.create!(email: "admin@kotonoha.cl", password: "a-long-password", role: :admin) }

  describe "GET /events" do
    it "returns http success" do
      get events_path
      expect(response).to have_http_status(:success)
    end

    it "hides events flagged as hidden from guests" do
      Event.create!(title: "Secreto", event_date: 1.week.from_now, hidden: true)

      get events_path

      expect(response.body).not_to include("Secreto")
    end

    it "shows hidden events to a signed-in admin" do
      Event.create!(title: "Secreto", event_date: 1.week.from_now, hidden: true)
      sign_in admin

      get events_path

      expect(response.body).to include("Secreto")
    end
  end

  describe "as a guest (not signed in)" do
    it "cannot reach the new event form" do
      get new_event_path
      expect(response).to redirect_to(events_path)
    end

    it "cannot create an event" do
      expect {
        post events_path, params: { event: { title: "Ciclo de cine", event_date: 1.week.from_now } }
      }.not_to change(Event, :count)
    end

    it "cannot edit an event" do
      event = Event.create!(title: "Evento", event_date: 1.week.from_now)
      get edit_event_path(event)
      expect(response).to redirect_to(events_path)
    end

    it "cannot toggle hidden" do
      event = Event.create!(title: "Evento", event_date: 1.week.from_now, hidden: false)
      patch toggle_hidden_event_path(event)
      expect(event.reload.hidden).to be false
    end

    it "cannot delete an event" do
      event = Event.create!(title: "Evento", event_date: 1.week.from_now)
      expect { delete event_path(event) }.not_to change(Event, :count)
    end

    it "does not show admin controls on the event page" do
      event = Event.create!(title: "Evento", event_date: 1.week.from_now)
      get event_path(event)
      expect(response.body).not_to include("Editar")
    end
  end

  describe "as a signed-in admin" do
    before { sign_in admin }

    describe "POST /events" do
      it "creates an event with valid params" do
        expect {
          post events_path, params: { event: { title: "Ciclo de cine", event_date: 1.week.from_now } }
        }.to change(Event, :count).by(1)

        expect(response).to redirect_to(Event.last)
      end

      it "re-renders the form with errors when invalid" do
        expect {
          post events_path, params: { event: { title: "", event_date: nil } }
        }.not_to change(Event, :count)

        expect(response).to have_http_status(:unprocessable_content)
      end

      it "accepts an attached image" do
        file = fixture_file_upload("spec/fixtures/files/test_image.png", "image/png")

        post events_path, params: { event: { title: "Con imagen", event_date: 1.week.from_now, image: file } }

        expect(Event.last.image).to be_attached
      end
    end

    describe "PATCH /events/:id/toggle_hidden" do
      it "flips the hidden flag" do
        event = Event.create!(title: "Evento", event_date: 1.week.from_now, hidden: false)

        patch toggle_hidden_event_path(event)

        expect(event.reload.hidden).to be true
      end
    end

    describe "DELETE /events/:id" do
      it "removes the event" do
        event = Event.create!(title: "Evento", event_date: 1.week.from_now)

        expect { delete event_path(event) }.to change(Event, :count).by(-1)
      end
    end
  end
end
