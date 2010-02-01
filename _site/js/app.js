var Blog = {
  
  getTwitter: function() {
    $("#tweets").getTwitter({
      userName: "rokmihevc",
      numTweets: 3,
      slideIn: true,
      showHeading: true,
      headingText: 'Recently on <a href="http://twitter.com/rokmihevc">Twitter</a>:',
      showProfileLink: false,
      rejectRepliesOutOf: 20
    });
  },

  init: function() {
    this.getTwitter();
  }
  
};

$(function() { Blog.init() });