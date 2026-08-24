# Claude Code configuration

Stow package for `~/.claude`. Unlike every other package in this repo, it targets
`$HOME` rather than `~/.config`, because Claude Code reads `~/.claude` directly.

## Apply

```bash
cd ~ && stow --dir ~/dotfiles --target ~ claude
```

Run it from outside `~/dotfiles`. The repo's `.stowrc` contains `--ignore=claude`
so that a plain `stow .` does not mistakenly link this package into `~/.config`,
and that ignore rule would also suppress the explicit command if it were run with
the repo as the working directory.

To remove the symlinks again:

```bash
cd ~ && stow --dir ~/dotfiles --target ~ -D claude
```

## What is tracked

| Path | Contents |
| --- | --- |
| `.claude/settings.json` | Model, theme, status line, enabled plugins, marketplaces |
| `.claude/statusline.sh` | Custom status line script |
| `.claude/agents/` | User-defined subagents |
| `.claude/skills/` | User-installed skills |
| `.claude/plugins/installed_plugins.json` | Which plugins are installed |
| `.claude/plugins/known_marketplaces.json` | Plugin marketplace sources |

Everything else in `~/.claude` is machine-local runtime state and stays untracked
(see the Claude Code section of the repo `.gitignore`):

- `plugins/marketplaces/` (439M) and `plugins/cache/` (23M) — clones and caches
  rebuilt automatically from the two tracked plugin manifests.
- `projects/`, `sessions/`, `session-env/`, `history.jsonl` — conversation
  transcripts and prompt history. Private, and worthless on another machine.
- `cache/`, `backups/`, `file-history/`, `paste-cache/`, `shell-snapshots/`,
  `downloads/` — scratch state.
- `ui-ux-pro-max-skill/` (31M) — an upstream git clone with its own `.git`; the
  installed skill itself already lives in `skills/ui-ux-pro-max/`.
- `~/.claude.json` — account and per-project state, kept out of the repo.

## Adding a new file

Copy it into `claude/.claude/`, delete the original from `~/.claude`, then re-run
the stow command above. Stow only links leaves whose parent directory already
exists in the target, so new subdirectories appear as symlinks to this repo.
