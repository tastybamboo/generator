require "open-uri"
require "zip"

# TODO: This works whilst the gem is in development, but
# will need to be updated when released to:
# gem "panda_cms"
add_source "https://rubygems.pkg.github.com/pandacms" do
  gem "panda_cms"
end


# Choose a test framework
test_framework = "minitest"

if yes?("Do you want to replace minitest with rspec?")
  test_framework = "rspec"
  gem_group :development, :test do
    gem "rspec-rails"
    gem "standard"
  end

  run "rm -rf test"
else
  # We're vaguely opinionated, so let's assume people want nice code... 🎋
  gem_group :development, :test do
    gem "standard"
  end
end

# Download the theme and extract it into app/views
theme = "plain24"
theme_url = "https://github.com/pandacms/generator/raw/main/themes/#{theme}.zip"
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
  rails_command "generate panda_cms:install"
  rails_command "db:create"
  rails_command "db:migrate"
  rails_command "db:seed"

  git :init
  git add: "."
  git commit: %( -m '🐼' )
end
