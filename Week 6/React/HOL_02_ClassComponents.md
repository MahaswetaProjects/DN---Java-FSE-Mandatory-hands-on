# HOL 2: Class Components — StudentApp

```bash
npx create-react-app StudentApp
cd StudentApp
```

## src/Components/Home.js
```jsx
import React, { Component } from 'react';

class Home extends Component {
  render() {
    return <h2>Welcome to the Home page of Student Management Portal</h2>;
  }
}

export default Home;
```

## src/Components/About.js
```jsx
import React, { Component } from 'react';

class About extends Component {
  render() {
    return <h2>Welcome to the About page of the Student Management Portal</h2>;
  }
}

export default About;
```

## src/Components/Contact.js
```jsx
import React, { Component } from 'react';

class Contact extends Component {
  render() {
    return <h2>Welcome to the Contact page of the Student Management Portal</h2>;
  }
}

export default Contact;
```

## src/App.js
```jsx
import React from 'react';
import Home from './Components/Home';
import About from './Components/About';
import Contact from './Components/Contact';

function App() {
  return (
    <div>
      <Home />
      <About />
      <Contact />
    </div>
  );
}

export default App;
```

## Run
```bash
npm start
```
