## Neovim Motions, Operators, and Commands Cheatsheet

This guide covers Neovim's powerful movement commands (motions), text manipulation commands (operators), and other related functionalities.

**Understanding the Basics:**

*   **Modes:**
    *   `N`: **Normal Mode** (Default mode for commands and navigation)
    *   `V`: **Visual Mode** (For selecting text character-wise)
    *   `V-Line`: **Visual Line Mode** (For selecting whole lines)
    *   `V-Block`: **Visual Block Mode** (For selecting rectangular blocks)
    *   `O`: **Operator-Pending Mode** (After an operator like `d`, `c`, `y`, waiting for a motion)
    *   `I`: **Insert Mode** (For typing text)
    *   `R`: **Replace Mode** (For overwriting text)
*   **`[count]`:** Many commands can be prefixed with a number (e.g., `3j`) to repeat them `[count]` times.
*   **Operators + Motions:** A core Vim concept! Operators (`d`elete, `c`hange, `y`ank, etc.) are combined with motions (like `w`, `j`, `/pattern`) or text objects (like `iw`, `ap`) to act on specific regions of text. Example: `dw` deletes a word, `ci"` changes text inside double quotes.
*   **(Custom):** Items marked this way are user-defined mappings, not built-in Neovim defaults. Their behavior depends on your specific configuration.
*   **Word vs. WORD:** A `word` consists of letters, digits, and underscores, or a sequence of other non-blank characters. A `WORD` is a sequence of non-blank characters separated by whitespace.

---

### **1. Basic Cursor Movement**

Move the cursor character by character or line by line.

| Key(s)           | Mode(s) | Description                                                              | Notes                                                       |
| :--------------- | :------ | :----------------------------------------------------------------------- | :---------------------------------------------------------- |
| `h` / `<Left>`   | N, V, O | Move cursor **left** one character.                                      | `[count]h`                                                  |
| `j` / `<Down>`   | N, V, O | Move cursor **down** one line.                                           | `[count]j`                                                  |
| `k` / `<Up>`     | N, V, O | Move cursor **up** one line.                                             | `[count]k`                                                  |
| `l` / `<Space>`  | N, V, O | Move cursor **right** one character.                                     | `[count]l`                                                  |
| `gj`             | N, V    | Move **down** one **display line** (ignores line wraps).                 | `[count]gj`. Useful with long, wrapped lines.             |
| `gk`             | N, V    | Move **up** one **display line** (ignores line wraps).                   | `[count]gk`. Useful with long, wrapped lines.             |
| `0` (zero)       | N, V, O | Go to the **first character** of the current line.                       |                                                             |
| `^`              | N, V, O | Go to the **first non-blank character** of the current line.             |                                                             |
| `$` / `<End>`    | N, V, O | Go to the **end** of the current line.                                   | `[count]$` goes to end of `[count]-1` lines down.         |
| `g^`             | N, V, O | Go to the **first non-blank character** of the **display line**.         | Useful with wrapping.                                       |
| `g$` / `g<End>`  | N, V, O | Go to the **end** of the **display line**.                               | `[count]g$` goes to end of `[count]-1` display lines down. |
| `gm`             | N, V, O | Go to the **middle** character of the screen line.                       |                                                             |
| `\|` (pipe)      | N, V, O | Go to column `[count]` (default: 1) on the current line.                 |                                                             |

---

### **2. Word Movement**

Navigate by words or WORDs.

| Key(s) | Mode(s) | Description                                                      | Notes                                           |
| :----- | :------ | :--------------------------------------------------------------- | :---------------------------------------------- |
| `w`    | N, V, O | Go forward to the beginning of the next **word**.                | `[count]w`                                      |
| `W`    | N, V, O | Go forward to the beginning of the next **WORD**.                | `[count]W`                                      |
| `e`    | N, V, O | Go forward to the **end** of the current/next **word**.          | `[count]e`                                      |
| `E`    | N, V, O | Go forward to the **end** of the current/next **WORD**.          | `[count]E`                                      |
| `b`    | N, V, O | Go back to the beginning of the previous **word**.               | `[count]b`                                      |
| `B`    | N, V, O | Go back to the beginning of the previous **WORD**.               | `[count]B`                                      |
| `ge`   | N, V, O | Go backward to the **end** of the previous **word**.             | `[count]ge`                                     |
| `gE`   | N, V, O | Go backward to the **end** of the previous **WORD**.             | `[count]gE`                                     |

