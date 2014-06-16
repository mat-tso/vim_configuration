import os

"""
Custom configuration for ycm
Only supports Compilation Database
    see http://clang.llvm.org/docs/JSONCompilationDatabase.html

CompilationDatabase format is
[
  {
    "directory": "/home/user/llvm/build",
    "command"  : "/usr/bin/clang++ -Irelative -DSOMEDEF=\"somevalue\" -c -o file.o file.cc",
    "file"     : "file.cc"
  },
    ...
]
It can be generated by cmake using the CMAKE_EXPORT_COMPILE_COMMANDS option

This config script uses the closest .compilation_commands.json in
the file ancestor folders.
ie. for the filepath /a/b/c/d/file
    it will test if /a/b/c/d/.compilation_commands.json exists and use it if so.
    or if /a/b/c/.compilation_commands.json exists and use it,
    ...

If no compilation commands are found, the script uses for a .flags file
in the ancestor folders.
This file should contain the flags to provide to clang, one per line.
The first line *MUST* contain the root path of all flags relative path.

To generate flags on android:
    grep -Eoe '-[^ ]*( [^ ]*/[^ ]*)?' compilation.cmd |
        grep -v -e '^-o' -e '^-MF' -e ' out/host/linux-x86/' |
        sort -u | sed -r 's/.*/"&",/;s/ +/", "/' > flags
"""

compilationDatabaseFileName = ".compilation_commands.json"
compilationFlagsListFileName = ".flags"

defaultFlags = [
        '-Wall',
        '-Wextra',
        '-Werror',
    ]

SOURCE_EXTENSIONS = ['.cpp', '.cxx', '.cc', '.c', '.m', '.mm']

class YcmException(Exception):
    """ Base class for all ycm config exceptions. """
    pass

class FlagsNotFound(YcmException): pass

def isHeaderFile(filepath):
    extension = os.path.splitext(filepath)[1]
    return extension in ['.h', '.hxx', '.hpp', '.hh']

class DatabaseNotFound(YcmException): pass

def findClosestDatabase(filepath, filename):
    """Find first existing {filepath}/.../{filename}"""

    folder = os.path.dirname(filepath)
    rootTested = False

    while not rootTested:
        maybeFile = os.path.join(folder, filename)
        if os.path.exists(maybeFile):
            return maybeFile
        rootTested = (folder == "/")
        folder = os.path.dirname(folder)

    raise DatabaseNotFound("No %s found in %s ancestors" % (filename,filepath))

class CompilationInfoNotFound(YcmException): pass

def getCompilationInfoForFile(filepath, database):
    """
    The compilation_commands.json file generated by CMake does not have entries
    for header files. So we do our best by asking the db for flags for a
    corresponding source file, if any. If one exists, the flags for that file
    should be good enough.
    """
    if not IsHeaderFile(filepath):
      return database.GetCompilationInfoForFile(filepath)

    basename = os.path.splitext(filepath)[0]
    dirname = os.path.dirname(filepath)
    for extension in SOURCE_EXTENSIONS:
        for path in [".", "..", "../src"]:
            replacementFile = os.path.join([dirname, path, basename + extension])
            if os.path.exists(replacementFile):
                compilationInfo = database.GetCompilationInfoForFile(replacementFile)
                if compilationInfo.compiler_flags_:
                    return compilationInfo

    raise CompilationInfoNotFound("No flag found for %s in %s" % (filepath, database))


def makeRelativePathsInFlagsAbsolute(flags, workingDirectory):
    newFlags = []
    nextIsPath = False
    pathFlags = ['-isystem', '-I', '-iquote', '--sysroot=', '-include']

    for flag in flags:
        newFlag = flag

        if nextIsPath:
            nextIsPath = False
            if not flag.startswith('/'):
                newFlag = os.path.join(workingDirectory, flag)

        for pathFlag in pathFlags:
            if flag == pathFlag:
                nextIsPath = True
                break

            if flag.startswith(pathFlag):
                path = flag[len(pathFlag):]
                newFlag = pathFlag + os.path.join(workingDirectory, path)
                break

        if newFlag:
            newFlags.append(newFlag)

    return newFlags

def directoryOfThisScript():
    return os.path.dirname(os.path.abspath(__file__))

class ParseError (YcmException):
    """Exception raised when ycm could not parse a database."""
    pass

def findFlagsInDatabase(filepath):

    databasePath = findClosestDatabase(filepath, compilationDatabaseFileName)

    import ycm_core
    database = ycm_core.CompilationDatabase(databasePath)
    if not database:
        raise ParseError("No flag found for %s in %s" % (filepath, databasePath))

    compilationInfo = getCompilationInfoForFile(filepath, database)

    # Bear in mind that compilation_info.compiler_flags_ does NOT return a
    # python list, but a "list-like" StringVec object
    flags = list(compilationInfo.compiler_flags_)
    if not flags:
        raise FlagsNotFound("No flags for %s in database %s" % (filepath, databasePath))

    relativeTo = compilationInfo.compiler_working_dir_

    return flags, relativeTo

def findFlagsInList(filepath):
    """
    Return the flags listed in the first ancestor .flags"
    One flag per line, the first line being a PWD for relative path flags.
    """
    databasePath = findClosestDatabase(filepath, compilationFlagsListFileName)
    with open(databasePath, "r") as file:
        lines = map(str.strip, file.readlines())
    return lines[1:], lines[0]

def getDefaultFlags():
    """ Return the default flags and the root folder of relative flag paths. """
    if not defaultFlags: raise FlagsNotFound("No defaultFlags")
    return defaultFlags, directoryOfThisScript()

class AllFailed (YcmException):
    def __init__(self, exceptions): self.exceptions = exceptions

def evaluates(functions,*arg):
    exceptions = []
    for function in functions:
        try:
            return function(*arg)
        except YcmException, ex:
            exceptions += ex

    raise AllFailed(exceptions)

def getFlags(filepath):
    """
    Return the flags for a filename and the root folder of relative flag paths.
    Flags are search in CompilationDatabase, flag file and defaultFlags.
    """
    try:
        return evaluates([
                findFlagsInDatabase,
                findFlagsInList,
                lambda _ : getDefaultFlags()
            ], filepath)
    except AllFailed, ex:
        raise FlagsNotFound("Could not find flags for %s: %s" %
                (filepath, "; ".join(map(str, ex.exceptions))))

def getAbsoluteFlags(filename):
    """ Return the flags for a filename, all path path absolute. """
    return makeRelativePathsInFlagsAbsolute(*getFlags(filename))

def FlagsForFile(filepath, **kwargs):
    return {'flags': getAbsoluteFlags(filepath), 'do_cache': True}
