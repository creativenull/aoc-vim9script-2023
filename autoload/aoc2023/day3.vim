vim9script

import './utils.vim'

const samples: list<string> = [
  '467..114..',
  '...*......',
  '..35..633.',
  '......#...',
  '617*......',
  '.....+.58.',
  '..592.....',
  '......755.',
  '...$.*....',
  '.664.598..',
]

def GetSymbolPos(str: string): number
  return str->match('[^.a-zA-z0-9]')
enddef

# return an array with position of symbol: [x, y]
def GetFoundSymbols(raw_input: list<string>): list<list<number>>
  var symbols: list<list<number>> = []
  var x = 0

  while x < raw_input->len()

    var y = 0
    while y < raw_input[x]->strlen()

      const found = GetSymbolPos(raw_input[x][y])
      if found >= 0
        symbols->add([x, y])
      endif

      y += 1
    endwhile

    x += 1
  endwhile

  return symbols
enddef

# returns an array, each element has structure [number, row, col_start, col_end]
def GetFoundNumbers(raw_input: list<string>): list<list<number>>
  var numbers = []
  var row = 0
  
  while row < raw_input->len()
    var pos = 0

    while pos < raw_input[row]->len()
      const matched = raw_input[row]->matchstrpos('\(\d\+\)', pos)

      if matched[0] != ''
        numbers->add([matched[0]->str2nr(), row, matched[1], matched[2] - 1]) # [number, row, col_start, col_end]
        pos = matched[2]
        continue
      endif

      pos += 1
    endwhile

    row += 1
  endwhile

  return numbers
enddef

def SumFoundNumbers(chars: list<string>): list<number>
  var nums: list<number> = []
  const numchars = chars->filter((idx, item) => item->match('[0-9]') != -1)

  for ch in numchars
    nums->add(ch->str2nr())
  endfor

  return nums
enddef

# def GetAdjacentNumbers(raw_input: list<string>, symbols: list<list<number>>): list<list<number>>
#   var found: list<list<number>> = []
#   const row_first = 0
#   const row_last = raw_input->len() - 1
#   const col_first = 0
#   const col_last = raw_input[0]->strlen() - 1
# 
#   for symbol in symbols
#     const x = symbol[0]
#     const y = symbol[1]
# 
#     if x == row_first && y == col_first
#       # top left corner: bot, botright, right
#       found->add(SumFoundNumbers([ raw_input[x + 1][y], raw_input[x + 1][y + 1], raw_input[x][y + 1] ]))
#     elseif x == row_first && y == col_last
#       # top right corner: left, botleft, bot
#       found->add(SumFoundNumbers([ raw_input[x][y - 1], raw_input[x + 1][y - 1], raw_input[x + 1][y] ]))
#     elseif x == row_last && y == col_first
#       # bot left corner: top, topright, right
#       found->add(SumFoundNumbers([ raw_input[x - 1][y], raw_input[x - 1][y + 1], raw_input[x][y + 1] ]))
#     elseif x == row_last && y == col_last
#       # bot right corner: left, topleft, top
#       found->add(SumFoundNumbers([ raw_input[x][y - 1], raw_input[x - 1][y - 1], raw_input[x - 1][y] ]))
#     elseif x == row_first
#       # first row: left, botleft, bot, botright, right
#       found->add(SumFoundNumbers([ raw_input[x][y - 1], raw_input[x + 1][y - 1], raw_input[x + 1][y], raw_input[x + 1][y - 1], raw_input[x][y + 1] ]))
#     elseif x == row_last
#       # last row: left, topleft, top, topright, right
#       found->add(SumFoundNumbers([ raw_input[x][y - 1], raw_input[x - 1][y - 1], raw_input[x - 1][y], raw_input[x - 1][y + 1], raw_input[x][y + 1] ]))
#     elseif y == col_first
#       # first col: top, topright, right, botright, bot
#       found->add(SumFoundNumbers([ raw_input[x - 1][y], raw_input[x - 1][y + 1], raw_input[x][y + 1], raw_input[x + 1][y + 1], raw_input[x + 1][y] ]))
#     elseif y == col_last
#       # last col: top, topleft, left, botleft, bot
#       found->add(SumFoundNumbers([ raw_input[x - 1][y], raw_input[x - 1][y - 1], raw_input[x][y - 1], raw_input[x + 1][y - 1], raw_input[x + 1][y] ]))
#     else
#       # everywhere in between: top, topright, right, botright, bot, botleft, left, topleft
#       found->add(SumFoundNumbers([ raw_input[x - 1][y], raw_input[x - 1][y + 1], raw_input[x][y + 1], raw_input[x + 1][y + 1], raw_input[x + 1][y], raw_input[x + 1][y - 1], raw_input[x][y - 1], raw_input[x - 1][y - 1] ]))
#     endif
#   endfor
# 
#   return found
# enddef

def GetAdjacentNumbers(raw_input: list<string>, symbols: list<list<number>>, numbers: list<list<number>>): list<number>
  var found = []
  var found_linear = false

  for symbol in symbols
    const [x, y] = symbol

    # top, right, bot, left
    const linear_pos = [ [x - 1, y], [x, y + 1], [x + 1, y], [x, y - 1] ]

    for pos in linear_pos
      # TODO
    endfor
  endfor

  return found
enddef

export def PartOne(): void
  const symbols: list<list<number>> = GetFoundSymbols(samples)
  const numbers: list<list<number>> = GetFoundNumbers(samples)
  # const nums_found = GetAdjacentNumbers(samples, symbols)

  echom numbers
  echom symbols
  # echom nums_found->flattennew()
enddef

export def PartTwo(): void
enddef
