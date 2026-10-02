vim.cmd.highlight("clear")
vim.g.colors_name = "dark_mono"

local C = {
  bg01            = "#0a0a0a",
  bg02            = "#0f0f0f",
  bg03            = "#181818",
  txt_highlight   = "#eeeeee",
  txt_primary     = "#c0c0c0",
  txt_secondary   = "#999999",
  txt_tertiary    = "#777777",
  txt_selection_bg = "#1f1a18",
  txt_selection_fg = "#aa9966",
  accent_bg       = "#aa9966",
  accent_fg       = "#aa9966",
  cursor_primary  = "#aa9966",
  cursor_secondary = "#665522",
}

local function hl(group, opts)
  vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hl("Normal",        { fg = C.txt_primary, bg = C.bg01 })
hl("NormalNC",      { fg = C.txt_secondary, bg = C.bg01 })
hl("NormalFloat",   { fg = C.txt_secondary, bg = C.bg02 })
hl("FloatBorder",   { fg = C.bg02, bg = C.bg02 })
hl("FloatTitle",    { fg = C.accent_fg, bg = C.bg02 })
hl("Cursor",        { bg = C.cursor_secondary, fg = "#000000" })
hl("CursorLine",    { bg = C.bg02 })
hl("CursorLineNr",  { fg = C.txt_primary, bg = C.bg02, bold = true })
hl("MatchParen",    { fg = C.txt_highlight, underline = true })
hl("Visual",        { bg = C.txt_selection_bg, fg = C.txt_selection_fg })
hl("VisualNOS",     { bg = C.txt_selection_bg, fg = C.txt_selection_fg })
hl("LineNr",        { fg = C.txt_tertiary, bg = C.bg01 })
hl("SignColumn",    { bg = C.bg01 })
hl("FoldColumn",    { bg = C.bg01 })
hl("ColorColumn",   { bg = C.bg03 })
hl("StatusLine",    { fg = C.accent_fg, bg = C.bg02 })
hl("StatusLineNC",  { fg = C.txt_tertiary, bg = C.bg02 })
hl("TabLine",       { fg = C.txt_tertiary, bg = C.bg01 })
hl("TabLineFill",   { bg = C.bg01 })
hl("TabLineSel",    { fg = C.txt_secondary, bg = C.bg01 })
hl("WinSeparator",  { fg = C.txt_tertiary })
hl("WildMenu",      { fg = C.bg01, bg = C.accent_bg })
hl("Pmenu",         { fg = C.txt_secondary, bg = C.bg02 })
hl("PmenuSel",      { fg = C.txt_selection_fg, bg = C.txt_selection_bg })
hl("PmenuSbar",     { bg = C.bg03 })
hl("PmenuThumb",    { bg = C.txt_tertiary })
hl("Question",      { fg = C.accent_fg })
hl("MoreMsg",       { fg = C.txt_primary })
hl("WarningMsg",    { fg = C.accent_fg })
hl("ErrorMsg",      { fg = C.txt_primary, bold = true })
hl("ModeMsg",       { fg = C.txt_secondary })
hl("MsgArea",       { fg = C.txt_secondary })
hl("NonText",       { fg = C.txt_tertiary })
hl("Whitespace",    { fg = C.txt_tertiary })
hl("SpecialKey",    { fg = C.txt_tertiary })
hl("Conceal",       { fg = C.txt_tertiary })
hl("Directory",     { fg = C.txt_primary })
hl("Title",         { fg = C.txt_primary, bold = true })

hl("Search",        { bg = C.txt_selection_bg, fg = C.accent_fg })
hl("IncSearch",     { bg = C.accent_fg, fg = C.bg01 })
hl("Substitute",    { bg = C.txt_selection_bg, fg = C.accent_fg })

