if has("gui_macvim")
  set anti enc=utf-8
  "" nice font
  set guifont=Source\ Code\ Pro:h15

  "" Remap Command-t to CtrlP
  if exists(':CtrlP')
    macmenu &File.New\ Tab key=<nop>
    map <D-t> :CtrlP<CR>
  endif

  "" Remap Command-F to Ack
  if exists(':Ack')
    nmap <D-F> :Ack<space>
  endif

  "" Disable  bells
  set vb
endif
