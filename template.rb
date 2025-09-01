require "open-uri"
require "zip"

gem "panda-cms"

# Choose a test framework
test_framework = "minitest"

if yes?("Do you want to replace minitest with rspec?")
  test_framework = "rspec"
  gem_group :development, :test do
    gem "rspec-rails"
  end

  run "rm -rf test"
end

# Download the theme and extract it into app/views
theme = "plain24"
theme_url = "https://github.com/tastybamboo/generator/raw/main/themes/#{theme}.zip"
puts "Downloading theme #{theme}..."
URI.open(theme_url) do |file| # rubocop:disable Security/Open
  Zip::File.open_buffer(file) do |zip_file|
    zip_file.each do |entry|
      entry.extract("app/views/#{entry.name.delete_prefix("#{theme}/")}")
    end
  end
end

run "bundle install"

after_bundle do
  rails_command "generate rspec:install" if test_framework == "rspec"
  rails_command "generate panda:core:install"
  rails_command "generate panda:cms:install"
  rails_command "panda:core:install:migrations"
  rails_command "panda:cms:install:migrations"
  rails_command "db:create"
  rails_command "db:migrate"
  rails_command "db:seed"

  git :init
  git add: "."
  git commit: %( -m '🐼' )
end
