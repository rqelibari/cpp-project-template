# C++ Project Template
A default project layout for C++ projects, which runs tests with Googlemock.

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

[1]: https://github.com/rqelibari/cpp-project-template/blob/master/Makefile#L18-L23

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
> make init
```

**Alternatively**: You can add this repo as a submodule to your existing
repository.