---

### **3. Text Object Selection (used with Operators or in Visual Mode)**

Select semantic units of text like words, sentences, paragraphs, or blocks enclosed by delimiters.

| Key(s)         | Mode(s) | Description                                                                           | Notes                      |
| :------------- | :------ | :------------------------------------------------------------------------------------ | :------------------------- |
| `iw`           | V, O    | **Inner word**: Selects word under cursor (no surrounding spaces).                      | `[count]iw`                |
| `aw`           | V, O    | **A word**: Selects word under cursor and a trailing/leading space.                   | `[count]aw`                |
| `iW`           | V, O    | **Inner WORD**: Selects WORD under cursor (no surrounding spaces).                      | `[count]iW`                |
| `aW`           | V, O    | **A WORD**: Selects WORD under cursor and a trailing/leading space.                   | `[count]aW`                |
| `is`           | V, O    | **Inner sentence**.                                                                   | `[count]is`                |
| `as`           | V, O    | **A sentence** (includes trailing whitespace).                                        | `[count]as`                |
| `ip`           | V, O    | **Inner paragraph**.                                                                  | `[count]ip`                |
| `ap`           | V, O    | **A paragraph** (includes trailing blank line).                                       | `[count]ap`                |
| `i[` or `i]`   | V, O    | **Inner block `[]`**: Content inside `[...]`.                                         | `[count]i[`                |
| `a[` or `a]`   | V, O    | **A block `[]`**: Content inside `[...]` including the brackets.                      | `[count]a[`                |
| `i(` or `ib`   | V, O    | **Inner block `()`**: Content inside `(...)`. (`b` for block).                         | `[count]ib`                |
| `a(` or `ab`   | V, O    | **A block `()`**: Content inside `(...)` including the parentheses.                    | `[count]ab`                |
| `i{` or `iB`   | V, O    | **Inner block `{}`**: Content inside `{...}`. (`B` for Block).                         | `[count]iB`                |
| `a{` or `aB`   | V, O    | **A block `{}`**: Content inside `{...}` including the braces.                        | `[count]aB`                |
| `i<` or `i>`   | V, O    | **Inner block `<>`**: Content inside `<...>`.                                         | `[count]i<`                |
| `a<` or `a>`   | V, O    | **A block `<>`**: Content inside `<...>` including the angle brackets.                | `[count]a<`                |
| `it`           | V, O    | **Inner tag block** (HTML/XML).                                                       | `[count]it`                |
| `at`           | V, O    | **A tag block** (HTML/XML, includes tags).                                            | `[count]at`                |
| `i'`           | V, O    | **Inner single quotes**: Content inside `'...'`.                                      | `[count]i'`                |
| `a'`           | V, O    | **A single quotes**: Content inside `'...'` including the quotes.                     | `[count]a'`                |
| `i"`           | V, O    | **Inner double quotes**: Content inside `"..."`.                                      | `[count]i"`                |
| `a"`           | V, O    | **A double quotes**: Content inside `"..."` including the quotes.         | `[count]a"`                |
| `` i` ``       | V, O    | **Inner backticks**: Content inside `` `...` ``.                                      | `[count]i``                |
| `` a` ``       | V, O    | **A backticks**: Content inside `` `...` `` including the backticks.                   | `[count]a``                |

---

### **4. Line & File Navigation**

Move between lines or to specific locations within the file or screen.

