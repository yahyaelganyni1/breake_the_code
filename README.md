# Break the Code 🔐

A challenging and engaging web-based code-breaking game built with Ruby on Rails. Test your deduction skills by trying to guess a secret 4-digit code within 10 attempts!

## 🎮 Live Demo

🌐 **[Play Break the Code](https://breake-the-code-2duiqa.fly.dev/)**

## 🎯 Game Overview

Break the Code is a digital version of the classic mastermind game. Players must guess a secret 4-digit code where:

- Each digit is unique and ranges from 1 to 9
- You have a maximum of 10 attempts to crack the code
- After each guess, you receive visual feedback to guide your next move

### 🎲 How to Play

1. **Start a New Game**: Click "Start New Game" to generate a random 4-digit code
2. **Make Your Guess**: Enter 4 unique digits (1-9) in the input field
3. **Analyze Feedback**: After each guess, you'll see colored indicators:
   - 🟢 **Green**: Right number in the right position
   - 🟡 **Yellow**: Right number but in the wrong position  
   - 🔴 **Red**: Number is not in the code at all
4. **Win or Lose**: Crack the code within 10 attempts to win!

### 🏆 Scoring System

Your score is calculated based on:

- **Base Score**: 1,000 points
- **Attempt Penalty**: -50 points per guess
- **Time Penalty**: -10 points per minute
- **Minimum Score**: 0 points (no negative scores)

## 🚀 Features

- **Clean, Modern UI**: Responsive design that works on all devices
- **Real-time Feedback**: Visual indicators help guide your guessing strategy
- **Score Tracking**: Performance-based scoring system
- **Game Analytics**: Tracks player metadata (device, location, browser info)
- **Unique Game Sessions**: Each game has a unique token for sharing
<!-- - **Leaderboard**: Top 10 high scores (when implemented) -->

## 🛠 Technical Stack

- **Backend**: Ruby on Rails 7.0.8
- **Database**: PostgreSQL
- **Frontend**: HTML5, CSS3, JavaScript (Stimulus)
- **Deployment**: Fly.io
- **Ruby Version**: 3.2.2

### Key Dependencies

- **geocoder**: For location-based analytics
- **browser**: For device and browser detection
- **pg**: PostgreSQL adapter
- **puma**: Web server
- **turbo-rails**: SPA-like page acceleration
- **stimulus-rails**: JavaScript framework

## 🔧 Setup and Installation

### Prerequisites

- Ruby 3.2.2
- PostgreSQL
- Bundler gem

### Local Development

1. **Clone the repository**

   ```bash
   git clone https://github.com/yahyaelganyni1/breake_the_code.git

   cd breake_the_code
   ```

2. **Install dependencies**

   ```bash
   bundle install
   ```

3. **Setup database**

   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Start the server**

   ```bash
   rails server
   ```

5. **Visit the application**

   ```text
   http://localhost:3000
   ```

## 📊 Game Analytics

The application tracks anonymous user data including:

- Device and browser information
- Geographic location (country/city)
- Referrer information
- Game performance metrics

## 🎯 Future Enhancements

- [ ] Difficulty levels (3, 4, 5 digit codes)
- [ ] Multiplayer mode
- [ ] Daily challenges
- [ ] Achievement system
- [ ] Social media sharing
- [ ] Mobile app version

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is open source and available under the [MIT License](LICENSE).

## 🎮 Play Now

Ready to test your code-breaking skills?

**👉 [Start Playing Break the Code](https://breake-the-code-2duiqa.fly.dev/)**

---

### Built with ❤️ using Ruby on Rails

### Give us a star if you like the project!
