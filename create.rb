print "Title: "
title = gets.chomp
print "Tag: "
tag = gets.chomp
print "Location: "
location = gets.chomp
post = "#{Time.now.strftime("%Y-%m-%d")} #{title.downcase}".gsub(/ /,'-')
file = "_posts/#{post}.textile"
File.open(file,"w") do |f|
f.write <<EOF
---
layout: post
title: #{title}
tag: #{tag}
---
 
h2. {{ page.title }}

p(meta). {{ Time.now.strftime("%Y-%m-%d") }} - {{ location }}

EOF
end
#system "mate #{file}"
system "e #{file}"
 