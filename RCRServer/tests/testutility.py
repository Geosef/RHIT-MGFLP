__author__ = 'kochelmj'


testOneRematchEach_HostExpected = \
[
    {'source': 'recv', 'type': 'Login'},
    {'source': 'send', 'type': 'Login'},
    {'source': 'recv', 'type': 'Create Game'},
    {'source': 'send', 'type': 'Create Game'},
    {'source': 'send', 'type': 'Player Joined'},
    {'source': 'recv', 'type': 'Player Joined'},
    {'source': 'send', 'type': 'Game Setup'},
    {'source': 'recv', 'type': 'Start Game'},
    {'source': 'send', 'type': 'Start Game'},
    {'source': 'recv', 'type': 'Submit Move'},
    {'source': 'send', 'type': 'Run Events'},
    {'source': 'recv', 'type': 'Update Locations'},
    {'source': 'send', 'type': 'Game Over'},
    {'source': 'recv', 'type': 'End Game'},
    {'source': 'send', 'type': 'Rematch'},
    {'source': 'send', 'type': 'Game Setup'},
    {'source': 'recv', 'type': 'Start Game'},
    {'source': 'send', 'type': 'Start Game'},
    {'source': 'recv', 'type': 'Submit Move'},
    {'source': 'send', 'type': 'Run Events'},
    {'source': 'recv', 'type': 'Update Locations'},
    {'source': 'send', 'type': 'Game Over'},
    {'source': 'recv', 'type': 'End Game'},
    {'source': 'send', 'type': 'Rematch'}
]

testOneRematchEach_PeerExpected = \
[
    {'source': 'recv', 'type': 'Login'},
    {'source': 'send', 'type': 'Login'},
    {'source': 'recv', 'type': 'Browse Games'},
    {'source': 'send', 'type': 'Browse Games'},
    {'source': 'recv', 'type': 'Join Game'},
    {'source': 'send', 'type': 'Join Game'},
    {'source': 'send', 'type': 'Game Setup'},
    {'source': 'recv', 'type': 'Start Game'},
    {'source': 'send', 'type': 'Start Game'},
    {'source': 'recv', 'type': 'Submit Move'},
    {'source': 'send', 'type': 'Run Events'},
    {'source': 'send', 'type': 'Game Over'},
    {'source': 'recv', 'type': 'End Game'},
    {'source': 'send', 'type': 'Rematch'},
    {'source': 'send', 'type': 'Game Setup'},
    {'source': 'recv', 'type': 'Start Game'},
    {'source': 'send', 'type': 'Start Game'},
    {'source': 'recv', 'type': 'Submit Move'},
    {'source': 'send', 'type': 'Run Events'},
    {'source': 'send', 'type': 'Game Over'},
    {'source': 'recv', 'type': 'End Game'},
    {'source': 'send', 'type': 'Rematch'}
]

testOneRematchHost_HostExpected = \
[
    {'source': 'recv', 'type': 'Login'},
    {'source': 'send', 'type': 'Login'},
    {'source': 'recv', 'type': 'Create Game'},
    {'source': 'send', 'type': 'Create Game'},
    {'source': 'send', 'type': 'Player Joined'},
    {'source': 'recv', 'type': 'Player Joined'},
    {'source': 'send', 'type': 'Game Setup'},
    {'source': 'recv', 'type': 'Start Game'},
    {'source': 'send', 'type': 'Start Game'},
    {'source': 'recv', 'type': 'Submit Move'},
    {'source': 'send', 'type': 'Run Events'},
    {'source': 'recv', 'type': 'Update Locations'},
    {'source': 'send', 'type': 'Game Over'},
    {'source': 'recv', 'type': 'End Game'}
]

testOneRematchHost_PeerExpected = \
[
    {'source': 'recv', 'type': 'Login'},
    {'source': 'send', 'type': 'Login'},
    {'source': 'recv', 'type': 'Browse Games'},
    {'source': 'send', 'type': 'Browse Games'},
    {'source': 'recv', 'type': 'Join Game'},
    {'source': 'send', 'type': 'Join Game'},
    {'source': 'send', 'type': 'Game Setup'},
    {'source': 'recv', 'type': 'Start Game'},
    {'source': 'send', 'type': 'Start Game'},
    {'source': 'recv', 'type': 'Submit Move'},
    {'source': 'send', 'type': 'Run Events'},
    {'source': 'send', 'type': 'Game Over'},
    {'source': 'recv', 'type': 'End Game'},
    {'source': 'send', 'type': 'Rematch'}
]

testOneRematchPeer_HostExpected = \
[
    {'source': 'recv', 'type': 'Login'},
    {'source': 'send', 'type': 'Login'},
    {'source': 'recv', 'type': 'Create Game'},
    {'source': 'send', 'type': 'Create Game'},
    {'source': 'send', 'type': 'Player Joined'},
    {'source': 'recv', 'type': 'Player Joined'},
    {'source': 'send', 'type': 'Game Setup'},
    {'source': 'recv', 'type': 'Start Game'},
    {'source': 'send', 'type': 'Start Game'},
    {'source': 'recv', 'type': 'Submit Move'},
    {'source': 'send', 'type': 'Run Events'},
    {'source': 'recv', 'type': 'Update Locations'},
    {'source': 'send', 'type': 'Game Over'},
    {'source': 'recv', 'type': 'End Game'},
    {'source': 'send', 'type': 'Rematch'}
]

testOneRematchPeer_PeerExpected = \
[
    {'source': 'recv', 'type': 'Login'},
    {'source': 'send', 'type': 'Login'},
    {'source': 'recv', 'type': 'Browse Games'},
    {'source': 'send', 'type': 'Browse Games'},
    {'source': 'recv', 'type': 'Join Game'},
    {'source': 'send', 'type': 'Join Game'},
    {'source': 'send', 'type': 'Game Setup'},
    {'source': 'recv', 'type': 'Start Game'},
    {'source': 'send', 'type': 'Start Game'},
    {'source': 'recv', 'type': 'Submit Move'},
    {'source': 'send', 'type': 'Run Events'},
    {'source': 'send', 'type': 'Game Over'},
    {'source': 'recv', 'type': 'End Game'}
]