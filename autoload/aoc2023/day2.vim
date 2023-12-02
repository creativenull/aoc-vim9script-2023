vim9script

import './utils.vim'

const samples = [
  'Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green',
  'Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue',
  'Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red',
  'Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red',
  'Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green',
]

type GameSet = dict<any>

def ParseCubeFromRawSet(raw_set: string): GameSet
  var decoded_set: GameSet = {}
  const game_sets = raw_set->split(',')

  for gset in game_sets
    # string starts w/ number so easy to decode via str2nr
    const gset_trimmed = gset->trim()->split(' ')
    const count = gset_trimmed[0]->str2nr(10)

    # use the first char to get the color
    const color_char = gset_trimmed[1]
    if color_char == 'red'
      decoded_set['red'] = count
    elseif color_char == 'green'
      decoded_set['green'] = count
    elseif color_char == 'blue'
      decoded_set['blue'] = count
    endif
  endfor

  return decoded_set
enddef

def Parse(lines: list<string>): list<any>
  var decoded: list<dict<any>> = []

  for line in lines
    const game_sets = line->split(':')
    const game = game_sets[0][5 :]
    const sets = game_sets[1]->trim()->split(';')

    var parsed_sets = []
    for raw_set in sets
      parsed_sets->add(ParseCubeFromRawSet(raw_set->trim()))
    endfor

    decoded->add({ id: game->str2nr(10), sets: parsed_sets })
  endfor

  return decoded
enddef

export def PartOne()
  var input = utils.GetInputFromTxt('day2')
  const parsed = Parse(input)
  var ids: list<number> = []

  for game in parsed
    const max_red = game.sets->copy()->mapnew((idx, item) => item->get('red', 0))->max()
    const max_green = game.sets->copy()->mapnew((idx, item) => item->get('green', 0))->max()
    const max_blue = game.sets->copy()->mapnew((idx, item) => item->get('blue', 0))->max()

    if max_red > 12 || max_green > 13 || max_blue > 14
      continue
    endif

    ids->add(game.id)
  endfor

  echom ids->reduce((acc, total) => acc + total, 0)
enddef

export def PartTwo()
  var input = utils.GetInputFromTxt('day2')
  const parsed = Parse(input)
  var powers = []

  for game in parsed
    const max_red = game.sets->copy()->mapnew((idx, item) => item->get('red', 0))->max()
    const max_green = game.sets->copy()->mapnew((idx, item) => item->get('green', 0))->max()
    const max_blue = game.sets->copy()->mapnew((idx, item) => item->get('blue', 0))->max()
    powers->add(max_red * max_green * max_blue)
  endfor

  echom powers->reduce((acc, total) => acc + total, 0)
enddef
