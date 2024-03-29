# Project 1: Automated Linux/Unix Command Manual Generation.
# This project aims to automate the generation of a system manual for Linux/Unix commands using Python or shell scripting.
#***************************************************************************************************************************************.

# This is the first part: Generate Linux/Unix Command Manual.

#***************************************************************************************************************************************.

#!/bin/bash

echo -e "Welcome to the Linux/Unix command manual generator!\n"
echo -e "This script will automatically create manual files for specified commands.\n"
echo -e "===============================================================================================================================================\n"


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
    echo "$modified_string"
}

# Function to delete all spaces of a given string.
delete_spaces() {
    local input_string="$1"
    echo -e "$input_string" | sed 's/^[[:space:]]*//'
}
#******************************************************************************************************************************************.


# Display the commands for the user.
echo -e "The command list...\n"

commands=("ls" "echo" "mv" "rm" "touch" "cat" "chmod" "grep" "tar" "date" "whoami" "sort" "head" "mkdir" "find" "printf" "cp" "rmdir" "more" "chown" "zip")

for command in "${commands[@]}"
do
    echo -e -n "\033[42m\033[3m "$command" \033[m/"
done
echo -e "\n"

# Ask the user, to start create man files for the commands.
echo -n "Would you like to start the process of creating the manual files for the above commands [Y/N]?"
read -r answer

if [ "$answer" = "Y" ] || [ "$answer" = "y" ]
then 
	echo -e "\nCreating the command manual files started..\n\n"
	# Create new directory to put all generated files in it.
	mkdir GeneratedFiles
	
elif [ "$answer" = "N" ] || [ "$answer" = "n" ]
then 
	 echo -e "\nExiting script."
         exit 1
    
else
 	echo -e "\nInvalid input."
fi

#**********************************************************************************
    	# This file will be used in the examples down:
    	touch GeneratedFiles/fileExample.txt
	echo -e "Hello EVERYONE !\nThis an illustrative example showcasing the usage of the commands: cat, head, sort, more, and grep.\nThe commands: cat, head, more will just display  the contents of a File.\nThe sort command will appear clearly in the lines will double quotations.\n'She ate a delicious apple pie for dessert.'\n'Pies are often served at the end of a meal.'\n'Apples are a popular fruit for baking.'\n'Desserts can be sweet or savory.'">> GeneratedFiles/fileExample.txt
#*********************************************************************************





# Array of commands.
# This loop processes a series of commands, creating a dedicated file for each command to store its relevant information.

for command in "${commands[@]}"
do
	# The file name will be: commandName.txt
	filename="${command}.txt"
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
        	touch GeneratedFiles/oldFile.txt
        	exampleBefore=$(ls GeneratedFiles/oldFile.txt)
        	$command GeneratedFiles/oldFile.txt GeneratedFiles/newFile.txt
        	example=$( ls GeneratedFiles/newFile.txt)
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
        elif [ "$command" = "rm" ] 
        then
        	exampleBefore=$(ls GeneratedFiles)
        	$command GeneratedFiles/newFile.txt
        	example=$( ls GeneratedFiles/)
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
        elif [ "$command" = "touch" ]
        then
        	exampleBefore=$(ls GeneratedFiles/)
        	$command GeneratedFiles/newFile.txt
        	example=$( ls GeneratedFiles/)
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
        elif [ "$command" = "mkdir" ]
        then
        	exampleBefore=$(ls GeneratedFiles/)
        	$command GeneratedFiles/newDirectory
        	example=$(ls GeneratedFiles/)
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
		exampleBefore=$(ls -l GeneratedFiles/newFile.txt)
		$command 755 GeneratedFiles/newFile.txt 
		example=$(ls -l GeneratedFiles/newFile.txt)
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
		touch GeneratedFiles/fileToZipOrTar1.txt GeneratedFiles/fileToZipOrTar2.txt
		exampleBefore=$(ls GeneratedFiles/)
		temp=$($command -cvf  GeneratedFiles/newDirectory.tar GeneratedFiles/fileToZipOrTar1.txt  GeneratedFiles/fileToZipOrTar2.txt)
		example=$(ls GeneratedFiles/)
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
        	
        	mkdir GeneratedFiles/oldDirectory
        	exampleBefore=$( ls  GeneratedFiles/ )
        	$command  GeneratedFiles/oldDirectory
        	example=$( ls GeneratedFiles )
        	echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        	
          	
        elif [ "$command" = "chown" ]
	then 
		exampleBefore=$(ls -l GeneratedFiles/newFile.txt)
		sudo $command 1200531 GeneratedFiles/newFile.txt
		example=$(ls -l GeneratedFiles/newFile.txt)
		echo -e "\033[1;97m________________\t_____________________________________________________________________________________________________________________________" >> "$filename"
        	echo -e -n "EXAMPLE\t\t\t\033[m"  >> "$filename"
        	replace_space_by_newLineWithSpaces "$exampleBefore\n" >> "$filename"
        	replace_space_by_newLineWithSpaces "\t\t\t$example\n" >> "$filename"
        
	else #Here the command will be zip.
		exampleBefore=$(ls GeneratedFiles/)
		temp=$($command GeneratedFiles/newDirectory.zip GeneratedFiles/fileToZipOrTar1.txt  GeneratedFiles/fileToZipOrTar2.txt)
		example=$(ls GeneratedFiles/)
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

    	echo -e "Information for ${command} saved to ${filename}\n"
    	mv "$filename" GeneratedFiles/
done
	

while true
do

	echo -n "Would you like to display a file of any of these generated files (enter Y for show file or N for exit) [Y/N]?"
	read -r answer
	if [ "$answer" = "Y" ] || [ "$answer" = "y" ]
	then
		echo -e "\nThe command list...\n"

		for command in "${commands[@]}"
		do
    			echo -e -n "\033[42m\033[3m "$command" \033[m/"
		done
		echo -e "\n"
		
		echo -e "\nPlease enter the name of the command you want to display the generated documentation for it:"
		read -r option 
		if [ -e "GeneratedFiles/$option.txt" ]
		then
			echo -e "Yes, this command exists.\n"
			cat "GeneratedFiles/$option.txt"
		else
			echo -e "Sorry, This command does not exist, please try another command!\n"
		fi
	elif [ "$answer" = "N" ] || [ "$answer" = "n" ]
	then
		echo -e "Thank you!\n"
		break
	else
		echo -e "Invalid input ! try again.\n"
	fi
done
	

	
echo -e "The first part of generating *Linux/Unix Command Manual* DONE successfully !\n\n "
echo -e "******************************************************************************************************.\n\n"
echo -n "Would you like to move on and verify the generated manual for any command in this program [Y/N]?"
read -r answer

if [ "$answer" = "Y" ] || [ "$answer" = "y" ]
then 
	echo -e "\nVerifying files started..\n\n"
	./verify.sh
	
elif [ "$answer" = "N" ] || [ "$answer" = "n" ]
then 
	echo -e "Thank you!\n"
	exit 1
else
	echo -e "Invalid input ! try again.\n"

fi









