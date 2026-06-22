# Hands-On 7: Angular Routing — Guards, Lazy Loading & Route Data

## app.routes.ts — all portal routes
```typescript
import { Routes } from '@angular/router';
import { HomeComponent } from './pages/home/home.component';
import { CourseListComponent } from './pages/course-list/course-list.component';
import { StudentProfileComponent } from './pages/student-profile/student-profile.component';
import { NotFoundComponent } from './pages/not-found/not-found.component';
import { AuthGuard } from './guards/auth.guard';

export const routes: Routes = [
  { path: '', component: HomeComponent },
  {
    path: 'courses',
    children: [
      { path: '', component: CourseListComponent },
      { path: ':id', component: CourseDetailComponent }
    ]
  },
  { path: 'profile', canActivate: [AuthGuard], component: StudentProfileComponent },
  // Lazy loaded enrollment feature module
  {
    path: 'enroll',
    canActivate: [AuthGuard],
    loadChildren: () => import('./features/enrollment/enrollment.module').then(m => m.EnrollmentModule)
  },
  { path: '**', component: NotFoundComponent } // wildcard MUST be last
];
```

## course-detail.component.ts — read :id route param
```typescript
import { ActivatedRoute } from '@angular/router';
import { CourseService } from '../../services/course.service';

export class CourseDetailComponent implements OnInit {
  course: any;

  constructor(private route: ActivatedRoute, private courseService: CourseService) {}

  ngOnInit() {
    const id = Number(this.route.snapshot.paramMap.get('id'));
    this.course = this.courseService.getCourseById(id);
  }
}
```

## course-list.component.ts — navigate to detail + query param
```typescript
import { Router } from '@angular/router';

constructor(private router: Router, private route: ActivatedRoute) {}

goToDetail(courseId: number) {
  this.router.navigate(['courses', courseId]);
}

onSearch() {
  this.router.navigate(['courses'], { queryParams: { search: this.searchTerm } });
}

ngOnInit() {
  // Read query param back from URL
  this.searchTerm = this.route.snapshot.queryParamMap.get('search') ?? '';
}
```

## auth.guard.ts
```bash
ng generate guard guards/auth
```
```typescript
import { Injectable } from '@angular/core';
import { CanActivate, Router } from '@angular/router';

@Injectable({ providedIn: 'root' })
export class AuthGuard implements CanActivate {
  isLoggedIn = true; // hardcoded; replace with AuthService check

  constructor(private router: Router) {}

  canActivate(): boolean {
    if (this.isLoggedIn) return true;
    this.router.navigate(['/']);
    return false;
  }
}
```

## unsaved-changes.guard.ts (CanDeactivate)
```bash
ng generate guard guards/unsaved-changes
```
```typescript
import { CanDeactivate } from '@angular/router';
import { ReactiveEnrollmentFormComponent } from '../pages/reactive-enrollment-form/reactive-enrollment-form.component';

export class UnsavedChangesGuard implements CanDeactivate<ReactiveEnrollmentFormComponent> {
  canDeactivate(component: ReactiveEnrollmentFormComponent): boolean {
    if (component.enrollForm.dirty) {
      return window.confirm('You have unsaved changes. Leave?');
    }
    return true;
  }
}
```

## Lazy loading — enrollment.module.ts
```bash
ng generate module features/enrollment --routing
```
```typescript
// enrollment.module.ts
@NgModule({
  declarations: [EnrollmentFormComponent, ReactiveEnrollmentFormComponent],
  imports: [CommonModule, EnrollmentRoutingModule, FormsModule, ReactiveFormsModule]
})
export class EnrollmentModule {}

// enrollment-routing.module.ts
const routes: Routes = [
  { path: '', component: EnrollmentFormComponent },
  { path: 'reactive', component: ReactiveEnrollmentFormComponent,
    canDeactivate: [UnsavedChangesGuard] }
];
```

// Verify lazy loading: Chrome DevTools → Network tab → navigate to /enroll
// A new .js chunk file downloads only on first visit — not on initial app load.
