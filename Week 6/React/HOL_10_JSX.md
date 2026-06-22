# HOL 10: JSX — Office Space Rental App

```bash
npx create-react-app officespacerentalapp
cd officespacerentalapp
```

## src/App.js
```jsx
import React from 'react';

const offices = [
  { id: 1, name: 'Skyview Office',  rent: 45000, address: '12 MG Road, Bangalore' },
  { id: 2, name: 'Tech Hub',        rent: 72000, address: '5 IT Park, Hyderabad' },
  { id: 3, name: 'Central Plaza',   rent: 58000, address: '8 Anna Salai, Chennai' },
];

function App() {
  return (
    <div>
      {/* JSX heading element */}
      <h1>Office Space Rental</h1>

      {/* JSX attribute — image */}
      <img src="https://via.placeholder.com/400x200?text=Office+Space" alt="Office" />

      {/* JSX loop + inline conditional CSS */}
      {offices.map(office => (
        <div key={office.id} style={{ border: '1px solid #ccc', margin: '10px', padding: '10px' }}>
          <h3>{office.name}</h3>
          <p>Address: {office.address}</p>
          <p style={{ color: office.rent < 60000 ? 'red' : 'green' }}>
            Rent: ₹{office.rent}
          </p>
        </div>
      ))}
    </div>
  );
}

export default App;
```