-- Syntax
hl("Comment",       { fg = C.txt_tertiary, italic = true })
hl("Constant",      { fg = C.txt_primary })
hl("String",        { fg = C.txt_tertiary })
hl("Character",     { fg = C.txt_tertiary })
hl("Number",        { fg = C.txt_primary })
hl("Boolean",       { fg = C.txt_primary })
hl("Float",         { fg = C.txt_primary })
hl("Identifier",    { fg = C.txt_primary })
hl("Function",      { fg = C.txt_primary })
hl("Statement",     { fg = C.txt_primary })
hl("Conditional",   { fg = C.txt_primary })
hl("Repeat",        { fg = C.txt_primary })
hl("Label",         { fg = C.txt_primary })
hl("Operator",      { fg = C.txt_primary })
hl("Keyword",       { fg = C.txt_primary })
hl("Exception",     { fg = C.txt_primary })
hl("PreProc",       { fg = C.txt_primary })
hl("Include",       { fg = C.txt_primary })
hl("Define",        { fg = C.txt_primary })
hl("Macro",         { fg = C.txt_primary })
hl("PreCondit",     { fg = C.txt_primary })
hl("Type",          { fg = C.txt_primary })
hl("StorageClass",  { fg = C.txt_primary })
hl("Structure",     { fg = C.txt_primary })
hl("Typedef",       { fg = C.txt_primary })
hl("Special",       { fg = C.txt_primary })
hl("SpecialChar",   { fg = C.txt_tertiary })
hl("Tag",           { fg = C.txt_primary })
hl("Delimiter",     { fg = C.txt_primary })
hl("SpecialComment", { fg = C.txt_tertiary })
hl("Debug",         { fg = C.txt_tertiary })
hl("Underlined",    { fg = C.accent_fg, underline = true })
hl("Bold",          { bold = true })
hl("Italic",        { italic = true })
hl("Strikethrough", { strikethrough = true })
hl("Todo",          { fg = C.accent_fg, bold = true })

-- Diff
hl("DiffAdd",       { fg = C.txt_primary, bold = true })
hl("DiffChange",    { fg = C.accent_fg })
hl("DiffDelete",    { fg = C.txt_primary, bold = true })
hl("DiffText",      { fg = C.accent_fg })

-- Spell
hl("SpellBad",      { undercurl = true, sp = C.txt_tertiary })
hl("SpellCap",      { undercurl = true, sp = C.txt_tertiary })
hl("SpellLocal",    { undercurl = true, sp = C.txt_tertiary })
hl("SpellRare",     { undercurl = true, sp = C.txt_tertiary })

-- Diagnostic
hl("DiagnosticError",            { fg = C.txt_primary, bold = true })
hl("DiagnosticWarn",             { fg = C.accent_fg })
hl("DiagnosticInfo",             { fg = C.txt_secondary })
hl("DiagnosticHint",             { fg = C.txt_tertiary })
hl("DiagnosticOk",               { fg = C.txt_tertiary })
hl("DiagnosticUnderlineError",   { underline = true, sp = C.txt_primary })
hl("DiagnosticUnderlineWarn",    { underline = true, sp = C.accent_fg })
hl("DiagnosticUnderlineInfo",    { underline = true, sp = C.txt_secondary })
hl("DiagnosticUnderlineHint",    { underline = true, sp = C.txt_tertiary })
hl("DiagnosticSignError",        { fg = C.txt_primary, bold = true })
hl("DiagnosticSignWarn",         { fg = C.accent_fg })
hl("DiagnosticSignInfo",         { fg = C.txt_secondary })
hl("DiagnosticSignHint",         { fg = C.txt_tertiary })
hl("DiagnosticFloatingError",    { fg = C.txt_primary, bold = true })
hl("DiagnosticFloatingWarn",     { fg = C.accent_fg })
hl("DiagnosticFloatingInfo",     { fg = C.txt_secondary })
hl("DiagnosticFloatingHint",     { fg = C.txt_tertiary })
hl("DiagnosticVirtualTextError", { fg = C.txt_primary, bold = true })
hl("DiagnosticVirtualTextWarn",  { fg = C.accent_fg })
hl("DiagnosticVirtualTextInfo",  { fg = C.txt_secondary })
hl("DiagnosticVirtualTextHint",  { fg = C.txt_tertiary })
hl("LspReferenceText",           { bg = C.txt_selection_bg })
hl("LspReferenceRead",           { bg = C.txt_selection_bg })
hl("LspReferenceWrite",          { bg = C.txt_selection_bg })
hl("LspInlayHint",               { fg = C.txt_tertiary, bg = C.bg03 })