| Key(s)          | Mode(s) | Description                                                                    | Notes                                                           |
| :-------------- | :------ | :----------------------------------------------------------------------------- | :-------------------------------------------------------------- |
| `gg`            | N, V, O | Go to the **first line** of the file.                                          | `[count]gg` goes to line `[count]`.                           |
| `G` / `<C-End>` | N, V, O | Go to the **last line** of the file.                                           | `[count]G` goes to line `[count]`.                            |
| `H`             | N, V, O | Go to the **top** (High) line visible on the screen.                           | `[count]H` goes to `[count]` lines from the top.              |
| `M`             | N, V, O | Go to the **middle** line visible on the screen.                               |                                                                 |
| `L`             | N, V, O | Go to the **bottom** (Low) line visible on the screen.                         | `[count]L` goes to `[count]` lines from the bottom.           |
| `-` (minus)     | N, V, O | Go to the **first non-blank character** of the `[count]` previous line(s).     | `[count]-`                                                    |
| `+` / `<CR>`    | N, V, O | Go to the **first non-blank character** of the `[count]` next line(s).         | `[count]+`                                                    |
| `_`             | N, V, O | Go to the **first non-blank character** of the `[count]-1` lines below current. | `[count]_` (e.g., `1_` is current line, `2_` is next line)    |

---

### **5. Character Find (within current line)**

Jump precisely to characters on the current line.

| Key(s)    | Mode(s) | Description                                                                     | Notes                                      |
| :-------- | :------ | :------------------------------------------------------------------------------ | :----------------------------------------- |
| `f{char}` | N, V, O | Go forward **to** the `[count]`th occurrence of `{char}`.                       | Cursor lands *on* the character.         |
| `F{char}` | N, V, O | Go backward **to** the `[count]`th occurrence of `{char}`.                      | Cursor lands *on* the character.         |
| `t{char}` | N, V, O | Go forward **until** just before the `[count]`th occurrence of `{char}`.        | Cursor lands *before* the character.     |
| `T{char}` | N, V, O | Go backward **until** just after the `[count]`th occurrence of `{char}`.        | Cursor lands *after* the character.      |
| `;`       | N, V, O | Repeat the last `f`, `F`, `t`, or `T` command `[count]` times.                  |                                            |
| `,`       | N, V, O | Repeat the last `f`, `F`, `t`, or `T` command `[count]` times in reverse direction. |                                            |

---

### **6. Search**

Find patterns within the file.

| Key(s)           | Mode(s) | Description                                                              | Notes                                                                   |
| :--------------- | :------ | :----------------------------------------------------------------------- | :---------------------------------------------------------------------- |
| `/{pattern}<CR>` | N, V, O | Search **forward** for `{pattern}`.                                      | `[count]` finds `[count]`th match. Motion goes to beginning of match. |
| `?{pattern}<CR>` | N, V, O | Search **backward** for `{pattern}`.                                     | `[count]` finds `[count]`th match. Motion goes to beginning of match. |
| `n`              | N, V, O | Repeat the last search (`/` or `?`) in the **same** direction.           | `[count]n` finds `[count]`th next match.                              |
| `N`              | N, V, O | Repeat the last search (`/` or `?`) in the **opposite** direction.       | `[count]N` finds `[count]`th previous match.                          |
| `*`              | N, V, O | Search forward for the **word** under cursor (whole word match).         | `[count]*` finds `[count]`th match.                                   |
| `#`              | N, V, O | Search backward for the **word** under cursor (whole word match).        | `[count]#` finds `[count]`th match.                                   |
| `g*`             | N, V, O | Search forward for the **word** under cursor (partial match allowed).    | `[count]g*` finds `[count]`th match.                                  |
| `g#`             | N, V, O | Search backward for the **word** under cursor (partial match allowed).   | `[count]g#` finds `[count]`th match.                                  |
| `<Esc>`          | N       | **(Custom)** Clear search highlights.                                    | Typically runs `<cmd>nohlsearch<CR>`.                                   |

---

### **7. Marks & Jumps**

Set markers and navigate through jump history, change history, or specific locations.

