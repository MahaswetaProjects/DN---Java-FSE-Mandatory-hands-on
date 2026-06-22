# Hands-On 4: Template-Driven Forms & Validation

```bash
ng generate component pages/enrollment-form
```

## enrollment-form.component.ts
```typescript
import { Component } from '@angular/core';
import { FormsModule, NgForm } from '@angular/forms';
import { NgIf } from '@angular/common';

@Component({
  selector: 'app-enrollment-form',
  standalone: true,
  imports: [FormsModule, NgIf],
  templateUrl: './enrollment-form.component.html',
  styleUrls: ['./enrollment-form.component.css']
})
export class EnrollmentFormComponent {
  submitted = false;

  onSubmit(form: NgForm) {
    console.log('form.value:', form.value);
    console.log('form.valid:', form.valid);
    if (form.valid) {
      this.submitted = true;
    }
  }
}
```

## enrollment-form.component.html
```html
<form #enrollForm="ngForm" (ngSubmit)="onSubmit(enrollForm)">

  <!-- Student Name -->
  <label>Student Name</label>
  <input name="studentName" [(ngModel)]="studentName" required minlength="3" #nameCtrl="ngModel">
  <span *ngIf="nameCtrl.touched && nameCtrl.errors?.['required']">Name is required</span>
  <span *ngIf="nameCtrl.touched && nameCtrl.errors?.['minlength']">Name must be at least 3 characters</span>

  <!-- Student Email -->
  <label>Email</label>
  <input name="studentEmail" [(ngModel)]="studentEmail" required email #emailCtrl="ngModel">
  <span *ngIf="emailCtrl.touched && emailCtrl.errors?.['required']">Email is required</span>
  <span *ngIf="emailCtrl.touched && emailCtrl.errors?.['email']">Enter a valid email</span>

  <!-- Course ID -->
  <label>Course ID</label>
  <input name="courseId" type="number" [(ngModel)]="courseId" required #courseCtrl="ngModel">
  <span *ngIf="courseCtrl.touched && courseCtrl.errors?.['required']">Course ID is required</span>

  <!-- Preferred Semester -->
  <label>Preferred Semester</label>
  <select name="preferredSemester" [(ngModel)]="preferredSemester" required>
    <option value="Odd">Odd</option>
    <option value="Even">Even</option>
  </select>

  <!-- Agree to Terms -->
  <label>
    <input name="agreeToTerms" type="checkbox" [(ngModel)]="agreeToTerms" required>
    I agree to the terms
  </label>

  <button type="submit" [disabled]="enrollForm.invalid">Submit</button>
  <button type="button" (click)="enrollForm.resetForm()">Reset</button>
</form>

<div *ngIf="submitted">Enrollment request submitted successfully!</div>
```

## enrollment-form.component.css
```css
/* Angular auto-applies these classes — just add the CSS rules */
input.ng-invalid.ng-touched { border-color: red; }
input.ng-valid.ng-touched   { border-color: green; }
```

## Add route in app.routes.ts
```typescript
{ path: 'enroll', component: EnrollmentFormComponent }
```
