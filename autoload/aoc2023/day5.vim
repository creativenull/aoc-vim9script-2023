vim9script

import './utils.vim'

const samples = [
  'seeds: 79 14 55 13',
  '',
  'seed-to-soil map:',
  '50 98 2',
  '52 50 48',
  '',
  'soil-to-fertilizer map:',
  '0 15 37',
  '37 52 2',
  '39 0 15',
  '',
  'fertilizer-to-water map:',
  '49 53 8',
  '0 11 42',
  '42 0 7',
  '57 7 4',
  '',
  'water-to-light map:',
  '88 18 7',
  '18 25 70',
  '',
  'light-to-temperature map:',
  '45 77 23',
  '81 45 19',
  '68 64 13',
  '',
  'temperature-to-humidity map:',
  '0 69 1',
  '1 0 69',
  '',
  'humidity-to-location map:',
  '60 56 37',
  '56 93 4',
]

def KeyMatch(line: string): string
  if line->match('seed-to-soil') != -1
    return 'seed-to-soil'
  elseif line->match('soil-to-fertilizer') != -1
    return 'soil-to-fertilizer'
  elseif line->match('fertilizer-to-water') != -1
    return 'fertilizer-to-water'
  elseif line->match('water-to-light') != -1
    return 'water-to-light'
  elseif line->match('light-to-temperature') != -1
    return 'light-to-temperature'
  elseif line->match('temperature-to-humidity') != -1
    return 'temperature-to-humidity'
  elseif line->match('humidity-to-location') != -1
    return 'humidity-to-location'
  endif

  return ''
enddef

def ToNumber(idx: number, val: string): number
  return str2nr(val)
enddef

def CreateMap(line: string): list<list<number>>
  const parsed = line->split(' ')->mapnew(ToNumber)
  const length = parsed[2]
  # return [range(parsed[1], parsed[1] + (length - 1)), range(parsed[0], parsed[0] + (length - 1))]

  return [ [parsed[1], parsed[1] + (length - 1)], [parsed[0], parsed[0] + (length - 1)] ]
enddef

def ParseMaps(input: list<string>): dict<any>
  var data: dict<any>
  var input_map = false
  var key = ''

  var i = 2
  while i < input->len()
    if input[i] == ''
      # skip empty lines
      i += 1
      continue
    endif

    if KeyMatch(input[i]) != ''
      # if we match the key, then start taking data on next iteration
      input_map = true
      key = KeyMatch(input[i])
      data[key] = []

      i += 1
      continue
    endif

    if input_map
      # start taking data ranges
      data[key]->add(CreateMap(input[i]))
    endif

    i += 1
  endwhile

  return data
enddef

def ParseSeeds(input: string): list<number>
  return input[7 :]->split(' ')->mapnew(ToNumber)
enddef

def GetResult(pairs: list<list<list<number>>>, needle: number): number
  var result = -1

  for pair in pairs
    if needle - pair[0][0] <= -1 || needle - pair[0][1] >= 1
      # not in range, skip
      continue
    endif

    # in range, get the mapped number
    result = (needle - pair[0][0]) + pair[1][0] # offset + mapped lower value
    break
  endfor

  if result == -1
    return needle
  endif

  return result
enddef

def GetMinLocation(seeds: list<number>, maps: dict<any>): number
  var min_location = -1

  for seed in seeds
    # soil
    const soil = GetResult(maps['seed-to-soil'], seed)
    # fertilizer
    const fertilizer = GetResult(maps['soil-to-fertilizer'], soil)
    # water
    const water = GetResult(maps['fertilizer-to-water'], fertilizer)
    # light
    const light = GetResult(maps['water-to-light'], water)
    # temperature
    const temperature = GetResult(maps['light-to-temperature'], light)
    # humidity
    const humidity = GetResult(maps['temperature-to-humidity'], temperature)
    # location
    const location = GetResult(maps['humidity-to-location'], humidity)

    if min_location == -1
      min_location = location
      continue
    endif

    min_location = location < min_location ? location : min_location
  endfor

  return min_location
enddef

export def PartOne()
  # const input = samples
  const input = utils.GetInputFromTxt('day5')
  const seeds = ParseSeeds(input[0])
  const maps = ParseMaps(input)

  const min_location = GetMinLocation(seeds, maps)
  echom min_location
enddef

def ParseSeedsAsRangePairs(input: string): list<list<number>>
  const seeds = ParseSeeds(input)
  var pairs = []

  var i = 0
  while i < seeds->len()
    pairs->add([ seeds[i], seeds[i + 1] - 1 ])

    i += 2
  endwhile

  return pairs
enddef

def GetMinLocationFromRange(range: list<number>, maps: dict<any>): number
  var min_location = -1

  var seed = range[0]
  while seed < range[0] + (range[1] + 1)
    # soil
    const soil = GetResult(maps['seed-to-soil'], seed)
    # fertilizer
    const fertilizer = GetResult(maps['soil-to-fertilizer'], soil)
    # water
    const water = GetResult(maps['fertilizer-to-water'], fertilizer)
    # light
    const light = GetResult(maps['water-to-light'], water)
    # temperature
    const temperature = GetResult(maps['light-to-temperature'], light)
    # humidity
    const humidity = GetResult(maps['temperature-to-humidity'], temperature)
    # location
    const location = GetResult(maps['humidity-to-location'], humidity)

    min_location = min_location == -1 ? location : (location < min_location ? location : min_location)

    seed += 1
  endwhile

  return min_location
enddef

export def PartTwo()
  const input = samples
  # const input = utils.GetInputFromTxt('day5')
  const maps = ParseMaps(input)
  const pairs = ParseSeedsAsRangePairs(input[0])
  var locations = []

  for pair in pairs
    const min_location = GetMinLocationFromRange(pair, maps)
    locations->add(min_location)
  endfor

  echom locations->min()
enddef
