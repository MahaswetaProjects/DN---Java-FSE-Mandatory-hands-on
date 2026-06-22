# Hands-On 9: State Management — NgRx Store, Actions, Reducers, Effects & Selectors

```bash
npm install @ngrx/store @ngrx/effects @ngrx/entity @ngrx/store-devtools
```

## app.config.ts — provide store
```typescript
import { provideStore } from '@ngrx/store';
import { provideEffects } from '@ngrx/effects';
import { provideStoreDevtools } from '@ngrx/store-devtools';
import { courseReducer } from './store/course/course.reducer';
import { CourseEffects } from './store/course/course.effects';
import { enrollmentReducer } from './store/enrollment/enrollment.reducer';

export const appConfig = {
  providers: [
    provideStore({ course: courseReducer, enrollment: enrollmentReducer }),
    provideEffects([CourseEffects]),
    provideStoreDevtools({ maxAge: 25 })
  ]
};
```

## store/course/course.actions.ts
```typescript
import { createAction, props } from '@ngrx/store';
import { Course } from '../../models/course.model';

// [Course] prefix groups actions by feature in Redux DevTools timeline
export const loadCourses        = createAction('[Course] Load Courses');
export const loadCoursesSuccess = createAction('[Course] Load Courses Success', props<{ courses: Course[] }>());
export const loadCoursesFailure = createAction('[Course] Load Courses Failure', props<{ error: string }>());
```

## store/course/course.reducer.ts
```typescript
import { createReducer, on } from '@ngrx/store';
import { Course } from '../../models/course.model';
import { loadCourses, loadCoursesSuccess, loadCoursesFailure } from './course.actions';

export interface CourseState {
  courses: Course[];
  loading: boolean;
  error: string | null;
}

const initialState: CourseState = { courses: [], loading: false, error: null };

export const courseReducer = createReducer(
  initialState,
  on(loadCourses,        state => ({ ...state, loading: true, error: null })),
  on(loadCoursesSuccess, (state, { courses }) => ({ ...state, courses, loading: false })),
  on(loadCoursesFailure, (state, { error }) => ({ ...state, error, loading: false }))
);
```

## store/course/course.selectors.ts
```typescript
import { createFeatureSelector, createSelector } from '@ngrx/store';
import { CourseState } from './course.reducer';

// Selectors are memoised — only recompute when their input selectors' values change
export const selectCourseState  = createFeatureSelector<CourseState>('course');
export const selectAllCourses   = createSelector(selectCourseState, s => s.courses);
export const selectCoursesLoading = createSelector(selectCourseState, s => s.loading);
export const selectCoursesError   = createSelector(selectCourseState, s => s.error);
```

## store/course/course.effects.ts
```typescript
import { Injectable } from '@angular/core';
import { Actions, createEffect, ofType } from '@ngrx/effects';
import { CourseService } from '../../services/course.service';
import { loadCourses, loadCoursesSuccess, loadCoursesFailure } from './course.actions';
import { switchMap, map, catchError } from 'rxjs/operators';
import { of } from 'rxjs';

@Injectable()
export class CourseEffects {
  // Effects are the ONLY place for side effects (HTTP, navigation, localStorage)
  // Reducers must remain pure functions
  loadCourses$ = createEffect(() =>
    this.actions$.pipe(
      ofType(loadCourses),
      switchMap(() =>
        this.courseService.getCourses().pipe(
          map(courses => loadCoursesSuccess({ courses })),
          catchError(error => of(loadCoursesFailure({ error: error.message })))
        )
      )
    )
  );

  constructor(private actions$: Actions, private courseService: CourseService) {}
}
```

## course-list.component.ts — use Store instead of service directly
```typescript
import { Store } from '@ngrx/store';
import { loadCourses } from '../../store/course/course.actions';
import { selectAllCourses, selectCoursesLoading } from '../../store/course/course.selectors';

export class CourseListComponent implements OnInit {
  courses$  = this.store.select(selectAllCourses);
  loading$  = this.store.select(selectCoursesLoading);

  constructor(private store: Store) {}

  ngOnInit() {
    this.store.dispatch(loadCourses()); // triggers Effect → HTTP → success action → reducer → selector emits
  }
}
```

## course-list.component.html — async pipe auto-subscribes/unsubscribes
```html
<div *ngIf="loading$ | async">Loading...</div>
<app-course-card *ngFor="let c of courses$ | async" [course]="c"></app-course-card>
```

## store/enrollment/enrollment.actions.ts
```typescript
export const enrollInCourse      = createAction('[Enrollment] Enroll',   props<{ courseId: number }>());
export const unenrollFromCourse  = createAction('[Enrollment] Unenroll', props<{ courseId: number }>());
```

## store/enrollment/enrollment.reducer.ts
```typescript
export interface EnrollmentState { enrolledCourseIds: number[]; }
const initialState: EnrollmentState = { enrolledCourseIds: [] };

export const enrollmentReducer = createReducer(
  initialState,
  on(enrollInCourse,     (state, { courseId }) => ({
    ...state, enrolledCourseIds: [...state.enrolledCourseIds, courseId]
  })),
  on(unenrollFromCourse, (state, { courseId }) => ({
    ...state, enrolledCourseIds: state.enrolledCourseIds.filter(id => id !== courseId)
  }))
);
```

## store/enrollment/enrollment.selectors.ts
```typescript
// Cross-slice selector: combines course + enrollment state — no state duplication
export const selectEnrollmentState = createFeatureSelector<EnrollmentState>('enrollment');
export const selectEnrolledIds     = createSelector(selectEnrollmentState, s => s.enrolledCourseIds);
export const selectEnrolledCourses = createSelector(
  selectAllCourses, selectEnrolledIds,
  (courses, ids) => courses.filter(c => ids.includes(c.id))
);
```

## course-card.component.html — dispatch enroll/unenroll
```html
<button (click)="toggleEnroll()">
  {{ (enrolledIds$ | async)?.includes(course.id) ? 'Unenroll' : 'Enroll' }}
</button>
```

## course-card.component.ts
```typescript
enrolledIds$ = this.store.select(selectEnrolledIds);

toggleEnroll() {
  const action = this.enrolledIds$.pipe(
    take(1),
    map(ids => ids.includes(this.course.id)
      ? unenrollFromCourse({ courseId: this.course.id })
      : enrollInCourse({ courseId: this.course.id }))
  ).subscribe(action => this.store.dispatch(action));
}
```
