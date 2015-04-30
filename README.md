# knife-remote

knife-remote is a knife plugin that exposes a basic set of ipmi commands and provides remote access via ipmi or ssh (where available) to servers in a self hosted datacenter/servers hosted on Internap. 

## List of available commands

```bash
knife remote configure PROVIDER
knife remote console activate (--internap) NODE
knife remote power off (--internap) NODE
knife remote power on (--internap) NODE
knife remote power reset (--internap) NODE
knife remote power status (--internap) NODE
```
