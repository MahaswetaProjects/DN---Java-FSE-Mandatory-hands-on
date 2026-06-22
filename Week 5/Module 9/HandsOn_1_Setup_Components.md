# Hands-On 1: Environment Setup, Project Structure & First Component

## Task 1: Scaffold the Project

```bash
npm install -g @angular/cli
ng new student-course-portal --routing --style=css
cd student-course-portal
ng serve
ng build
```

## notes.txt (file explanations)
```
angular.json        - Workspace config: build, serve, test settings and file paths for all projects
tsconfig.json       - Root TypeScript compiler config inherited by all tsconfig.*.json files
tsconfig.app.json   - TypeScript config specific to the app build (excludes test files)
package.json        - NPM dependencies, scripts (start, build, test) and project metadata
src/main.ts         - Application entry point: bootstraps the root component/module to start Angular
src/app/app.config.ts   - Standalone app config: registers providers (router, HttpClient, store) globally
src/app/app.component.ts - Root component: the top-level component rendered inside index.html <app-root>
src/index.html      - Shell HTML page: contains <app-root> where Angular mounts the entire SPA
```

## Task 2: Generate Components

```bash
ng generate component components/header
ng generate component pages/home
ng generate component pages/course-list
ng generate component pages/student-profile
```

## header.component.html
```html
<nav>
  <span>Student Course Portal</span>
  <a routerLink="/">Home</a>
  <a routerLink="/courses">Courses</a>
  <a routerLink="/profile">Profile</a>
</nav>
```

## home.component.html
```html
<h1>Welcome to Student Course Portal</h1>
<p>Browse and enroll in courses, check grades, and manage your profile.</p>
<div class="stats">
  <div>Courses Available: 12</div>
  <div>Enrolled: 3</div>
  <div>GPA: 3.8</div>
</div>
```

## app.component.html
```html
<app-header></app-header>
<router-outlet></router-outlet>
```
