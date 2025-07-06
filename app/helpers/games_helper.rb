module GamesHelper
  def share_on_facebook(game)
    share_text = "I just cracked the code in #{game.attempts} attempts! 🎉 Can you beat me?"
    share_url = game_url(game)

    facebook_url = "https://www.facebook.com/sharer/sharer.php"
    params = {
      u: share_url,
      quote: share_text
    }

    "#{facebook_url}?#{params.to_query}"
  end

  def share_on_twitter(game)
    share_text = "I just cracked the code in #{game.attempts} attempts! 🎉 Can you beat me? #BreakTheCode"
    share_url = game_url(game)

    twitter_url = "https://twitter.com/intent/tweet"
    params = {
      text: share_text,
      url: share_url
    }

    "#{twitter_url}?#{params.to_query}"
  end

  def share_message(game)
    "I just cracked the code in #{game.attempts} attempts! 🎉 Can you beat me? Play Break the Code: #{game_url(game)}"
  end
end