-- Treesitter
local ts = {
  ["@comment"]              = "Comment",
  ["@comment.error"]        = "DiagnosticError",
  ["@comment.warning"]      = "DiagnosticWarn",
  ["@comment.todo"]         = "Todo",
  ["@comment.note"]         = "DiagnosticInfo",
  ["@none"]                 = "Normal",
  ["@preproc"]              = "PreProc",
  ["@define"]               = "Define",
  ["@string"]               = "String",
  ["@string.escape"]        = "SpecialChar",
  ["@string.regex"]         = "SpecialChar",
  ["@string.special"]       = "SpecialChar",
  ["@string.special.symbol"] = "SpecialChar",
  ["@string.special.path"]  = "SpecialChar",
  ["@string.special.url"]   = "Underlined",
  ["@character"]            = "Character",
  ["@character.special"]    = "SpecialChar",
  ["@number"]               = "Number",
  ["@boolean"]              = "Boolean",
  ["@float"]                = "Float",
  ["@function"]             = "Function",
  ["@function.builtin"]     = "Function",
  ["@function.call"]        = "Function",
  ["@function.method"]      = "Function",
  ["@function.method.call"] = "Function",
  ["@constructor"]          = "Structure",
  ["@operator"]             = "Operator",
  ["@keyword"]              = "Keyword",
  ["@keyword.function"]     = "Keyword",
  ["@keyword.return"]       = "Keyword",
  ["@keyword.operator"]     = "Keyword",
  ["@keyword.coroutine"]    = "Keyword",
  ["@keyword.import"]       = "Include",
  ["@keyword.type"]         = "Keyword",
  ["@keyword.modifier"]     = "Keyword",
  ["@keyword.repeat"]       = "Repeat",
  ["@keyword.conditional"]  = "Conditional",
  ["@keyword.debug"]        = "Debug",
  ["@keyword.exception"]    = "Exception",
  ["@keyword.directive"]    = "PreProc",
  ["@keyword.directive.define"] = "Define",
  ["@variable"]             = "Identifier",
  ["@variable.builtin"]     = "Identifier",
  ["@variable.parameter"]   = "Identifier",
  ["@variable.member"]      = "Identifier",
  ["@type"]                 = "Type",
  ["@type.builtin"]         = "Type",
  ["@type.definition"]      = "Typedef",
  ["@type.qualifier"]       = "Type",
  ["@attribute"]            = "PreProc",
  ["@property"]             = "Identifier",
  ["@label"]                = "Label",
  ["@namespace"]            = "Include",
  ["@punctuation.delimiter"] = "Delimiter",
  ["@punctuation.bracket"]  = "Delimiter",
  ["@punctuation.special"]  = "Special",
  ["@tag"]                  = "Tag",
  ["@tag.attribute"]        = "Identifier",
  ["@tag.delimiter"]        = "Delimiter",
  ["@markup.heading"]       = "Title",
  ["@markup.heading.1"]     = "Title",
  ["@markup.heading.2"]     = "Title",
  ["@markup.heading.3"]     = "Title",
  ["@markup.heading.4"]     = "Title",
  ["@markup.heading.5"]     = "Title",
  ["@markup.heading.6"]     = "Title",
  ["@markup.italic"]        = "Italic",
  ["@markup.bold"]          = "Bold",
  ["@markup.strikethrough"] = "Strikethrough",
  ["@markup.underline"]     = "Underlined",
  ["@markup.link"]          = "Underlined",
  ["@markup.link.url"]      = "Underlined",
  ["@markup.link.label"]    = "String",
  ["@markup.list"]          = "Special",
  ["@markup.list.checked"]  = "Special",
  ["@markup.list.unchecked"] = "Special",
  ["@markup.quote"]         = "Comment",
  ["@markup.raw"]           = "String",
  ["@markup.raw.block"]     = "String",
  ["@markup.math"]          = "Special",
  ["@diff.plus"]            = "DiffAdd",
  ["@diff.minus"]           = "DiffDelete",
  ["@diff.delta"]           = "DiffChange",
  ["@error"]                = "DiagnosticError",
  ["@spell"]                = "SpellBad",
  ["@nospell"]              = "Normal",
}
for group, target in pairs(ts) do
  vim.api.nvim_set_hl(0, group, { link = target })
