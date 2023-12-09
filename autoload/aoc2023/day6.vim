vim9script

import './utils.vim'

const samples = [
  'Time:      7  15   30',
  'Distance:  9  40  200',
]

def ParseTime(input: string): list<number>
  return input[5 :]->trim()->split(' ')->mapnew(utils.MapToNumber)->filter((_, val) => val != 0)
enddef

def ParseDist(input: string): list<number>
  return input[9 :]->trim()->split(' ')->mapnew(utils.MapToNumber)->filter((_, val) => val != 0)
enddef

def CalculateDistance(speed: number, time: number): number
  return speed * time
enddef

export def PartOne()
  # const input = samples
  const input = utils.GetInputFromTxt('day6')
  const times = ParseTime(input[0])
  const distances = ParseDist(input[1])
  var possibles = []

  var i = 0
  while i < times->len()
    var possible_distances = 0

    var hold = 1
    while hold <= times[i]
      const speed = hold
      const dist = CalculateDistance(speed, times[i] - hold)

      if dist > distances[i]
        possible_distances += 1
      endif

      hold += 1
    endwhile

    possibles->add(possible_distances)

    i += 1
  endwhile

  echom possibles
  echom possibles->reduce((acc, val) => acc * val, 1)
enddef

def ParseTimeAsOne(input: string): number
  return input[5 :]->trim()->substitute(' ', '', 'g')->str2nr()
enddef

def ParseDistAsOne(input: string): number
  return input[9 :]->trim()->substitute(' ', '', 'g')->str2nr()
enddef

export def PartTwo()
  # const input = samples
  const input = utils.GetInputFromTxt('day6')
  const time = ParseTimeAsOne(input[0])
  const distance = ParseDistAsOne(input[1])
  var possible_distances = 0

  var hold = 1
  while hold <= time
    const speed = hold
    const dist = CalculateDistance(speed, time - hold)

    if dist > distance
      possible_distances += 1
    endif

    hold += 1
  endwhile

  echom possible_distances
enddef
