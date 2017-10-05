.data
/* Create the memory allocations for the array and the temp variable, used for swapping. */
array: .word 25,110,149,10,12
temp: .word 0 @temp value to store addresses
.text
.global main
.func main
main:
                mov r1, #0
                mov r2, #0
                mov r3, #0
                mov r4, #0
                mov r5, #0
                mov r6, #0
                mov r7, #0
                mov r8, #0
                mov r9, #0
                /**
                Register Mapping
                r2: Holds the max offset - it points to the location in memory after the last element in the array. 
                r5: Holds the offset used to iterate through the main loop
                all other registers used are used depending on the breakpoint. I made sure to focus on using memory and not registers.
                **/
                mov r2, #20
                mov r5, #0
loopBegin:
                /**
                Initiate the loop to start the sorting algorithm
                r1: loads memory address of the array, then is used to load the value at the current offset
                r9: used as a "middle" register to store the value of at offset in the array
                r8: used as a temp register to compare differences, reinitialized at each iteration
                r7: used as the iterator for the inner loop. Allows to start from the element after the "current" element
                r3: Used to keep track of the current offset where the smallest position is available. 
                **/
                ldr r1, =array
                ldr r9, [r1, r5]
                mov r1, r9
                subs r4, r2, r5       /*Compares the current offset and the max offset, if it's max, go to end*/
                beq end
                mov r8, #0 /*Initialize a register to hold the difference between the current element and smallest element. Used to compare*/
                mov r7, r5
                mov r3, #0
                b innerLoop
innerLoop:
                /**
                Inner loop to compare the current value in the array to all values before it. 
                checks the difference between the current element and every following element. 
                If the difference is positive, store the difference in r8 and element's offset in r3
                repeat until the end of the array.
                Register mapping:
                r7: offset iterator
                r4: used to hold substraction values, doesn't affect outcome
                r6: used to load the memory address of the array
                r9: loads value in array at current r7 offset
                **/
                add r7, r7, #4 /* Initially used to go to the elements following the current one being compared. Then used as iterator */
                subs r4, r7, r2 /* Compare the offset to the max possible offset, end the loop if end of the array is reached */
                beq innerLoopEnd
                ldr r6, =array /* Loads the memory address of the array into r6 */
                ldr r9, [r6, r7] /* Loads the value at the current r7 offset */
                sub r4, r1, r9 /* Compare the element checked to the elements in the array and store the difference in r4 */
                subs r4, r4, r8 /* Compares the value in r4 to the the value in the "difference" register, r8, if r4 is bigger, the new element is the smallest found so far */
                movpl r8, r4 /* stores the new difference into r8 for future checking */
                movpl r3, r7 /* Stores the new offset into the offset register r3 */
                b innerLoop
swapOperation:
                /**
                Performs the swap operation in the array between the current element and the smallest element after it.
                Each step of the swap is explained below:
                **/
                ldr r1, =array /* Load the memory address of the array into r1, this is done to ensure that r1 isn't ocmpromised and no programmer error occured */
                /* Better be safe than sorry!! */
                ldr r4, [r1, r5] /* Load the value of the element to be swapped into r4 */
                ldr r9, =temp /* Load the memory address of the temp variable into r9 */
                str r4, [r9] /* Store the value of the element to be swapped into the temp address */
                mov r9, r3 /* Move the offset of the new smallest element into r9 */
                ldr r1, =array /* reload the memory address of the array. Again, done to ensure that I didn't do anything stupid! */
                ldr r9, [r1, r3] /* Load the value of the new smallest element into r9 */
                str r9, [r1, +r5] /* Store the current smallest value into the memory address of the original element */
                ldr r9, =temp /* Load memory address of temp variable - this now contains the original value */
                ldr r9, [r9] /* load the original value into r9 */
                str r9, [r1, +r3] /* Store the original value into the memory address of what was the smallest value found, thus swapping them in memory! */
                add r5, r5, #4 /* Increment the loop iterator */
                b loopBegin
innerLoopEnd:
                /**
                Checks to see if the value in the offset register changed from its initial value
                If it did, perform the swap operation.
                **/
                subs r8, r8, #0
                bne swapOperation
                add r5, r5, #4
end:
                /**
                Pulls the last element in the array (which should be the biggest). And displays it. 
                **/
                ldr r1, =array
                ldr r9, [r1, r5]
                mov r0, r9
                bx lr
