# HOL 14: Context API — Employee Theme App

```bash
npx create-react-app employeethemeapp
cd employeethemeapp
```

## src/ThemeContext.js
```jsx
import { createContext } from 'react';

// Default value is 'light'; Provider overrides this
const ThemeContext = createContext('light');

export default ThemeContext;
```

## src/EmployeeCard.js
```jsx
import React, { useContext } from 'react';
import ThemeContext from './ThemeContext';

function EmployeeCard({ employee }) {
  const theme = useContext(ThemeContext); // reads from context — no props needed

  const btnStyle = {
    background: theme === 'dark' ? '#333' : '#eee',
    color:      theme === 'dark' ? '#fff' : '#000',
    padding: '5px 10px', margin: '5px', borderRadius: '4px', cursor: 'pointer'
  };

  return (
    <div style={{ border: '1px solid #ccc', margin: 10, padding: 10 }}>
      <h4>{employee.name}</h4>
      <p>{employee.role}</p>
      <button style={btnStyle}>View</button>
      <button style={btnStyle}>Edit</button>
    </div>
  );
}

export default EmployeeCard;
```

## src/EmployeesList.js
```jsx
import React from 'react';
import EmployeeCard from './EmployeeCard';

// Theme no longer passed as prop — context handles it
function EmployeesList({ employees }) {
  return (
    <div>
      {employees.map(e => <EmployeeCard key={e.id} employee={e} />)}
    </div>
  );
}

export default EmployeesList;
```

## src/App.js
```jsx
import React, { Component } from 'react';
import ThemeContext from './ThemeContext';
import EmployeesList from './EmployeesList';

const employees = [
  { id: 1, name: 'Alice', role: 'Developer' },
  { id: 2, name: 'Bob',   role: 'Tester' },
  { id: 3, name: 'Carol', role: 'Designer' },
];

class App extends Component {
  constructor(props) {
    super(props);
    this.state = { theme: 'light' };
  }

  toggleTheme() {
    this.setState(p => ({ theme: p.theme === 'light' ? 'dark' : 'light' }));
  }

  render() {
    return (
      // Provider wraps the whole app — all children can read theme via useContext
      <ThemeContext.Provider value={this.state.theme}>
        <h2>Employee Management — Theme: {this.state.theme}</h2>
        <button onClick={() => this.toggleTheme()}>Toggle Theme</button>
        <EmployeesList employees={employees} />
      </ThemeContext.Provider>
    );
  }
}

export default App;
```
