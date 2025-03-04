#!/bin/bash
BUGID="234"
DESCRIPTION="File name should contain date in header"
BRANCH="br_1"
DEVNAME="b.cohen"
PRIORITY="3"
REPO_PATH="./REPO1"
CURR_DATE_TIME=$(date "+%Y-%m-%d_%H-%M-%S")
COMMIT_MSG="${BUGID}:${CURR_DATE_TIME}:${BRANCH}:${DEVNAME}:${PRIORITY}:${DESCRIPTION}"
git add .
git commit -m "$COMMIT_MSG"
echo "$COMMIT_MSG" >> ~/Linux_Course_Work/Q3/commits.txt
