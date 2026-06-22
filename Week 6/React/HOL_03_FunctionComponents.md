# HOL 3: Function Components — Score Calculator

```bash
npx create-react-app scorecalculatorapp
cd scorecalculatorapp
```

## src/Stylesheets/mystyle.css
```css
.container { font-family: Arial; padding: 20px; }
.result    { color: green; font-weight: bold; }
```

## src/Components/CalculateScore.js
```jsx
import React from 'react';
import '../Stylesheets/mystyle.css';

function CalculateScore({ name, school, total, goal }) {
  const average = total / goal;
  return (
    <div className="container">
      <h2>Score Calculator</h2>
      <p>Name:   {name}</p>
      <p>School: {school}</p>
      <p>Total:  {total}</p>
      <p>Goal:   {goal}</p>
      <p className="result">Average Score: {average.toFixed(2)}</p>
    </div>
  );
}

export default CalculateScore;
```

## src/App.js
```jsx
import React from 'react';
import CalculateScore from './Components/CalculateScore';

function App() {
  return (
    <CalculateScore name="Alice" school="ABC School" total={450} goal={5} />
  );
}

export default App;
```
