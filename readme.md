# Event Caching Override Module

This module allows you to set an override for event caching to allow dynamic cache values, like in this module, midnight.

## Example

```
// Cache this event, defaulting to 1440 mins, or 1 day, but we want to have it actually timeout at midnight
function index( event, rc, prc ) cache="true" cacheTimeout="1440" cacheOverrideTimeout="midnight" {
    // stuff goes here
}
```
