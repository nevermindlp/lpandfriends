local targetTable = {};
function creatTable()
	--local t1 = {id = 1000, winner = {"a"}, failure = {"b","c"}};
	--local t2 = {id = 2000, winner = {a}, failure = {b,c}};
	--table.insert(targetTable,t1);
	--table.insert(targetTable,t2);
	local t1 = {id = 1000};
	local t2 = {id = 2000};
	table.insert(targetTable,t1);
	table.insert(targetTable,t2);

	if targetTable["3000"] then
		targetTable["3000"].winner = {player = "lp"};
		if targetTable["3000"].failure then
			local ct1 = {player = "b"};
			table.insert(targetTable["3000"].failure,ct1);
		else
			targetTable["3000"].failure = {};
		end
	else
		targetTable["3000"] = {};
		targetTable["3000"]["winner"] = {player = "lpp"};
	end

	if targetTable["3000"] then
		targetTable["3000"].winner = {player = "lp"};
		if targetTable["3000"].failure then
			local ct1 = {player = "b"};
			table.insert(targetTable["3000"].failure,ct1);
		else
			targetTable["3000"].failure = {};
		end
	else
		targetTable["3000"] = {};
	end

	if targetTable["3000"] then
		targetTable["3000"].winner = {player = "lp"};
		if targetTable["3000"].failure then
			local ct1 = {player = "b"};
			table.insert(targetTable["3000"].failure,ct1);
		else
			targetTable["3000"].failure = {};
		end
	else
		targetTable["3000"] = {};
	end

end

function test()
	for k,v in pairs(targetTable) do
		print(k);
		print(v["id"]);
		v.info = {winner = "a", failure = {b,c} , test = {ttt}};
	end

	for k,v in pairs(targetTable) do
		print(v["info"]["failure"]);
	end

end


creatTable();
test();
