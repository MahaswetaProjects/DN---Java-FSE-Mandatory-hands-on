# Hands-On 5: Reactive Forms — FormBuilder, FormGroup, FormArray & Custom Validators

```bash
ng generate component pages/reactive-enrollment-form
```

## reactive-enrollment-form.component.ts
```typescript
import { Component, OnInit } from '@angular/core';
import { AbstractControl, FormArray, FormBuilder, FormControl,
         ReactiveFormsModule, ValidationErrors, Validators } from '@angular/forms';
import { NgFor, NgIf } from '@angular/common';

// Custom sync validator: disallow course codes starting with 'XX'
function noCourseCode(control: AbstractControl): ValidationErrors | null {
  return control.value?.startsWith('XX') ? { noCourseCode: true } : null;
}

// Custom async validator: simulate checking if email is already taken
function simulateEmailCheck(control: AbstractControl): Promise<ValidationErrors | null> {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve(control.value?.includes('test@') ? { emailTaken: true } : null);
    }, 800);
  });
}

@Component({
  selector: 'app-reactive-enrollment-form',
  standalone: true,
  imports: [ReactiveFormsModule, NgFor, NgIf],
  templateUrl: './reactive-enrollment-form.component.html'
})
export class ReactiveEnrollmentFormComponent implements OnInit {
  enrollForm: any;

  constructor(private fb: FormBuilder) {}

  ngOnInit() {
    this.enrollForm = this.fb.group({
      studentName:       ['', [Validators.required, Validators.minLength(3)]],
      studentEmail:      ['', [Validators.required, Validators.email], [simulateEmailCheck]],
      courseId:          [null, [Validators.required, noCourseCode]],
      preferredSemester: ['Odd', Validators.required],
      agreeToTerms:      [false, Validators.requiredTrue],
      additionalCourses: this.fb.array([])
    });
  }

  // Typed getter: avoids casting in the template; keeps type safety
  get additionalCourses() {
    return this.enrollForm.get('additionalCourses') as FormArray;
  }

  addCourse() {
    this.additionalCourses.push(new FormControl('', Validators.required));
  }

  removeCourse(i: number) {
    this.additionalCourses.removeAt(i);
  }

  onSubmit() {
    // enrollForm.value excludes disabled controls
    // enrollForm.getRawValue() includes ALL controls including disabled ones
    console.log(this.enrollForm.value);
    console.log(this.enrollForm.getRawValue());
  }
}
```

## reactive-enrollment-form.component.html
```html
<form [formGroup]="enrollForm" (ngSubmit)="onSubmit()">

  <input formControlName="studentName" placeholder="Student Name">
  <span *ngIf="enrollForm.get('studentName')?.touched && enrollForm.get('studentName')?.errors?.['required']">
    Name is required</span>
  <span *ngIf="enrollForm.get('studentName')?.errors?.['minlength']">Min 3 characters</span>

  <input formControlName="studentEmail" placeholder="Email">
  <span *ngIf="enrollForm.get('studentEmail')?.errors?.['emailTaken']">Email is already taken</span>

  <input formControlName="courseId" placeholder="Course Code">
  <span *ngIf="enrollForm.get('courseId')?.errors?.['noCourseCode']">
    Course code starting with XX is not allowed.</span>

  <select formControlName="preferredSemester">
    <option value="Odd">Odd</option>
    <option value="Even">Even</option>
  </select>

  <input type="checkbox" formControlName="agreeToTerms"> Agree to Terms

  <!-- FormArray: dynamic additional courses -->
  <div formArrayName="additionalCourses">
    <div *ngFor="let ctrl of additionalCourses.controls; let i = index">
      <input [formControl]="ctrl" placeholder="Additional course">
      <button type="button" (click)="removeCourse(i)">Remove</button>
    </div>
  </div>
  <button type="button" (click)="addCourse()">Add Another Course</button>

  <button type="submit" [disabled]="enrollForm.invalid">Submit</button>
</form>
```

## Add route in app.routes.ts
```typescript
{ path: 'enroll-reactive', component: ReactiveEnrollmentFormComponent }
```
