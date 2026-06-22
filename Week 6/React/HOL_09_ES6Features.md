# HOL 9: ES6 Features — Cricket App (map, arrow functions, destructuring, spread)

```bash
npx create-react-app cricketapp
cd cricketapp
```

## src/App.js
```jsx
import React from 'react';
import ListofPlayers from './ListofPlayers';
import IndianPlayers from './IndianPlayers';

const flag = true; // change to false to see IndianPlayers

function App() {
  return flag ? <ListofPlayers /> : <IndianPlayers />;
}

export default App;
```

## src/ListofPlayers.js
```jsx
import React from 'react';

const players = [
  { name: 'Rohit',   score: 85 },
  { name: 'Virat',   score: 92 },
  { name: 'Dhoni',   score: 60 },
  { name: 'Rahul',   score: 45 },
  { name: 'Jadeja',  score: 72 },
  { name: 'Bumrah',  score: 20 },
  { name: 'Shami',   score: 15 },
  { name: 'Ashwin',  score: 55 },
  { name: 'Hardik',  score: 68 },
  { name: 'Iyer',    score: 78 },
  { name: 'Surya',   score: 90 },
];

function ListofPlayers() {
  // ES6 map + arrow function
  const allPlayers = players.map(p => <li key={p.name}>{p.name}: {p.score}</li>);

  // ES6 arrow function filter
  const lowScorers = players
    .filter(p => p.score < 70)
    .map(p => <li key={p.name}>{p.name}: {p.score}</li>);

  return (
    <div>
      <h2>All Players</h2>
      <ul>{allPlayers}</ul>
      <h3>Players with score below 70</h3>
      <ul>{lowScorers}</ul>
    </div>
  );
}

export default ListofPlayers;
```

## src/IndianPlayers.js
```jsx
import React from 'react';

const team = ['Rohit', 'Virat', 'Dhoni', 'Rahul', 'Jadeja', 'Bumrah', 'Shami', 'Ashwin', 'Hardik', 'Iyer', 'Surya'];

const T20Players    = ['Rohit', 'Surya', 'Hardik'];
const RanjiPlayers  = ['Virat', 'Rahul', 'Iyer'];

function IndianPlayers() {
  // ES6 destructuring
  const [odd1, , odd2, , odd3, ...rest] = team;
  const evenPlayers = team.filter((_, i) => i % 2 === 1);

  // ES6 spread to merge arrays
  const allTournamentPlayers = [...T20Players, ...RanjiPlayers];

  return (
    <div>
      <h2>Odd Team Players (destructuring)</h2>
      <p>{odd1}, {odd2}, {odd3}</p>

      <h2>Even Team Players</h2>
      <ul>{evenPlayers.map(p => <li key={p}>{p}</li>)}</ul>

      <h2>Merged Tournament Players (spread)</h2>
      <ul>{allTournamentPlayers.map(p => <li key={p}>{p}</li>)}</ul>
    </div>
  );
}

export default IndianPlayers;
```
