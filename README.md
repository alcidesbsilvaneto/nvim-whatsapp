# nvim-whatsapp

A whatsapp client for neovim that uses [podeorganizar](https://podeorganizar.com.br) API.

PodeOrganizar is a Brazilian startup that offers a service to organize your whatsapp chats in tickets (I am a co-founder and a developer in this startup).

It's basically a whatsapp web abstraction that allows you to manage your chats/contacts in a more organized way.

This is also my first neovim plugin, and my first Lua code, so some bugs are expected

## Installation

Use one of the most popular Neovim package managers to install this plugin. The most common ones are [Lazy](https://github.com/folke/lazy.nvim), [Packer](https://github.com/wbthomason/packer.nvim) and [Plug](https://github.com/junegunn/vim-plug).

#### Lazy

```lua
require('lazy').setup({
  { 'alcidesbsilvaneto/nvim-whatsapp' },
})
```

#### Packer

```lua
use('alcidesbsilvaneto/nvim-whatsapp')
```

#### Plug

```viml
Plug 'alcidesbsilvaneto/nvim-whatsapp'
```

## Setup

This plugins loads the PodeOrganizar api key from ~/.pode_token file. So create this file before using the plugin.

You can get the API key sending a POST http request with username and password to https://api.podeorganizar.com.br/auth/authenticate.

## Working Features

- Chats list
- Chat messages
- Send messages
- Socket listening for new messages

## Keymaps

| Keymap  | Description             |
| ------- | ----------------------- |
| `Enter` | Open chat               |
| `q`     | Close chat              |
| `<C-l>` | Focus conversation buff |
| `<C-k>` | Focus chats list buff   |
| `<C-j>` | Focus chat input        |

## TODO

- [ ] Setup nodejs dependencies on plugin setup
- [ ] Listen to tickets update and update tickets list
- [ ] Notifications
- [ ] Show unread messages count on tickets list
- [ ] Mark as read
- [ ] Search tickets using telescope
- [ ] Open URLs with default browser
