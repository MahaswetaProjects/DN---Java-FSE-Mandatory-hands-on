# HOL 6: React Router — Trainers App

```bash
npx create-react-app TrainersApp
cd TrainersApp
npm install react-router-dom
```

## src/TrainersMock.js
```jsx
export const trainers = [
  { id: 1, name: 'Alice',   email: 'alice@example.com', phone: '9876543210', technology: 'React',  skills: 'JS, CSS, Redux' },
  { id: 2, name: 'Bob',     email: 'bob@example.com',   phone: '9876543211', technology: 'Angular', skills: 'TS, RxJS' },
  { id: 3, name: 'Charlie', email: 'charlie@ex.com',    phone: '9876543212', technology: 'Node',   skills: 'Express, MongoDB' },
];
```

## src/Home.js
```jsx
import React from 'react';

function Home() {
  return (
    <div>
      <h2>Welcome to Trainers Portal</h2>
      <p>Click on Trainers to see the list of available trainers.</p>
    </div>
  );
}

export default Home;
```

## src/TrainersList.js
```jsx
import React from 'react';
import { Link } from 'react-router-dom';
import { trainers } from './TrainersMock';

function TrainersList() {
  return (
    <div>
      <h2>Trainers List</h2>
      <ul>
        {trainers.map(t => (
          <li key={t.id}>
            <Link to={`/trainers/${t.id}`}>{t.name}</Link>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default TrainersList;
```

## src/TrainerDetails.js
```jsx
import React from 'react';
import { useParams } from 'react-router-dom';
import { trainers } from './TrainersMock';

function TrainerDetails() {
  const { id } = useParams();
  const trainer = trainers.find(t => t.id === parseInt(id));

  if (!trainer) return <p>Trainer not found</p>;

  return (
    <div>
      <h2>{trainer.name}</h2>
      <p>Email:      {trainer.email}</p>
      <p>Phone:      {trainer.phone}</p>
      <p>Technology: {trainer.technology}</p>
      <p>Skills:     {trainer.skills}</p>
    </div>
  );
}

export default TrainerDetails;
```

## src/App.js
```jsx
import React from 'react';
import { BrowserRouter, Routes, Route, Link } from 'react-router-dom';
import Home from './Home';
import TrainersList from './TrainersList';
import TrainerDetails from './TrainerDetails';

function App() {
  return (
    <BrowserRouter>
      <nav>
        <Link to="/">Home</Link> | <Link to="/trainers">Trainers</Link>
      </nav>
      <Routes>
        <Route path="/"            element={<Home />} />
        <Route path="/trainers"    element={<TrainersList />} />
        <Route path="/trainers/:id" element={<TrainerDetails />} />
      </Routes>
    </BrowserRouter>
  );
}

export default App;
```
