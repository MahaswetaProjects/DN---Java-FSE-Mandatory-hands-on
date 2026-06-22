# Hands-On 8: HTTP Client — API Integration, Observables & Interceptors

## Setup JSON Server
```bash
npm install -g json-server
```
## db.json
```json
{
  "courses": [
    { "id": 1, "name": "Data Structures", "code": "CS101", "credits": 4, "gradeStatus": "passed" },
    { "id": 2, "name": "Algorithms", "code": "CS102", "credits": 4, "gradeStatus": "failed" }
  ],
  "students": [],
  "enrollments": []
}
```
```bash
json-server --watch db.json --port 3000
```

## app.config.ts — provide HttpClient
```typescript
import { provideHttpClient, withInterceptors } from '@angular/common/http';
import { authInterceptor } from './interceptors/auth.interceptor';
import { errorHandlerInterceptor } from './interceptors/error-handler.interceptor';
import { loadingInterceptor } from './interceptors/loading.interceptor';

export const appConfig = {
  providers: [
    provideHttpClient(withInterceptors([authInterceptor, errorHandlerInterceptor, loadingInterceptor]))
  ]
};
```

## Task 1: course.service.ts — HTTP methods
```typescript
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable, throwError } from 'rxjs';
import { catchError, map, retry, tap } from 'rxjs/operators';
import { Course } from '../models/course.model';

const API = 'http://localhost:3000';

@Injectable({ providedIn: 'root' })
export class CourseService {
  constructor(private http: HttpClient) {}

  getCourses(): Observable<Course[]> {
    return this.http.get<Course[]>(`${API}/courses`).pipe(
      map(courses => courses.filter(c => c.credits > 0)),        // transform
      tap(courses => console.log('Courses loaded:', courses.length)), // side effect — never modify data here, use map for transforms
      retry(2),                                                   // retry failed requests twice
      catchError(err => {
        console.error(err);
        return throwError(() => new Error('Failed to load courses. Please try again.'));
      })
    );
  }

  getCourseById(id: number): Observable<Course> {
    return this.http.get<Course>(`${API}/courses/${id}`);
  }

  createCourse(course: Omit<Course, 'id'>): Observable<Course> {
    return this.http.post<Course>(`${API}/courses`, course);
  }

  updateCourse(id: number, course: Partial<Course>): Observable<Course> {
    return this.http.put<Course>(`${API}/courses/${id}`, course);
  }

  deleteCourse(id: number): Observable<void> {
    return this.http.delete<void>(`${API}/courses/${id}`);
  }
}
```

## Task 1: course-list.component.ts — subscribe with error handling
```typescript
courses: Course[] = [];
errorMessage = '';
isLoading = true;

ngOnInit() {
  this.courseService.getCourses().subscribe({
    next:     courses => this.courses = courses,
    error:    err => this.errorMessage = err.message,
    complete: () => this.isLoading = false
  });
}
```

## Task 2: switchMap — load students when course selected
```typescript
// switchMap cancels the previous inner Observable when a new courseId arrives,
// preventing out-of-order responses in type-ahead / dependent HTTP scenarios.
selectedCourse$ = new Subject<number>();

students$ = this.selectedCourse$.pipe(
  switchMap(courseId => this.enrollmentService.getStudentsByCourse(courseId))
);
```

## Task 3: auth.interceptor.ts
```bash
ng generate interceptor interceptors/auth
```
```typescript
import { HttpInterceptorFn } from '@angular/common/http';

export const authInterceptor: HttpInterceptorFn = (req, next) => {
  const cloned = req.clone({
    setHeaders: { Authorization: 'Bearer mock-token-12345' }
  });
  return next(cloned);
  // Verify: Chrome DevTools → Network → any API call → Request Headers → Authorization
};
```

## error-handler.interceptor.ts
```typescript
import { HttpInterceptorFn, HttpErrorResponse } from '@angular/common/http';
import { catchError, throwError } from 'rxjs';
import { inject } from '@angular/core';
import { Router } from '@angular/router';

export const errorHandlerInterceptor: HttpInterceptorFn = (req, next) => {
  const router = inject(Router);
  return next(req).pipe(
    catchError((err: HttpErrorResponse) => {
      if (err.status === 401) router.navigate(['/']);
      if (err.status === 500) console.error('Server error — show global notification');
      return throwError(() => err);
    })
  );
};
```

## loading.interceptor.ts + LoadingService
```typescript
// loading.service.ts
@Injectable({ providedIn: 'root' })
export class LoadingService {
  isLoading$ = new BehaviorSubject<boolean>(false);
}

// loading.interceptor.ts
import { finalize } from 'rxjs/operators';

export const loadingInterceptor: HttpInterceptorFn = (req, next) => {
  const loadingService = inject(LoadingService);
  loadingService.isLoading$.next(true);
  return next(req).pipe(
    finalize(() => loadingService.isLoading$.next(false)) // finalize runs on complete OR error
  );
};
```

## Global spinner in app.component.html
```html
<div *ngIf="loadingService.isLoading$ | async" class="spinner">Loading...</div>
<app-header></app-header>
<router-outlet></router-outlet>
```
