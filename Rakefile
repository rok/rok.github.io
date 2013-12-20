task :default => :preview

desc "rebuild the site and start the server"
task :preview do
  system "rm -rf _site"
  system "jekyll serve watch"
  system "open _site/index.html"
end

namespace :post do
  desc "Create a new post"
  task :new do
    system "ruby create.rb"
  end
end
 
desc "deploy site to Dreamhost and Github"
task :deploy do
  system "jekyll"
  system "git add ."
  system 'git commit -m "scripted update"'
  system "git push dreamhost master"
  system "git push origin master"
end
