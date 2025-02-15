SERVER_MOCKS = {}
local collectGame = 
{
	host= true,
    type= 'Game Setup',
    game= 'Collectors',
    diff= 'Medium',
    gridSize= 10,
    cellData=
    {
		wallLocations=
        {
            {
                x= 1,
                y= 4
            },
            {
                x= 1,
                y= 5
            },
			{
                x= 1,
                y= 6
            },
			{
                x= 1,
                y= 7
            },
			{
                x= 1,
                y= 10
            },
			{
                x= 2,
                y= 5
            },
			{
                x= 2,
                y= 6
            },
			{
                x= 3,
                y= 1
            },
			{
                x= 3,
                y= 9
            },
			{
                x= 4,
                y= 10
            },
			{
                x= 5,
                y= 3
            },
			{
                x= 5,
                y= 7
            },
			{
                x= 5,
                y= 10
            },
			{
                x= 6,
                y= 3
            },
			{
                x= 6,
                y= 4
            },
			{
                x= 6,
                y= 7
            },
			{
                x= 6,
                y= 10
            },
			{
                x= 7,
                y= 3
            },
			{
                x= 7,
                y= 10
            },
			{
                x= 8,
                y= 2
            },
			{
                x= 9,
                y= 4
            },
			{
                x= 9,
                y= 5
            },
			{
                x= 10,
                y= 3
            },
			{
                x= 10,
                y= 4
            },
			{
                x= 10,
                y= 5
            },
			{
                x= 10,
                y= 8
            },
        },
        goldLocations=
        {
            {
                x= 2,
                y= 2
            },
            {
                x= 3,
                y= 3
            },
            {
                x= 5,
                y= 5
            },
            {
                x= 6,
                y= 6
            },
            {
                x= 8,
                y= 8
            },
            {
                x= 9,
                y= 9
            },
            {
                x= 2,
                y= 9
            },
            {
                x= 3,
                y= 8
            },
            {
                x= 5,
                y= 6
            },
            {
                x= 6,
                y= 5
            },
            {
                x= 8,
                y= 3
            },
            {
                x= 9,
                y= 2
            },
        },
        gemLocations=
        {
            {
                x= 4,
                y= 4
            },
            {
                x= 7,
                y= 7
            },
            {
                x= 4,
                y= 7
            },
            {
                x= 7,
                y= 4
            },
        },
        treasureLocations=
        {
			{x=1, y=1},
            {
                x= 1,
                y= 10
            },
            {
                x= 10,
                y= 1
            },
        },
        enemyStart=
        {
            x= 5,
            y= 6
        }
    }
}
local trapGame = 
{
	host= true,
    type= 'Game Setup',
    game= 'Trap Game',
    diff= 'Medium',
    gridSize= 16,
    cellData=
    {
		wallLocations = {}
    }
}
SERVER_MOCKS['Game Setup'] = function(data)
	if data == 'Collectors' then return collectGame
	elseif data == 'Trap' then return trapGame
	else print('SERVER MOCKS: invalid game setup parameter')
	end
end
SERVER_MOCKS['Run Events'] = function(data)
return {
	type='Run Events',
	moves = {
		p1=data,
		p2={
		{
			name = 'Move',
			params = {
				"S",
				1
			}
		}},
		enemy = {
		{
			name = 'Move',
			params = {
				"S",
				1
			}
		},
		{
			name = 'Move',
			params = {
				"E",
				1
			}
		},
		{
			name = 'Move',
			params = {
				"N",
				1
			}
		}}
	}
}
end
SERVER_MOCKS['Game Over'] = {
	type='Game Over',
	winner='User 1'
}