| Key(s)            | Mode(s) | Description                                                                   | Notes                                                                                               |
| :---------------- | :------ | :---------------------------------------------------------------------------- | :-------------------------------------------------------------------------------------------------- |
| `m{a-zA-Z}`       | N       | **Set mark** `{a-zA-Z}` at cursor position.                                   | Lowercase local to buffer, uppercase global (file marks). *Not a motion.*                         |
| `` `{mark}` ``     | N, V, O | Go to the **exact position** (line & column) of `{mark}`.                     | `{mark}` can be `a-z`, `A-Z`, `0-9` (viminfo), `'`, ```, `[`, `]`, `<`, `>`.                      |
| `' {mark}`        | N, V, O | Go to the **first non-blank char** on the line of `{mark}`.                   | `{mark}` same as above.                                                                             |
| `` ` `` ``         | N, V, O | Go back to the **exact position** before the latest jump.                     | Use repeatedly to go further back. Swaps position with `''`.                                        |
| `''`              | N, V, O | Go to the **first non-blank char** on the line before the latest jump.        | Use repeatedly to go further back. Swaps position with `` ` `` ``.                                        |
| `` `[ `` or `'[`   | N, V, O | Go to the **start** of the previously changed or yanked text.                 |                                                                                                     |
| `` `] `` or `']`   | N, V, O | Go to the **end** of the previously changed or yanked text.                   |                                                                                                     |
| `` `< `` or `'<`   | N, V, O | Go to the **start** of the last visual selection.                             |                                                                                                     |
| `` `> `` or `'>`   | N, V, O | Go to the **end** of the last visual selection.                               |                                                                                                     |
| `` `. `` or `'.`   | N, V, O | Go to the position where the **last change** was made.                          |                                                                                                     |
| `Ctrl+O`          | N       | Go to **older** cursor position in the **jump list**.                         | `[count]<C-O>`. Jumps are "non-trivial" movements like `G`, `/`, `gg`.                              |
| `Ctrl+I` / `<Tab>`| N       | Go to **newer** cursor position in the **jump list**.                         | `[count]<C-I>`. `<Tab>` might be overridden.                                                        |
| `g;`              | N, V, O | Go to `[count]` **older** position in the **change list**.                    | Navigate where changes occurred.                                                                    |
| `g,`              | N, V, O | Go to `[count]` **newer** position in the **change list**.                    | Navigate where changes occurred.                                                                    |
| `:jumps`          | N       | **List** the jump list.                                                       | Command-line command.                                                                               |
| `:marks`          | N       | **List** all marks.                                                           | Command-line command.                                                                               |
| `:changes`        | N       | **List** the change list.                                                     | Command-line command.                                                                               |

---

### **8. Section & Code Navigation**

Move between paragraphs, sections, or code blocks.

| Key(s)    | Mode(s) | Description                                                                | Notes                                                          |
| :-------- | :------ | :------------------------------------------------------------------------- | :------------------------------------------------------------- |
| `(`       | N, V, O | Go back `[count]` sentences.                                               |                                                                |
| `)`       | N, V, O | Go forward `[count]` sentences.                                            |                                                                |
| `{`       | N, V, O | Go back `[count]` paragraphs (blank line separated).                       |                                                                |
| `}`       | N, V, O | Go forward `[count]` paragraphs (blank line separated).                    |                                                                |
| `[[`      | N, V, O | Go back `[count]` sections (often `{` in first column).                      | Language specific, useful for function start in C-like code. |
| `]]`      | N, V, O | Go forward `[count]` sections (often `}` in first column).                      | Useful for function end in C-like code.                      |
| `[]`      | N, V, O | Go back `[count]` sections ending with `}` in first column.                 |                                                                |
| `][`      | N, V, O | Go forward `[count]` sections ending with `}` in first column.               |                                                                |
| `[{`      | N, V, O | Go back `[count]` unclosed `{` (usually in first column).                   |                                                                |
| `]}`      | N, V, O | Go forward `[count]` unclosed `}` (usually in first column).                 |                                                                |
| `[( `     | N, V, O | Go back `[count]` unclosed `(`.                                           |                                                                |
| `])`      | N, V, O | Go forward `[count]` unclosed `)`.                                         |                                                                |
| `%`       | N, V, O | Go to matching bracket: `()`, `{}`, `[]`. If not on bracket, finds nearest. | `[count]%` goes to `[count]` percentage into the file.        |
| `gd`      | N       | Go to **local definition** of word under cursor (in current scope/func).   | Often enhanced by LSP (Language Server Protocol).              |
| `gD`      | N       | Go to **global definition** of word under cursor (in current file).        | Often enhanced by LSP.                                         |
| `gf`      | N       | Go to the **file name** under the cursor.                                  | `[count]gf` uses `&path`. `gF` goes to file:line_nr.           |
| `<leader>cr` | N    | **(Custom)** LSP Rename symbol under cursor.                               | Example mapping, requires LSP setup / plugins.                 |

