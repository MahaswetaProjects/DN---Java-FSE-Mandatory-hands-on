# HOL 7: Props — Shopping App

```bash
npx create-react-app shoppingapp
cd shoppingapp
```

## src/App.js
```jsx
import React, { Component } from 'react';

class Cart {
  constructor(itemname, price) {
    this.itemname = itemname;
    this.price    = price;
  }
}

class OnlineShopping extends Component {
  constructor(props) {
    super(props);
    this.items = [
      new Cart('Laptop',     75000),
      new Cart('Phone',      20000),
      new Cart('Headphones', 3000),
      new Cart('Tablet',     30000),
      new Cart('Charger',    1500),
    ];
  }

  render() {
    return (
      <div>
        <h2>Online Shopping Cart</h2>
        <table border="1">
          <thead>
            <tr><th>Item</th><th>Price (₹)</th></tr>
          </thead>
          <tbody>
            {this.items.map((item, i) => (
              <tr key={i}>
                <td>{item.itemname}</td>
                <td>{item.price}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    );
  }
}

export default OnlineShopping;
```
