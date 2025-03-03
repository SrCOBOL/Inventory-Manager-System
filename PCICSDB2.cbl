      **********************************************************
      * PROGRAM: INVENTORY.CBL                                 *
      * DESCRIPTION: INVENTORY MANAGER SYSTEM                  *
      * AUTHOR: FRANCISCO BORGES                               *
      **********************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. INVENTORY.
       ENVIRONMENT DIVISION.
       DATA DIVISION.
       WORKING-STORAGE SECTION.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       01  WS-OPTION        PIC X.
       01  WS-PROD-CODE     PIC 9(4).
       01  WS-PROD-NAME     PIC X(30).
       01  WS-STOCK-QTY     PIC 9(5).
       01  WS-PRICE         PIC 9(5)V99.

      *_________________CICS__________________
       LINKAGE SECTION.
       01  DFHCOMMAREA
           05 DFH-DATA      PIC X(100).
       
       PROCEDURE DIVISION.
       MAIN-LOGIC SECTION.

           EXEC CICS RECEIVE 
               INTO(DFH-DATA)
           END-EXEC.

           DISPLAY "INVENTORY MANAGEMENT SYSTEM".
           DISPLAY "1 - ADD PRODUCT".
           DISPLAY "2 - VIEW PRODUCT".
           DISPLAY "3 - UPDATE PRODUCT".
           DISPLAY "4 - DELETE PRODUCT".
           DISPLAY "5 - EXIT".
       
           ACCEPT WS-OPTION.
           EVALUATE WS-OPTION
             WHEN '1'
               PERFORM ADD-PRODUCT
             WHEN '2'
               PERFORM VIEW-PRODUCT
             WHEN '3'
               PERFORM UPDATE-PRODUCT
             WHEN '4'
               PERFORM DELETE-PRODUCT
             WHEN '5'
               STOP RUN
             WHEN OTHER
               DISPLAY "Option choosen isn't available"
           GOBACK.


      *__________________DB2 OPERATIONS____________________
       ADD-PRODUCT SECTION.
           DISPLAY "PRODUCT CODE".
           ACCEPT WS-PROD-CODE.
           DISPLAY "PRODUCT NAME".
           ACCEPT WS-PROD-NAME.
           DISPLAY "QT IN STORAGE".
           ACCEPT WS-STOCK-QTY.
           DISPLAY "PRICE".
           ACCEPT WS-PRICE.
           
           EXEC SQL
             INSERT INTO PRODUCTS (PROD_CODE, PROD_NAME, STOCK_QTY, 
                                   PRICE) 
             VALUES (:WS-PROD-CODE, :WS-PROD-NAME, :WS-STOCK-QTY, 
                     :WS-PRICE)
           END-EXEC.

           IF SQLCODE = 0 THEN
               DISPLAY "PRODUCT ADDED SUCCESSFULLY"  
           ELSE
               DISPLAY "ERROR ADDING PRODUCT. SQLCODE: " SQLCODE.
           GOBACK.
        

       VIEW-PRODUCT SECTION.
           DISPLAY "PLEASE ENTER THE PRODUCT CODE".
           ACCEPT WS-PROD-CODE.
           
           EXEC SQL
               SELECT PROD_NAME, STOCK_QTY, PRICE
               INTO :WS-PROD-NAME, :WS-STOCK-QTY, :WS-PRICE
               FROM PRODUCTS
               WHERE PROD_CODE = :WS-PROD-CODE
           END-EXEC.

           IF SQLCODE = 0 THEN
               DISPLAY "PRODUCT FOUND: " WS-PROD-NAME
               DISPLAY "STOCK: " WS-STOCK-QTY
               DISPLAY "PRICE: " WS-PRICE
           ELSE
               DISPLAY "PRODUCT NOT FOUND. SQLCODE: " SQLCODE.
           GOBACK.

       UPDATE-PRODUCT SECTION.
           DISPLAY "TO UPDATE PRODT PLEASE INSERT PRODT CODE:".
           ACCEPT WS-PROD-CODE.
           DISPLAY "NEW QUANTITY:".  
           ACCEPT WS-STOCK-QTY.
           
           EXEC SQL
               UPDATE PRODUCTS
               SET STOCK-QTY = :WS-STOCK-QTY
               WHERE PROD_CODE = :WS-PROD-CODE
           END-EXEC.

           IF SQLCODE = THEN 
               DISPLAY "PRODUCTS UPDATED SUCCESSFULLY"
           ELSE
               DISPLAY "ERROR UPDATING PRODUCT. SQLCODE: " SQLCODE.
           GOBACK.

       DELETE-PRODUCT SECTION.
           DISPLAY "PLEASE INSERT PRODT CODE TO DELETE:".
           ACCEPT WS-PROD-CODE.
           
           EXEC SQL
               DELETE FROM PRODUCTS
               WHERE PROD_CODE = :WS-PROD-CODE
           END-EXEC.

           IF SQLCODE = 0 THEN
               DISPLAY "PRODUCT DELETED SUCCESSFULLY"
           ELSE
               DISPLAY "ERROR DELETING PRODUCT. SQLCODE: " SQLCODE.
           GOBACK.
       
       END PROGRAM INVENTORY.
                        