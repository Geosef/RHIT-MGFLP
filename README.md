<snippet>
  <content><![CDATA[
# ${1:Run Coder Run}
This is a senior capstone project for RHIT written by Prithvi Kanherkar, Michael Kochell, Bill Mader and Joe Carroll.

Note: Program is being exported under the TSU exception.
## Usage
Currently the only working simulator for this application is the Gideros Player. 

### Offline Play
In order to run this application offline, follow these steps: 

1. Open the main.lua file in the Gideros Studio application.
2. Near the beginning of the file, change the multiplayerMode variable to false.
3. Open and run the Gideros player using main.lua

During offline operation, the second player will run a default set of moves. The human player is always the player in the top left of the grid.

###Multiplayer
In order to run this application on multiple Gideros player on separate computers, follow these steps:

1. Open the main.py file in the RCRServer project.
2. Run ipconfig or ifconfig and enter your IP address for the host variable.
3. Run the python server by executing the command "python main.py" in the command line (must be in project directory) or run main.py in a PyDev console. The server should now be listening for connections.
4. Open the main.lua and networkadapter.lua files in the Gideros Project on both computers that you will be using for the game.
5. On both computers, change the playerIP to the IP you used in #2 and change the multiplayerMode variable in main.lua to true.
6. Run the program on both computers. The server should recognize that two users have logged in. One user should then create a game by pressing "Create Game" and the other should press "Join Game" to join the same game. Now, both users should be in the same game and ready to play!

## Credits
[Prithvi Kanherkar](https://www.github.com/pkanher617)
[Michael Kochell](https://www.github.com/mickmister)
[Bill Mader](https://www.github.com/Bill-Mader)
[Joe Carroll](https://www.github.com/Geosef)

## License
TODO: Write license
]]></content>
  <tabTrigger>readme</tabTrigger>
</snippet>
