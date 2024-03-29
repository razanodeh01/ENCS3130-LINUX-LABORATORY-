#***************************************************************************************************************.

# This is the third part:  Continuous Improvement and Extension.
# This part contain two stages: 1-Search Functionality. 2-Command Recommendation.
# This part aims to enhance the existing project by incorporating additional features, improving usability,and extending functionality

#****************************************************************************************************************.
#!/bin/bash

while true
do
    echo -e "This part has two stages: Search or command recommendation.\n"
    echo -e "Option 1) Search.\nOption 2) Command Recommendation.\nOption 3) Exit.\n"
    echo -n "Please enter the number of your option you would to run:"
    read -r option

    case "$option" in
        1) while true
            do
                echo -e "In search stage, there few options:\n\t\t1- Search for specific information for a command.\n\t\t2- Search for specific topic.\n\t\t3- Exit.\n"
                echo -n "Please enter the option of the search technique you would like to run:"
                read -r choice

                case "$choice" in
                    1) # Display the commands for the user.
		       echo -e "The command list...\n"
		       commands=("ls" "echo" "mv" "rm" "touch" "cat" "chmod" "grep" "tar" "date" "whoami" "sort" "head" "mkdir" "find" "printf" "cp" "rmdir" "more" "chown" "zip")

		       for command in "${commands[@]}"
		       do
    				echo -e -n "\033[42m\033[3m "$command" \033[m/"
		       done
		       
		       echo -e "\n"
                       echo "Please enter the name of the command:"
                       read -r commandToSearch
                       
                       if [ -e "GeneratedFiles/$commandToSearch.txt" ]
                       then
                           echo -e "\nYes this command exists, so you can search about the information related to this command."
                           echo -e "\nWhat details about this command (Description/Version/Example/Related commands) are you looking for?"
                           read -r infoType
                           
                           if [ "$infoType" = "VERSION" ] || [ "$infoType" = "EXAMPLE" ] 
                           then
                          	  result=$(awk "/$infoType\t\t\t\033\[m/,/^$/" "GeneratedFiles/$commandToSearch.txt")
                          	  echo -e "$result\n"
                          	  
                           elif [ "$infoType" = "DESCRIPTION" ] || [ "$infoType" = "RELATEDCOMMANDS" ] 
                           then 
                                  result=$(awk "/$infoType\t\t\033\[m/,/^$/" "GeneratedFiles/$commandToSearch.txt")
                                  echo -e "$result\n"
                           else
                           	echo -e "Sorry, this type of information does NOT exit in the generated file for the command.!\n"
                           fi
                           
                       else
                           echo -e "Sorry, This command does not exist, please try another command!\n"
                       fi;;
                       
                    #*****************************************************************************************
                    2) echo -e "\nPlease enter a word related to the topic you would like to search about it:"
                       read -r topic
                       result=$(grep -Hn "$topic" GeneratedFiles/*.txt)
                       if [ -n "$result" ]  
                       then
                           echo -e "The search is done SUCCESSFULLY!\n"
                           echo -e "This is where the generated files contained this topic.\n"
                           echo -e "$result\n"
                       else
                           echo -e "The search is done, but no files contained the entered topic.\n"
                       fi;;
                    #*****************************************************************************************
                    3) echo -e "Thank you!\n"
                       break 1;;
                    #******************************************************************************************
                    *) echo -e "Invalid input, please enter a number from 1-3!\n";;
                esac
            done;;
            
            
        #****************************************************************************************************************
        2) echo -e "In command recommendation stage, I would suggest some commands if you want to display any of them.\n"
        	
          #Enable the history feature and source the user's bash history file
          HISTFILE=~/.bash_history
          set -o history
          history -r $HISTFILE
          echo "Command Recommendations Based on Your History:"

	  #Analyze and suggest commands based on user's history
          history | awk '{CMD[$2]++;count++;}END { for (a in CMD)print a;}' | grep -v './' | column -c3 -s ' ' -t | sort -nr | nl | head -n10
          
          echo -n "Would you to display any of these commands [Y\N]?"
          read -r answer
          
          if [ "$answer" = "Y" ] || [ "$answer" = "y" ]
          then
          	# Display the command for the user.
		echo -e "The command list...\n"
		commands=("ls" "echo" "mv" "rm" "touch" "cat" "chmod" "grep" "tar" "date" "whoami" "sort" "head" "mkdir" "find" "printf" "cp" "rmdir" "more" "chown" "zip")

		for command in "${commands[@]}"
		do
  		    echo -e -n "\033[42m\033[3m "$command" \033[m/"
		done

          	echo -e "\nPlease enter the name of the command you want to display it:"
          	read -r command
          	
          	if [ -e GeneratedFiles/$command.txt ]
          	then
          		echo -e "\nYes, this command exist."
          		cat GeneratedFiles/$command.txt
          		
          	else
          		echo -e "\nSorry, this command doesn't exist, try another command!"
      
          	fi
          	
          	
          elif [ "$answer" = "N" ] || [ "$answer" = "n" ]
          then
          	echo -e "\nThank you !"
          	break 1
          	
          else
          	echo -e "\nInvalid input, try again!"
          fi;;
          
        #******************************************************************************************************************
        3) echo -e "Thank you!\n"
           echo -e "The third 'LAST' part of generating *Linux/Unix Command Manual* DONE successfully !\n\n"
	   echo -e "******************************************************************************************************."
           break;;
        #*******************************************************************************************************************
        *) echo -e "Invalid input, please enter a number from 1-3!\n";;
    esac
done
