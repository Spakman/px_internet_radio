task :default => :test

desc "Run all the tests"
task :test => [ "test:models", "test:cards" ]

namespace :test do
  desc "Run the model tests"
  task :models do
    Dir.glob "#{File.dirname(__FILE__)}/test/models/*.rb" do |file|
      require file
    end
  end
end

namespace :test do
  desc "Run the card tests"
  task :cards do
    Dir.glob "#{File.dirname(__FILE__)}/test/cards/*.rb" do |file|
      require file
    end
  end
end

desc "Generate the RDoc HTML documentation"
task :doc do
  FileUtils.rm_rf "#{File.dirname(__FILE__)}/doc/"
  system 'rdoc . --exclude="test/*.rb" --exclude="Rakefile" -N -v'
end
