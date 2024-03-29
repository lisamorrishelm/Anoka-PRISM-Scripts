'---------------------------------------------------------------------------------------------------
'HOW THIS SCRIPT WORKS:
'
'This script contains functions that the other BlueZone scripts use very commonly. The
'other BlueZone scripts contain a few lines of code that run this script and get the 
'functions. This saves me time in writing and copy/pasting the same functions in
'many different places. Only add functions to this script if they've been tested by
'the workgroups. This document is actively used by live scripts, so it needs to be
'functionally complete at all times.
'
'Here's the code to add, including stats gathering pieces (without comments of course):
'
'GATHERING STATS----------------------------------------------------------------------------------------------------
'name_of_script = ""
'start_time = timer
'
''LOADING ROUTINE FUNCTIONS
'Set run_another_script_fso = CreateObject("Scripting.FileSystemObject")
'Set fso_command = run_another_script_fso.OpenTextFile("Q:\Blue Zone Scripts\Child Support Script Files\FUNCTIONS FILE.vbs")
'text_from_the_other_script = fso_command.ReadAll
'fso_command.Close
'Execute text_from_the_other_script
'----------------------------------------------------------------------------------------------------

'FUNCTIONS THAT ARE BEING USED:
'          attn
'          back_to_SELF
'          end_excel_and_script
'          find_variable
'		fix_case
'          navigate_to_MAXIS_screen
'          navigate_to_PRISM_screen
'          PF1
'          PF2
'          PF3
'          PF4
'          PF5
'          PF6
'          PF7
'          PF8
'          PF9
'          PF10
'          PF11
'          PF12
'          PF20
'		PRISM_case_number_finder
'		PRISM_case_number_validation
'          run_another_script
'          script_end_procedure
'          script_end_procedure_wsh
'          step_through_handling
'          transmit
'		write_editbox_in_PRISM_case_note
'		write_new_line_in_PRISM_case_note
'-------------------------------------------------------------------------------------------------------



Function attn
  EMSendKey "<attn>"
  EMWaitReady -1, 0
End function

function back_to_SELF
  Do
    EMSendKey "<PF3>"
    EMWaitReady 0, 0
    EMReadScreen SELF_check, 4, 2, 50
  Loop until SELF_check = "SELF"
End function

Function end_excel_and_script
  objExcel.Workbooks.Close
  objExcel.quit
  stopscript
End function

Function enter_PRISM_case_number(case_number_variable, row, col)
	EMSetCursor row, col
	EMSendKey replace(case_number_variable, "-", "")                                                                                                                                       'Entering the specific case indicated
	EMSendKey "<enter>"
	EMWaitReady 0, 0
End function

Function find_variable(x, y, z) 'x is string, y is variable, z is length of new variable
  row = 1
  col = 1
  EMSearch x, row, col
  If row <> 0 then EMReadScreen y, z, row, col + len(x)
End function

'This function fixes the case for a phrase. For example, "ROBERT P. ROBERTSON" becomes "Robert P. Robertson". 
'	It capitalizes the first letter of each word.
Function fix_case(phrase_to_split, smallest_length_to_skip)									'Ex: fix_case(client_name, 3), where 3 means skip words that are 3 characters or shorter
	phrase_to_split = split(phrase_to_split)											'splits phrase into an array
	For each word in phrase_to_split												'processes each word independently
		If word <> "" then													'Skip blanks
			first_character = ucase(left(word, 1))									'grabbing the first character of the string, making uppercase and adding to variable
			remaining_characters = LCase(right(word, len(word) -1))						'grabbing the remaining characters of the string, making lowercase and adding to variable
			If len(word) > smallest_length_to_skip then								'skip any strings shorter than the smallest_length_to_skip variable
				output_phrase = output_phrase & first_character & remaining_characters & " "		'output_phrase is the output of the function, this combines the first_character and remaining_characters
			Else															
				output_phrase = output_phrase & word & " "							'just pops the whole word in if it's shorter than the smallest_length_to_skip variable
			End if
		End if
	Next
	phrase_to_split = output_phrase												'making the phrase_to_split equal to the output, so that it can be used by the rest of the script.
