-- Hands files opened from Finder to Homebrew's mpv, as a single playlist.
on open theFiles
	set args to ""
	repeat with f in theFiles
		set args to args & " " & quoted form of POSIX path of f
	end repeat
	do shell script "/opt/homebrew/bin/mpv --player-operation-mode=pseudo-gui --" & args & " > /dev/null 2>&1 &"
end open

on run
	do shell script "/opt/homebrew/bin/mpv --player-operation-mode=pseudo-gui > /dev/null 2>&1 &"
end run
