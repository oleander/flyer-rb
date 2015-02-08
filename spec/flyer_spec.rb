describe Flyer::Notification do
  let(:message) { SecureRandom.hex }

  it "should have a message" do
    Flyer::Notification.init do |config|
      config.id = "new-user"
      config.smessage { "This is my message" }
      config.spath { root_path }
    end

    visit "/"
    expect(page).to have_content("This is my message")
  end
end