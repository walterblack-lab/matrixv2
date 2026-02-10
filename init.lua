-- MATRIX HUB OFFICIAL LOADER
-- User: walterblack-lab | Repo: matrix

local base = "https://raw.githubusercontent.com/walterblack-lab/matrix/refs/heads/main/"

-- Modulok betöltése a megadott mappákból
_G.Matrix_Modules = {
    Net = loadstring(game:HttpGet(base .. "modules/net.lua"))(),
    Tween = loadstring(game:HttpGet(base .. "modules/tween.lua"))(),
}

-- Fő menü betöltése
if _G.Matrix_Modules.Net and _G.Matrix_Modules.Tween then
    loadstring(game:HttpGet(base .. "main.lua"))()
    print("Matrix Hub: Sikeresen betöltve!")
else
    warn("Matrix Hub: Hiba a modulok betöltésekor! Ellenőrizd a GitHub mappákat.")
end
