# HOL 18: Unit Testing with Jest & Enzyme — Cohort Details

```bash
# Inside the existing cohort react app
npm install --save-dev enzyme @wojtekmaj/enzyme-adapter-react-17
```

## src/setupTests.js (modify)
```js
import Enzyme from 'enzyme';
import Adapter from '@wojtekmaj/enzyme-adapter-react-17';

Enzyme.configure({ adapter: new Adapter() });
```

## src/Cohort.js (mock data)
```js
export const CohortData = [
  { code: 'DN001', status: 'ongoing',   trainer: 'Alice', startDate: '2024-01-01' },
  { code: 'DN002', status: 'completed', trainer: 'Bob',   startDate: '2023-06-01' },
];
```

## src/CohortDetails.js
```jsx
import React from 'react';

function CohortDetails({ cohort }) {
  return (
    <div>
      <h3>{cohort.code}</h3>
      <p>Status:  {cohort.status}</p>
      <p>Trainer: {cohort.trainer}</p>
    </div>
  );
}

export default CohortDetails;
```

## src/CohortDetails.test.js
```js
import React from 'react';
import { shallow, mount } from 'enzyme';
import CohortDetails from './CohortDetails';
import { CohortData } from './Cohort';

describe('Cohort Details Component', () => {

  // Test 1: component renders without crashing
  test('should create the component', () => {
    const wrapper = shallow(<CohortDetails cohort={CohortData[0]} />);
    expect(wrapper).toBeTruthy();
  });

  // Test 2: props are assigned correctly
  test('should initialize the props', () => {
    const wrapper = mount(<CohortDetails cohort={CohortData[0]} />);
    expect(wrapper.props().cohort).toEqual(CohortData[0]);
  });

  // Test 3: h3 displays the correct cohort code
  test('should display cohort code in h3', () => {
    const wrapper = mount(<CohortDetails cohort={CohortData[0]} />);
    expect(wrapper.find('h3').text()).toBe('DN001');
  });

  // Test 4: snapshot test
  test('should always render same html', () => {
    const wrapper = shallow(<CohortDetails cohort={CohortData[0]} />);
    expect(wrapper).toMatchSnapshot();
  });
});
```

## Run tests
```bash
npm test
```
