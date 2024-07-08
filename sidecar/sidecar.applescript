on findLastTargetIndex(targetItem, itemList)
    repeat with i from (count itemList) down to 1
        if item i of itemList = target someItem then
            return i
        end if
    end repeat
    return 0
end findLastTargetIndex

beep 1
beep 1

tell application "System Settings"
    activate
    delay 1

    tell application "System Events"
        tell process "System Settings"
            click menu item "显示器" of menu "显示" of menu bar item "显示" of menu bar 1
            delay 0.3

            tell group 1 of group 2 of splitter group 1 of group 1 of window "显示器"
                try
                    click pop up button "添加"
                    delay 0.3
                    set menuItems to name of menu items of menu "添加" of pop up button "添加"
                    set targetIndex to my findLastTargetIndex("这里替换为ipadde 设备名称", menuItems)

                    if targetIndex ≠ 0 then
                        click menu item targetIndex of menu "添加" of pop up button "添加"
                    end if
                on error
                    delay 0.5
                end try
            end tell
        end tell
    end tell
end tell

delay 1
beep 1
tell application "System Settings" to quit