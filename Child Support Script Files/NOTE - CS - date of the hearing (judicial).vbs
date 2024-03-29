'GATHERING STATS----------------------------------------------------------------------------------------------------
name_of_script = "NOTE - CS - date of the hearing (judicial)"
start_time = timer
'
''LOADING ROUTINE FUNCTIONS
Set run_another_script_fso = CreateObject("Scripting.FileSystemObject")
Set fso_command = run_another_script_fso.OpenTextFile("Q:\Blue Zone Scripts\Child Support Script Files\FUNCTIONS FILE.vbs")
text_from_the_other_script = fso_command.ReadAll
fso_command.Close
Execute text_from_the_other_script


BeginDialog date_of_the_hearing_jud_dialog, 0, 0, 321, 260, "Date of the Hearing Judicial"
  Text 5, 5, 80, 10, "Motion before the Court"
  ComboBox 85, 5, 155, 15, "Select one or type in other motion:"+chr(9)+"Initial Contempt of Court"+chr(9)+"Contempt Review"+chr(9)+"Continued Contempt Motion"+chr(9)+"Paternity Action", motion_before_court
  Text 5, 25, 65, 10, "District Court Judge"
  DropListBox 75, 25, 85, 15, "Select one:"+chr(9)+"James Cunningham"+chr(9)+"John P. Dehen"+chr(9)+"Thomas M. Fitzpatrick"+chr(9)+"Bethany Fountain-Lindberg"+chr(9)+"Tammi A. Fredrickson"+chr(9)+"Sean C. Gibbs"+chr(9)+"Sharon L. Hall"+chr(9)+"Jenny Walker-Jasper"+chr(9)+"Jonathan N. Jasper"+chr(9)+"Lawrence R. Johnson"+chr(9)+"Kristin C. Larson"+chr(9)+"Nancy J. Logering"+chr(9)+"Douglas B. Meslow"+chr(9)+"Daniel O'Fallon"+chr(9)+"Alan Pendleton"+chr(9)+"Dyanna Street"+chr(9)+"Barry A. Sullivan", district_court_judge
  Text 5, 45, 55, 10, "County Attorney"
  DropListBox 65, 45, 85, 15, "Select one:"+chr(9)+"Tonya D.F. Berzat"+chr(9)+"Michael S. Barone"+chr(9)+"Paul C. Clabo"+chr(9)+"Dorrie B. Estebo"+chr(9)+"Kay M. Gavinski"+chr(9)+"Rachel Morrison"+chr(9)+"D. Marie Sieber"+chr(9)+"Brett Schading", CAO_list
  CheckBox 5, 70, 50, 10, "NCP present", NCP_present_check
  Text 60, 70, 60, 10, "Represented by:"
  EditBox 120, 70, 85, 15, NCP_represented_by
  CheckBox 5, 85, 50, 10, "CP present", CP_present_check
  Text 60, 85, 55, 10, "Represented by:"
  EditBox 120, 85, 85, 15, CP_represented_by
  Text 5, 105, 70, 10, "Details of the hearing"
  EditBox 80, 105, 170, 15, details_of_the_hearing
  CheckBox 10, 125, 100, 10, "Driver's license addressed", DL_addressed_check
  Text 20, 140, 105, 10, "Details of drivers license status"
  EditBox 130, 135, 155, 15, dl_details
  Text 10, 160, 70, 10, "Review Hearing Date"
  EditBox 85, 160, 65, 15, review_hearing_date
  Text 150, 195, 60, 10, "Worker signature"
  EditBox 215, 195, 90, 15, worker_signature
  ButtonGroup ButtonPressed
    OkButton 210, 235, 50, 15
    CancelButton 265, 235, 50, 15
EndDialog


'case number dialog-
BeginDialog case_number_dialog, 0, 0, 176, 85, "Case number dialog"
  EditBox 60, 5, 75, 15, PRISM_case_number
  ButtonGroup ButtonPressed
    OkButton 70, 65, 50, 15
    CancelButton 125, 65, 50, 15
  Text 5, 10, 50, 10, "Case number:"
EndDialog


'Connecting to BlueZone
EMConnect ""

call PRISM_case_number_finder(PRISM_case_number)

'Case number display dialog
Do
	Dialog case_number_dialog
	If buttonpressed = 0 then stopscript
	call PRISM_case_number_validation(PRISM_case_number, case_number_valid)
	If case_number_valid = False then MsgBox "Your case number is not valid. Please make sure it uses the following format: ''XXXXXXXXXX-XX''"
Loop until case_number_valid = True



'Displays dialog for date of the hearing caad note and checks for information
Do
	Do
		Do
			Do 	
				Do
					'Shows dialog, validates that PRISM is up and not timed out, with transmit
					Dialog date_of_the_hearing_jud_dialog
					If buttonpressed = 0 then stopscript
					transmit
					EMReadScreen PRISM_check, 5, 1, 36
					If PRISM_check <> "PRISM" then MsgBox "You appear to have timed out, or are out of PRISM. Navigate to PRISM and try again."
				Loop until PRISM_check = "PRISM"
				'Makes sure worker enters in signature
				If worker_signature = "" then MsgBox "Sign your CAAD note"
			Loop until worker_signature <> ""
			'Makes sure worker selects motion type
			If motion_before_court = "" or motion_before_court = "Select one or type in other motion:" then MsgBox "You must enter in a motion!"
		Loop until motion_before_court <> "" and motion_before_court <> "Select one or type in other motion:"
		'Makes sure worker select county attorney
		If CAO_list = "Select one:" then MsgBox "Please select a County Attorney"
	Loop until CAO_list <> "Select one:"			
	'Makes sure worker selects district court judge
	If district_court_judge = "Select one:" then MsgBox "Please select a District Court Judge"
Loop until district_court_judge <> "Select one:"


'Going to CAAD note
call navigate_to_PRISM_screen("CAAD")

'Entering case number
call enter_PRISM_case_number(PRISM_case_number, 20, 8)


PF5					'Did this because you have to add a new note

EMWriteScreen "M3909", 4, 54  'adds correct caad code 

EMSetCursor 16, 4			'Because the cursor does not default to this location

call write_editbox_in_PRISM_case_note("Motion before the Court", motion_before_court, 4) 
call write_editbox_in_PRISM_case_note("District Court Judge", district_court_judge, 4)
call write_editbox_in_PRISM_case_note("County Attorney", CAO_list, 4)
if NCP_present_check = 1 then
	call write_new_line_in_PRISM_case_note("* NCP present")
	call write_editbox_in_PRISM_case_note("Represented by", NCP_represented_by, 4)
else 
	call write_new_line_in_PRISM_case_note ("* NCP not present")
end if
if CP_present_check = 1 then
	call write_new_line_in_PRISM_case_note("* CP present")
	call write_editbox_in_PRISM_case_note("Represented by", CP_represented_by, 4)
else 
	call write_new_line_in_PRISM_case_note ("* CP not present")
end if
call write_editbox_in_PRISM_case_note("Details of the Hearing", details_of_the_hearing, 4)
if DL_addressed_check = 1 then 
	call write_new_line_in_PRISM_case_note("* Drivers license addressed")
	call write_editbox_in_PRISM_case_note("Details of drivers license", dl_details, 4)
end if
if review_hearing_date <> "" then
	call write_editbox_in_PRISM_case_note("Review Hearing date", review_hearing_date, 4)
end if
call write_new_line_in_PRISM_case_note("---")	
call write_new_line_in_PRISM_case_note(worker_signature)

















