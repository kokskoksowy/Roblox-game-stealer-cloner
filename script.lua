local plr = game.Players.LocalPlayer
local czekanie = 0
local MainString = ""
local textLenght = 1000000
local brakuje
local HttpService = game:GetService("HttpService")

local screenGui = Instance.new("ScreenGui",plr.PlayerGui)
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = math.huge

local scrolingFrame = Instance.new("ScrollingFrame",screenGui)
scrolingFrame.Size = UDim2.new(0.184, 0,0.411, 0)
scrolingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
scrolingFrame.Position = UDim2.new(0, 0,0.129, 0)
local list = Instance.new("UIListLayout",scrolingFrame)
local cloneButton = Instance.new("TextButton",screenGui)
cloneButton.Size = UDim2.new(0.184, 0,0.08, 0)
cloneButton.Position = UDim2.new(0, 0,0.539, 0)
cloneButton.BackgroundColor3 = Color3.new(0.333333, 1, 0)
cloneButton.TextScaled = true
cloneButton.Text = "Clone Game"
if game.ReplicatedStorage:FindFirstChild("MainFolder") then
	game.ReplicatedStorage.MainFolder:Destroy()
end
local MainFolder




local activated = false
local objects
cloneButton.MouseButton1Up:Connect(function()
	if activated then return else activated = true end
	brakuje = {}
	MainFolder = Instance.new("Folder",game.ReplicatedStorage)
	MainFolder.Name = "MainFolder"
	CreateFoldersFUNCTION()
	objects = MainFolder:GetDescendants()
	wait(1)
	ChangeNamesFUNCTION()
	wait(1)
	CreatingLocFUNCTION()
	wait(1)
	CloneFUNCTION()
	MainFolder:Destroy()
	wait(1)
	createButtonsFUNCTION()
	wait(1)
	activated = false
	cloneButton.Text = "Clone Game"
end)

local function createFolder(obj,name)
	local newFolder = Instance.new("Folder",MainFolder)
	newFolder.Name = name or obj.Name
	for i,child in pairs(obj:GetChildren()) do
		if child.Archivable == false then
			child.Archivable = true
			local ChangeArchivable = Instance.new("RayValue",child)
			ChangeArchivable.Name = "ChangeArchivable"
		end
		local success, result = pcall(function()
			local klon = child:Clone()
			klon.Parent = newFolder
		end)

		if not success then
			warn("twożenie folderu: "..result)
		end
	end
end
function CreateFoldersFUNCTION()
	cloneButton.Text = "Creating folders"-------------------------------------------

	createFolder(game.Lighting)
	createFolder(plr.PlayerGui,"CurrentGui")
	createFolder(game.StarterGui)
	createFolder(game.ReplicatedStorage)
	createFolder(workspace)
	wait(0.5)
	cloneButton.Text = "Succes1"--------------------------------------------------
end

local function filterText(text)
	text = string.gsub(text,"?","?1")
	text = string.gsub(text,"ChangeArchivable","?2")
	text = string.gsub(text,"#","?3")
	text = string.gsub(text,"*","?4")
	text = string.gsub(text,"MainFolder","?5")
	text = string.gsub(text,"_","?6")
	text = string.gsub(text,":","?7")
	text = string.gsub(text," ","?8")
	return text
end
function ChangeNamesFUNCTION()
	cloneButton.Text = "Changing names"-------------------------------------------
	local saveAmount = #objects
	for i,child in pairs(objects) do
		child.Name = filterText(child.Name).."#"..i
		cloneButton.Text = "Changing names "..i.."/"..saveAmount
		if czekanie >= 500 then task.wait() czekanie = 0 else czekanie+= 1 end
	end

	cloneButton.Text = "Succes2"--------------------------------------------------