---

### **9. Scrolling**

Move the viewport without (necessarily) moving the cursor relative to the text.

| Key(s)                 | Mode(s) | Description                                                                  | Notes                                                            |
| :--------------------- | :------ | :--------------------------------------------------------------------------- | :--------------------------------------------------------------- |
| `Ctrl+F` / `<PageDown>`| N       | Scroll window **down** one full screen.                                      | `[count]<C-F>`.                                                  |
| `Ctrl+B` / `<PageUp>`  | N       | Scroll window **up** one full screen.                                        | `[count]<C-B>`.                                                  |
| `Ctrl+D`               | N       | Scroll window **down** half a screen (default, see `&scroll`).               | `[count]<C-D>`. Cursor also moves down.                          |
| `Ctrl+U`               | N       | Scroll window **up** half a screen (default, see `&scroll`).                 | `[count]<C-U>`. Cursor also moves up.                            |
| `Ctrl+E`               | N       | Scroll window **down** `[count]` lines (default 1), keep cursor line stable. | Cursor stays unless it scrolls off screen.                     |
| `Ctrl+Y`               | N       | Scroll window **up** `[count]` lines (default 1), keep cursor line stable.   | Cursor stays unless it scrolls off screen.                     |
| `zt`                   | N       | Redraw screen, position current line at the **top**.                         | Mnemonic: "z top"                                                |
| `zz` or `z.`           | N       | Redraw screen, position current line in the **center**.                      | Mnemonic: "z zenith" / "z center"                            |
| `zb`                   | N       | Redraw screen, position current line at the **bottom**.                      | Mnemonic: "z bottom"                                             |
| `z<CR>`                | N       | Redraw screen, line at **top**, cursor at first non-blank.                   |                                                                  |
| `z-`                   | N       | Redraw screen, line at **bottom**, cursor at first non-blank.                |                                                                  |

---

### **10. Operators (require a Motion or Text Object)**

Perform actions like deleting, changing, or yanking text. Combine with motions/text objects.

| Key(s)        | Mode(s) | Description                                                                    | Line-wise Shortcut | Notes                                                                                             |
| :------------ | :------ | :----------------------------------------------------------------------------- | :----------------- | :------------------------------------------------------------------------------------------------ |
| `d{motion}`   | N       | **Delete** text specified by `{motion}`.                                       | `dd`               |                                                                                                   |
| `c{motion}`   | N       | **Change** text specified by `{motion}` (deletes & enters Insert mode).        | `cc` or `S`        |                                                                                                   |
| `y{motion}`   | N       | **Yank** (copy) text specified by `{motion}`.                                  | `yy` or `Y`        | **(Custom)** `TextYankPost` event can highlight yanked text.                                        |
| `>{motion}`   | N       | **Indent Right** text specified by `{motion}`.                                 | `>>`               |                                                                                                   |
| `<{motion}`   | N       | **Indent Left** text specified by `{motion}`.                                  | `<<`               |                                                                                                   |
| `>`           | V       | **(Custom)** Indent selected lines right, keep selection.                      |                    | Runs `>gv`.                                                                                       |
| `<`           | V       | **(Custom)** Indent selected lines left, keep selection.                       |                    | Runs `<gv`.                                                                                       |
| `={motion}`   | N       | **Auto-indent** text specified by `{motion}`.                                  | `==`               | Uses filetype settings or LSP.                                                                    |
| `!{motion}`   | N       | **Filter** text via external command specified by `{motion}`.                  | `!!`               | Prompts for external command.                                                                     |
| `gq{motion}`  | N       | **Format** text by `{motion}` according to `&textwidth`.                       | `gqq`              | Cursor might move.                                                                                |
| `gw{motion}`  | N       | **Format** text like `gq`, but keep cursor position.                           | `gww`              |                                                                                                   |
| `gu{motion}`  | N       | Make text by `{motion}` **lowercase**.                                         | `guu`              |                                                                                                   |
| `gU{motion}`  | N       | Make text by `{motion}` **uppercase**.                                         | `gUU`              |                                                                                                   |
| `g~{motion}`  | N       | **Swap case** of text specified by `{motion}`.                                 | `g~~`              |                                                                                                   |
| `~`           | N       | **Swap case** of char under cursor & move right (if `tildeop` off).            |                    | If `&tildeop` is set, `~` acts as an operator like `g~`.                                          |
| `zf{motion}`  | N       | Create **fold** for text specified by `{motion}`.                              |                    | Requires `foldmethod=manual` or `marker`.                                                         |

