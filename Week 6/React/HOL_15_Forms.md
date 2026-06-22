# HOL 15: Forms — Ticket Raising App

```bash
npx create-react-app ticketraisingapp
cd ticketraisingapp
```

## src/ComplaintRegister.js
```jsx
import React, { Component } from 'react';

class ComplaintRegister extends Component {
  constructor(props) {
    super(props);
    this.state = { empName: '', complaint: '' };
  }

  handleSubmit(e) {
    e.preventDefault();
    const refNo = 'REF' + Math.floor(Math.random() * 100000);
    alert(`Complaint submitted!\nEmployee: ${this.state.empName}\nReference No: ${refNo}`);
    this.setState({ empName: '', complaint: '' });
  }

  render() {
    return (
      <div style={{ padding: 20 }}>
        <h2>Complaint Register</h2>
        <form onSubmit={(e) => this.handleSubmit(e)}>
          <div>
            <label>Employee Name:</label><br />
            <input
              type="text"
              value={this.state.empName}
              onChange={e => this.setState({ empName: e.target.value })}
              required
            />
          </div>
          <div>
            <label>Complaint:</label><br />
            <textarea
              value={this.state.complaint}
              onChange={e => this.setState({ complaint: e.target.value })}
              rows={4} cols={40}
              required
            />
          </div>
          <button type="submit">Submit Complaint</button>
        </form>
      </div>
    );
  }
}

export default ComplaintRegister;
```

## src/App.js
```jsx
import React from 'react';
import ComplaintRegister from './ComplaintRegister';

function App() { return <ComplaintRegister />; }

export default App;
```