End function

function navigate_to_MAXIS_screen(x, y)
  EMSendKey "<enter>"
  EMWaitReady 0, 0
  EMReadScreen MAXIS_check, 5, 1, 39
  If MAXIS_check = "MAXIS" or MAXIS_check = "AXIS " then
    row = 1
    col = 1
    EMSearch "Function: ", row, col
    If row <> 0 then 
      EMReadScreen MAXIS_function, 4, row, col + 10
      EMReadScreen STAT_note_check, 4, 2, 45
      row = 1
      col = 1
      EMSearch "Case Nbr: ", row, col
      EMReadScreen current_case_number, 8, row, col + 10
      current_case_number = replace(current_case_number, "_", "")
      current_case_number = trim(current_case_number)
    End if
    If current_case_number = case_number and MAXIS_function = ucase(x) and STAT_note_check <> "NOTE" then 
      row = 1
      col = 1
      EMSearch "Command: ", row, col
      EMWriteScreen y, row, col + 9
      EMSendKey "<enter>"
      EMWaitReady 0, 0
    Else
      Do
        EMSendKey "<PF3>"
        EMWaitReady 0, 0
        EMReadScreen SELF_check, 4, 2, 50
      Loop until SELF_check = "SELF"
      EMWriteScreen x, 16, 43
      EMWriteScreen "________", 18, 43
      EMWriteScreen case_number, 18, 43
      EMWriteScreen footer_month, 20, 43
      EMWriteScreen footer_year, 20, 46
      EMWriteScreen y, 21, 70
      EMSendKey "<enter>"
      EMWaitReady 0, 0
      EMReadScreen abended_check, 7, 9, 27
      If abended_check = "abended" then
        EMSendKey "<enter>"
        EMWaitReady 0, 0
      End if
    End if
  End if
End function

Function navigate_to_PRISM_screen(x) 'x is the name of the screen
  EMWriteScreen x, 21, 18
  EMSendKey "<enter>"
  EMWaitReady 0, 0
End function

Function PF1
  EMSendKey "<PF1>"
  EMWaitReady 0, 0
End function

Function PF2
  EMSendKey "<PF2>"
  EMWaitReady 0, 0
End function

function PF3
  EMSendKey "<PF3>"
  EMWaitReady 0, 0
end function

Function PF4
  EMSendKey "<PF4>"
  EMWaitReady 0, 0
End function

Function PF5
  EMSendKey "<PF5>"
  EMWaitReady 0, 0
End function

Function PF6
  EMSendKey "<PF6>"
  EMWaitReady 0, 0
End function

Function PF7
  EMSendKey "<PF7>"
  EMWaitReady 0, 0
End function

function PF8
  EMSendKey "<PF8>"
  EMWaitReady 0, 0
end function

function PF9
  EMSendKey "<PF9>"
  EMWaitReady 0, 0
end function

function PF10
  EMSendKey "<PF10>"
  EMWaitReady 0, 0
end function

Function PF11
  EMSendKey "<PF11>"
  EMWaitReady 0, 0
End function

Function PF12
  EMSendKey "<PF12>"
  EMWaitReady 0, 0
End function

function PF20
  EMSendKey "<PF20>"
  EMWaitReady 0, 0
end function

Function PRISM_case_number_finder(variable_for_PRISM_case_number)
	'Searches for the case number.
	PRISM_row = 1
	PRISM_col = 1
	EMSearch "Case: ", PRISM_row, PRISM_col
	If PRISM_row <> 0 then
		EMReadScreen variable_for_PRISM_case_number, 13, PRISM_row, PRISM_col + 6
		variable_for_PRISM_case_number = replace(variable_for_PRISM_case_number, " ", "-")
	Else	'Searches again if not found, this time for "Case/Person"
		PRISM_row = 1
		PRISM_col = 1
		EMSearch "Case/Person: ", PRISM_row, PRISM_col
		If PRISM_row <> 0 then
			EMReadScreen variable_for_PRISM_case_number, 13, PRISM_row, PRISM_col + 13
			variable_for_PRISM_case_number = replace(variable_for_PRISM_case_number, " ", "-")
		End if
	End if	
	If isnumeric(left(variable_for_PRISM_case_number, 10)) = False or isnumeric(right(variable_for_PRISM_case_number, 2)) = False then variable_for_PRISM_case_number = ""
