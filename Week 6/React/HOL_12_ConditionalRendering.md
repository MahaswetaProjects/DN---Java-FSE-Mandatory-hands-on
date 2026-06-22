# HOL 12: Conditional Rendering — Ticket Booking App

```bash
npx create-react-app ticketbookingapp
cd ticketbookingapp
```

## src/App.js
```jsx
import React, { Component } from 'react';

function GuestPage() {
  return (
    <div>
      <h2>Available Flights</h2>
      <p>DEL → MUM | 9:00 AM | ₹4500</p>
      <p>BLR → DEL | 2:00 PM | ₹5200</p>
      <p>Please log in to book tickets.</p>
    </div>
  );
}

function UserPage({ onLogout }) {
  return (
    <div>
      <h2>Book Your Ticket</h2>
      <p>Select a flight and confirm your booking.</p>
      <button onClick={onLogout}>Logout</button>
    </div>
  );
}

class App extends Component {
  constructor(props) {
    super(props);
    this.state = { isLoggedIn: false };
  }

  render() {
    const { isLoggedIn } = this.state;
    return (
      <div>
        <h1>Ticket Booking App</h1>
        {isLoggedIn
          ? <UserPage onLogout={() => this.setState({ isLoggedIn: false })} />
          : <GuestPage />
        }
        {!isLoggedIn &&
          <button onClick={() => this.setState({ isLoggedIn: true })}>Login</button>
        }
      </div>
    );
  }
}

export default App;
```
