require 'sinatra/base'

class Subtrees < Sinatra::Base

  # articles and all associated images live like this:
  #
  # /public
  #   /articles
  #     /article-slug-1
  #       article.markdown
  #       pic-1.png
  #       pic-2.png
  #     /article-slug-2
  #       article.markdown
  #       pic-1.png
  #       pic-2.png
  #
  # And inside the markdown images are referred to as if local, e.g. `![My pic](pic-1.png)`


  get '/' do
    all_slugs = Dir.glob(settings.public_folder + '/articles/*')
    markdown all_slugs.inject("# Hello World!\n\n") {|md,slug| md + 
      "- [#{File.basename(slug)}](/article/#{File.basename(slug)})\n"}
  end


  get '/article/*' do |slug|
    body = File.read(settings.public_folder + "/articles/#{slug}/article.markdown")

    markdown_img_matcher = /\!\[(?<alt>.*)\]\((?<pic>.+\.png)\)/
    replacement = "![\\k<alt>](/articles/#{slug}/\\k<pic>)"
    body.gsub!(markdown_img_matcher, replacement)
    markdown body
  end
end