End function

Function PRISM_case_number_validation(case_number_to_validate, outcome)
  If len(case_number_to_validate) <> 13 then 
    outcome = False
  Elseif isnumeric(left(case_number_to_validate, 10)) = False then
    outcome = False
  Elseif isnumeric(right(case_number_to_validate, 2)) = False then
    outcome = False
  Elseif InStr(11, case_number_to_validate, "-") <> 11 then
    outcome = False
  Else
    outcome = True
  End if
End function

function PRISM_check_function
	EMReadScreen PRISM_check, 5, 1, 36
	If PRISM_check <> "PRISM" then script_end_procedure("You do not appear to be in PRISM. You may be passworded out. Please check your PRISM screen and try again.")
END function

function run_another_script(script_path)
  Set run_another_script_fso = CreateObject("Scripting.FileSystemObject")
  Set fso_command = run_another_script_fso.OpenTextFile(script_path)
  text_from_the_other_script = fso_command.ReadAll
  fso_command.Close
  Execute text_from_the_other_script
end function

function script_end_procedure(closing_message)
	If closing_message <> "" then MsgBox closing_message
	stop_time = timer
	script_run_time = stop_time - start_time
	'Getting user name
	Set objNet = CreateObject("WScript.NetWork") 
	user_ID = objNet.UserName

	'Setting constants
	Const adOpenStatic = 3
	Const adLockOptimistic = 3

	'Creating objects for Access
	Set objConnection = CreateObject("ADODB.Connection")
	Set objRecordSet = CreateObject("ADODB.Recordset")

	'Opening DB
	objConnection.Open "Provider = Microsoft.ACE.OLEDB.12.0; Data Source = Q:\Blue Zone Scripts\Statistics\usage statistics.accdb"

	'Opening usage_log and adding a record
	objRecordSet.Open "INSERT INTO usage_log (USERNAME, SDATE, STIME, SCRIPT_NAME, SRUNTIME, CLOSING_MSGBOX)" &  _
	"VALUES ('" & user_ID & "', '" & date & "', '" & time & "', '" & name_of_script & "', " & script_run_time & ", '" & closing_message & "')", objConnection, adOpenStatic, adLockOptimistic
	stopscript
end function

function script_end_procedure_wsh(closing_message) 'For use when running a script outside of the BlueZone Script Host
	If closing_message <> "" then MsgBox closing_message
	stop_time = timer
	script_run_time = stop_time - start_time
	'Getting user name
	Set objNet = CreateObject("WScript.NetWork") 
	user_ID = objNet.UserName

	'Setting constants
	Const adOpenStatic = 3
	Const adLockOptimistic = 3

	'Creating objects for Access
	Set objConnection = CreateObject("ADODB.Connection")
	Set objRecordSet = CreateObject("ADODB.Recordset")

	'Opening DB
	objConnection.Open "Provider = Microsoft.ACE.OLEDB.12.0; Data Source = Q:\Blue Zone Scripts\Statistics\usage statistics.accdb"

	'Opening usage_log and adding a record
	objRecordSet.Open "INSERT INTO usage_log (USERNAME, SDATE, STIME, SCRIPT_NAME, SRUNTIME, CLOSING_MSGBOX)" &  _
	"VALUES ('" & user_ID & "', '" & date & "', '" & time & "', '" & name_of_script & "', " & script_run_time & ", '" & closing_message & "')", objConnection, adOpenStatic, adLockOptimistic
	Wscript.Quit