---

### **11. Mode Changes & Simple Edits**

Switch between modes or perform simple character/line edits.

| Key(s)          | Mode(s) | Description                                                                   | Notes                                                                  |
| :-------------- | :------ | :---------------------------------------------------------------------------- | :--------------------------------------------------------------------- |
| `i`             | N       | **Insert** text **before** the cursor.                                        | Enters Insert mode.                                                    |
| `I` / `<Home>`  | N       | **Insert** text at the **beginning** of the first non-blank char on the line. | Enters Insert mode. `<Home>` behavior might vary.                     |
| `a`             | N       | **Append** text **after** the cursor.                                         | Enters Insert mode.                                                    |
| `A` / `<End>`   | N       | **Append** text at the **end** of the current line.                           | Enters Insert mode. `<End>` behavior might vary.                       |
| `o`             | N       | **Open** a new line **below** the current line and enter Insert mode.         |                                                                        |
| `O`             | N       | **Open** a new line **above** the current line and enter Insert mode.         |                                                                        |
| `s`             | N       | **Substitute** `[count]` characters under the cursor (delete & insert).       | Like `[count]cl`. Enters Insert mode.                                  |
| `S`             | N       | **Substitute** `[count]` lines (delete lines & insert).                       | Like `[count]cc`. Enters Insert mode.                                  |
| `r{char}`       | N       | **Replace** `[count]` characters under cursor with `{char}`.                  | Stays in Normal mode.                                                  |
| `R`             | N       | Enter **Replace mode** (overwrite characters).                                | Press `<Esc>` to exit Replace mode.                                    |
| `v`             | N       | Enter **Visual mode** (character-wise selection).                             | Use motions to select. `gv` reselects last visual area.                |
| `V`             | N       | Enter **Visual Line mode** (line-wise selection).                             | Selects whole lines.                                                   |
| `Ctrl+V`        | N, V    | Enter **Visual Block mode** (rectangular selection).                          | Toggles back to Normal from V-Block if already in V-Block.           |
| `o`             | V       | Move cursor to **other end** of visually selected text.                       | Useful for adjusting selection boundaries.                             |
| `O`             | V-Block | Move cursor to **other corner** of visually selected block.                   | Only in Visual Block mode.                                             |
| `x` / `<Delete>`| N       | **Delete** `[count]` characters under and after the cursor.                   | Like `dl`.                                                             |
| `X` / `<BS>`    | N       | **Delete** `[count]` characters before the cursor.                            | Like `dh`. `<BS>` behavior depends on `&backspace` option.             |
| `J`             | N       | **Join** `[count]` lines (default 2) with spaces.                             | Removes leading indentation of joined line.                            |
| `gJ`            | N       | **Join** `[count]` lines (default 2) without spaces.                          | Preserves leading indentation.                                         |

---

