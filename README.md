## rmote

### Running R on a remote server

R users often find themselves needing to log in to a remote machine to do analysis.  Sometimes this is due to data restrictions, computing power on the remote machine, etc.  Users can ssh in and run R in a terminal, but it is not possible to look at graphics, etc.

There are currently three approaches that I am aware of to deal with this:

1. Install [RStudio Server](https://www.rstudio.com/products/rstudio-server-pro/) on the remote server and use that from a web browser on your local machine.  Graphics output is shown in the IDE.
2. Use X11 forwarding (`ssh -X|Y`).  Graphics output is sent back to your machine.
3. Use VNC with a linux desktop environment like KDE or GNOME.

Whenever possible, #1 is by far the best way to go and is one of the beautiful things about RStudio Server.  #2 is not a good choice - plots are very slow to render, the quality is terrible, and it doesn't support recent advances in plot outputs like [htmlwidgets](http://htmlwidgets.org) (unless you launch firefox through X11, which will mean you might get to look at one plot per hour).  #3 is okay if it is available and you are comfortable working in one of these desktop environments.

There could be other obvious ways to deal with this that I am oblivious to.

### A problem

Often we do not have the choice of installing RStudio Server or a desktop environment on the remote machine.  Also, some users prefer to work in a terminal sending commands from a favorite text editor on a local machine, but still want to see graphics.  We would like to have something better than X11 forwarding to view graphics and other output when running R in a terminal on a remote machine.

### A solution

The rmote package is an attempt to make working in R over ssh on a server a bit more pleasant in terms of viewing output.  It uses [servr](https://github.com/yihui/servr) on the remote machine to serve R graphics as they are created.  These can be viewed on the local machine in a web browser. Using [live.js](http://livejs.com) in the web browser on the local machine, the user's browser will automatically refresh each time a new output is available.

Currently there is support for lattice, ggplot2, htmlwidgets, and help output.

### Setup

1. Choose a port to run your remote server on (default is 4321)
2. ssh into the remote machine, mapping the port on the remote back to your local machine:

    ```
    ssh -L 4321:localhost:4321 -L 8100:localhost:8100 user@remote
    ```

    I also add port 8100 so I can forward shiny apps back to my local machine on a dedicated port.

3. On the remote machine launch R and install rmote (one time only)

    ```
    devtools::install_github("hafen/rmote")`
    ```

4. Run the following in R on the remote:

    ```r
    rmote::rmote_server_init()
    ```

    To view some of the options for this, see `?rmote_server_init`.  One option is the port, which needs to match the one your forwarded in step 2 (4321 is the default.)

5. On your local machine, open up your web browser to `localhost:4321`

    Now as you create compatible plots on your remote machine, your browser on your local machine will automatically update to show the results.  For example, try runningn each of the following in succession:

    ```r
    ?plot
    qplot(mpg, wt, data=mtcars, colour=cyl)
    dotplot(variety ~ yield | year * site, data=barley)
    library(rbokeh)
    figure() %>% ly_hexbin(rnorm(10000), rnorm(10000))
    ```

This process is slightly more tedious than `ssh -X` for initial setup, but much faster and more functional.

### Other useful utilities

If you must work on a remote terminal, here are some additional utilities that help make things nice:

- [colorout](https://github.com/jalvesaq/colorout)
- [Sublime](https://www.sublimetext.com) + [SFTP](http://wbond.net/sublime_packages/sftp)
- [Vim](http://www.vim.org) + [Vim-R-plugin](https://github.com/vim-scripts/Vim-R-plugin)

### Disclaimer

*This is a preliminary package and is extremely experimental, just meant to be a quick utility for some work I'm doing.  If there is any interest, ideas and PRs are welcome.  Use at your own risk.*


