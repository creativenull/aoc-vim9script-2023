vim9script

import './utils.vim'

const samples = [
  'Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53',
  'Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19',
  'Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1',
  'Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83',
  'Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36',
  'Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11',
]

def Parse(raw_input: list<string>): list<dict<any>>
  var cards = []

  for line in raw_input
    const sets = line->split(':')
    const cardId = sets[0]->split(' ')[-1]->str2nr()
    const num_sets = sets[1]->trim()->split(' | ')
    const winning_nums = num_sets[0]->split(' ')->mapnew((idx, item) => str2nr(item))->filter((idx, item) => item != 0)
    const provided_nums = num_sets[1]->split(' ')->mapnew((idx, item) => str2nr(item))->filter((idx, item) => item != 0)

    cards->add({
      id: cardId,
      winnings: winning_nums,
      provided: provided_nums,
    })
  endfor

  return cards
enddef

def GetWinningNumbersFromProvided(cards: list<dict<any>>): list<list<number>>
  var points: list<list<number>> = []

  for card in cards
    var winners = []

    for win in card.winnings
      const found = card.provided->copy()->filter((idx, item) => item == win)

      if found->len() > 0
        winners->add(found[0])
      endif
    endfor

    points->add(winners)
  endfor

  return points
enddef

def CalculatePoints(idx: number, item: list<number>): number
  if item->len() == 0
    return 0
  endif

  return pow(2, item->len() - 1)->float2nr()
enddef

export def PartOne()
  # const input = samples
  const input = utils.GetInputFromTxt('day4')
  const cards = Parse(input)
  const winners = GetWinningNumbersFromProvided(cards)

  echom winners->mapnew(CalculatePoints)->reduce((acc, val) => acc + val, 0)
enddef

def GenerateCopies(cards: list<dict<any>>, winnings: list<list<number>>): list<number>
  var copies = []

  var i = 0
  while i < winnings->len()
    const id = i + 1
    
    if copies->count(id) > 0
      for v in range(1, copies->count(id))
        const c = winnings[i]->mapnew((idx, val) => id + idx + 1)
        copies += c
      endfor
    endif

    const c = winnings[i]->mapnew((idx, val) => id + idx + 1)
    copies += c

    i += 1
  endwhile

  return copies
enddef

export def PartTwo()
  # const input = samples
  const input = utils.GetInputFromTxt('day4')
  const cards = Parse(input)
  const winnings = GetWinningNumbersFromProvided(cards)
  const copies = GenerateCopies(cards, winnings)

  echom copies->len() + winnings->len()
enddef
