# Hands-On 6: Services & Dependency Injection

```bash
ng generate service services/course
ng generate service services/enrollment
```

## models/course.model.ts
```typescript
export interface Course {
  id: number;
  name: string;
  code: string;
  credits: number;
  gradeStatus: 'passed' | 'failed' | 'pending';
}
```

## course.service.ts
```typescript
import { Injectable } from '@angular/core';
import { Course } from '../models/course.model';

@Injectable({ providedIn: 'root' }) // singleton — one instance shared app-wide
export class CourseService {
  private courses: Course[] = [
    { id: 1, name: 'Data Structures',  code: 'CS101', credits: 4, gradeStatus: 'passed' },
    { id: 2, name: 'Algorithms',       code: 'CS102', credits: 4, gradeStatus: 'failed' },
    { id: 3, name: 'Web Development',  code: 'CS201', credits: 3, gradeStatus: 'pending' },
    { id: 4, name: 'Database Systems', code: 'CS301', credits: 3, gradeStatus: 'passed' },
    { id: 5, name: 'Machine Learning', code: 'CS401', credits: 4, gradeStatus: 'pending' },
  ];

  getCourses(): Course[] { return this.courses; }

  getCourseById(id: number): Course | undefined {
    return this.courses.find(c => c.id === id);
  }

  addCourse(course: Course): void { this.courses.push(course); }
}
```

## enrollment.service.ts
```typescript
import { Injectable } from '@angular/core';
import { CourseService } from './course.service';
import { Course } from '../models/course.model';

@Injectable({ providedIn: 'root' })
export class EnrollmentService {
  private enrolledCourseIds: number[] = [];

  // Service-to-service injection: inject CourseService into EnrollmentService
  constructor(private courseService: CourseService) {}

  enroll(courseId: number): void {
    if (!this.isEnrolled(courseId)) this.enrolledCourseIds.push(courseId);
  }

  unenroll(courseId: number): void {
    this.enrolledCourseIds = this.enrolledCourseIds.filter(id => id !== courseId);
  }

  isEnrolled(courseId: number): boolean {
    return this.enrolledCourseIds.includes(courseId);
  }

  getEnrolledCourses(): Course[] {
    return this.enrolledCourseIds
      .map(id => this.courseService.getCourseById(id))
      .filter((c): c is Course => c !== undefined);
  }
}
```

## course-list.component.ts — inject CourseService
```typescript
export class CourseListComponent implements OnInit {
  courses: Course[] = [];

  constructor(private courseService: CourseService) {}

  ngOnInit() {
    this.courses = this.courseService.getCourses(); // reads from singleton service
  }
}
```

## course-card.component.ts — inject EnrollmentService
```typescript
export class CourseCardComponent {
  @Input() course!: Course;

  constructor(private enrollmentService: EnrollmentService) {}

  get isEnrolled() { return this.enrollmentService.isEnrolled(this.course.id); }

  toggleEnroll() {
    this.isEnrolled
      ? this.enrollmentService.unenroll(this.course.id)
      : this.enrollmentService.enroll(this.course.id);
  }
}
```

## course-card.component.html (enroll toggle)
```html
<button (click)="toggleEnroll()">{{ isEnrolled ? 'Unenroll' : 'Enroll' }}</button>
```

## student-profile.component.ts — show enrolled courses
```typescript
export class StudentProfileComponent implements OnInit {
  enrolledCourses: Course[] = [];

  constructor(private enrollmentService: EnrollmentService) {}

  ngOnInit() { this.enrolledCourses = this.enrollmentService.getEnrolledCourses(); }
}
```

## Component-level provider (NotificationService example)
```typescript
// Providing at component level creates a NEW instance scoped only to this component
// and its children — other parts of the app get a different instance.
@Component({
  selector: 'app-notification',
  providers: [NotificationService],  // scoped instance, not the root singleton
  template: `...`
})
export class NotificationComponent {}
```
