#***************************************************************************************************************.

# This is the second part: Verification.
# This part aims to verify the generated content. Read the existing document and verify its correctness by running the command, checking the example, etc.

#****************************************************************************************************************.
#!/bin/bash

#****************************************************************************************************************************************.
# Functions used for edit the strings, in order to make it as the CISCO templete.

# Function that adds two tabs after each newline in a given string.
add_tabs_to_string() {
    local input_string="$1"
    # Use 'sed' to substitute newlines with a newline followed by two tabs.
    local modified_string=$(echo -e "$input_string" | sed ':a;N;$!ba;s/\n/\n\t\t\t/g')
}

# Function to replace all occurrences of newline characters with a newline character followed by two tabs.
replace_space_by_newLineWithSpaces() {
    local input_string="$1"
    # Use 'sed' to substitute newlines with a newline followed by two tabs
    local modified_string=$(echo -e "$input_string" | sed ':a;N;$!ba;s/\n/\n\t\t\t/g')
    echo -e "$modified_string"
}

# Function to delete all spaces of a given string.
delete_spaces() {
    local input_string="$1"
    echo -e "$input_string" | sed 's/^[[:space:]]*//'
}
#******************************************************************************************************************************************.


# New folder for those files Generated in verification part.
mkdir newGeneratedFiles

