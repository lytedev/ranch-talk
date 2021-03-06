# ranch-talk

[🖥️ Upstream][upstream] • [🐙 GitHub Mirror][github]

I was asked to give a 5-15 minute talk on [Ranch][ranch], a TCP socket acceptor
pool writter in Erlang, to show how OTP constructs are used in the real world
and expose some of [Elixir's Phoenix's][phoenix] underpinnings. This
[Livebook][livebook] contains my code and notes for that talk.

Thanks to [Divvy][divvy] for inviting me to give this talk.

# Usage

Install and run a local Livebook in `attached` mode and automatically grab my
code:

```bash
asdf install
mix escript.install github livebook-dev/livebook
git clone https://git.lyte.dev/lytedev/ranch-talk.git
cd ranch-talk
mix do deps.get, compile
env LIVEBOOK_PORT=5588 LIVEBOOK_IFRAME_PORT=5589 \
  livebook server --default-runtime mix \
  "$(pwd)/ranch-talk.livemd"
```

Enjoy!

[ranch]: https://github.com/ninenines/ranch
[phoenix]: https://www.phoenixframework.org/
[livebook]: https://github.com/livebook-dev/livebook
[divvy]: https://getdivvy.com/
[upstream]: https://git.lyte.dev/lytedev/ranch-talk
[github]: https://github.com/lytedev/ranch-talk