end
function CreatingLocFUNCTION()
	local iloscOBJ = #objects
	local function returnLoc(obj)
		local toReturn = ""

		local current = obj.Parent
		while current.Name ~= "MainFolder" do
			toReturn = current.Name.."*"..toReturn
			current = current.Parent
		end
		return toReturn
	end
	local lokalizacje = {}
	for i,child in pairs(objects) do
		local success, result = pcall(function()
			local loc = Instance.new("StringValue")
			loc.Name = "Loc"
			loc.Parent = child
			loc.Value = returnLoc(child)
			table.insert(lokalizacje,loc)
		end)
		if not success then
			warn(child,result)
		end
		if czekanie >= 500 then 
			czekanie = 0
			task.wait()
			cloneButton.Text = "Addod Localizations ("..i.."/"..iloscOBJ..")"
		else czekanie += 1 end
	end
	cloneButton.Text = "Succes3"--------------------------------------------------
end
local function CodeObject(object)
	if object:IsA("Pose") then
		return ""
	end
	local codeddStr = ""
	local success, result = pcall(function()
		codeddStr = "c:"..object.ClassName
		codeddStr = codeddStr .. "_n:"..tostring(object.Name)
		codeddStr = codeddStr .. "_l:"..tostring(object.Loc.Value)
		if object:IsA("BasePart") then--------------------------------------------------------------------------
			codeddStr = codeddStr .. "_Bp:"..tostring(object.Position.X.."="..object.Position.Y.."="..object.Position.Z)
			codeddStr = codeddStr .. "_Bs:"..tostring(object.Size.X.."="..object.Size.Y.."="..object.Size.Z)
			codeddStr = codeddStr .. "_Bc:"..tostring(object.Color.R.."="..object.Color.G.."="..object.Color.B)
			codeddStr = codeddStr .. "_Br:"..tostring(object.Orientation.X.."="..object.Orientation.Y.."="..object.Orientation.Z)
			if object.Transparency ~= 0 then
				codeddStr = codeddStr .. "_Bt:"..tostring(object.Transparency)
			end
			if object.CastShadow ~= true then
				codeddStr = codeddStr .. "_Bcs:"
			end
			if object.CanCollide ~= true then
				codeddStr = codeddStr .. "_Bcc:"
			end
			if object.CanTouch ~= true then
				codeddStr = codeddStr .. "_Bct:"
			end
			if object.CanQuery ~= true then
				codeddStr = codeddStr .. "_Bcq:"
			end
			if object.Material ~= Enum.Material.Plastic then
				codeddStr = codeddStr .. "_Bm:" ..tostring(object.Material.Value)
			end
			if object.Anchored == false then
				codeddStr = codeddStr .. "_Ba:"
			end
			if not object:IsA("WedgePart") and not object:IsA("MeshPart") and not object:IsA("CornerWedgePart") and object.Shape.Value ~= 1 then
				codeddStr = codeddStr .. "_Bs:" ..tostring(object.Shape.Value)
			end

			if object.BackSurface.Value ~= 0 then------------------surfaces
				codeddStr = codeddStr .. "_Bbs:" ..tostring(object.BackSurface.Value)
			end
			if object.BottomSurface.Value ~= 0 then
				codeddStr = codeddStr .. "_Bbts:" ..tostring(object.BottomSurface.Value)
			end
			if object.FrontSurface.Value ~= 0 then
				codeddStr = codeddStr .. "_Bfs:" ..tostring(object.FrontSurface.Value)
			end
			if object.LeftSurface.Value ~= 0 then
				codeddStr = codeddStr .. "_Bls:" ..tostring(object.LeftSurface.Value)
			end
			if object.RightSurface.Value ~= 0 then
				codeddStr = codeddStr .. "_Brs:" ..tostring(object.RightSurface.Value)
			end
			if object.TopSurface.Value ~= 0 then
				codeddStr = codeddStr .. "_Bts:" ..tostring(object.TopSurface.Value)
			end
		elseif object:IsA("Decal") then-------------------------------------------------------------------
			if object.Texture ~= nil or object.Texture ~= "" then
				codeddStr = codeddStr .. "_Dt:" ..tostring(string.gsub(object.Texture,":","?1"))
			end
			if object.Face ~= 5 then
				codeddStr = codeddStr .. "_Df:" ..tostring(object.Face.Value)
			end
			if object.Transparency ~= 0 then
				codeddStr = codeddStr .. "_Dtr:" ..tostring(object.Face.Value)
			end
			if object.ZIndex ~= 1 then
				codeddStr = codeddStr .. "_Dz:" ..tostring(object.Face.Value)
			end
		elseif object:IsA("Attachment") then-------------------------------------------------------------------
			codeddStr = codeddStr .. "_Ap:"..tostring((object.Position.X).."="..(object.Position.Y).."="..(object.Position.Z))
			codeddStr = codeddStr .. "_Ar:"..tostring((object.Orientation.X).."="..(object.Orientation.Y).."="..(object.Orientation.Z))
			codeddStr = codeddStr .. "_Ax:"..tostring((object.Axis.X).."="..(object.Axis.Y).."="..(object.Axis.Z))
			codeddStr = codeddStr .. "_Asx:"..tostring((object.SecondaryAxis.X).."="..(object.SecondaryAxis.Y).."="..(object.SecondaryAxis.Z))

			codeddStr = codeddStr .. "_Awp:"..tostring((object.WorldPosition.X).."="..(object.WorldPosition.Y).."="..(object.WorldPosition.Z))
			codeddStr = codeddStr .. "_Awr:"..tostring((object.WorldOrientation.X).."="..(object.WorldOrientation.Y).."="..(object.WorldOrientation.Z))
			codeddStr = codeddStr .. "_Awx:"..tostring((object.WorldAxis.X).."="..(object.WorldAxis.Y).."="..(object.WorldAxis.Z))
			codeddStr = codeddStr .. "_Awsx:"..tostring((object.WorldSecondaryAxis.X).."="..(object.WorldSecondaryAxis.Y).."="..(object.WorldSecondaryAxis.Z))

			if object.Visible ~= false then
				codeddStr = codeddStr .. "_Av:" ..tostring(object.Visible)
			end
		elseif object:IsA("ValueBase") then-------------------------------------------------------------------
			if object:IsA("BoolValue") and object.Value ~= false then
				codeddStr = codeddStr .. "_Vb:"
			elseif object:IsA("BrickColorValue") then
				codeddStr = codeddStr .. "_Vbc:"..object.Value.Number
			elseif object:IsA("CFrameValue") then
				codeddStr = codeddStr .. "_Vcf:"..tostring((object.Value.Position.X).."="..(object.Value.Position.Y).."="..(object.Value.Position.Z).."="..(object.Value.Rotation.X).."="..(object.Value.Rotation.Y).."="..(object.Value.Rotation.Z))
			elseif object:IsA("Color3Value") then
				codeddStr = codeddStr .. "_Vc:"..tostring(object.Value.R.."="..object.Value.G.."="..object.Value.B)
			elseif object:IsA("IntValue") or object:IsA("NumberValue") then
				codeddStr = codeddStr .. "_V:"..object.Value
			elseif object:IsA("Vector3Value") then
				codeddStr = codeddStr .. "_V3:"..tostring((object.Value.X).."="..(object.Value.Y).."="..(object.Value.Z))
			elseif object:IsA("StringValue") then
				codeddStr = codeddStr .. "_V:"..filterText(object.Value)

			end

		else
			if brakuje[object.ClassName] then
				brakuje[object.ClassName] += 1

			else
				brakuje[object.ClassName] = 1
			end

		end
		codeddStr = codeddStr.." "
	end)
	if not success then
		warn(result)
	end
	
	return codeddStr
end
local MainString

function CloneFUNCTION()
	local stringParts = {}  -- Utwórz pustą tablicę do przechowywania fragmentów stringa.
	local iloscOBJ = #objects

	for i, child in pairs(objects) do
		table.insert(stringParts, CodeObject(child)) -- Dodaj fragment stringa z CodeObject do tablicy.

		if czekanie >= 500 then
			czekanie = 0
			task.wait()
			cloneButton.Text = "Copying game (" .. i .. "/" .. iloscOBJ .. ")"
		else
			czekanie = czekanie + 1
		end
	end

	cloneButton.Text = "łączenie textu w jeden string"
	MainString = table.concat(stringParts)  -- Połącz wszystkie fragmenty stringa w tablicy w jeden string.
	cloneButton.Text = "Succes4"
end


function createButtonsFUNCTION()
	print(MainString)
	writefile("GameCopy.txt",MainString)
	cloneButton.Text = "Succes5"
end
