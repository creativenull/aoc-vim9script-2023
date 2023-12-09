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
      i += 1
      continue
    endif

    if KeyMatch(input[i]) != ''
      input_map = true
      key = KeyMatch(input[i])
      data[key] = []

      i += 1
      continue
    endif

    if input_map
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
    const length = pair[0][1] - pair[0][0] + 1

    const pos = pair[0]->index(needle)
    if pos != -1
      result = pair[1][pos]
    endif
  endfor

  if result == -1
    # return the same number, because not unique map
    return needle
  endif

  return result
enddef

def GetLocations(seeds: list<number>, maps: dict<any>): list<number>
  var locations = []

  for seed in seeds
    # echom $'seed: {seed}'

    # soil
    const soil = GetResult(maps['seed-to-soil'], seed)
    # echom $'soil: {soil}'

    # fertilizer
    const fertilizer = GetResult(maps['soil-to-fertilizer'], soil)
    # echom $'fertilizer: {fertilizer}'

    # water
    const water = GetResult(maps['fertilizer-to-water'], fertilizer)
    # echom $'water: {water}'

    # light
    const light = GetResult(maps['water-to-light'], water)
    # echom $'light: {light}'

    # temperature
    const temperature = GetResult(maps['light-to-temperature'], light)
    # echom $'temperature: {temperature}'

    # humidity
    const humidity = GetResult(maps['temperature-to-humidity'], temperature)
    # echom $'humidity: {humidity}'

    # location
    const location = GetResult(maps['humidity-to-location'], humidity)
    # echom $'location: {location}'

    locations->add(location)

    break
  endfor

  return locations
enddef

export def PartOne()
  const input = samples
  # const input = utils.GetInputFromTxt('day5')
  const seeds = ParseSeeds(input[0])
  const maps = ParseMaps(input)

  const locations = GetLocations(seeds, maps)
  # echom locations->min()
enddef

export def PartTwo()
enddef
