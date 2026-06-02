# Break the Code 🔐

A web-based code-breaking game built with Ruby on Rails. Test your deduction skills by cracking a secret code before your attempts run out!

## 🎮 Live Demo

🌐 **[Play Break the Code](https://breake-the-code-2duiqa.fly.dev/)**

## 🎯 Game Overview

Break the Code is a digital take on the classic Mastermind game. A secret code is generated at the start of each game — your job is to crack it using logical deduction and the color-coded feedback after each guess.

### 🎲 How to Play

1. **Choose a Difficulty** and click "Start New Game"
2. **Enter Your Guess**: type in the digits and submit
3. **Read the Feedback** — indicators appear after each guess:
   - 🟢 **Green**: correct digit in the correct position
   - 🟡 **Yellow**: correct digit but wrong position
   - 🔴 **Red**: digit is not in the code at all
   > ⚠️ Feedback indicators are **shuffled** — they don't correspond to digit positions directly.
4. **Use a Hint** (once per game) to reveal one digit and its exact position
5. **Win or Lose**: crack the code within the allowed attempts!

### 🏅 Difficulty Levels

| Difficulty | Code Length | Digit Pool | Max Attempts | Score Multiplier |
|------------|-------------|------------|--------------|-----------------|
| Easy       | 4 digits    | 1–9        | 10           | ×1.0            |
| Normal     | 4 digits    | 0–9        | 10           | ×1.5            |
| Hard       | 4 digits    | 0–9        | 8            | ×2.5            |

### 🏆 Scoring System

Scoring only applies when you win. Your final score is:

```
final = (base − attempt_penalty − time_penalty − hint_penalty) × difficulty_multiplier
```

| Component        | Value                                  |
|------------------|----------------------------------------|
| Base score       | 1,000 points                           |
| Attempt penalty  | −60 points per guess (after the first) |
| Time penalty     | −10 points per minute elapsed          |
| Hint penalty     | −150 points if a hint was used         |
| Difficulty bonus | ×1.0 / ×1.5 / ×2.5                    |
| Minimum score    | 0 (no negative scores)                 |

### 🎖️ Achievements

Earn badges within a game for exceptional play:

| Badge            | Condition                                       |
|------------------|-------------------------------------------------|
| ⚡ Speed Demon   | Win in under 60 seconds                         |
| 🎯 Sharpshooter  | Win in 4 guesses or fewer                       |
| 🧠 Pure Skill    | Win without using a hint                        |
| 💀 Hard Mode     | Win on Hard difficulty                          |
| ✨ Flawless      | Every guess contained at least one green digit  |

### 🏅 Leaderboard

Top 10 all-time scores are displayed on the home page, ranked by score, then fewest attempts, then fastest time.

## 🚀 Features

- **Three Difficulty Levels**: Easy, Normal, and Hard with different digit pools, attempt limits, and score multipliers
- **Hint System**: Reveal one secret digit per game (at a score penalty)
- **Achievements**: Earn in-game badges for exceptional performance
- **Leaderboard**: Top 10 high scores on the home screen
- **Shareable Games**: Every game has a unique URL token
- **Clean UI**: Responsive design with real-time feedback
- **Game Analytics**: Tracks device, browser, and location data anonymously

## 🛠 Technical Stack

- **Backend**: Ruby on Rails 7.0.8
- **Database**: PostgreSQL
- **Frontend**: HTML5, CSS3, Hotwire (Turbo + Stimulus)
- **Deployment**: Fly.io
- **Ruby**: 3.2.2

### Key Dependencies

| Gem | Purpose |
|-----|---------|
| `pg` | PostgreSQL adapter |
| `puma` | Web server |
| `turbo-rails` | SPA-like page transitions |
| `stimulus-rails` | JS framework |
| `geocoder` | Location-based analytics |
| `browser` | Device/browser detection |
| `redis` | Action Cable support |

## 🔧 Setup and Installation

### Prerequisites

- Ruby 3.2.2
- PostgreSQL
- Bundler

### Local Development

```bash
# 1. Clone the repository
git clone https://github.com/yahyaelganyni1/breake_the_code.git
cd breake_the_code

# 2. Install dependencies
bundle install

# 3. Set up the database
rails db:create db:migrate

# 4. Start the server
rails server
```

Then open [http://localhost:3000](http://localhost:3000).

## 📊 Game Analytics

Each game anonymously records:

- Device type, browser name & version, platform
- IP address, country, and city (via geocoder)
- Referrer URL and user agent

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/my-feature`
3. Commit your changes: `git commit -m 'Add my feature'`
4. Push to the branch: `git push origin feature/my-feature`
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

---

Built with ❤️ using Ruby on Rails · **[Play now!](https://breake-the-code-2duiqa.fly.dev/)**
