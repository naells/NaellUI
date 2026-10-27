--[[
          __                 __   __   __
  _______/  |_  ____ _____  |  |_/  |_|  |__ ___  ___
 /  ___/\   __\/ __ \\__  \ |  |\   __\  |  \\  \/  /
 \___ \  |  | \  ___/ / __ \|  |_|  | |   Y  \>    <
/____  > |__|  \___  >____  /____/__| |___|  /__/\_ \
     \/            \/     \/               \/      \/

]]

local j = { spaces = 4, highlighting = false };
local m = clonefunction;
local G = string;
local D = game;
local W = m(G.sub);
local q = m(G.format);
local L = m(G.rep);
local B = m(G.byte);
local o = m(G.match);
local r = m(D.GetFullName);
local S = m(debug.getinfo);
local a = math.huge;
local H = m(typeof);
local F = m(pairs);
local Z = m(assert);
local s = m(tostring);
local R = m(table.concat);
local x = m(getmetatable);
local f = m(rawget);
local J = m(rawset);
local t = L(" ", j.spaces or 4);
local v;
local M = {
		Axes = true,
		BrickColor = true,
		CatalogSearchParams = true,
		CFrame = true,
		Color3 = true,
		ColorSequence = true,
		ColorSequenceKeypoint = true,
		DateTime = true,
		DockWidgetPluginGuiInfo = true,
		Enum = true,
		Faces = true,
		Instance = true,
		NumberRange = true,
		NumberSequence = true,
		NumberSequenceKeypoint = true,
		OverlapParams = true,
		PathWaypoint = true,
		PhysicalProperties = true,
		Random = true,
		Ray = true,
		RaycastParams = true,
		RaycastResult = true,
		Rect = true,
		Region3 = true,
		Region3int16 = true,
		TweenInfo = true,
		UDim = true,
		UDim2 = true,
		Vector2 = true,
		Vector2int16 = true,
		Vector3 = true,
		Vector3int16 = true,
	};
local function Q(j)
	local m, G, D = x(j);
	if not m or H(m) ~= "table" then
		return s(j);
	end;
	D = f(m, "__tostring");
	J(m, "__tostring", nil);
	G = s(j);
	J(m, "__tostring", D);
	return G;
end;
local function V(...)
	local j = {};
	for m, G in F({ ... }) do
		local D = H(G);
		local W = #j + 1;
		if D == "string" then
			j[W] = q("\027[32m\"%s\"\027[0m", G);
		elseif D == "table" then
			j[W] = v(G, 0);
		else
			j[W] = Q(G);
		end;
	end;
	return R(j, ", ");
end;
local function T(j)
	if S then
		local m = S(j);
		local G = {};
		if m.nparams then
			for j = 1, m.nparams, 1 do
				G[j] = q("p%d", j);
			end;
			if m.isvararg then
				G[#G + 1] = "...";
			end;
		end;
		return q("function (%s) --[[ Function Name: \"%s\" ]] end", R(G, ", "), m.namewhat or m.name or "");
	end;
	return "function () end";
end;
local function N(j)
	local m = 1;
	local G = {};
	while m <= #j do
		local D = W(j, m, m);
		if D == "\n" then
			G[m] = "\\n";
		elseif D == "\009" then
			G[m] = "\\t";
		elseif D == "\"" then
			G[m] = "\\\"";
		else
			local j = B(D);
			if j < 32 or j > 126 then
				G[m] = q("\\%d", j);
			else
				G[m] = D;
			end;
		end;
		m = m + 1;
	end;
	return R(G);
end;
local function l(j)
	if j == a then
		return "math.huge";
	elseif j == -a then
		return "-math.huge";
	end;
	return Q(j);
end;
local function K(m, G)
	local D = H(m);
	local W = m;
	if D == "string" then
		if o(m, "[^_%a%d]+") then
			W = q(j.highlighting and "\027[32m\"%s\"\027[0m" or "\"%s\"", N(m));
		else
			return m;
		end;
	elseif D == "table" then
		G = G + 1;
		W = v(m, G);
	elseif D == "number" or D == "boolean" then
		if j.highlighting then
			W = q("\027[33m%s\027[0m", l(m));
		else
			W = l(m);
		end;
	elseif D == "function" then
		W = T(m);
	elseif D == "Instance" then
		W = r(m);
	else
		W = Q(m);
	end;
	return q("[%s]", W);
end;
v = function(m, G, D)
		D = D or {};
		if D[m] then
			return q("\"%s -- recursive table\"", Q(m));
		end;
		D[m] = true;
		G = G or 0;
		local B = {};
		local o = L(t, G);
		local S = L(t, G + 1);
		local a = 0;
		for m, W in F(m) do
			local L = a + 1 ~= m;
			local o = q(L and "%s = " or "", K(m, G));
			local F = H(W);
			local Z = #B + 1;
			if F == "string" then
				B[Z] = q(j.highlighting and "%s%s\027[32m\"%s\"\027[0m,\n" or "%s%s\"%s\",\n", S, o, N(W));
			elseif F == "number" or F == "boolean" then
				B[Z] = q(j.highlighting and "%s%s\027[33m%s\027[0m,\n" or "%s%s%s,\n", S, o, l(W));
			elseif F == "table" then
				B[Z] = q("%s%s%s,\n", S, o, v(W, G + 1, D));
			elseif F == "userdata" then
				B[Z] = q("%s%s newproxy(),\n", S, o);
			elseif F == "function" then
				B[Z] = q("%s%s%s,\n", S, o, T(W));
			elseif F == "Instance" then
				B[Z] = q("%s%s%s,\n", S, o, r(W));
			elseif M[F] then
				B[Z] = q("%s%s%s.new(%s),\n", S, o, F, Q(W));
			else
				B[Z] = q("%s%s\"%s\",\n", S, o, Q(W));
			end;
			a = a + 1;
		end;
		local Z = B[#B];
		if Z then
			B[#B] = W(Z, 0, -3) .. "\n";
		end;
		if a > 0 then
			if G < 1 then
				return q("{\n%s}", R(B));
			else
				return q("{\n%s%s}", R(B), o);
			end;
		else
			return "{}";
		end;
	end;
local h = {};
function h.Serialize(j)
	if H(j) ~= "table" then
		error("invalid argument #1 to \'Serialize\' (table expected)");
	end;
	Z(H(j) == "table", "");
	return v(j);
end;
function h.FormatArguments(...)
	return V(...);
end;
function h.FormatString(j)
	if H(j) ~= "string" then
		error("invalid argument #1 to \'FormatString\' (string expected)");
	end;
	return N(j);
end;
function h.UpdateConfig(m)
	Z(H(m) == "table", "invalid argument #1 to \'UpdateConfig\' (table expected)");
	j.spaces = m.spaces or 4;
	j.highlighting = m.highlighting;
	t = L(" ", j.spaces or 4);
end;
return h;