### **12. Window Management**

Split, navigate, resize, and close windows (viewports within a tab).

| Key(s)           | Mode(s) | Description                                            | Notes                                                          |
| :--------------- | :------ | :----------------------------------------------------- | :------------------------------------------------------------- |
| `Ctrl+W s` / `ss`| N       | **Split** window horizontally (**ss Custom**).         | `ss` typically maps to `:split<Return>`.                       |
| `Ctrl+W v` / `sv`| N       | **Split** window vertically (**sv Custom**).           | `sv` typically maps to `:vsplit<Return>`.                      |
| `Ctrl+W q`       | N       | **Quit** current window.                               | `:quit`                                                        |
| `Ctrl+W c`       | N       | **Close** current window.                              | `:close`                                                       |
| `Ctrl+W o`       | N       | Keep **only** current window (close others).           | `:only`                                                        |
| `Ctrl+W h/j/k/l` | N       | Move cursor to window **left/down/up/right**.          |                                                                |
| `Ctrl+W H/J/K/L` | N       | **Move** current window to far **left/bottom/top/right**. |                                                                |
| `Ctrl+W =`       | N       | Make all windows **equal size**.                       |                                                                |
| `Ctrl+W _`       | N       | Maximize current window **height**.                    |                                                                |
| `Ctrl+W \|`      | N       | Maximize current window **width**.                     |                                                                |
| `Ctrl+W + / -`   | N       | **Increase / Decrease** current window **height**.     | `[count]<C-W>+` increases by `[count]`.                      |
| `Ctrl+W > / <`   | N       | **Increase / Decrease** current window **width**.      | `[count]<C-W>>` increases by `[count]`.                      |

---

### **13. Tab Management**

Manage multiple workspaces (tabs).

| Key(s)                     | Mode(s) | Description                                                       | Notes                                                               |
| :------------------------- | :------ | :---------------------------------------------------------------- | :------------------------------------------------------------------ |
| `:tabnew`/`:tabedit`/`te`   | N       | **Open a new tab** page (**te Custom**).                          | `te` often maps to `:tabedit` (opens new tab or with filename).   |
| `gt` / `<Tab>`             | N       | Go to **next** tab page (**<Tab> Custom**).                       | `[count]gt` goes to tab `[count]`. `<Tab>` might map to `:tabnext`. |
| `gT` / `<S-Tab>`           | N       | Go to **previous** tab page (**<S-Tab> Custom**).                 | `[count]gT` goes `[count]` tabs back. `<S-Tab>` might map `:tabprev`. |
| `[N]gt`                    | N       | Go to tab page number **N**.                                      | `1gt` goes to the first tab.                                        |
| `:tabn [N]`                | N       | Go to **next** tab page (or tab `N`).                             | Command-line command.                                               |
| `:tabp [N]`                | N       | Go to **previous** tab page (or `N` tabs back).                   | Command-line command.                                               |
| `:tabc`/`<leader><tab>d`   | N       | **Close** current tab page (**`<leader><tab>d` Custom**).          | `<leader><tab>d` might map to `:tabclose`.                          |
| `:tabo`                    | N       | Close all **other** tab pages.                                    | `:tabonly`                                                          |
| `:tabs`                    | N       | **List** all tab pages.                                           | Command-line command.                                               |

---

### **14. Buffer Management**

Manage loaded files (buffers).

