# ranch-talk

I was asked to give a 5-15 minute talk on [Ranch][ranch], a TCP socket acceptor
pool, to show how OTP constructs are used in the real world and expose some of
[Phoenix's][phoenix] underpinnings. This [Livebook][livebook] contains my code
and notes for that talk.

Thanks to [Divvy][divvy] for inviting me to give this talk.

# Usage

Install and run a local Livebook in `attached` mode and automatically grab my
code:

```bash
mix escript.install github livebook-dev/livebook
git clone https://git.lyte.dev/lytedev/ranch-talk.git
mix do deps.get, compile
env LIVEBOOK_PORT=5588 LIVEBOOK_IFRAME_PORT=5589 \
  livebook server --name ranch_is_neat@localhost --cookie yes-please \
  --default-runtime attached:ranch_is_neat@localhost:yes-please \
  "$(pwd)/ranch-talk.livemd"
```

Enjoy!

[ranch]: https://github.com/ninenines/ranch
[phoenix]: https://www.phoenixframework.org/
[livebook]: https://github.com/livebook-dev/livebook
[divvy]: https://getdivvy.com/
