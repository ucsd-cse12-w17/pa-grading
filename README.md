# Autograder Wrapper for Gradescope

This is the result of following this tutorial:

https://gradescope-autograders.readthedocs.io/en/latest/git_pull/

It is a massively helpful upfront step that will save hours of effort later on
when iterating on grading scripts.

The key idea is that for each PA, Gradescope wants you to upload a zip file
that has a `setup.sh` script that installs dependencies (like Java or valgrind
or whatever you need). This actually takes a while to run, so you don't want to
be iterating on a grading script by re-uploading this script over and over.
This wrapper script installs dependencies once, and then on each student
submission, will fetch the appropriate grading repository for the PA and run
the script specific to that repo.

## (My) Setup

- [Optional] Make a new Github _organization_ for your course. You can also just
host the repositories yourself, but it's pretty easy to get Github to give you
unlimited private repositories for a course, which I do literally every
quarter:

https://education.github.com/discount_requests/new

- [Optional] Make a new Github account just for your course. You can use your own
account, but for general security hygeine's sake it's better to make a new one.
Since we will make a separate repository for each PA's grading scripts, it's
best to follow the instructions for "Machine Users":

https://developer.github.com/v3/guides/managing-deploy-keys/#machine-users


- Use the account settings in Github and `ssh-keygen` to make a password-less
  key pair. Save the private key somewhere on the machine you use to do
  development (this avoids checking it into a repository anywhere).

- Edit `setup.sh` in this repo to add any packages or dependencies you need.
  That script run with root and internet access, so you have a ton of control.

- Edit `run_autograder` in this repo to point to the organization you're using.
  In the example it says

  ```
  git clone git@github.com:ucsd-cse12-w17/${ASSIGNMENT_TITLE}-grading.git
  ```

  The `ucsd-cse12-w17` is what I named the course organization. If you're using
  your own private repos, that will be your username.

  I also picked the convention that all of my _grading_ scripts would be
  separate repositories named `paN-grading`. This name is important, because
  `ASSIGNMENT_TITLE` is an environment variable set by Gradescope. So I made
  Gradescope assignments called `pa2`, `pa3`, and so on, and then made Github
  repositories for grading them with the same name and `-grading` appended. The
  nice thing about this is that it meant I can do this setup once and then
  upload the same configuration for each PA.

  The other convention I picked is that each grading repo has a `grade` script at

  ```
  ${ASSIGNMENT_TITLE}-grading/ucsd-cse12-${ASSIGNMENT_TITLE}-grading/grade
  ```

  This isn't strictly necessary, actually. It just helped keep things clean
  when there were multiple directories in the grader itself, and it would be
  known that the ucsd-cse12-pa2-grading subdirectory would hold the grading
  script itself.
  
- Run

  ```
  bash build-for-gradescope.sh PATH_TO_PRIVATE_KEY
  ```

  This will create a file called `pa.zip` which is suitable for uploading to
  Gradescope's autograder page. On each submission, it will clone the
  appropriate `paN-grading` repo based on the title of the submission, and run
  the `grade` script in that repo. The `grade` script _must_ put a JSON file
  into

  `/autograder/results/results.json`

  and it gets to assume that student code will be in /autograder/submission/.

  (This is per https://gradescope-autograders.readthedocs.io/en/latest/specs/)

