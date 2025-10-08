<!-- LTeX: enabled=false -->
# zsh-magic-dashboard
Pressing `enter` on an empty buffer displays an information-rich and pretty
dashboard.

![Showcase](https://github.com/user-attachments/assets/4ad050cc-4fce-4199-a80b-afbbefbba88d)
<!-- LTeX: enabled=true -->

- **Top:** Recent commits (`git log`)
- **Center:** Current Status (hybrid of `git status` and `git diff --stat`)
- **Bottom:** Files in the current directory (via `eza`)

Empty components, such as `git status` in a clean repo, are automatically
hidden.

## Table of contents

<!-- toc -->

- [Installation](#installation)
	* [Requirements](#requirements)
	* [Manual](#manual)
	* [oh-my-zsh](#oh-my-zsh)
- [Configuration](#configuration)
- [Usage](#usage)
- [Display dashboard on `cd`](#display-dashboard-on-cd)
- [Credits](#credits)

<!-- tocstop -->

## Installation

### Requirements
- [eza](https://github.com/eza-community/eza)
- [Nerdfont](https://www.nerdfonts.com/)

### Manual
Clone the repository somewhere on your machine. This manual assumes
you are using `~/.zsh/`.

```bash
cd ~/.zsh/ # where to install the plugin
git clone https://github.com/chrisgrieser/zsh-magic-dashboard
```

Add the following to your `~/.zshrc`:

```bash
source ~/.zsh/zsh-magic-dashboard/magic_dashboard.zsh
```

<!-- LTeX: enabled=false -->
### oh-my-zsh
<!-- LTeX: enabled=true -->
Clone this repository into `$ZSH_CUSTOM/plugins` (by default
`~/.oh-my-zsh/custom/plugins`)

```bash
git clone https://github.com/chrisgrieser/zsh-magic-dashboard ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-magic-dashboard
```

Add the plugin to the list of plugins for `oh-my-zsh` to load (inside `~/.zshrc`):

```bash
plugins=( 
    # other plugins...
    zsh-magic-dashboard
)
```

Start a new terminal session.

```bash
source ~/.zshrc
```

## Configuration
Export these variables in your `~/.zshrc`. The values displayed are the defaults.

```bash
export MAGIC_DASHBOARD_GITLOG_LINES=5
export MAGIC_DASHBOARD_FILES_LINES=6
export MAGIC_DASHBOARD_FILES_LINES=4
export MAGIC_DASHBOARD_DISABLED_BELOW_TERM_HEIGHT=15
```

## Usage
Press `enter` on an empty buffer. That's it!

## Display dashboard on `cd`
The dashboard call also be called via `_magic_dashboard`. One use case would be
to modify your `cd` command to display the dashboard after the directory change.

```bash
function cd {
	builtin cd "$@" && _magic_dashboard
}
```

## Credits
This plugin is based on [Magic
Enter](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/magic-enter) by
[@dufferzafar](https://github.com/dufferzafar).

In my day job, I am a sociologist studying the social mechanisms underlying the
digital economy. For my PhD project, I investigate the governance of the app
economy and how software ecosystems manage the tension between innovation and
compatibility. If you are interested in this subject, feel free to get in touch.

- [Website](https://chris-grieser.de/)
- [ResearchGate](https://www.researchgate.net/profile/Christopher-Grieser)
- [Discord](https://discordapp.com/users/462774483044794368/)
- [LinkedIn](https://www.linkedin.com/in/christopher-grieser-ba693b17a/)

<a href='https://ko-fi.com/Y8Y86SQ91' target='_blank'> <img height='36'
style='border:0px;height:36px;' src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3'
border='0' alt='Buy Me a Coffee at ko-fi.com' /></a>
