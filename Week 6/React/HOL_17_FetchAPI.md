# HOL 17: REST API with Fetch — Fetch User App

```bash
npx create-react-app fetchuserapp
cd fetchuserapp
```

## src/Getuser.js
```jsx
import React, { Component } from 'react';

class Getuser extends Component {
  constructor(props) {
    super(props);
    this.state = { user: null };
  }

  async componentDidMount() {
    const res    = await fetch('https://api.randomuser.me/');
    const data   = await res.json();
    const user   = data.results[0];
    this.setState({ user });
  }

  render() {
    const { user } = this.state;
    if (!user) return <p>Loading user...</p>;

    return (
      <div style={{ padding: 20 }}>
        <h2>Random User</h2>
        <img src={user.picture.large} alt="User" />
        <p>Title:      {user.name.title}</p>
        <p>First Name: {user.name.first}</p>
        <p>Last Name:  {user.name.last}</p>
        <p>Email:      {user.email}</p>
        <p>Country:    {user.location.country}</p>
      </div>
    );
  }
}

export default Getuser;
```

## src/App.js
```jsx
import React from 'react';
import Getuser from './Getuser';

function App() { return <Getuser />; }

export default App;
```
