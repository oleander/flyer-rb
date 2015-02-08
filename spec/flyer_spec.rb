describe Flyer::Notification do
  let(:message) { SecureRandom.hex }
  let(:id) { SecureRandom.hex }

  before(:each) do
    Flyer::Notification.reset!
  end

  it "should have a message" do
    Flyer::Notification.init do |config|
      config.id = id
      config.smessage { "This is my message" }
    end

    visit "/"
    expect(page).to have_content("This is my message")
  end

  it "should not appear when on is false" do
    Flyer::Notification.init do |config|
      config.id = id
      config.smessage { "This is another message" }
      config.on { false }
    end

    visit "/"
    expect(page).not_to have_content("This is another message")
  end

  it "should handle on's as 'or'" do
    Flyer::Notification.init do |config|
      config.id = id
      config.smessage { "How about this?" }
      config.on { false }
      config.on { true }
    end

    visit "/"
    expect(page).to have_content("How about this?")
  end

  it "should handle limit" do
    Flyer::Notification.init do |config|
      config.id = id
      config.smessage { "This one?" }
      config.limit = 0
    end

    visit "/"
    expect(page).not_to have_content("This one?")
  end

  it "should handle limit" do
    Flyer::Notification.init do |config|
      config.id = id
      config.smessage { "Twice is NOT okay!" }
      config.limit = 1
    end

    visit "/"
    expect(page).to have_content("Twice is NOT okay!")

    visit "/"
    expect(page).not_to have_content("Twice is NOT okay!")
  end

  it "should set path" do
    Flyer::Notification.init do |config|
      config.id = id
      config.smessage { 1 }
      config.spath { path_path }
    end

    visit path_path
    expect(page).to have_content("My path is #{path_path}")
  end

  it "should raise error if path isn't set" do
    Flyer::Notification.init do |config|
      config.id = id
      config.smessage { 1 }
    end

    expect { visit path_path }.to raise_error(ActionView::Template::Error)
  end
end