end

-- Telescope
hl("TelescopeNormal",        { bg = C.bg02 })
hl("TelescopeBorder",        { fg = C.bg02, bg = C.bg02 })
hl("TelescopePromptNormal",  { bg = C.bg03 })
hl("TelescopePromptBorder",  { fg = C.bg03, bg = C.bg03 })
hl("TelescopeResultsNormal",  { bg = C.bg02 })
hl("TelescopeResultsBorder",  { fg = C.bg02, bg = C.bg02 })
hl("TelescopePreviewNormal",  { bg = C.bg01 })
hl("TelescopePreviewBorder",  { fg = C.bg01, bg = C.bg01 })
hl("TelescopeSelection",      { bg = C.txt_selection_bg })
hl("TelescopeTitle",          { fg = C.accent_fg, bold = true })
hl("TelescopePromptTitle",    { fg = C.accent_fg, bold = true })
hl("TelescopePreviewTitle",   { fg = C.accent_fg, bold = true })

-- Mini.nvim
hl("MiniStatuslineNormal",  { fg = C.accent_fg, bg = C.bg02 })
hl("MiniStatuslineInactive", { fg = C.txt_tertiary, bg = C.bg02 })
hl("MiniStatuslineFilename", { fg = C.txt_secondary, bg = C.bg03 })
hl("MiniStatuslineFileinfo", { fg = C.txt_tertiary, bg = C.bg03 })
hl("MiniFilesNormal",        { fg = C.txt_secondary, bg = C.bg01 })
hl("MiniFilesBorder",        { fg = C.bg01, bg = C.bg01 })
hl("MiniFilesTitle",         { fg = C.accent_fg, bg = C.bg01, bold = true })
hl("MiniFilesCursorLine",    { bg = C.bg02 })
hl("MiniIndentscopeSymbol",  { fg = C.txt_tertiary })

-- NvimTree
hl("NvimTreeNormal",          { fg = C.txt_secondary, bg = C.bg01 })
hl("NvimTreeRootFolder",      { fg = C.txt_primary, bold = true })
hl("NvimTreeGitDirty",        { fg = C.accent_fg })
hl("NvimTreeGitNew",          { fg = C.txt_primary })
hl("NvimTreeGitDeleted",      { fg = C.txt_primary, bold = true })
hl("NvimTreeOpenedFolderName", { fg = C.txt_primary })
hl("NvimTreeFolderIcon",      { fg = C.txt_tertiary })
hl("NvimTreeIndentMarker",    { fg = C.txt_tertiary })
hl("NvimTreeSymlink",         { fg = C.txt_primary })
hl("NvimTreeStatusLine",      { link = "StatusLineNC" })

-- blink.cmp
hl("BlinkCmpLabel",            { fg = C.txt_secondary })
hl("BlinkCmpLabelMatch",       { fg = C.accent_fg, bold = true })
hl("BlinkCmpLabelDetail",      { fg = C.txt_tertiary })
hl("BlinkCmpMenu",             { link = "Pmenu" })
hl("BlinkCmpMenuSelection",    { link = "PmenuSel" })
hl("BlinkCmpMenuBorder",       { link = "FloatBorder" })
hl("BlinkCmpDoc",              { link = "NormalFloat" })
hl("BlinkCmpDocBorder",        { link = "FloatBorder" })
hl("BlinkCmpScrollBarThumb",   { link = "PmenuThumb" })
hl("BlinkCmpScrollBarTrack",   { link = "PmenuSbar" })

