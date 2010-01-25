task :default => :build
 
namespace :post do
  desc "Create a new post and launch e"
  task :new do
    system "ruby create.rb"
  end
end
 
desc "rebuild the jekyll page"
task :rebuild do
  system "rm -rf _site"
  system "jekyll --no-auto"
end
 
desc "build the jekyll page"
task :build do
  system "jekyll --no-auto"
end
 
namespace :web do
  desc "run server and browser"
  task :start do
    server = Thread.new { system "jekyll --server" }
    browser = Thread.new { sleep 10; system "open http://localhost:3000/" }
    server.join
    browser.join
  end
end
 
desc "launch default browser"
task :launch do
  system "open _site/index.html"
end
 
desc "deploy site to Heroku and Github"
task :deploy do
  system "jekyll"
  system "git add _posts/* _site/*"
  system "git commit -a -m 'updated page'"
  system "git push heroku master"
  system "git push origin master"
end