# In each iteration, the script create a new file, to verfiy the new file with the old one, and show if there's diffrences between them.
while true 
do
	# Display the command for the user.
	echo -e "The command list...\n"

	commands=("ls" "echo" "mv" "rm" "touch" "cat" "chmod" "grep" "tar" "date" "whoami" "sort" "head" "mkdir" "find" "printf" "cp" "rmdir" "more" "chown" "zip")

	for command in "${commands[@]}"
	do
    		echo -e -n "\033[42m\033[3m "$command" \033[m/"
	done
	echo -e "\n"

	# This file to verfiy it with the old one.
	echo "Please enter the name of the command you want to verfiy it:"
	read command
	if [ -e "GeneratedFiles/$command.txt" ]
	then
		echo -e "Yes, This command exists, so it can be verified.\n"
		
	else
		echo -e "Sorry, This command does not exist, please try another command!\n"
		continue 
	fi
	
	# The file name will be: newcommandName.txt 
	
	filename="new${command}.txt"
	echo -e "\033[1;91m${command} Command:\033[m" > "$filename"

   	# Extract command description from man page
    	description=$(man "$command" | awk '/^DESCRIPTION$/,/^$/ {if (!/^$/ && NR > 1) print}' | grep -v '^DESCRIPTION$')

   	if [ $? -eq 0 ]
        then
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "DESCRIPTION\t\t\033[m" >> "$filename"
        	description=$(delete_spaces "$description")
        	add_tabs_to_string "$description"
        	echo -e "$description\n" >> "$filename"
    	else
        	echo -e "Description not found.\n" >> "$filename"
        	exit 1
   	fi

   	# Extract command version history.
    	if [ "$command" = "echo" ] || [ "$command" = "printf" ]
    	then
    		version=$(/usr/bin/"$command" --version | head -n 1)
    		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "VERSION\t\t\t\033[m" >> "$filename"
        	add_tabs_to_string "$version"
        	echo -e "$version\n" >> "$filename"
    	else
    		version=$("$command" --version | head -n 1)
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "VERSION\t\t\t\033[m" >> "$filename"
        	add_tabs_to_string "$version"
        	echo -e "$version\n" >> "$filename"
        fi
    	


    	# Example: To show the usage of the command.
	if [ "$command" = "ls" ] || [ "$command" = "date" ] || [ "$command" = "whoami" ]
	then  
		example=$("$command")
		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$example\n" >> "$filename"
       
        elif [ "$command" = "echo" ] || [ "$command" = "printf" ]
	then 
		example=$("$command" "Welcome to the world of command-line magic!")
		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$example\n" >> "$filename"
        	
        elif [ "$command" = "mv" ]
        then
        	touch newGeneratedFiles/oldFile.txt
        	exampleBefore=$(ls newGeneratedFiles/oldFile.txt)
        	$command newGeneratedFiles/oldFile.txt newGeneratedFiles/newFile.txt 
        	example=$( ls newGeneratedFiles/newFile.txt )
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
        elif [ "$command" = "rm" ] 
        then
        	exampleBefore=$(ls newGeneratedFiles/)
        	$command newGeneratedFiles/newFile.txt 
        	example=$(ls newGeneratedFiles/)
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
        elif [ "$command" = "touch" ]
        then
        	exampleBefore=$(ls newGeneratedFiles/)
        	$command newGeneratedFiles/newFile.txt
        	example=$( ls newGeneratedFiles/)
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
        elif [ "$command" = "mkdir" ]
        then
        	exampleBefore=$(ls newGeneratedFiles/)
        	$command newGeneratedFiles/newDirectory
        	example=$(ls newGeneratedFiles/)
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
        	
        elif [ "$command" = "cat" ] || [ "$command" = "head" ] || [ "$command" = "sort" ] || [ "$command" = "more" ]
	then
		
		example=$("$command" GeneratedFiles/fileExample.txt)
		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$example\n" >> "$filename"
        	
        
	elif [ "$command" = "chmod" ]
	then 
		exampleBefore=$(ls -l newGeneratedFiles/newFile.txt)
		$command 755 newGeneratedFiles/newFile.txt 
		example=$(ls -l newGeneratedFiles/newFile.txt)
		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
        elif [ "$command" = "grep" ]
	then 
		example=$("$command" -n "$command" GeneratedFiles/fileExample.txt)
		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$example\n" >> "$filename"
        	
        elif [ "$command" = "tar" ]
	then 
		touch newGeneratedFiles/fileToZipOrTar1.txt newGeneratedFiles/fileToZipOrTar2.txt
		exampleBefore=$(ls newGeneratedFiles/)
		temp=$($command -cvf  newGeneratedFiles/newDirectory.tar newGeneratedFiles/fileToZipOrTar1.txt  newGeneratedFiles/fileToZipOrTar2.txt)
		example=$(ls newGeneratedFiles/)
		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
        elif [ "$command" = "find" ]
	then 
		example=$("$command" GeneratedFiles/fileExample.txt)
		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$example\n" >> "$filename"
        	
        elif [ "$command" = "cp" ]
	then 
		touch GeneratedFiles/copyFile.txt
		temp=$("$command" GeneratedFiles/fileExample.txt GeneratedFiles/copyFile.txt)
		example=$(cat GeneratedFiles/copyFile.txt)
		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$example\n" >> "$filename"
		
	elif [ "$command" = "rmdir" ] 
        then
        	mkdir newGeneratedFiles/oldDirectory
        	exampleBefore=$( ls newGeneratedFiles/ )
        	$command  newGeneratedFiles/oldDirectory
        	example=$( ls newGeneratedFiles )
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
          	
        elif [ "$command" = "chown" ]
	then 
		exampleBefore=$(ls -l newGeneratedFiles/newFile.txt)
		sudo $command 1200531 newGeneratedFiles/newFile.txt
		example=$(ls -l newGeneratedFiles/newFile.txt)
		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
	else #Here the command will be zip.
		exampleBefore=$(ls newGeneratedFiles/)
		temp=$($command newGeneratedFiles/newDirectory.zip newGeneratedFiles/fileToZipOrTar1.txt  newGeneratedFiles/fileToZipOrTar2.txt)
		example=$(ls newGeneratedFiles/)
		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        fi
	
	
	
	
	
	
	
    	# Extract all related commands to the command.
    	relatedCommands=$(compgen -c | grep "$command")

    	if [ $? -eq 0 ]; then
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "RELATEDCOMMANDS\t\t\033[m" >> "$filename"
        	replace_space_by_newLineWithSpaces "$relatedCommands\n" >> "$filename"
    	else
        	echo -e "There's no related commands to this command.\n" >> "$filename"
        	exit 1
    	fi

    	echo -e "Information for new ${command} saved to ${filename}\n"
    	mv "$filename" newGeneratedFiles/
    	
    	diffOutput=$(diff newGeneratedFiles/${filename} GeneratedFiles/${command}.txt)
    	if [ $? -eq 0 ]
    	then
    		echo -e "The verification is done SUCCESSFULLY !\n"
    		echo -e "And there's no differences found between the old file and the new one.\n"
    	else
    		echo -e "The verification is done SUCCESSFULLY !\n"
    		echo -e "And there's a differences found between them (the OLD file for the command and the NEW one):\n"
    		echo -e "$diffOutput\n"
    	fi
    	
    	
    	# Ask user to verfiy other commands.
    	
	echo -n "Would you to verfiy more commands (enter y for verifying or n for exit) [Y/N]?"
	read -r answer

	if [ "$answer" = "Y" ] || [ "$answer" = "y" ]
	then 
		continue
	
	elif [ "$answer" = "N" ] || [ "$answer" = "n" ]
	then 
		echo -e "Thank you!\n"
		break
	else
		echo -e "Invalid input ! try again.\n"
	fi
done
	
	
echo -e "The Second part of generating *Linux/Unix Command Manual* DONE successfully !\n\n "
echo -e "******************************************************************************************************.\n\n"
echo -n "Would you like to go ahead and improve the usability of the generated manual files for any command in this program [Y/N]?"
read -r answer

if [ "$answer" = "Y" ] || [ "$answer" = "y" ]
then 
	echo -e "\nImprovement the files started..\n\n"
	./improve.sh
	
elif [ "$answer" = "N" ] || [ "$answer" = "n" ]
then 
	echo -e "Thank you!\n"
	exit 1
else
	echo -e "Invalid input ! try again.\n"

fi
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
exit 1
