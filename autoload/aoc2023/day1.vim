vim9script

import './utils.vim'

var samples = [
  '1abc2',
  'pqr3stu8vwx',
  'a1b2c3d4e5f',
  'treb7uchet',
]

export def PartOne()
  var pairs = ''
  var numbers = []
  var input = utils.GetInputFromTxt('day1')

  for sample in input

    # first number
    for char in sample
      if char->str2nr(10) != 0
        pairs ..= char
        break
      endif
    endfor

    # last number
    for char in sample->reverse()
      if char->str2nr(10) != 0
        pairs ..= char
        break
      endif
    endfor

    numbers->add(pairs->str2nr(10))
    pairs = ''
  endfor

  echom numbers->reduce((acc, total) => total + acc)
enddef

var samples2 = [
  'two1nine',
  'eightwothree',
  'abcone2threexyz',
  'xtwone3four',
  '4nineeightseven2',
  'zoneight234',
  '7pqrstsixteen',
]

def GetFirstDigit(i: number, sample: string): number
  if sample[i] == 'o' && sample->match('one') == i
    return 1
  elseif sample[i] == 't' && sample->match('two') == i
    return 2
  elseif sample[i] == 't' && sample->match('three') == i
    return 3
  elseif sample[i] == 'f' && sample->match('four') == i
    return 4
  elseif sample[i] == 'f' && sample->match('five') == i
    return 5
  elseif sample[i] == 's' && sample->match('six') == i
    return 6
  elseif sample[i] == 's' && sample->match('seven') == i
    return 7
  elseif sample[i] == 'e' && sample->match('eight') == i
    return 8
  elseif sample[i] == 'n' && sample->match('nine') == i
    return 9
  endif

  return -1
enddef

def GetFirstDigitReversed(i: number, sample: string): number
  if sample[i] == 'e' && sample->match('eno') == i
    return 1
  elseif sample[i] == 'o' && sample->match('owt') == i
    return 2
  elseif sample[i] == 'e' && sample->match('eerht') == i
    return 3
  elseif sample[i] == 'r' && sample->match('ruof') == i
    return 4
  elseif sample[i] == 'e' && sample->match('evif') == i
    return 5
  elseif sample[i] == 'x' && sample->match('xis') == i
    return 6
  elseif sample[i] == 'n' && sample->match('neves') == i
    return 7
  elseif sample[i] == 't' && sample->match('thgie') == i
    return 8
  elseif sample[i] == 'e' && sample->match('enin') == i
    return 9
  endif

  return -1
enddef

export def PartTwo()
  var converted = ''
  var numbers: list<number> = []
  var input = utils.GetInputFromTxt('day1')

  for sample in input

    var i = 0
    while i < sample->strlen()
      const res = GetFirstDigit(i, sample)

      if res > -1
        converted ..= string(res)
        break
      elseif sample[i]->str2nr(10) != 0
        converted ..= sample[i]
        break
      endif

      i += 1
    endwhile

    const sample_reversed = sample->copy()->reverse()

    i = 0
    while i < sample_reversed->strlen()
      const res = GetFirstDigitReversed(i, sample_reversed)

      if res > -1
        converted ..= string(res)
        break
      elseif sample_reversed[i]->str2nr(10) != 0
        converted ..= sample_reversed[i]
        break
      endif

      i += 1
    endwhile

    # get first and last digit into a number
    const first_last = printf('%s%s', converted[0], converted[-1])
    numbers->add(first_last->str2nr(10))
    converted = ''
  endfor

  echom numbers->reduce((acc, total) => total + acc)
enddef
