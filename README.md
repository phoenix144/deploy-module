# deploy-module

## Description
A shell script to automate deployment of predefined modules (e.g. configuration files for a service, or
just any file structure you want to deploy to one or more machines).
The script expects a pattern file, which holds deployment details, as argument. To push files and for
execution of post-deployment commands on the remote machine, ssh and rsync are utilized.


## Modules
A module consists of a full path folder structure, holding the source files. The module root holds a 
single pattern file, containing a filelist, targets and the post-deployment commands. It's just a script
snipplet, that is sourced by the deployment script. For details see the `template.pattern` file

For example, if you want to create a module for an apache webserver, the module folder could look like this:

<apache-server.example.org>
|
|- etc
   |- apache2
      |- sites-availible
      |- sites-enabled
      |- apache2.conf
      |- envars
|- apache2.pattern


