# deploy-module

## Description
A shell script to automate deployment of predefined modules (e.g. configuration files for a service, or
just any file structure you want to deploy on one or more machines). You can keep a central file-based
repository of your configs for your different machines and easily submit changes to the remote targets
The script expects a pattern file, which holds deployment details, as argument. To push files and for
execution of post-deployment commands on the remote machine, ssh and rsync are utilized.


## Modules
A module consists of a full path folder structure, holding the source files. The module root holds a 
single pattern file, containing a filelist, targets and the post-deployment commands. It's just a script
snipplet, that is sourced by the deployment script. For details see the example pattern file ´template.deploy´

For example, if you want to create a module for an apache webserver, the module folder could look like this:

<pre>
[module-apache]
├── apache2.deploy
└── etc 
    └── apache2
        ├── apache2.conf
        ├── conf-available  
        ├── conf-enabled  
        ├── envvars  
        ├── magic  
        ├── mods-available  
        ├── mods-enabled  
        ├── ports.conf  
        ├── sites-available  
        │   └── 000-default.conf  
        └── sites-enabled  
            └── 000-default.conf
</pre>

After you finished editing your config, just simply deploy it by running ´deploy-module.sh <path/to/file/apache2.deploy´ 

## ToDo
- [x] Hardening: simple error handling 
- [ ] feature: set additional rsync and ssh options via pattern file
- [ ] feature: add pre-commands