-- nvim-dap-ui
hl("DapUINormal",              { bg = C.bg01 })
hl("DapUIFloatBorder",         { fg = C.accent_fg, bg = C.bg01 })
hl("DapUIWatchesNormal",       { bg = C.bg01 })
hl("DapUIVariable",            { fg = C.txt_secondary })
hl("DapUIValue",               { fg = C.txt_primary })
hl("DapUIType",                { fg = C.txt_tertiary })
hl("DapUILineNumber",          { fg = C.txt_tertiary })
hl("DapUIBreakpointsPath",     { fg = C.txt_secondary })
hl("DapUIBreakpointsInfo",     { fg = C.txt_primary })
hl("DapUIBreakpointsCurrentLine", { fg = C.accent_fg, bold = true })
hl("DapUIScope",               { fg = C.accent_fg, bold = true })
hl("DapUIStopped",             { fg = C.accent_fg, bold = true })
hl("DapUISource",              { fg = C.txt_primary })
hl("DapUIDecoration",          { fg = C.txt_tertiary })
hl("DapUIThread",              { fg = C.accent_fg })
hl("DapUIWatchesValue",        { fg = C.txt_primary })
hl("DapUIWatchesEmpty",        { fg = C.txt_tertiary })
hl("DapUIWatchesError",        { fg = C.txt_primary, bold = true })

-- render-markdown.nvim
hl("RenderMarkdownH1",         { fg = C.txt_primary, bold = true })
hl("RenderMarkdownH2",         { fg = C.txt_primary, bold = true })
hl("RenderMarkdownH3",         { fg = C.txt_primary, bold = true })
hl("RenderMarkdownH4",         { fg = C.txt_primary, bold = true })
hl("RenderMarkdownH5",         { fg = C.txt_primary, bold = true })
hl("RenderMarkdownH6",         { fg = C.txt_primary, bold = true })
hl("RenderMarkdownCode",       { bg = C.bg03 })
hl("RenderMarkdownCodeInline", { bg = C.bg03 })
hl("RenderMarkdownQuote",      { fg = C.txt_tertiary })
hl("RenderMarkdownTableHead",  { fg = C.txt_primary, bold = true })
hl("RenderMarkdownTableRow",   { fg = C.txt_secondary })
hl("RenderMarkdownBold",       { bold = true })
hl("RenderMarkdownItalic",     { italic = true })
hl("RenderMarkdownStrike",     { strikethrough = true })
hl("RenderMarkdownLink",       { fg = C.accent_fg, underline = true })
hl("RenderMarkdownDash",       { fg = C.txt_tertiary })
hl("RenderMarkdownBullet",     { fg = C.txt_tertiary })
hl("RenderMarkdownCheckbox",   { fg = C.accent_fg })
hl("RenderMarkdownCallout",    { fg = C.txt_tertiary })

-- vim-fugitive
hl("gitcommitComment",        { link = "Comment" })
hl("gitcommitHash",           { link = "Identifier" })
hl("gitcommitOnBranch",       { link = "Statement" })
hl("gitcommitBranch",         { fg = C.accent_fg })
hl("gitcommitHeader",         { fg = C.txt_primary, bold = true })
hl("gitcommitSelectedType",   { fg = C.txt_primary })
hl("gitcommitSelectedFile",   { fg = C.txt_primary })
hl("gitcommitDiscardedType",  { fg = C.txt_primary })
hl("gitcommitDiscardedFile",  { fg = C.txt_primary })
hl("gitcommitUntrackedFile",  { fg = C.txt_tertiary })
hl("gitcommitSummary",        { fg = C.txt_primary, bold = true })
