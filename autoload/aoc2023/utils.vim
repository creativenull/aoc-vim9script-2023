vim9script

export def GetPluginDir(): string
  var rtp = &runtimepath->split(',')->filter((_, path) => path->match('aoc') != -1)
  if rtp->len() > 0
    return rtp[0]
  endif

  return ''
enddef

export def GetInputFromTxt(day: string): list<string>
  const plugindir = GetPluginDir()

  return readfile($'{plugindir}/autoload/aoc2023/{day}.txt', '')
enddef
