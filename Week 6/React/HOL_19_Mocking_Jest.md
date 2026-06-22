# HOL 19: Mocking with Jest — GitHub Client App

```bash
npx create-react-app gitclientapp
cd gitclientapp
npm install axios
```

## src/GitClient.js
```js
import axios from 'axios';

class GitClient {
  getRepositories(username) {
    return axios
      .get(`https://api.github.com/users/${username}/repos`)
      .then(res => res.data.map(repo => repo.name));
  }
}

export default new GitClient();
```

## src/App.js
```jsx
import React, { Component } from 'react';
import GitClient from './GitClient';

class App extends Component {
  constructor(props) {
    super(props);
    this.state = { repos: [] };
  }

  componentDidMount() {
    GitClient.getRepositories('techiesyed').then(repos => this.setState({ repos }));
  }

  render() {
    return (
      <div style={{ padding: 20 }}>
        <h2>GitHub Repositories — techiesyed</h2>
        <ul>
          {this.state.repos.map((name, i) => <li key={i}>{name}</li>)}
        </ul>
      </div>
    );
  }
}

export default App;
```

## src/GitClient.test.js
```js
import axios from 'axios';
import GitClient from './GitClient';

// Mock the entire axios module
jest.mock('axios');

describe('Git Client Tests', () => {

  test('should return repository names for techiesyed', async () => {
    // Mock axios.get to return dummy data instead of hitting GitHub API
    const mockRepos = [
      { name: 'repo-one' },
      { name: 'repo-two' },
      { name: 'repo-three' },
    ];

    axios.get.mockResolvedValue({ data: mockRepos });

    const repos = await GitClient.getRepositories('techiesyed');

    expect(repos).toEqual(['repo-one', 'repo-two', 'repo-three']);
    expect(axios.get).toHaveBeenCalledWith(
      'https://api.github.com/users/techiesyed/repos'
    );
  });
});
```

## Run tests
```bash
npm test
```
