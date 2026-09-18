# Pi setup

This stow package adapts [davis7dotsh/my-pi-setup](https://github.com/davis7dotsh/my-pi-setup)
at commit `5a0863f442402aa35cb0830805d67639957c7172` for this dotfiles repo.
It keeps the runtime extensions, two Pi skills, and GitHub Dark theme. Upstream
assets, tests, and extra Markdown guides are omitted. The standalone upstream
LICENSE file is omitted; its required MIT notice is retained below.

The package is named `pi` and maps `pi/.pi/agent/*` to `~/.pi/agent/*`. It does
not track or replace `auth.json`, sessions, models, trust decisions, or API keys.
The included GitHub Dark theme matches the Ghostty theme in this repo and uses
cool blue accents beside the Catppuccin tmux status bar.

## Install

Pi itself must be installed separately. Install these extension dependencies in
the repo; `node_modules` is ignored by Git and linked by Stow so Pi can
resolve extension imports through `~/.pi/agent`:

```bash
cd ~/dotfiles/pi/.pi/agent
npm ci --ignore-scripts
npm run check
```

If `~/.pi/agent/settings.json` is an ordinary file, back it up before stowing.
Merge any personal settings into the tracked `pi/.pi/agent/settings.json` first.
Do not use `stow --adopt`: it would overwrite the tracked copy with the old file.
From outside the dotfiles repo, run:

```bash
cd ~
stow --dir ~/dotfiles --target ~ pi
```

Pi discovers the linked `extensions/*/index.ts`, `skills/*/SKILL.md`, and
`themes/*.json` automatically. Restart Pi to load them. The `fd` and `rg`
extension uses installed binaries when available. Its fallback downloads
official releases only if neither an installed nor bundled binary is present.

The tracked `settings.json` excludes selected shared `~/.agents/skills`
capabilities from Pi only. The skill directories are not deleted and remain
available to other agents.

## Firecrawl

The search, scrape, and crawl tools need your own Firecrawl API key. Add
`FIRECRAWL_API_KEY` to your shell environment, or put it in
`~/.pi/agent/.env` using the tracked `.env.example` as a template. Keep the
real `.env` private; it is ignored by Git and is not stowed.

## Upstream license notice

MIT License

Copyright (c) 2026 Benjamin Davis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
