.data

filename: 
.string "input.txt"

mode:     
.string "r"

yes:     
.string "Yes\n"

no:      
.string "No\n"

.text

.globl main

main:
    addi sp,sp,-80           #save return address and all registers used in the question(s0-s8)into stack
    sd ra,72(sp)
    sd s0,64(sp)   
    sd s1,56(sp)
    sd s2,48(sp)
    sd s3,40(sp)
    sd s4,32(sp)
    sd s5,24(sp)
    sd s6,16(sp)
    sd s7,8(sp)
    sd s8,0(sp)


    la a1,mode               #open file (address of txtfile="input.txt" and read mode="r")(file pointer saved into s0 always)
    la a0,filename
    call fopen
    mv s0,a0

    mv a0,s0                 #putting s0(fpt) back into a0,now using fseek to go the end of the file.
    li a1,0
    li a2,2       
    call fseek


    mv a0,s0                  #ftells tells the position of file pointer into a0
    call ftell
    mv s4,a0

    addi s5,x0,0                #initializing both the pointers(i=0 and j=n-1)
    addi s6,s4,-1


loop:
    bge s5,s6,exityes            #if left>=right,all characters matched,it is a palindrome


    mv a0,s0                     #read left character(first seek to i and then read using ftell and save that character into char[i])
    mv a1,s5
    li a2,0        
    call fseek
    mv a0,s0
    call fgetc
    mv s7,a0

    #read right character(first seek to j and then read using ftell and save that character into char[j])

    mv a0,s0
    mv a1,s6
    li a2,0
    call fseek
    mv a0,s0
    call fgetc
    mv s8,a0

    bne s7,s8,exitno                    #compare char[i] and char[j], if mismatch then print no otherwise carry on


    addi s5,s5,1                        #i++ and j--and then looping again
    addi s6,s6,-1
    jal x0,loop

exityes:                                 #all palindrome cases end here.
    la a0,yes
    call printf
    jal x0,done

exitno:                                  #all not palindrome cases end here.
    la a0,no
    call printf
done:
    mv a0,s0                     #fclose the file
    call fclose
    ld ra,72(sp)                         #restore return address and all registers used in the question (s0-s8) into stack
    ld s0,64(sp)   
    ld s1,56(sp)
    ld s2,48(sp)
    ld s3,40(sp)
    ld s4,32(sp)
    ld s5,24(sp)
    ld s6,16(sp)
    ld s7,8(sp)
    ld s8,0(sp)
    addi sp,sp,80
    addi a0,x0,0
    ret



















