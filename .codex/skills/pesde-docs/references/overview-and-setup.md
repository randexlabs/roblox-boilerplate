# Overview And Setup

Product overview, installation, quickstart workflow, and root project context for getting productive with pesde.

## Readme

- Source: `README.md`

![pesde logo](https://raw.githubusercontent.com/pesde-pkg/pesde/0.7/assets/logotype.svg)

pesde is a package manager for the Luau programming language, designed to
prevent runtime lock-in.

## Installation

pesde can be installed with your favourite toolchain manager. If you don't have
a preference, [mise-en-place](https://github.com/jdx/mise) is recommended.

## Documentation

For more information about its usage, you can check the
[documentation](https://docs.pesde.dev).

## Previous art

pesde is heavily inspired by [npm](https://www.npmjs.com/),
[pnpm](https://pnpm.io/), [Wally](https://wally.run), and
[Cargo](https://doc.rust-lang.org/cargo/).

---

## What is pesde?

- Source: `docs/src/content/docs/index.mdx`
- Original description: A package manager for the Luau programming language, supporting multiple runtimes including Roblox and Lune.

pesde is a package manager for the Luau programming language.

## Why use pesde?

When you write code, you often want to use libraries or frameworks that others
have written. Manually downloading and managing these can be cumbersome.

These libraries or frameworks can be distributed as packages. You can then
easily install and use these packages using pesde. pesde will automatically
download and manage the packages, and their dependencies, for you.

## Multi-target support

Luau can run in a lot of different places, such as on [Roblox][roblox], or in
[Lune][lune].

pesde is designed to work with all of these runtimes. Packages can publish
multiple versions of themselves, each tailored to a specific runtime.

[registry]: https://pesde.daimond113.com/
[roblox]: https://www.roblox.com/
[lune]: https://lune-org.github.io/docs

## The pesde registry

The [pesde registry][registry] is where anyone can publish their packages for
others to use.

---

## Installation

- Source: `docs/src/content/docs/installation.mdx`
- Original description: Install pesde

1. Go to the [GitHub releases page](https://github.com/pesde-pkg/pesde/releases/latest).

2. Download the corresponding archive for your operating system.

3. Extract the downloaded archive to a folder on your computer.

4. Open a terminal and locate the path of the extracted `pesde` binary.

    #### Windows

    If you extracted the archive to `C:\Users\User\Downloads`, the path to the
    `pesde` binary would be `C:\Users\User\Downloads\pesde.exe`.

    You can then run the `self-install` command:

    ```ps
    C:\Users\User\Downloads\pesde.exe self-install
    ```

    pesde should now be installed on your system. You may need to restart your
    computer for the changes to take effect.

    #### Linux & macOS

    If you extracted the archive to `~/Downloads`, the path to the `pesde`
    binary would be `~/Downloads/pesde`.

    You must then add execute permissions and run the `self-install` command:

    ```sh
    chmod +x ~/Downloads/pesde
    ~/Downloads/pesde self-install
    ```

    pesde should now be installed on your system. You will need to update your
    shell configuration file to add the pesde binary to your `PATH`
    environment variable.

    ```sh title=".zshrc"
    export PATH="$PATH:$HOME/.pesde/bin"
    ```

    You should then be able to run `pesde` after restarting your shell.

5. Verify that pesde is installed by running the following command:

    ```sh
    pesde -v
    ```

    This command should output the version of pesde that you installed.

> [!CAUTION]
> It is not recommended to use toolchain managers (such as Rokit or Aftman) to
> install pesde. You can use `pesde self-upgrade` if you need to update pesde.
>
> If you need everyone to use a compatible version of pesde, you can use the
> `[engines.pesde]` field in `pesde.toml` to specify the version of pesde to use
> for the current project.

---

## Quickstart

- Source: `docs/src/content/docs/quickstart.mdx`
- Original description: Start using pesde

Let's make a simple Luau program that uses the `pesde/hello` package to print
hello to the terminal.

## Scaffolding the project

In your terminal, run the following commands to create a folder and navigate
into it.

```sh
mkdir hello-pesde
cd hello-pesde
```

Then, we'll use `pesde init` to scaffold a new pesde project. The command will
ask you a few questions to set up the project. Our project will be named
`<username>/hello_pesde`, replace `<username>` with a username of your choice.
The name may only contain lowercase letters, numbers, and underscores. The
environment we're targeting is `luau`.

```sh
pesde init

# what is the name of the project? <username>/hello_pesde
# what is the description of the project?
# who are the authors of this project?
# what is the repository URL of this project?
# what is the license of this project? MIT
# what environment are you targeting for your package? luau
# would you like to setup Roblox compatibility scripts? No
```

The command will create a `pesde.toml` file in the current folder. Go ahead
and open this file in your text editor of choice.

## Adding a main script

Under the `[target]` section, we're going to add a `bin` field to specify
the path to the main script of our package.

```diff lang="toml" title="pesde.toml"
  name = "<username>/hello_pesde"
  version = "0.1.0"
  license = "MIT"

  [target]
  environment = "luau"
+ bin = "main.luau"

  [indices]
  default = "https://github.com/pesde-pkg/index"
```

Don't forget to save the file after making the changes.

Now, lets create a `main.luau` file in the project folder and add the following
code to it.

```luau title="main.luau"
print("Hello, pesde!")
```

## Running the script

Then, we can run the following command to run the script.

```sh
pesde run
```

You should see `Hello, pesde!` printed to the terminal.

## Install a dependency

Let's use the `pesde/hello` package instead of printing ourselves.

Run the following command to add the package to `pesde.toml`.

```sh
pesde add pesde/hello
```

You should see that `pesde.toml` has been updated with the new dependency.

```diff lang="toml" title="pesde.toml"
  name = "lukadev_0/hello_pesde"
  version = "0.1.0"
  license = "MIT"

  [target]
  environment = "luau"
  bin = "main.luau"

  [indices]
  default = "https://github.com/pesde-pkg/index"

+ [dependencies]
+ hello = { name = "pesde/hello", version = "^1.0.0" }
```

Run the following command to install the new dependency.

```sh
pesde install
```

You should see that pesde has created a `luau_packages` folder containing the
newly installed package. It has also created a `pesde.lock` file, this file
contains the exact versions of the dependencies that were installed so that
they can be installed again in the future.

```text
- luau_packages/
  - hello.luau
  - ...
- main.luau
- pesde.lock
- pesde.toml
```

Let's update the `main.luau` file to use the `pesde/hello` package.

```luau title="main.luau"
local hello = require("./luau_packages/hello")

hello()
```

If we run the script again, we should see something printed to the terminal.

```sh
pesde run
# Hello, pesde! (pesde/hello@1.0.0, luau)
```
