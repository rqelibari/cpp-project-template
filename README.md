# C++ Project Template
A default project Makefile for C++ projects, which runs tests with Googlemock.

## What is included?
This project template for C++ includes a Makefile which takes care of usual
tasks during development with C++. If your project follows the folder structure
defined in the [Makefile][1] than the makefile will offer you a standard build
procedure and can run your tests etc.
If you have another structure and provide an own Makefile for that project,
this Makefile will delegate targets of the format
`make <your-project> <some-target>` to the Makefile of your project.

> Notice: This Makefile is most util when used with the standard folder
  structure.

[1]: https://github.com/rqelibari/cpp-project-template/blob/master/Makefile#L82-L100

The following targets are offered:

|command      | description   |
|-------------|---------------|
| `make init` | Init repository to include googlemock as a submodule. Also build the googlemock library. |
| `make <some-project> screate`      | Create a subfolder `<some-project>` and add subdirectories accordingly. |
| `make <some-project> sbuild`       | Run the standard build procedure for the project `<some-project>`.   |
| `make <some-project> sclean`       | Removes object files and binaries created during build. |
| `make <some-project> sclean-all`   | Same as sclean target but additionally removes dependency files. |

## Setup
1. Download this repo as a zip and unpack it to `REPO_DIR`.

2. Run the followin code:

```
> cd REPO_DIR
> git init
> make init
```

**Alternatively**: You can add this repo as a submodule to your existing
repository and than symlink the toplevel Makefile to this one.

## Good to know:
- This Makefile uses special features of GNUMake in favor of writing less code.

- This Makefile disables make buil-in rules (see [documentation][3]). With that
it optimizez the runtime up to 33% (for more details see
[this experiment][2]).

- This Makefile makes use of [secondexpansion][4], so that object files don't
have to be in the same directory as the according source files.

- The standard build proecedure for projects in this Makefile has automatic
dependency generation included. It will find out by itself, which file needs to
be updated when a file changed. This feature is inspired by the explainations
given by Tom Tromey and written down by Paul D. Smith on his [Website][5].

[2]: http://electric-cloud.com/blog/2009/08/makefile-performance-built-in-rules/
[3]: https://www.gnu.org/software/make/manual/html_node/Catalogue-of-Rules.html#Catalogue-of-Rules
[4]: https://www.gnu.org/software/make/manual/html_node/Secondary-Expansion.html
[5]: http://make.mad-scientist.net/papers/advanced-auto-dependency-generation/#combine