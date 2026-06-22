# HOL 1: Setup & First React App

## Setup
```bash
node -v   # must be LTS 20+
npm install -g create-react-app
npx create-react-app myfirstreact
cd myfirstreact
```

## src/App.js
```jsx
import React from 'react';

function App() {
  return (
    <div>
      <h1>Welcome to the first session of React</h1>
    </div>
  );
}

export default App;
```

## Run
```bash
npm start
# Open http://localhost:3000
```
