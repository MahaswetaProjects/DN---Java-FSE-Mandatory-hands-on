# HOL 16: Form Validation — Mail Register App

```bash
npx create-react-app mailregisterapp
cd mailregisterapp
```

## src/Register.js
```jsx
import React, { Component } from 'react';

class Register extends Component {
  constructor(props) {
    super(props);
    this.state = {
      name: '', email: '', password: '',
      errors: { name: '', email: '', password: '' },
      submitted: false
    };
  }

  validate(name, value) {
    if (name === 'name') {
      return value.length < 5 ? 'Name must have at least 5 characters' : '';
    }
    if (name === 'email') {
      return (!value.includes('@') || !value.includes('.')) ? 'Invalid email address' : '';
    }
    if (name === 'password') {
      return value.length < 8 ? 'Password must have at least 8 characters' : '';
    }
    return '';
  }

  handleChange(e) {
    const { name, value } = e.target;
    this.setState({
      [name]: value,
      errors: { ...this.state.errors, [name]: this.validate(name, value) }
    });
  }

  handleSubmit(e) {
    e.preventDefault();
    const { name, email, password } = this.state;
    const errors = {
      name:     this.validate('name', name),
      email:    this.validate('email', email),
      password: this.validate('password', password),
    };
    this.setState({ errors });
    if (!errors.name && !errors.email && !errors.password) {
      this.setState({ submitted: true });
    }
  }

  render() {
    const { errors, submitted } = this.state;
    if (submitted) return <h3>Registration Successful!</h3>;

    return (
      <div style={{ padding: 20 }}>
        <h2>Register</h2>
        <form onSubmit={(e) => this.handleSubmit(e)}>
          <div>
            <label>Name:</label><br />
            <input name="name" value={this.state.name} onChange={e => this.handleChange(e)} />
            {errors.name && <p style={{ color: 'red' }}>{errors.name}</p>}
          </div>
          <div>
            <label>Email:</label><br />
            <input name="email" value={this.state.email} onChange={e => this.handleChange(e)} />
            {errors.email && <p style={{ color: 'red' }}>{errors.email}</p>}
          </div>
          <div>
            <label>Password:</label><br />
            <input name="password" type="password" value={this.state.password} onChange={e => this.handleChange(e)} />
            {errors.password && <p style={{ color: 'red' }}>{errors.password}</p>}
          </div>
          <button type="submit">Register</button>
        </form>
      </div>
    );
  }
}

export default Register;
```

## src/App.js
```jsx
import React from 'react';
import Register from './Register';

function App() { return <Register />; }

export default App;
```
