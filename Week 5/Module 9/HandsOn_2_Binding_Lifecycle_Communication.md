# Hands-On 2: Data Binding, Lifecycle Hooks & Component Communication

## Task 1: All Four Binding Types — home.component.ts
```typescript
import { Component } from '@angular/core';
import { FormsModule } from '@angular/forms';

@Component({
  selector: 'app-home',
  standalone: true,
  imports: [FormsModule],
  templateUrl: './home.component.html'
})
export class HomeComponent {
  portalName = 'Student Course Portal';
  isPortalActive = true;
  message = '';
  searchTerm = '';

  onEnrollClick() {
    this.message = 'Enrollment opened!';
  }
}
```

## home.component.html
```html
<!-- Interpolation -->
<h1>{{ portalName }}</h1>

<!-- Property binding: one-way component → DOM -->
<button [disabled]="!isPortalActive" (click)="onEnrollClick()">Enroll Now</button>
<p>{{ message }}</p>

<!-- Two-way binding: DOM ↔ component (requires FormsModule) -->
<!-- [property] is one-way; [(ngModel)] is shorthand for [ngModel]="x" (ngModelChange)="x=$event" -->
<input [(ngModel)]="searchTerm" placeholder="Search courses">
<p>Searching for: {{ searchTerm }}</p>
```

## Task 2: Lifecycle Hooks — home.component.ts (updated)
```typescript
import { Component, OnInit, OnDestroy } from '@angular/core';

export class HomeComponent implements OnInit, OnDestroy {
  availableCourses = 0;

  ngOnInit() {
    this.availableCourses = 12; // simulate data fetch
    console.log('HomeComponent initialised — courses loaded');
  }

  ngOnDestroy() {
    console.log('HomeComponent destroyed');
  }
}
```

## Task 2: CourseCardComponent with ngOnChanges

```bash
ng generate component components/course-card
```

## course-card.component.ts
```typescript
import { Component, Input, OnChanges, SimpleChanges, Output, EventEmitter } from '@angular/core';

@Component({
  selector: 'app-course-card',
  standalone: true,
  templateUrl: './course-card.component.html'
})
export class CourseCardComponent implements OnChanges {

  @Input() course: { id: number; name: string; code: string; credits: number } = { id: 0, name: '', code: '', credits: 0 };

  @Output() enrollRequested = new EventEmitter<number>();

  ngOnChanges(changes: SimpleChanges) {
    if (changes['course']) {
      console.log('course previous:', changes['course'].previousValue);
      console.log('course current:', changes['course'].currentValue);
    }
  }
}
```

## course-card.component.html
```html
<div class="course-card">
  <h3>{{ course.name }}</h3>
  <p>Code: {{ course.code }}</p>
  <p>Credits: {{ course.credits }}</p>
  <button (click)="enrollRequested.emit(course.id)">Enroll</button>
</div>
```

## Task 3: @Input / @Output — course-list.component.ts
```typescript
import { Component } from '@angular/core';
import { NgFor, NgIf } from '@angular/common';
import { CourseCardComponent } from '../../components/course-card/course-card.component';

@Component({
  selector: 'app-course-list',
  standalone: true,
  imports: [NgFor, NgIf, CourseCardComponent],
  templateUrl: './course-list.component.html'
})
export class CourseListComponent {
  courses = [
    { id: 1, name: 'Data Structures', code: 'CS101', credits: 4 },
    { id: 2, name: 'Algorithms', code: 'CS102', credits: 4 },
    { id: 3, name: 'Web Development', code: 'CS201', credits: 3 },
    { id: 4, name: 'Database Systems', code: 'CS301', credits: 3 },
    { id: 5, name: 'Machine Learning', code: 'CS401', credits: 4 },
  ];
  selectedCourseId: number | null = null;

  onEnroll(courseId: number) {
    console.log('Enrolling in course: ' + courseId);
    this.selectedCourseId = courseId;
  }
}
```

## course-list.component.html
```html
<app-course-card
  *ngFor="let c of courses"
  [course]="c"
  (enrollRequested)="onEnroll($event)">
</app-course-card>
<p *ngIf="selectedCourseId">Selected course ID: {{ selectedCourseId }}</p>
```
