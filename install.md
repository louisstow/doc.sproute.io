# Getting Started &amp; Installation

## Installation

First of all you should download the required dependencies to run a Sproute application. Sproute relies on the following technologies:

- [Node.js (> 0.10.8)](http://nodejs.org)
- [Mongodb (> 2.4.3)](http://mongodb.org)

For installation on **OSX** or **Linux**, change directory to the `posix` directory in the package. Execute `./install.sh`.

For installation on **Windows**, double-click `install.bat` under the `windows` directory in the package.

Now that everything is installed, let's take a look at your newly downloaded package from [purchasing a license](/buy).

### docs/

Offline documentation in simple HTML. This is just convencience if the online documentation is not available for any reason.

### sproute/

This is the source code for the Sproute framework. Advanced users can browse through the code to see how it works and even extend the framework if need be.

### views/

Put your view code files in this directory.

### models/

Put your models in this directory.

### windows/

This contains some scripts to install the framework and start the server on the Windows operating system. Double-click `install.bat` to install Sproute. 

From there you can run `start-server.bat` and test your website at [`http://localhost:8000`](http://localhost:8000) or whatever [port](/docs/config#port) you choose. To stop the server, simply exit the terminal window that will open.

### posix/

This contains scripts to install the framework and start the server on a POSIX complaint operating system such as OSX or Linux.

Execute `install.sh` to install. Then run `start-server.sh` to test your website. To stop the server, use `Control + C` in the running process.

## Your first website!

You need a name for the site. Let's say it was a simple blog, we will call the site `myfirstblog`.

Edit `config.json` and replace the current value of name with our new name. Add an `admin` key with a username and password.

Then we need a home page. This is the first page the viewer will come across. Edit `controller.json` and add this to the object:

~~~
{
	"/": "home"
}
~~~

This tells Sproute to execute the `views/home.sprt` file when the user requests the home page.

Create the file `home.sprt` under `views/`. Add any HTML to it.

Then run the server with the script under your operating system directory.

Target the website in your browser at [`http://localhost:8000`](http://localhost:8000). You should see the HTML rendered.

**Remove the `admin` key previously created in the config as it is not needed after first run and poses a security risk.**