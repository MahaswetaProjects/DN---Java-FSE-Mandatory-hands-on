# HOL 4: Lifecycle Hooks — Blog App (componentDidMount, componentDidCatch)

```bash
npx create-react-app blogapp
cd blogapp
```

## src/Post.js
```jsx
export class Post {
  constructor(id, title, body) {
    this.id    = id;
    this.title = title;
    this.body  = body;
  }
}
```

## src/Posts.js
```jsx
import React, { Component } from 'react';

class Posts extends Component {
  constructor(props) {
    super(props);
    this.state = { posts: [] };
  }

  loadPosts() {
    fetch('https://jsonplaceholder.typicode.com/posts')
      .then(res => res.json())
      .then(data => this.setState({ posts: data }));
  }

  componentDidMount() {
    this.loadPosts();
  }

  componentDidCatch(error, info) {
    alert('Error: ' + error);
  }

  render() {
    return (
      <div>
        <h2>Blog Posts</h2>
        {this.state.posts.map(post => (
          <div key={post.id}>
            <h3>{post.title}</h3>
            <p>{post.body}</p>
          </div>
        ))}
      </div>
    );
  }
}

export default Posts;
```

## src/App.js
```jsx
import React from 'react';
import Posts from './Posts';

function App() {
  return <Posts />;
}

export default App;
```
