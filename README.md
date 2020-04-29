# SER502-Spring2020-Team7

# Installation Guide
This document gives the installation steps required to set up and runs our Programming
language - Sparky. The executing Environment is Microsoft Windows.
# Environment Setup
1. Install SWI-SH Prolog installed on the system and environment path variables should be
set. Detailed instructions to install SWI-SH Prolog is found here
2. Install Java JDK 8 and set environment variables path variables. Java JDK can be found
here. Ensure JAVA_HOME is set.
3. Install Maven on the system if you are running on the terminal/command prompt. Maven
installation guide here . You can download Maven here .
4. Download Sparky source code from git to an empty folder.
# Execution Steps for Terminal / Command Prompt
1. Open the downloaded source code folder in the terminal/command prompt.
2. Run the following commands: <br />
mvn clean compile assembly:single <br />
java -jar target\sparky-0 .0.1-SNAPSHOT-jar-with-dependencies.jar
# To Run custom files
java -jar target\sparky-0 .0.1-SNAPSHOT-jar-with-dependencies.jar
<< full_path_to_your_file_with_filename .spk >>
