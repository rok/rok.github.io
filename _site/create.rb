print "Title: "
title = gets.chomp
print "Tag: "
tag = gets.chomp
print "Location: "
location = gets.chomp
time = Time.now.strftime("%d %B %Y")
post = "#{Time.now.strftime("%Y-%m-%d")} #{title.downcase}".gsub(/ /,'-')
file = "_posts/#{post}.textile"
File.open(file,"w") do |f|
f.write <<EOF
---
layout: post
title: #{title}
tag: #{tag}
location: #{location}
time: #{time}
---
 
h2. {{ page.title }}

p(meta). {{ page.time }} - {{ page.location }}

EOF
end
#system "mate #{file}"
system "notepad++ #{file}"