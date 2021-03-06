classpath "support"

uses gw.vark.annotations.Target
uses gw.lang.Param

var buildDir = file("build")
var classesDir = buildDir.file("classes")
var testClassesDir = buildDir.file("testclasses")
var distDir = buildDir.file("dist")

function echoHello() {
  Ant.echo(:message = "Hello World")
}

/**
 * A target with one argument.
 */
@Target
@Param("foo", "An argument called foo")
function targetWithArg(foo : String) {
  Ant.echo(:message = "foo: ${foo} (${typeof foo})")
}

/**
 * A target with a default argument.
 */
@Target
@Param("foo", "An argument with a default value")
function targetWithDefaultValueArg(foo : String = "baz") {
  Ant.echo(:message = "foo: ${foo} (${typeof foo})")
}

@Target
function targetWithBooleanArg(foo : boolean) {
  Ant.echo(:message = "foo: ${foo} (${typeof foo})")
}

@Target
function targetWithBooleanArgDefaultTrue(foo : boolean = true) {
  Ant.echo(:message = "foo: ${foo} (${typeof foo})")
}

@Target
function targetWithBooleanArgDefaultFalse(foo : boolean = false) {
  Ant.echo(:message = "foo: ${foo} (${typeof foo})")
}

@Target
function targetWithIntArg(foo : int) {
  Ant.echo(:message = "foo: ${foo} (${typeof foo})")
}

@Target
function targetWithIntArgDefault1357(foo : int = 1357) {
  Ant.echo(:message = "foo: ${foo} (${typeof foo})")
}

@Target
function targetWithTwoArgs(foo : String, bar : String) {
  Ant.echo(:message = "foo: ${foo}, bar: ${bar}")
}

@Target
function targetWithTwoDefaultValueArgs(foo : String = "baz", bar : String = "baz2") {
  Ant.echo(:message = "foo: ${foo}, bar: ${bar}")
}

@Target
function targetWithBooleanArgAndStringArg(foo : boolean, bar : String) {
  Ant.echo(:message = "foo: ${foo} (${typeof foo}), bar: ${bar} (${typeof bar})")
}

@Target
function targetWithDoubleArg(foo : double) {
  // this shouldn't work
}

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

@Depends("setup")
function copyWithFilesetListParam() {
  Ant.copy(:filesetList = { file(".").fileset(:includes = "build.vark") },
           :todir = buildDir)
}

@Depends("setup")
function copyWithResourcesParam() {
  Ant.copy(:resources = { file(".").fileset(:includes = "build.vark") },
           :todir = buildDir)
}

function clean() {
  Ant.delete(:dir = buildDir)
}
