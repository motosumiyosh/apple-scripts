set currentMonthNotionUrl to ""

tell application "Notes"
	set allNotes to {}
	set accountNotes to notes of default account
	repeat with aNote in accountNotes
		set aContainer to container of aNote
		if name of aContainer is not "Recently Deleted" then
			copy aNote to the end of allNotes
		end if
	end repeat
	set notesText to ""
	repeat with aNote in allNotes
		set noteBody to (body of aNote)
		
		-- HTMLタグを削除するためにシェルスクリプトを使用
		set cleanedNoteBody to do shell script "echo " & quoted form of noteBody & " | sed 's/<div>//g' | sed 's/<br>//g' | sed 's/<\\/div>//g' | sed 's/<h1>//g' | sed 's/<\\/h1>//g'"
		
		set notesText to notesText & cleanedNoteBody & return & return
	end repeat
end tell

set the clipboard to notesText

tell application "Notion"
	activate
	delay 1
end tell
-- Notionの特定のページに移動
tell application "System Events"
	-- Notionアプリがフォーカスされていることを確認
	tell process "Notion"
		-- ページ移動のためにCommand + Lを使う
		keystroke "p" using {command down}
		keystroke currentMonthNotionUrl
		delay 3.5
		keystroke return
		keystroke "125" using {command down}
		keystroke "v" using {command down}
	end tell
end tell

tell application "Notes"
	repeat with aNote in allNotes
		delete aNote
	end repeat
end tell
