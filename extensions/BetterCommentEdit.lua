--[[
Author: Skyrimfus
Discord ID: 244490308782391316
Name: Better Comments
Version: Public version 2.0

Written for CE 7.4


Description: 
	This extension replaces "Set/Change comment" in CE's Memory Viewer with a custom one.
	Pressing enter or clicking on the "OK" button will write your input as a comment and close the window.
	Pressing esc or clicking on the "Cancel" button will cancel any changes and close the window.
	
	Pressing shift and enter will write a new-line.


--]]

local fm,memo,pnl,bOk,bCancel,selAddress
local mvf = getMemoryViewForm()

fm = createForm(false)
fm.Caption = "Comment for:"
fm.OnClose = nil
fm.BorderStyle = bsSizeable

memo = createMemo(fm)
memo.Lines.Text = "Generating..."
memo.Anchors = "[akTop,akLeft,akRight,akBottom]"
memo.AnchorSideRight.Side = asrRight
memo.AnchorSideRight.Control = fm
memo.Scrollbars = ssVertical


pnl = createPanel(fm)
pnl.BevelOuter = 0
pnl.Anchors = "[akBottom,akLeft]"
pnl.AnchorSideLeft.Control = fm
pnl.AnchorSideLeft.Side = asrCenter
pnl.AnchorSideBottom.Control = fm
pnl.AnchorSideBottom.Side = asrBottom
pnl.Width = 150
pnl.Height  = 40


memo.AnchorSideBottom.Side = asrTop
memo.AnchorSideBottom.Control = pnl


bOk = createButton(fm)
bOk.Caption = "OK"
bOk.Anchors = "[akTop,akLeft]"
bOk.AnchorSideTop.Control = pnl
bOk.AnchorSideTop.Side = asrCenter
bOk.AnchorSideLeft.Control = pnl
bOk.AnchorSideLeft.Side = asrLeft
bOk.setSize(70,22)


bCancel = createButton(fm)
bCancel.Caption = "Cancel"
bCancel.Anchors = "[akRight,akTop]"
bCancel.AnchorSideTop.Control = pnl
bCancel.AnchorSideTop.Side = asrCenter
bCancel.AnchorSideRight.Control = pnl
bCancel.AnchorSideRight.Side = asrRight
bCancel.setSize(70,22)


local function ok()
	setComment(selAddress,memo.Lines.Text)
	fm.hide()
end

local function cancel()
	fm.hide()
end

memo.OnKeyDown= function(key)
 if isKeyPressed(VK_RETURN) and not isKeyPressed(VK_LSHIFT) then
  ok()
 end
 if isKeyPressed(VK_ESCAPE) then
  cancel()
 end
end

bOk.OnClick = ok
bCancel.OnClick = cancel

mvf.miUserdefinedComment.OnClick = function()
	selAddress = mvf.Disassemblerview.SelectedAddress
	fm.setPosition(mvf.Left,mvf.Top)
	fm.Caption = string.format("Comment for: %X %%s (shows the autguess value)",selAddress)
	memo.Lines.Text = getComment(selAddress)
	fm.show()
	memo.setFocus()
	memo.SelStart = #(memo.Lines.Text)

end

