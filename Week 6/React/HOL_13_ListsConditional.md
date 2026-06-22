# HOL 13: Lists & Conditional Rendering — Blogger App (3 ways)

```bash
npx create-react-app bloggerapp
cd bloggerapp
```

## src/App.js
```jsx
import React, { Component } from 'react';

function BookDetails() {
  return <div><h3>📚 Book Details</h3><p>React: Up and Running — 2nd Edition</p></div>;
}

function BlogDetails() {
  return <div><h3>📝 Blog Details</h3><p>Understanding React Hooks</p></div>;
}

function CourseDetails() {
  return <div><h3>🎓 Course Details</h3><p>Full Stack React with Node.js</p></div>;
}

class App extends Component {
  constructor(props) {
    super(props);
    this.state = { tab: 'book' };
  }

  render() {
    const { tab } = this.state;

    // Method 1: if-else
    let content;
    if (tab === 'book')   content = <BookDetails />;
    else if (tab === 'blog')   content = <BlogDetails />;
    else content = <CourseDetails />;

    // Method 2: ternary (used inline below)
    // Method 3: && short-circuit (used inline below)

    return (
      <div>
        <h2>Blogger App</h2>
        <button onClick={() => this.setState({ tab: 'book' })}>Books</button>
        <button onClick={() => this.setState({ tab: 'blog' })}>Blogs</button>
        <button onClick={() => this.setState({ tab: 'course' })}>Courses</button>

        <hr />
        {/* Method 1: element variable */}
        {content}

        {/* Method 2: ternary */}
        {tab === 'book' ? <p>(Showing via ternary)</p> : null}

        {/* Method 3: && short-circuit */}
        {tab === 'blog' && <p>(Showing via && short-circuit)</p>}
      </div>
    );
  }
}

export default App;
```
