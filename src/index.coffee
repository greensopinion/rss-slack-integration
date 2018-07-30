Watcher = require 'rss-watcher'
request = require 'request'

exports.start = (config) ->

  watcher = new Watcher config.feed

  watcher.set
    feed: config.feed
    interval: config.interval

  sendSlackNotification = (prefix,article) ->
    request.post
      url: config.slackHook,
      body: JSON.stringify(
        {"username": config.slackBotUser
        "text": "#{prefix}: <#{article.link}|#{article.title}>"
        "icon_url": config.slackIcon})
      headers:
        "Content-Type": "application/json"

  watcher.on "new article", (article) ->
    sendSlackNotification("New post",article)
  
  watcher.on "updated article", (article) ->
    sendSlackNotification("Updated post",article)

  watcher.run (error, articles) ->
    console.log "Started watching rss feed."
