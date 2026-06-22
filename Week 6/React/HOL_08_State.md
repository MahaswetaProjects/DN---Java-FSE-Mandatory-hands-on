# HOL 8: State — Counter App (Mall Entry/Exit)

```bash
npx create-react-app counterapp
cd counterapp
```

## src/App.js
```jsx
import React, { Component } from 'react';

class CountPeople extends Component {
  constructor(props) {
    super(props);
    this.state = { entrycount: 0, exitcount: 0 };
  }

  UpdateEntry() {
    this.setState(prev => ({ entrycount: prev.entrycount + 1 }));
  }

  UpdateExit() {
    this.setState(prev => ({ exitcount: prev.exitcount + 1 }));
  }

  render() {
    return (
      <div>
        <h2>Mall Entry / Exit Counter</h2>
        <p>People Entered: {this.state.entrycount}</p>
        <p>People Exited:  {this.state.exitcount}</p>
        <button onClick={() => this.UpdateEntry()}>Login (Entry)</button>
        <button onClick={() => this.UpdateExit()}>Exit</button>
      </div>
    );
  }
}

export default CountPeople;
```
