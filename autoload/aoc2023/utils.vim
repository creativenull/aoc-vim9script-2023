vim9script

export def GetPluginDir(): string
  var rtp = &runtimepath->split(',')->filter((_, path) => path->match('aoc') != -1)
  if rtp->len() > 0
    return rtp[0]
  endif

  return ''
enddef
