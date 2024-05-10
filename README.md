# BaotiLearning
## Installation
To install and run the app, simply clone the project onto your machine. Then run:
```
rails s -b 0.0.0.0 -p 3001
```
Ensure that port 3001 is open. Then, it should run on your machine's IP address under port 3001!

## Documentation
Our program has three user views:
* The Guest: Visitors with no account can look at the course pages but do nothing else. They, students, and instructors can all manipulate subjects and tasks.
* The Student: All users can be students of others’ courses. Enroll in a course by clicking the “Enroll” button before the course’s start date. They can see the sections and the assignments within a course. They manipulate anything within the course.
* The Instructor: All users can be instructors of their own courses. They create a course by signing in and clicking on the “New Course” button on the index page. Filling out the form automatically enrolls them as an instructor. In their course page, they can add new sections to courses and new assignments to sections. They can delete assignments, sections (which deletes all assignments within the section), and courses (which deletes all sections and thus all assignments within the course).

## State of Project
We got to a pretty good point where students and instructors are able to interact nicely. Courses and assignments can be created, edited, and destroyed. Sections can be created and destroyed. There are some things we wished to have added or fleshed out:
* Enable course payments through Stripe interacting with our database
* Hide assignment from students before its open date and after its close date
* Restrict students from seeing assignments until class's start date
* Add submissions to assignments through ActiveStorage