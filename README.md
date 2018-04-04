# TwitSplitDemo
TwitSplit Project for ZALORA's pre-interview assignment

# Envaironment
 -  Xcode 9.3
 - Swift 4

# What I've done
 - iOS application that serves the Tweeter interface.
 - Split Message funtion
 - Unit Test for Split Message funtion
 - Documentation.

# Workflow of Split Message

 - **Step 1:** Trim input message.
 - **Step 2:** Check if message length is valid then return message.
 - **Step 3:** Check if message is a span of non-whitespace characters longer than the limit characters then return error.
 - **Step 4:** Estimate the length of a chunk without the part indicator.
 - **Step 5:** Split Message.
    - **Step 5.1:** Estimate the End Index of new chunk base on the start index and the estimate length of chunk
    - **Step 5.2:** Find the left closest whitespace from the Estimated End Index. If it doesn't exist then return error, it means there is a span of non-whitespace characters longer than the limit characters.
    - **Step 5.3:** Set the founded index as the end of the new chunk and save the new chunk.
    - **Step 5.4:** Find the right closest non-whitespace from the founded index in step 5.2. If it doesn't exist then go to step 6, it means we have reached over the end of the message. 
    - **Step 5.5:** Check If the length of the part indicator should be changed when increase the number of chunks. If not, go to step 5.7
    - **Step 5.6:** Find the first invalid saved chunk with new length of the part indicator. Set the start index to this chunk's start index then loop to step 5.1
    - **Step 5.7:** Set found index in step 5.4 as the new start index then loop to step 5.1 
 - **Step 6:** Return the chunks splited from the input message.

# What I want to improve
- Improving the UI:
 + Hide navigation bar when scroll tableView to extend the content of tableView
 + Not Run Split Message funtion in main thread
 + Stored messages data in Core Data
 + Action on display message (edit, delete, show length of message...)
 + Setting to change the limit character
- Refactoring Code