end function



Function step_through_handling 'This function will introduce "warning screens" before each transmit, which is very helpful for testing new scripts
	'To use this function, simply replace the "Execute text_from_the_other_script" line with:
	'Execute replace(text_from_the_other_script, "EMWaitReady 0, 0", "step_through_handling")
	step_through = MsgBox("Step " & step_number & chr(13) & chr(13) & "If you see something weird on your screen (like a MAXIS or PRISM error), PRESS CANCEL then email the script writer about it. Make sure you include the step you're on.", 1)
	If step_number = "" then step_number = 1	'Declaring the variable
	If step_through = 2 then
		stopscript
	Else
		EMWaitReady 0, 0
		step_number = step_number + 1
	End if
End Function

function transmit
  EMSendKey "<enter>"
  EMWaitReady 0, 0
end function

Function write_editbox_in_PRISM_case_note(bullet, editbox, spaces_count)
  EMGetCursor row, col 
  EMReadScreen line_check, 2, 15, 2
  If ((row = 20 and col + (len(bullet)) >= 78) or row = 21) and line_check = "26" then 
    MsgBox "You've run out of room in this case note. The script will now stop."
    StopScript
  End if
  If row = 21 then
    EMSendKey "<PF8>"
    EMWaitReady 0, 0
    EMSetCursor 16, 4
  End if
  variable_array = split(editbox, " ")
  EMSendKey "* " & bullet & ": "
  For each editbox_word in variable_array 
    EMGetCursor row, col 
    EMReadScreen line_check, 2, 15, 2
    If ((row = 20 and col + (len(editbox_word)) >= 78) or row = 21) and line_check = "26" then 
      MsgBox "You've run out of room in this case note. The script will now stop."
      StopScript
    End if
    If (row = 20 and col + (len(editbox_word)) >= 78) or (row = 16 and col = 4) or row = 21 then
      EMSendKey "<PF8>"
      EMWaitReady 0, 0
      EMSetCursor 16, 4
    End if
    EMGetCursor row, col 
    If (row < 20 and col + (len(editbox_word)) >= 78) then EMSendKey "<newline>" & space(spaces_count) 
'    If (row = 16 and col = 4) then EMSendKey space(spaces_count)		'<<<REPLACED WITH BELOW IN ORDER TO TEST column issue
    If (col = 4) then EMSendKey space(spaces_count)
    EMSendKey editbox_word & " "
    If right(editbox_word, 1) = ";" then 
      EMSendKey "<backspace>" & "<backspace>" 
      EMGetCursor row, col 
      If row = 20 then
        EMSendKey "<PF8>"
        EMWaitReady 0, 0
        EMSetCursor 16, 4
        EMSendKey space(spaces_count)
      Else
        EMSendKey "<newline>" & space(spaces_count)
      End if
    End if
  Next
  EMSendKey "<newline>"
  EMGetCursor row, col 
  If (row = 20 and col + (len(bullet)) >= 78) or (row = 16 and col = 4) then
    EMSendKey "<PF8>"
    EMWaitReady 0, 0
    EMSetCursor 16, 4
  End if
End function

Function write_new_line_in_PRISM_case_note(x)
  EMGetCursor row, col 
  EMReadScreen line_check, 2, 15, 2
  If ((row = 20 and col + (len(x)) >= 78) or row = 21) and line_check = "26" then 
    MsgBox "You've run out of room in this case note. The script will now stop."
    StopScript
  End if
  If (row = 20 and col + (len(x)) >= 78 + 1 ) or row = 21 then
    EMSendKey "<PF8>"
    EMWaitReady 0, 0
    EMSetCursor 16, 4
  End if
  EMSendKey x & "<newline>"
  EMGetCursor row, col 
  If (row = 20 and col + (len(x)) >= 78) or (row = 21) then
    EMSendKey "<PF8>"
    EMWaitReady 0, 0
    EMSetCursor 16, 4
  End if
End function


