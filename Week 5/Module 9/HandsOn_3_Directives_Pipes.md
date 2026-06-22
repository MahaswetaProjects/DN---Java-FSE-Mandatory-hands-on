# Hands-On 3: Directives & Pipes

## Task 1: Structural Directives — course-list.component.ts
```typescript
export class CourseListComponent implements OnInit {
  isLoading = true;
  courses = [
    { id: 1, name: 'Data Structures', code: 'CS101', credits: 4, gradeStatus: 'passed' },
    { id: 2, name: 'Algorithms', code: 'CS102', credits: 4, gradeStatus: 'failed' },
    { id: 3, name: 'Web Development', code: 'CS201', credits: 3, gradeStatus: 'pending' },
  ];

  ngOnInit() {
    setTimeout(() => { this.isLoading = false; }, 1500);
  }

  // trackBy improves performance: Angular reuses existing DOM nodes instead of
  // re-rendering the whole list when the array changes
  trackByCourseId(index: number, course: any) { return course.id; }
}
```

## course-list.component.html
```html
<p *ngIf="isLoading">Loading courses...</p>

<ng-container *ngIf="!isLoading">
  <app-course-card
    *ngFor="let course of courses; let i = index; trackBy: trackByCourseId"
    [course]="course">
  </app-course-card>
  <ng-template #noCourses><p>No courses available.</p></ng-template>
  <ng-container *ngIf="courses.length === 0; else noCourses"></ng-container>
</ng-container>
```

## *ngSwitch badge in course-card.component.html
```html
<div [ngSwitch]="course.gradeStatus">
  <span *ngSwitchCase="'passed'" style="color:green">✔ Passed</span>
  <span *ngSwitchCase="'failed'" style="color:red">✘ Failed</span>
  <span *ngSwitchDefault style="color:grey">⏳ Pending</span>
</div>
```

## Task 2: ngClass and ngStyle — course-card.component.ts
```typescript
export class CourseCardComponent {
  @Input() course: any;
  isExpanded = false;

  // Getter keeps template clean — logic stays in TypeScript, not the HTML
  get cardClasses() {
    return {
      'card--enrolled': this.course.enrolled,
      'card--full': this.course.credits >= 4,
      'expanded': this.isExpanded
    };
  }

  get borderColor() {
    const map: any = { passed: 'green', failed: 'red', pending: 'grey' };
    return map[this.course.gradeStatus] || 'grey';
  }
}
```

## course-card.component.html (ngClass + ngStyle)
```html
<div [ngClass]="cardClasses" [ngStyle]="{ 'border-left': '4px solid ' + borderColor }">
  <h3>{{ course.name }}</h3>
  <button (click)="isExpanded = !isExpanded">Show Details</button>
</div>
```

## course-card.component.css
```css
.card--enrolled { background: #e8f5e9; }
.card--full { opacity: 0.8; }
.expanded { min-height: 200px; }
```

## Task 3: Custom Directive
```bash
ng generate directive directives/highlight
ng generate pipe pipes/credit-label
```

## highlight.directive.ts
```typescript
import { Directive, ElementRef, HostListener, Input } from '@angular/core';

@Directive({ selector: '[appHighlight]', standalone: true })
export class HighlightDirective {
  @Input() appHighlight = 'yellow';

  constructor(private el: ElementRef) {}

  @HostListener('mouseenter') onMouseEnter() {
    this.el.nativeElement.style.backgroundColor = this.appHighlight;
  }

  @HostListener('mouseleave') onMouseLeave() {
    this.el.nativeElement.style.backgroundColor = '';
  }
}
```

## credit-label.pipe.ts
```typescript
import { Pipe, PipeTransform } from '@angular/core';

@Pipe({ name: 'creditLabel', standalone: true })
export class CreditLabelPipe implements PipeTransform {
  transform(credits: number | null): string {
    if (!credits || credits === 0) return 'No Credits';
    return credits === 1 ? '1 Credit' : `${credits} Credits`;
  }
}
```

## Usage in course-card.component.html
```html
<!-- appHighlight directive with custom colour -->
<div appHighlight="lightblue">
  <p>{{ course.credits | creditLabel }}</p>
</div>
```
