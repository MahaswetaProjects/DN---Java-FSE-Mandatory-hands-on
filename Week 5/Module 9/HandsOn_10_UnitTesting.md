# Hands-On 10: Unit Testing — Jasmine, Karma & TestBed

```bash
ng test                   # run all tests in watch mode
ng test --code-coverage   # generate coverage report in coverage/ folder
```

## Task 1: course-card.component.spec.ts
```typescript
import { ComponentFixture, TestBed } from '@angular/core/testing';
import { By } from '@angular/platform-browser';
import { CourseCardComponent } from './course-card.component';

describe('CourseCardComponent', () => {
  let component: CourseCardComponent;
  let fixture: ComponentFixture<CourseCardComponent>;

  const mockCourse = { id: 1, name: 'Data Structures', code: 'CS101', credits: 4, gradeStatus: 'passed' as const };

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CourseCardComponent] // standalone component — use imports not declarations
    }).compileComponents();

    fixture = TestBed.createComponent(CourseCardComponent);
    component = fixture.componentInstance;
  });

  // Test 1: component exists
  it('should create', () => {
    expect(component).toBeTruthy();
  });

  // Test 2: @Input renders correctly
  it('should display the course name', () => {
    component.course = mockCourse;
    fixture.detectChanges(); // trigger change detection before querying DOM
    const h3 = fixture.debugElement.query(By.css('h3')).nativeElement;
    expect(h3.textContent).toContain('Data Structures');
  });

  // Test 3: @Output emits on button click
  it('should emit enrollRequested with course id when Enroll clicked', () => {
    component.course = mockCourse;
    fixture.detectChanges();
    spyOn(component.enrollRequested, 'emit');
    fixture.debugElement.query(By.css('button')).nativeElement.click();
    fixture.detectChanges();
    expect(component.enrollRequested.emit).toHaveBeenCalledWith(1);
  });

  // Test 4: ngOnChanges logs previous/current
  it('should log previous and current value in ngOnChanges', () => {
    spyOn(console, 'log');
    const changes: any = {
      course: { previousValue: null, currentValue: mockCourse, firstChange: true }
    };
    component.ngOnChanges(changes);
    expect(console.log).toHaveBeenCalled();
  });

  // Test 5: CSS class applied when enrolled
  it('should apply card--enrolled class when course is enrolled', () => {
    component.course = { ...mockCourse, enrolled: true } as any;
    fixture.detectChanges();
    const div = fixture.debugElement.query(By.css('.card--enrolled'));
    expect(div).toBeTruthy();
  });
});
```

## Task 2: course.service.spec.ts
```typescript
import { TestBed } from '@angular/core/testing';
import { HttpClientTestingModule, HttpTestingController } from '@angular/common/http/testing';
import { CourseService } from './course.service';

describe('CourseService', () => {
  let service: CourseService;
  let httpMock: HttpTestingController;

  const mockCourses = [
    { id: 1, name: 'Data Structures', code: 'CS101', credits: 4, gradeStatus: 'passed' },
    { id: 2, name: 'Algorithms',      code: 'CS102', credits: 4, gradeStatus: 'failed' }
  ];

  beforeEach(() => {
    TestBed.configureTestingModule({
      imports: [HttpClientTestingModule],
      providers: [CourseService]
    });
    service  = TestBed.inject(CourseService);
    httpMock = TestBed.inject(HttpTestingController);
  });

  afterEach(() => {
    // verify() asserts no unexpected HTTP requests were made after each test
    httpMock.verify();
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });

  // Test: getCourses() hits the correct URL and returns data
  it('should return courses from GET /courses', () => {
    service.getCourses().subscribe(courses => {
      expect(courses.length).toBe(2);
      expect(courses[0].name).toBe('Data Structures');
    });
    const req = httpMock.expectOne('http://localhost:3000/courses');
    expect(req.request.method).toBe('GET');
    req.flush(mockCourses); // simulate server response
  });

  // Test: error handling — 500 response propagates as error
  it('should handle a 500 error response', () => {
    service.getCourses().subscribe({
      next:  () => fail('should have errored'),
      error: err => expect(err.message).toContain('Failed to load courses')
    });
    httpMock.expectOne('http://localhost:3000/courses')
            .flush('Server Error', { status: 500, statusText: 'Internal Server Error' });
  });
});
```

## Task 2: NgRx MockStore — course-list.component.spec.ts
```typescript
import { MockStore, provideMockStore } from '@ngrx/store/testing';
import { CourseListComponent } from './course-list.component';
import { selectAllCourses, selectCoursesLoading } from '../../store/course/course.selectors';

describe('CourseListComponent with MockStore', () => {
  let store: MockStore;
  let fixture: ComponentFixture<CourseListComponent>;

  const mockCourses = [
    { id: 1, name: 'Data Structures', code: 'CS101', credits: 4, gradeStatus: 'passed' }
  ];

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [CourseListComponent],
      providers: [
        // MockStore replaces the real store — no reducers or effects run
        provideMockStore({
          initialState: { course: { courses: mockCourses, loading: false, error: null } }
        })
      ]
    }).compileComponents();

    store   = TestBed.inject(MockStore);
    fixture = TestBed.createComponent(CourseListComponent);
    fixture.detectChanges();
  });

  it('should render course cards from store initial state', () => {
    const cards = fixture.debugElement.queryAll(By.css('app-course-card'));
    expect(cards.length).toBe(1);
  });

  it('should show loading indicator when loading is true', () => {
    // Override selector to simulate loading state
    store.setState({ course: { courses: [], loading: true, error: null } });
    fixture.detectChanges();
    const loader = fixture.debugElement.query(By.css('.loading'));
    expect(loader).toBeTruthy();
  });

  it('should dispatch loadCourses on init', () => {
    spyOn(store, 'dispatch');
    fixture = TestBed.createComponent(CourseListComponent);
    fixture.detectChanges();
    expect(store.dispatch).toHaveBeenCalled();
  });
});
```
