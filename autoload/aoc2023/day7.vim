vim9script

import './utils.vim'

const samples = [
  '32T3K 765',
  'T55J5 684',
  'KK677 28',
  'KTJJT 220',
  'QQQJA 483',
]

var part = 1
const card_ranks = ['AKQJT98765432', 'AKQT98765432J']

const highcard = 0
const onepair = 1
const twopair = 2
const threekind = 3
const fullhouse = 4
const fourkind = 5
const fivekind = 6

def ByRank(a: string, b: string): number
  return card_ranks[part - 1]->match(a) - card_ranks[part - 1]->match(b)
enddef

def SortHand(raw_hand: string): list<string>
  return raw_hand->copy()->split('\zs')->sort(ByRank)
enddef

# return the hand type and the highest card rank(s)
def GetHandType(sorted_hand: list<string>): number
  const res = sorted_hand->copy()->uniq()

  if res->len() == 5
    # high card
    return highcard
  endif

  if res->len() == 1
    # five of a kind
    return fivekind
  endif

  if res->len() == 2
    if sorted_hand->count(res[0]) == 4 || sorted_hand->count(res[1]) == 4
      # four of a kind
      return fourkind
    endif

    if (sorted_hand->count(res[0]) == 3 && sorted_hand->count(res[1]) == 2)
        || (sorted_hand->count(res[0]) == 2 && sorted_hand->count(res[1]) == 3)
      # full house
      return fullhouse
    endif
  endif

  if res->len() == 3
    var pattern = [ [2, 2, 1], [2, 1, 2], [1, 2, 2] ]

    var i = 0
    while i < pattern->len()
      if sorted_hand->count(res[0]) == pattern[i][0]
          && sorted_hand->count(res[1]) == pattern[i][1]
          && sorted_hand->count(res[2]) == pattern[i][2]

        # two pair
        if pattern[i][0] == 2 || pattern[i][1] == 2
          return twopair
        endif
      endif

      i += 1
    endwhile

    # for three of a kind
    pattern = [ [3, 1, 1], [1, 3, 1], [1, 1, 3] ]

    i = 0
    while i < pattern->len()
      if sorted_hand->count(res[0]) == pattern[i][0]
          && sorted_hand->count(res[1]) == pattern[i][1]
          && sorted_hand->count(res[2]) == pattern[i][2]

        # three kind
        if pattern[i][0] == 3 || pattern[i][1] == 3 || pattern[i][2] == 3
          return threekind
        endif
      endif

      i += 1
    endwhile
  endif

  if res->len() == 4
    # one pair
    for card in res
      if sorted_hand->count(card) == 2
        return onepair
      endif
    endfor
  endif

  return -1
enddef

def SortByHighCard(a: list<any>, b: list<any>): number
  const hand_a = a[1]
  const hand_b = b[1]

  var i = 0
  while i < hand_a->strlen()
    if hand_b[i] != hand_a[i]
      return card_ranks[part - 1]->match(hand_b[i]) - card_ranks[part - 1]->match(hand_a[i])
    endif

    i += 1
  endwhile

  return 0
enddef

def MapBySortedHand(_: number, val: list<list<any>>): list<list<any>>
  if val->len() == 1
    return val
  endif

  return val->copy()->sort(SortByHighCard)
enddef

export def PartOne()
  part = 1
  # const input = samples
  const input = utils.GetInputFromTxt('day7')
  # highcard, onepair, twopair, threekind, fullhouse, fourkind, fivekind
  var hands = [[], [], [], [], [], [], []]

  var i = 0
  while i < input->len()
    const [hand, raw_bid] = input[i]->split(' ')
    const bid = str2nr(raw_bid)
    const sorted = SortHand(hand)
    const hand_type = GetHandType(sorted) # [hand type, hand rank sum]
    hands[hand_type]->add([hand_type, hand, bid])

    i += 1
  endwhile

  # echom hands
  echom hands->mapnew(MapBySortedHand)
    ->flattennew(1)
    ->mapnew((idx, val) => val[2] * (idx + 1))
    ->reduce((acc, total) => acc + total, 0)
enddef

export def PartTwo()
  part = 2
  const input = samples
  # const input = utils.GetInputFromTxt('day7')
enddef
