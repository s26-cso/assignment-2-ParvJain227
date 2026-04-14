.text
.globl make_node

make_node:
    #allocates a new BST node with val=a0,left=NULL,right=NULL
    #struct Node{int val;Node* left;Node* right;}=24 bytes
    addi sp,sp,-16                  #firstly storing ra and registers to used into stack so that they can be recovered.
    sd ra,8(sp)
    sd s0,0(sp)

    mv s0,a0
    addi a0,x0,24
    call malloc
    sw s0,0(a0)
    sd x0,8(a0)
    sd x0,16(a0)
    ld ra,8(sp)
    ld s0,0(sp)
    addi sp,sp,16
    ret

.globl insert
insert:
    #inserts val into BST rooted at a0,returns root
    #if root==NULL =>make new node and return it
    #if val==root->val =>return root unchanged
    #if val<root->val =>recurse left
    #if val>root->val =>recurse right

    addi sp,sp,-32      #firstly storing ra and registers to used into stack so that they can be recovered.
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)

    mv s0,a0                #s0 = root
    mv s1,a1                #s1 = val
    beq a0,x0,beforefinal
    lw t0,0(s0)
    beq t0,s1,firstif
    blt s1,t0,secondif

    #val>root->val:recurse right,update right child

    ld a0,16(s0)
    mv a1,s1
    jal ra,insert
    sd a0,16(s0)
    mv a0,s0

    ld ra,24(sp)                #recovering the stored RA and registers.
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret


    #root==NULL:create new node and return it
    beforefinal:
    mv a0,s1
    call make_node
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

    #duplicate val:return root unchanged
    firstif:
    mv a0,s0
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

    #val<root->val:recurse left,update left child
    secondif:
    ld a0,8(s0)
    mv a1,s1
    jal ra,insert
    sd a0,8(s0)
    mv a0,s0


    ld ra,24(sp)                                 #recovering the stored RA and registers.
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret


.globl get
#search BST for val,return pointer to node or NULL if not found

get:

    addi sp,sp,-32                      #firstly storing ra and registers to used into stack so that they can be recovered.
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)

    mv s0,a0                #s0 = root
    mv s1,a1                #s1 = val
    beq s0,x0,end1
    lw t0,0(s0)
    beq s1,t0,end2
    blt s1,t0,end3

    # val > root->val: search right subtree
    ld a0,16(s0)
    mv a1,s1
    call get
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

    # root==NULL: not found, return NULL
    end1:
    mv a0,x0


    ld ra,24(sp)                             #recovering the stored RA and registers.
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret
    
    # val==root->val: found, return this node
    end2:
    mv a0,s0
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

    # val < root->val: search left subtree
    end3:
    ld a0,8(s0)
    mv a1,s1
    call get
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

.globl getAtMost
getAtMost:
    #returns greatest value in tree <= val,or -1 if none exists
    #if root->val == val:exact match,return it
    #if root->val > val:answer must be in left subtree
    #if root->val < val:root->val is a candidate,check right for better

    addi sp,sp,-32              #firstly storing ra and registers to used into stack so that they can be recovered.
    sd ra,24(sp)
    sd s0,16(sp)
    sd s1,8(sp)

    mv s0,a0                #s0 = val
    mv s1,a1                #s1 = root

    beq s1,x0,end11
    lw t0,0(s1)
    beq t0,s0,end12
    bgt t0,s0,end13

    #root->val < val:recurse right,if right returns -1 use root->val
    mv a0, s0
    ld a1,16(s1)
    jal ra,getAtMost
    addi t0,x0,-1
    beq a0,t0,end14


    ld ra,24(sp)                                          #recovering the stored RA and registers.
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

    #root==NULL:no valid value exists,return -1
    
    end11:
    addi t0,x0,-1
    mv a0,t0
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

    #exact match:return val
    end12:
    mv a0,s0
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

    #root->val>val:answer can only be in left subtree
    end13:
    mv a0,s0
    ld a1,8(s1)
    jal ra,getAtMost
    ld ra,24(sp)
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

    #right subtree did not have bigger value,use root->val as answer
    end14:
    lw a0,0(s1)


    ld ra,24(sp)                                             #recovering the stored RA and registers.
    ld s0,16(sp)
    ld s1,8(sp)
    addi sp,sp,32
    ret

















