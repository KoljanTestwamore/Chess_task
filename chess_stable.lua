function iterate(n, point, board, step, temp_checked, total_checked)
	--[[if total_checked[point] then
		return
	else total_checked[point] = true
	end]]--
	x = point // n
	y = point % n
	for _, x_sign in pairs {1, -1} do
		for _, y_sign in pairs {1, -1} do
			xt = x + x_sign * 2
			yt = y + y_sign * 1

			if xt < n and xt >= 0
			and yt < n and yt >= 0
			and not total_checked[n * xt + yt] then
				temp_checked[#temp_checked + 1] = n * xt + yt
				total_checked[n * xt + yt] = true
				if board[n * xt + yt] < step then
					board[n * xt + yt] = step
				end
			end

			xt = x + x_sign * 1
			yt = y + y_sign * 2

			if xt < n and xt >= 0
			and yt < n and yt >= 0
			and not total_checked[n * xt + yt] then
				temp_checked[#temp_checked + 1] = n * xt + yt
				total_checked[n * xt + yt] = true
				if board[n * xt + yt] < step then
					board[n * xt + yt] = step
				end
			end
		end
	end
end

io.write("Enter board size and starting boxes of knights\n")
input = io.read()

args = {}

for token in string.gmatch(input, "%d+") do
   args[#args + 1] = token * 1
end

n = args[1]
knights = {}
flag = 1

for i, int in pairs({table.unpack(args,2)}) do
	if flag == 1 then
		knights[#knights + 1] = {}
		knights[#knights][1] = int
		flag = 2
	else
		knights[#knights][2] = int
		flag = 1
	end
end

board = {} -- We can instead make one dimensional array, since Lua supports tables, that start and end with any integer
for i = 0, (n - 1) do
	for j = 0, (n - 1) do
		board[n * i + j] = -1
	end
end

overall_time = 0

for knight_n, knight in pairs(knights) do
	io.write("Starting calculations for knight n",knight_n,"\n")
	local total_checked = {}
	--[[for i = 0, (n - 1) do
		for j = 0, (n - 1) do
			total_checked[n * i + j] = false
		end
	end]]--
	time = os.clock()
	local checked = {}
	checked[1] = n * knight[1] + knight[2]
	total_checked[n * knight[1] + knight[2]] = true
	local step = 0
	if board[n * knight[1] + knight[2]] == -1 then board[n * knight[1] + knight[2]] = 0 end
	while not (#checked == 0) do
		step = step + 1
		local temp_checked = {}
		for _, point in pairs(checked) do
			iterate(n, point, board, step, temp_checked, total_checked)
		end
		checked = temp_checked
	end
	overall_time = overall_time + os.clock() - time
end

min = n
meeting_points = {}
for i = 0, (n - 1) do
	for j = 0, (n - 1) do
		--io.write(board[n * i + j], " ")
		if board[n * i + j] < min then
			min = board[n * i + j]
			meeting_points = {}
			meeting_points[#meeting_points + 1] = n * i + j
		elseif board[n * i + j] == min then
			meeting_points[#meeting_points + 1] = n * i + j
		end
	end
	--io.write("\n")
end

for _, p in pairs(meeting_points) do
	io.write("(",p // n, ",", p % n, ") ")
end

io.write("\nTotal meeting points: ", #meeting_points,"\nCan meet in ",min, " steps. Took me ", overall_time , "s" )
