# HOL 5: Styling with CSS Modules

## src/CohortDetails.module.css
```css
.box {
  width: 300px;
  display: inline-block;
  margin: 10px;
  padding: 10px 20px;
  border: 1px solid black;
  border-radius: 10px;
}

dt {
  font-weight: 500;
}
```

## src/CohortDetails.js
```jsx
import React from 'react';
import styles from './CohortDetails.module.css';

function CohortDetails({ cohort }) {
  const headingStyle = {
    color: cohort.status === 'ongoing' ? 'green' : 'blue'
  };

  return (
    <div className={styles.box}>
      <h3 style={headingStyle}>{cohort.code}</h3>
      <dl>
        <dt>Status</dt>  <dd>{cohort.status}</dd>
        <dt>Trainer</dt> <dd>{cohort.trainer}</dd>
        <dt>Start</dt>   <dd>{cohort.startDate}</dd>
      </dl>
    </div>
  );
}

export default CohortDetails;
```

## src/App.js
```jsx
import React from 'react';
import CohortDetails from './CohortDetails';

const cohorts = [
  { code: 'DN001', status: 'ongoing',   trainer: 'Alice', startDate: '2024-01-01' },
  { code: 'DN002', status: 'completed', trainer: 'Bob',   startDate: '2023-06-01' },
];

function App() {
  return (
    <div>
      {cohorts.map(c => <CohortDetails key={c.code} cohort={c} />)}
    </div>
  );
}

export default App;
```
