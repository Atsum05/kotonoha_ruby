require "rails_helper"

RSpec.describe Event, type: :model do
  def build_event(attrs = {})
    Event.new({ title: "Charla de origami", event_date: 1.day.from_now }.merge(attrs))
  end

  it "is valid with just a title and event_date" do
    expect(build_event).to be_valid
  end

  it "requires a title" do
    event = build_event(title: nil)
    expect(event).not_to be_valid
  end

  it "requires an event_date" do
    event = build_event(event_date: nil)
    expect(event).not_to be_valid
  end

  it "allows a nil capacity (unlimited spots)" do
    event = build_event(capacity: nil)
    expect(event).to be_valid
    expect(event.unlimited_capacity?).to be true
  end

  it "rejects a zero or negative capacity" do
    expect(build_event(capacity: 0)).not_to be_valid
    expect(build_event(capacity: -5)).not_to be_valid
  end

  describe "scopes" do
    let!(:upcoming_event) { Event.create!(title: "Futuro", event_date: 1.day.from_now) }
    let!(:past_event) { Event.create!(title: "Pasado", event_date: 1.day.ago) }
    let!(:hidden_event) { Event.create!(title: "Oculto", event_date: 1.day.from_now, hidden: true) }

    it "upcoming only returns future events" do
      expect(Event.upcoming).to include(upcoming_event, hidden_event)
      expect(Event.upcoming).not_to include(past_event)
    end

    it "past only returns events before now" do
      expect(Event.past).to include(past_event)
      expect(Event.past).not_to include(upcoming_event)
    end

    it "visible excludes hidden events" do
      expect(Event.visible).not_to include(hidden_event)
      expect(Event.visible).to include(upcoming_event, past_event)
    end
  end

  describe "#past?" do
    it "is true once the event_date has passed" do
      expect(build_event(event_date: 1.day.ago).past?).to be true
      expect(build_event(event_date: 1.day.from_now).past?).to be false
    end
  end
end
