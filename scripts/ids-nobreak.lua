-- Verhindert Zeilenumbrüche innerhalb von IDs wie RR-2, QZ-4, SH-17 oder A-13:
-- ersetzt den Bindestrich durch einen geschützten Bindestrich (U+2011).
function Str(el)
  el.text = el.text:gsub("(%f[%w]%u%u?%u?)%-(%d+)", "%1\u{2011}%2")
  el.text = el.text:gsub("(%f[%w]%u%u?%u?)%-x%f[%W]", "%1\u{2011}x")
  return el
end

-- „**Name** · *Merkmal*“ in Tabellenzellen: Mittelpunkt durch Zeilenumbruch ersetzen
function Inlines(inl)
  for i = 1, #inl - 3 do
    if inl[i].t == "Strong" and inl[i + 1].t == "Space" and inl[i + 2].t == "Str"
       and inl[i + 2].text == "·" and inl[i + 3].t == "Space" then
      inl:remove(i + 3)
      inl:remove(i + 2)
      inl[i + 1] = pandoc.LineBreak()
      return inl
    end
  end
  -- „**Name** (Merkmal)“ in Tabellenzellen: Merkmal immer in die nächste Zeile
  if #inl >= 3 and inl[1].t == "Strong" and inl[2].t == "Space" and inl[3].t == "Str"
     and inl[3].text:sub(1, 1) == "(" then
    inl[2] = pandoc.LineBreak()
  end
  return inl
end

-- Randbedingungs-Tabellen mit kurzen Titeln (Kap. 2.1, IDs TR-x): Klasse „rb“,
-- damit die Titelspalte im PDF breiter wird. Weitere Präfixe hier ergänzen, sobald umgestellt.
-- Aufzählung in Tabellenzellen: jedes „•“ startet einen Punkt. Text vor dem ersten „•“
-- bleibt ein normaler Einleitungssatz über der Liste.
-- Pipe-Tabellen bleiben im Markdown einzeilig und lesbar, Word und PDF zeigen echte Listen.
local function zelle_als_liste(blocks)
  if #blocks ~= 1 or (blocks[1].t ~= "Plain" and blocks[1].t ~= "Para") then return nil end
  local inl = blocks[1].content
  local hat = false
  for _, el in ipairs(inl) do if el.t == "Str" and el.text == "•" then hat = true break end end
  if not hat then return nil end
  local einleitung, punkte, aktuell = pandoc.Inlines({}), {}, nil
  for _, el in ipairs(inl) do
    if el.t == "Str" and el.text == "•" then
      aktuell = pandoc.Inlines({})
      table.insert(punkte, aktuell)
    elseif aktuell == nil then
      einleitung:insert(el)
    elseif not (el.t == "Space" and #aktuell == 0) then
      aktuell:insert(el)
    end
  end
  while #einleitung > 0 and einleitung[#einleitung].t == "Space" do einleitung:remove(#einleitung) end
  local items = {}
  for _, p in ipairs(punkte) do
    while #p > 0 and p[#p].t == "Space" do p:remove(#p) end
    table.insert(items, { pandoc.Plain(p) })
  end
  local out = {}
  if #einleitung > 0 then table.insert(out, pandoc.Para(einleitung)) end
  table.insert(out, pandoc.BulletList(items))
  return out
end

local function listen_in_zellen(t)
  for _, body in ipairs(t.bodies) do
    for _, row in ipairs(body.body) do
      for _, c in ipairs(row.cells) do
        local liste = zelle_als_liste(c.contents)
        if liste then c.contents = liste end
      end
    end
  end
end

local kurz = { TR = true, OR = true, KV = true }
-- feste Spaltenbreiten (Anteile der Textbreite) für einzelne Tabellen, gilt für Word und PDF
local breiten = { SH = { 0.09, 0.22, 0.69 }, QZ = { 0.09, 0.27, 0.64 }, F = { 0.09, 0.27, 0.64 }, H = { 0.09, 0.27, 0.64 }, B = { 0.08, 0.24, 0.68 }, P = { 0.09, 0.27, 0.64 }, TE = { 0.08, 0.2, 0.54, 0.18 }, ST = { 0.07, 0.37, 0.24, 0.15, 0.17 }, OE = { 0.08, 0.3, 0.45, 0.17 }, S = { 0.06, 0.19, 0.21, 0.2, 0.07, 0.27 } }
function Table(t)
  listen_in_zellen(t)
  for _, body in ipairs(t.bodies) do
    for _, row in ipairs(body.body) do
      local id = pandoc.utils.stringify(row.cells[1].contents)
      local praefix = id:match("^(%u+)\u{2011}") or id:match("^(%u+)%-") or id:match("^(%u+)%d+$")
      if praefix then
        if kurz[praefix] then t.classes:insert("rb") end
        if praefix == "SH" then t.classes:insert("zusammen") end
        local b = breiten[praefix]
        if b and #t.colspecs == #b then
          for i, w in ipairs(b) do t.colspecs[i] = { t.colspecs[i][1], w } end
        end
        return t
      end
    end
  end
  return t
end

-- Überschrift mit Klasse „neue-seite“ beginnt auf einer neuen Seite (PDF per CSS, Word per Seitenumbruch)
function Header(h)
  if h.classes:includes("neue-seite") and FORMAT:match("docx") then
    return { pandoc.RawBlock("openxml", '<w:p><w:r><w:br w:type="page"/></w:r></w:p>'), h }
  end
  return h
end

-- „<br>“ im Markdown (z. B. in Pipe-Tabellen) wird ein echter Zeilenumbruch, auch in Word
function RawInline(r)
  if r.format == "html" and r.text:match("^<br%s*/?>$") then return pandoc.LineBreak() end
end
