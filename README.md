# Continuous Integration for O-RAN SC at LF

This repo contains configuration files for Jenkins jobs for the
O-RAN SC project.

## Defaults.yaml

To avoid repetition, many required configuration parameter values
are defined in the defaults.yaml file.

## Custom JJB templates for Docker CI PackageCloud projects

Custom JJB templates are defined for projects that use Docker to
compile code and build DEB/RPM packages, then push the packages to
PackageCloud.io. These projects should use the following jobs in
their respective project.yaml file::

    jobs:
      - gerrit-docker-verify
      - oran-gerrit-docker-ci-pc-merge

## Testing the templates

These instructions explain how to test the templates using the Jenkins
sandbox. This catches errors before submitting the changes as Gerrit
reviews.

### Prerequisites

Install the Jenkins job builder:

    pip install jenkins-job-builder

Check out the global JJB templates submodule within this repo:

    git submodule update --init

### Test Locally

Check sanity by running the Jenkins job-builder script in this directory:

    jenkins-jobs test -r jjb

### Deploy the templates to the Jenkins sandbox

Login (after requesting membership in group
oran-jenkins-sandbox-access) at the Jenkins sandbox:

    https://jenkins.o-ran-sc.org/sandbox

Get the authentication token from the sandbox:
a) click on your user name (top right)
b) click Configure (left menu)
c) under API Token, click Add new Token (button)
d) copy the token string

Create a config file jenkins.ini using the following template and your
credentials (user name and API token from above)::

    [job_builder]
    ignore_cache=True
    keep_descriptions=False
    recursive=True

    [jenkins]
    query_plugins_info=False
    url=https://jenkins.o-ran-sc.org/sandbox
    user=YOUR-USER-NAME
    password=YOUR-API-TOKEN

Build and deploy a specific job using the EXACT job name.

    jenkins-jobs --conf jenkins.ini update jjb your-job-name-here

Examples:

    jenkins-jobs --conf jenkins.ini update jjb project-maven-docker-verify-master-mvn33-openjdk8

In the sandbox visit the job page, then click the button "Build with
parameters" in left menu.

### How to build from a Gerrit review branch

This explains how to launch a "verify" job in the Sandbox on an open
review. Most "verify" jobs accept parameters to build code in a
review submitted to Gerrit. You must specify the change ref spec,
which is a Git branch name. Get this by inspecting Gerrit's
"download" links at the top right. The branch name will be something
like this:

    refs/changes/78/578/2

The first number is a mystery to me; the second number is the Gerrit
change number; the third number is the patch set within the change.

Enter this name for both the GERRIT_BRANCH and the GERRIT_REFSPEC
parameters, then click Build.
