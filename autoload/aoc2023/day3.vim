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

# Find if `numbers` has `row` and it's col ranges matches `col`
# where `numbers` is a list of list with each item [num, row, colstart, colend]
def FilterInRange(numbers: list<list<number>>, row: number, col: number): number
  const filtered = numbers->copy()
    ->filter((i, item) => item[1] == row && range(item[2], item[3])
    ->indexof($"v:val == {col}") > -1)

  if filtered->len() == 1
    return filtered[0][0]
  endif

  return -1
enddef

def GetAdjacentNumbers(raw_input: list<string>, symbols: list<list<number>>, numbers: list<list<number>>): list<number>
  var found: list<number> = []

  for symbol in symbols
    const [x, y] = symbol
    var filtered = -1
    var found_vertical = [false, false]

    # left, right
    const horz_pos = [ [x, y + 1], [x, y - 1] ]
    for hpos in horz_pos
      const [row, col] = hpos
      filtered = FilterInRange(numbers, row, col)
      if filtered != -1
        found->add(filtered)
      endif
    endfor

    # top
    filtered = FilterInRange(numbers, x - 1, y)
    if filtered != -1
      found->add(filtered)
      found_vertical[0] = true
    endif

    # bot
    filtered = FilterInRange(numbers, x + 1, y)
    if filtered != -1
      found->add(filtered)
      found_vertical[1] = true
    endif

    # if we didnt find any number right above the symbol, then
    # we check diagonal positions: topleft, topright
    if !found_vertical[0]
      filtered = FilterInRange(numbers, x - 1, y - 1)
      if filtered != -1
        found->add(filtered)
      endif
      filtered = FilterInRange(numbers, x - 1, y + 1)
      if filtered != -1
        found->add(filtered)
      endif
    endif

    # if we didnt find any number right below the symbol, then
    # we check diagonal positions: botright, botleft
    if !found_vertical[1]
      filtered = FilterInRange(numbers, x + 1, y + 1)
      if filtered != -1
        found->add(filtered)
      endif
      filtered = FilterInRange(numbers, x + 1, y - 1)
      if filtered != -1
        found->add(filtered)
      endif
    endif
  endfor

  return found
enddef

export def PartOne(): void
  # const input = samples
  const input = utils.GetInputFromTxt('day3')
  const symbols = GetFoundSymbols(input)
  const numbers = GetFoundNumbers(input)
  const nums_found = GetAdjacentNumbers(input, symbols, numbers)

  echom nums_found->reduce((acc, val) => acc + val)
enddef

def GetFoundGears(raw_input: list<string>): list<list<number>>
  var symbols: list<list<number>> = []
  var x = 0

  while x < raw_input->len()

    var y = 0
    while y < raw_input[x]->strlen()

      const found = raw_input[x][y] == '*'
      if found
        symbols->add([x, y])
      endif

      y += 1
    endwhile

    x += 1
  endwhile

  return symbols
enddef

def GetAdjacentGearNumbers(raw_input: list<string>, gears: list<list<number>>, numbers: list<list<number>>): list<number>
  var found: list<number> = []

  for gear in gears
    const [x, y] = gear
    var filtered = -1
    var found_vertical = [false, false]
    var found_pairs = []

    # left, right
    const horz_pos = [ [x, y + 1], [x, y - 1] ]
    for hpos in horz_pos
      const [row, col] = hpos
      filtered = FilterInRange(numbers, row, col)
      if filtered != -1
        found_pairs->add(filtered)
      endif
    endfor

    # top
    filtered = FilterInRange(numbers, x - 1, y)
    if filtered != -1
      found_pairs->add(filtered)
      found_vertical[0] = true
    endif

    # bot
    filtered = FilterInRange(numbers, x + 1, y)
    if filtered != -1
      found_pairs->add(filtered)
      found_vertical[1] = true
    endif

    # if we didnt find any number right above the symbol, then
    # we check diagonal positions: topleft, topright
    if !found_vertical[0]
      filtered = FilterInRange(numbers, x - 1, y - 1)
      if filtered != -1
        found_pairs->add(filtered)
      endif
      filtered = FilterInRange(numbers, x - 1, y + 1)
      if filtered != -1
        found_pairs->add(filtered)
      endif
    endif

    # if we didnt find any number right below the symbol, then
    # we check diagonal positions: botright, botleft
    if !found_vertical[1]
      filtered = FilterInRange(numbers, x + 1, y + 1)
      if filtered != -1
        found_pairs->add(filtered)
      endif
      filtered = FilterInRange(numbers, x + 1, y - 1)
      if filtered != -1
        found_pairs->add(filtered)
      endif
    endif

    if found_pairs->len() == 2
      found->add(found_pairs->reduce((acc, total) => acc * total, 1))
    endif
  endfor

  return found
enddef

export def PartTwo(): void
  # const input = samples
  const input = utils.GetInputFromTxt('day3')
  const gears = GetFoundGears(input)
  const numbers = GetFoundNumbers(input)
  const nums_found = GetAdjacentGearNumbers(input, gears, numbers)

  # echom gears
  # echom numbers
  echom nums_found->reduce((acc, total) => acc + total, 0)
enddef
