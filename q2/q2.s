.data
fmt_d:
.string "%d"

fmt_sp:
.string " "

fmt_nl:
.string "\n"

.text

.globl main

main:
addi sp,sp,-80                #save return address and all registers used in the question(s0-s8)into stack
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


#arcv=contains starting address of where memory is stored , argc=contains n+1
addi s0,a0,-1           #s0=n=argc-1
mv s1,a1                #s1=argv


addi t0,x0,8            #malloc the arr[n]
mul a0,s0,t0            #a0=n*8 bytes
call malloc


mv s2,a0                #s2=arr pointer
addi t0,x0,8            #malloc res[n]
mul a0,s0,t0            #a0=n*8 bytes
call malloc


mv s3,a0                #s3=res pointer
addi t0,x0,8            #malloc stk[n]
mul a0,s0,t0            #a0=n*8 bytes
call malloc

    
mv s4,a0                #s4=stk pointer

addi s5,x0,0
addi s6,x0,8


#loop1:convert argv strings to ints via atoi,store in arr[],initialize res[]=-1


loop1: 
beq s5,s0,loop1end
addi t0,s5,1              #t0=i+1
addi t1,x0,8
mul t0,t0,t1
add t0,s1,t0              #t0=&argv[i+1]
ld a0,0(t0)               #a0=argv[i+1](pointer to string)
call atoi
addi t1,x0,8
mul t2,s5,t1
add t3,s2,t2
sd a0,0(t3)
add t4,s3,t2
addi t5,x0,-1
sd t5,0(t4)
addi s5,s5,1
jal x0,loop1
loop1end:



#setup:i=n-1,top=-1,traverse right to left
addi t0,s0,-1             
add s5,t0,x0
addi s6,x0,-1


#loop2:outer loop over i from n-1 down to 0
loop2:
blt s5,x0,loop2end

#load arr[i] once before inner while
addi t0,x0,8
mul t0,s5,t0
add t1,s2,t0
ld t5,0(t1)

#if stack non-empty go to while loop,else skip straight to push
bge s6,x0,loop3start
jal x0,cond

#loop3start:while loop,pop stack while arr[stk[top]]<=arr[i]

loop3start:
blt s6,x0,cond          #stack empty,exit while

addi t0,x0,8
mul s8,s6,t0
add s7,s4,s8
ld t2,0(s7)            #j=stk[top]
addi t0,x0,8
mul t1,t2,t0
add t4,s2,t1
ld t3,0(t4)             #arr[j]
blt t5,t3,cond          #arr[j]>arr[i],found NGE,stop popping
addi s6,s6,-1           #pop
jal x0,loop3start
loop3end:


loop2end:
jal x0,printstart

#cond:set res[i]=stk[top] if stack non-empty,then push i

cond:
blt s6,x0,skip               #stack empty,skip result finding
slli t0,s5,3
slli t3,s6,3
add t1,s3,t0
add t5,s4,t3
ld t6,0(t5)
sd t6,0(t1)                  #res[i]=stk[top]


skip:
addi s6,s6,1
addi t0,x0,8
mul t0,s6,t0
add t5,s4,t0
sd s5,0(t5)                 #stk[top]=i
addi s5,s5,-1               #i--
jal x0,loop2
condend:


#print res[]space-separated followed by newline
printstart:
addi s5,x0,0

loopfinal:
beq s5,s0,loopfinalend
beq s5,x0,skip2
la a0,fmt_sp
call printf
skip2:
la a0,fmt_d
addi t0,x0,8
mul t0,s5,t0
add s7,s3,t0
ld a1,0(s7)
call printf
addi s5,s5,1
jal x0,loopfinal
loopfinalend:


la a0,fmt_nl
call printf
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


















