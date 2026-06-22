# HOL 11: Event Handling — Event Examples App

```bash
npx create-react-app eventexamplesapp
cd eventexamplesapp
```

## src/App.js
```jsx
import React, { Component } from 'react';
import CurrencyConvertor from './CurrencyConvertor';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = { counter: 0, message: '' };
  }

  increment()   { this.setState(p => ({ counter: p.counter + 1 })); }
  sayHello()    { this.setState({ message: 'Hello from static message!' }); }

  handleWelcome(msg) { this.setState({ message: msg }); }

  handleOnPress(e) {
    // Synthetic event — cross-browser wrapper around native event
    alert('I was clicked. Target: ' + e.target.tagName);
  }

  render() {
    return (
      <div>
        <h2>Event Examples</h2>
        <p>Counter: {this.state.counter}</p>

        {/* Button calling multiple methods */}
        <button onClick={() => { this.increment(); this.sayHello(); }}>Increment</button>

        {/* Decrement */}
        <button onClick={() => this.setState(p => ({ counter: p.counter - 1 }))}>Decrement</button>

        <p>{this.state.message}</p>

        {/* Argument passing */}
        <button onClick={() => this.handleWelcome('welcome')}>Say Welcome</button>

        {/* Synthetic event */}
        <button onClick={(e) => this.handleOnPress(e)}>OnPress (Synthetic)</button>

        <hr />
        <CurrencyConvertor />
      </div>
    );
  }
}

export default App;
```

## src/CurrencyConvertor.js
```jsx
import React, { Component } from 'react';

class CurrencyConvertor extends Component {
  constructor(props) {
    super(props);
    this.state = { rupees: '', euro: '' };
  }

  handleSubmit(e) {
    e.preventDefault();
    const euro = (parseFloat(this.state.rupees) / 89.5).toFixed(2);
    this.setState({ euro });
  }

  render() {
    return (
      <div>
        <h3>Currency Converter (₹ → €)</h3>
        <form onSubmit={(e) => this.handleSubmit(e)}>
          <input
            type="number"
            placeholder="Enter Rupees"
            value={this.state.rupees}
            onChange={e => this.setState({ rupees: e.target.value })}
          />
          <button type="submit">Convert</button>
        </form>
        {this.state.euro && <p>Euro: €{this.state.euro}</p>}
      </div>
    );
  }
}

export default CurrencyConvertor;
```
