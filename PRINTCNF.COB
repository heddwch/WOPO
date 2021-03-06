       IDENTIFICATION DIVISION.
       PROGRAM-ID. "PRINT-CONFIG".

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT CONFIG
               ASSIGN TO DISK
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               RECORD KEY IS CONFIG-KEY.
           SELECT USERS
               ASSIGN TO DISK
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               RECORD KEY IS USER-NAME.
           SELECT CHANNELS
               ASSIGN TO DISK
               ORGANIZATION IS SEQUENTIAL.
           SELECT PROGRAM-INDEX
               ASSIGN TO DISK
               ORGANIZATION IS INDEXED
               ACCESS MODE IS SEQUENTIAL
               RECORD KEY IS NAME OF INDEX-ENTRY.
           SELECT PROGRAM-CODE
               ASSIGN TO DISK
               ORGANIZATION IS RELATIVE
               ACCESS MODE IS DYNAMIC
               RELATIVE KEY IS PROGRAM-IP.

       DATA DIVISION.
       FILE SECTION.
       FD CONFIG.
       01 CONFIG-RECORD.
           03 CONFIG-KEY PIC X(16).
           03 CONFIG-VALUE PIC X(64).
       FD USERS.
       01 USER-RECORD.
           03 USER-NAME PIC X(40).
           03 USER-LEVEL PIC 9(2).
       FD CHANNELS.
       01 CHANNEL-RECORD.
           03 CHANNEL-NAME PIC X(50).
       FD PROGRAM-INDEX.
       01 INDEX-ENTRY.
           03 NAME PIC X(16).
           03 ADDR PIC 999.
       FD PROGRAM-CODE.
       01 PROGRAM-RECORD.
           03 INSTRUCTION-RECORD PIC X(999).
           03 PREV-IP PIC 999.
           03 NEXT-IP PIC 999.

       WORKING-STORAGE SECTION.
       01 STATE PIC 9(2) VALUE 0.
           88 DONE VALUE 10.
       01 PROGRAM-IP PIC 999.

       PROCEDURE DIVISION.
           DISPLAY "CONFIGURATION ENTRIES.".
           OPEN INPUT CONFIG.
           PERFORM PRINT-CONFIG-ENTRY UNTIL DONE.
           MOVE 0 TO STATE.
           CLOSE CONFIG.
           DISPLAY "USER ENTRIES.".
           OPEN INPUT USERS.
           PERFORM PRINT-USER-ENTRY UNTIL DONE.
           MOVE 0 TO STATE.
           CLOSE USERS.
           DISPLAY "CHANNEL ENTRIES.".
           OPEN INPUT CHANNELS.
           PERFORM PRINT-CHANNEL-ENTRY UNTIL DONE.
           MOVE 0 TO STATE.
           CLOSE CHANNELS.
           DISPLAY "PROGRAMS.".
           OPEN INPUT PROGRAM-INDEX, PROGRAM-CODE.
           PERFORM PRINT-PROGRAM UNTIL DONE.
           CLOSE PROGRAM-INDEX, PROGRAM-CODE.
           EXIT PROGRAM.

       PRINT-CONFIG-ENTRY.
           READ CONFIG NEXT RECORD
               AT END MOVE 10 TO STATE.
           IF NOT DONE THEN
               DISPLAY CONFIG-RECORD.

       PRINT-USER-ENTRY.
           READ USERS NEXT RECORD
               AT END MOVE 10 TO STATE.
           IF NOT DONE THEN
               DISPLAY USER-RECORD.

       PRINT-CHANNEL-ENTRY.
           READ CHANNELS NEXT RECORD
               AT END MOVE 10 TO STATE.
           IF NOT DONE THEN
               DISPLAY CHANNEL-RECORD.

       PRINT-PROGRAM.
           READ PROGRAM-INDEX NEXT RECORD
               AT END MOVE 10 TO STATE.
           IF NOT DONE THEN
               DISPLAY NAME OF INDEX-ENTRY
               MOVE ADDR OF INDEX-ENTRY TO PROGRAM-IP
               PERFORM PRINT-INSTRUCTION UNTIL DONE
               MOVE 0 TO STATE.

       PRINT-INSTRUCTION.
           READ PROGRAM-CODE RECORD
               AT END MOVE 10 TO STATE.
           IF NOT DONE THEN
               DISPLAY PROGRAM-IP, ".", INSTRUCTION-RECORD, ".",
                       PREV-IP, ".", NEXT-IP
               IF NEXT-IP OF PROGRAM-RECORD IS EQUAL TO 999 THEN
                   MOVE 10 TO STATE
               ELSE
                   MOVE NEXT-IP OF PROGRAM-RECORD TO PROGRAM-IP.