| Key(s)                 | Mode(s) | Description                                                              | Notes                                                                    |
| :--------------------- | :------ | :----------------------------------------------------------------------- | :----------------------------------------------------------------------- |
| `:ls`                  | N       | **List** all buffers.                                                    | Command-line command. Shows buffer numbers, status, names.               |
| `:b [N/name]`          | N       | Go to buffer `[N]` (number) or partial `[name]`.                         | Command-line command. `:buffer N`.                                       |
| `:bn`/`<S-l>`/`]b`      | N       | Go to **next** buffer (**`<S-l>`, `]b` Custom**).                        | Custom maps often run `:bnext<cr>`.                                      |
| `:bp`/`<S-h>`/`[b`      | N       | Go to **previous** buffer (**`<S-h>`, `[b` Custom**).                    | Custom maps often run `:bprevious<cr>`.                                  |
| `:bf`                  | N       | Go to **first** buffer in the list.                                      | Command-line command. `:bfirst`.                                         |
| `:bl`                  | N       | Go to **last** buffer in the list.                                       | Command-line command. `:blast`.                                          |
| `:bd [N/name]`         | N       | **Delete** buffer `[N]` or `[name]` (unload or wipeout).                 | Command-line command. `:bdelete`. Use `!` to force if modified.         |
| `<leader>bd`           | N       | **(Custom)** Delete current buffer (advanced).                           | Often uses a plugin (`bufdelete.nvim`, etc.) to close without messing up layout. |
| `<leader>bo`           | N       | **(Custom)** Delete all **other** buffers.                               | Often uses a plugin.                                                     |
| `<leader>bD`           | N       | **(Custom)** Delete current buffer (basic).                              | Often maps to `:bd<CR>`. Closes window only if it's the last buffer in it. |

---

### **15. Other Useful Commands**

Miscellaneous commands for repeating, undoing, pasting, macros, etc.

| Key(s)        | Mode(s) | Description                                                                       | Notes                                                                                    |
| :------------ | :------ | :-------------------------------------------------------------------------------- | :--------------------------------------------------------------------------------------- |
| `.` (dot)     | N       | **Repeat** the last change `[count]` times.                                       | Change = insert, delete, change, replace, command-line. Very powerful.                   |
| `u`           | N       | **Undo** `[count]` changes.                                                       |                                                                                          |
| `U`           | N       | **Undo** all latest changes on the line last modified.                            |                                                                                          |
| `Ctrl+R`      | N       | **Redo** `[count]` undone changes.                                                |                                                                                          |
| `p`           | N       | **Put** (paste) text from register **after** cursor/line.                         | `[count]p`. Default register is `"`. Pastes linewise below if register was linewise.   |
| `P`           | N       | **Put** (paste) text from register **before** cursor/line.                        | `[count]P`. Pastes linewise above if register was linewise.                            |
| `gp`          | N       | **Put** text like `p`, but leave cursor **after** pasted text.                    | `[count]gp`.                                                                             |
| `gP`          | N       | **Put** text like `P`, but leave cursor **after** pasted text.                    | `[count]gP`.                                                                             |
| `K`           | N       | Lookup **keyword** under cursor using `&keywordprg` (e.g., `man`, LSP hover).     |                                                                                          |
| `q{a-z}`      | N       | **Record** typed characters into register `{a-z}`. Press `q` again to stop.       | Appends if uppercase register `q{A-Z}` is used.                                          |
| `@ {a-z}`     | N       | Execute contents of register `{a-z}` (**macro**).                                 | `@@` repeats last macro. `[count]@{a-z}` executes `[count]` times.                     |
| `Ctrl+A`      | N       | **Increment** first number on/after cursor by `[count]` (default 1).              | Handles decimal, hex (`0x`), octal (`0`).                                                |
| `Ctrl+X`      | N       | **Decrement** first number on/after cursor by `[count]` (default 1).              | Handles decimal, hex (`0x`), octal (`0`).                                                |
| `Ctrl+G`      | N       | Show file name, status, and cursor position.                                      | `g<C-G>` shows more detail (byte/col/word/char count).                                   |
| `Ctrl+L`      | N       | Clear and **redraw** the screen.                                                  |                                                                                          |
| `Ctrl+Z`      | N       | **Suspend** Neovim (use `fg` in shell to resume).                                 | May not work in all environments.                                                        |
| `ZQ`          | N       | **Quit** Neovim without saving (like `:q!`).                                      |                                                                                          |
| `ZZ`          | N       | **Save** current file (if modified) and **quit** (like `:wq`).                    |                                                                                          |
| `<leader>n`   | N       | **(Custom)** Show Notifications History.                                          | Example mapping, requires notification plugin (`nvim-notify`, etc).                      |