# Unit 3 exercises
## Exercise 1:
- Create a function that returns 1 or 0 if a number is divisible by another. You must receive two numbers by parameters.
## Exercise 2:
- Use the conditional structures to show the day of the week according to a numerical entry value, 1 for Sunday, 2 Monday, etc.
## Exercise 3:
- Knowing that the `NOW()` function returns the current date and that `DATE_FORMAT` formats the date, creates a procedure that
call the previous function of the day of the week, and for the days **"Friday"** give us today's date in `dd-mm-yyyy` format.
## Exercise 4:
- create a procedure that receives a date by parameter and shows the day of the week on the screen, followed by the day, month and year
numbers.
## Exercise 5:
- Create a function, which receives a date of birth by parameter and returns the age of the person in years.
## Exercise 6
- Create a function that returns the largest of three numbers passed as parameters.
## Exercise 7
- Create a procedure with a while statement that: 
    - receive a whole number by parameter and show the sum of all the numbers, between 1 and the past as a parameter (both included).
    - If the entered number is zero or negative, an error message should be displayed.
## Exercise 8 
- Using the repeat statement, perform a procedure that shows the prime numbers from 0 up to a number passed by parameter.
## Exercise 9
- Performs a function called `leerDescriArti()`, which receives the code of an article and return your description.
## Exercise 10
- Perform a procedure called `consultarPedido()`, which receives the reference of a order and return the number of different items requested in said order and the number of units of items requested. The order reference is an input parameter and there will be two output parameters for the other two indicated data.
## Exercise 11
- Create a procedure called `mostrarInfoPedido()`, which receives the reference of a order, call the procedure `consultarPedido` and show the received data.
## Exercise 12
- Repeat the previous exercise but making the call to the procedure `consultarPedido()` through session variables.
## Exercise 13
- Perform a procedure called `importePedidos()` with an input / output parameter, it must receive an amount to which you must add the amount of all the orders of the database. The parameter is input / output because a data is passed to the procedure (input), data that it will be modified by the procedure and returned to the calling program (exit). In order to calculate the amount of all the orders, you have to add the amounts of all the line items in the OrderList table. It must be taken into account that the amount of a line item will be calculated by multiplying the number of units requested in said line order (`cantArt` attribute) for the unit price of the corresponding item (`PVPart` attribute of the article table).
## Exercise 14
- Perform a procedure called `impPedidos()` that makes a call to the procedure previous `importePedidos()`. The new procedure must be received as a parameter of enter the amount to which we want to add the amount of the orders of the database. It must show the message "The total amount is xxx.xx euros".
