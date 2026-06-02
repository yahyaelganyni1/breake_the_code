module GamesHelper
  ACHIEVEMENT_LABELS = {
    speed_demon:  "⚡ Speed Demon",
    sharpshooter: "🎯 Sharpshooter",
    pure_skill:   "🧠 Pure Skill",
    hard_mode:    "🔥 Hard Mode Hero",
    flawless:     "💎 Flawless"
  }.freeze

  def achievement_label(badge)
    ACHIEVEMENT_LABELS[badge.to_sym] || badge.to_s.titleize
  end

  def difficulty_label(game)
    game.difficulty.to_s.capitalize
  end

  def share_text(game)
    "I just cracked the code on #{difficulty_label(game)} in #{game.attempts} attempts! 🎉 Can you beat me?"
  end

  def share_text_with_tag(game)
    "#{share_text(game)} #BreakTheCode"
  end

  def share_message(game)
    "#{share_text(game)} Play Break the Code: #{game_url(game)}"
  end

  def share_on_facebook(game)
    "https://www.facebook.com/sharer/sharer.php?#{{ u: game_url(game), quote: share_text(game) }.to_query}"
  end

  def share_on_twitter(game)
    "https://twitter.com/intent/tweet?#{{ text: share_text_with_tag(game), url: game_url(game) }.to_query}"
  end

  def share_on_whatsapp(game)
    "https://wa.me/?#{{ text: share_message(game) }.to_query}"
  end

  def share_on_telegram(game)
    "https://t.me/share/url?#{{ url: game_url(game), text: share_text(game) }.to_query}"
  end

  def share_on_linkedin(game)
    "https://www.linkedin.com/sharing/share-offsite/?#{{ url: game_url(game) }.to_query}"
  end

  def share_on_reddit(game)
    "https://www.reddit.com/submit?#{{ url: game_url(game), title: share_text(game) }.to_query}"
  end

  def share_via_email(game)
    "mailto:?#{{ subject: 'Break the Code — beat my score!', body: share_message(game) }.to_query}"
  end
end
