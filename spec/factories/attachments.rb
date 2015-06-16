FactoryGirl.define do
  factory :attachment do
    file File.new("#{Rails.root}/spec/fixtures/screenshot0.jpg")
  end
end
