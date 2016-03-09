Version 0.3
----------------------------------------------------------------------

- Add history sidebar to viewer and option to use it or not (0.3.4)
- Add history thumbnail functions for all output modes (0.3.4)
- Clean up html and css (0.3.4)
- Add `hostname` option that will show hostname in page title (0.3.3)
- Add preliminary tests (0.3.3)
- Ensure raster graphics don't render if someone/thing has explicitly opened their own device (0.3.3)
- Fix iframe refresh issue (thanks @yihui) (0.3.2)
- Add base R graphics support (0.3.1)
- Add `rmote_on()` and `rmote_off()`
- Add main index page with history

Version 0.2
----------------------------------------------------------------------

- Add `capabilities()` checking for png
- When the rmote server isn't running, restore default behavior of print methods
- Add `rmote_device()` function to allow control over plot dimensions, etc.
- Add `daemon = FALSE` option for potentially running a single dedicated rmote server for multiple R sessions on a remote server
- Add `rmote_mode()` to toggle rmote on / off (useful for `daemon = FALSE` option)
- Change start and stop to `rmote_start()` and `rmote_stop()`
- Make graphics look good on retina displays by default
- Use servr's new `httw()` function for live reloading
- Remove packages from depends and import
- Avoid use of `:::`
