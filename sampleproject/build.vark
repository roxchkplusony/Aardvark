ProjectName = "Sample Project"
DefaultTarget = "run"
BaseDir = file(".")

var buildDir = file("build")
var classesDir = buildDir.file("classes")
var testClassesDir = buildDir.file("testclasses")
var distDir = buildDir.file("dist")
var userHome = file(getProperty("user.home"))

var compilePath = path()
        .withFile(userHome.file(".m2/repository/com/google/guava/guava/r08/guava-r08.jar"))
var runPath = path().withPath(compilePath)
        .withFile(classesDir)
var testCompilePath = path().withPath(runPath)
        .withFile(userHome.file(".m2/repository/junit/junit/4.8.2/junit-4.8.2.jar"))
var testRunPath = path().withPath(testCompilePath)
        .withFile(testClassesDir)

/**
 * Echos the value of a property passed in at the command line
 */
function echoPropVal() {
  Ant.echo(:message = "Value of property some.prop: " + getProperty("some.prop"))
}

/**
 * Breaks the process with an intentional failure
 */
function epicFail() {
  Ant.fail(:message = "you fail")
}

function nap() {
  Ant.echo(:message = "Sleeping 1.5 sec")
  Ant.sleep(:seconds = 1, :milliseconds = 500)
  Ant.echo(:message = "Done sleeping")
}

function setup() {
  Ant.mkdir(:dir = buildDir)
}

/**
 * Compiles the project
 */
@Depends("setup")
function compile() {
  Ant.mkdir(:dir = classesDir)
  Ant.javac(:srcdir = path(file("src")),
            :destdir = classesDir,
            :classpath = compilePath,
            :includeantruntime = false)
}

@Depends("compile")
function compileTests() {
  Ant.mkdir(:dir = testClassesDir)
  Ant.javac(:srcdir = path(file("test")),
            :destdir = testClassesDir,
            :classpath = testCompilePath,
            :includeantruntime = false)
}

@Depends("compile")
function jar() {
  Ant.mkdir(:dir = distDir)
  Ant.jar(:destfile = distDir.file("sampleproject.jar"),
          :basedir = classesDir)
}

@Depends("compileTests")
function test() {
  Ant.junit(:printsummary = Yes,
    :classpathBlocks = {
      \ cp -> cp.withPath(testRunPath)
    }, :batchtestBlocks = {
      \ bt -> {
        bt.setHaltonfailure(true)
        bt.setHaltonerror(true)
        bt.addFileSet(testClassesDir.fileset("gw/vark/test/HelloWorldTest.class"))
      }
    })
}

@Depends("setup")
function writeAndZipSomeStuff() {
  var stuff = buildDir.file("stuff")
  var a = stuff.file("a")
  Ant.mkdir(:dir = a)
  Ant.echo(:message = "text1\n", :file = a.file("foo.txt"))
  Ant.echo(:message = "text2\n", :file = a.file("foo.txt"), :append = true)
  var b = stuff.file("b")
  Ant.mkdir(:dir = b)
  Ant.echo(:message = "text3\n", :file = b.file("bar.txt"))
  Ant.echo(:message = "text4\n", :file = b.file("bar.txt"), :append = false)
  Ant.echo(:message = "text5\ntext6\n", :file = b.file("baz.txt"))
  var c = b.file("c")
  Ant.mkdir(:dir = c)
  Ant.echo(:message = "text7\n", :file = c.file("dontreadme.txt"))
  Ant.zip(:destfile = buildDir.file("stuff1.zip"), :basedir = stuff)
  Ant.zip(:destfile = buildDir.file("stuff2.zip"), :filesetList = { a.fileset(), b.fileset() })
}

@Depends({"jar", "test", "writeAndZipSomeStuff"})
function run() {
  Ant.java(:classname = "gw.vark.test.HelloWorld",
           :classpath = runPath,
           :fork = true)
}

function clean() {
  Ant.delete(:dir = buildDir)
}
