# Is the Library Open?

This is a simple application I built to show whether the Durham County Library is open at any given time, as well as show the hours of the library and a map. This code generates a static site which uses JavaScript for all its dynamic functionality, like switching branches, determining whether the branch is open, and displaying a map to the branch. I used [Middleman](http://middlemanapp.com/) to build the static site.

To build the site, you will need Ruby 1.9, Rubygems, and the `bundler` gem installed on your computer. Once you have that, you can build the site by running these commands:

```bash
# You only have to do this the first time
bundle install
rake build
```

