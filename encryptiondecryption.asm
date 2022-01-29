org 100h  


.data 

;----------------------
;Defining file names and file handle

fname db 'enc_file.txt',0
dec_file db 'dec_file.txt',0
handle dw ?
handle_d dw ?

;Defining necessary variables
newline db 13, 10, '$'
input db 100,?,100 dup(?)
line db 100 dup(?)
len db ?     
encrypted_line db 100 dup(?)
read_line db 100 dup(?)
read_line2 db 100 dup(?)
decrypted_line db 100 dup(?)
msg1 db "Enter password to encrypt the message : $"
msg2 db "Enter a string to encrypt : $" 
msg3 db "Encrypting... $"
msg4 db "Decrypting... $"
msg5 db "Encrypted message : $" 
msg6 db "Decrypted message : $"
msg7 db "Enter password for decryption : $"

;keys to encrypt and decrypt
k1 db ?
k2 db ? 


;----------------------

;Encryption procedure

proc encryption :

lea dx, newline
mov ah, 09h
int 21h

lea dx, msg1
mov ah, 09h
int 21h

mov ah, 1
int 21h

mov k1, al

mov ah,1
int 21h

mov k2, al

lea si, input
inc si
mov cl, [si]
mov ch, 0h

lea si, line
lea di, encrypted_line

enc_loop:
    
        
    lodsb
    
    add al, k1
    sub al, k2
       
    stosb
    
  loop enc_loop
    
ret


;Decryption procedure

proc decryption:
    
lea dx, newline
mov ah, 09h
int 21h

lea dx, newline
mov ah, 09h
int 21h

lea dx, msg7
mov ah, 09h
int 21h

mov ah, 1
int 21h

mov k1, al

mov ah,1
int 21h

mov k2, al



lea dx, newline
mov ah, 09h
int 21h  


lea si, input
inc si
mov cl, [si]
mov ch, 0h

lea si, read_line
lea di, decrypted_line

dec_loop:

    lodsb
    
    add al, k2
    sub al, k1
    
    stosb
  
  
  loop dec_loop
  
ret


.code
                                

lea dx, msg2
mov ah, 09h
int 21h
                                
;Opening file through write mode

mov al, 1
	mov dx, offset fname
	mov ah, 3dh
	int 21h
	
	mov handle, ax
  


;String input

lea dx, input
mov ah, 0ah
int 21h

lea si, input
inc si
mov cl, [si]
mov len, cl         ;length of input string
mov ch, 0h
add si, cx
mov [si+1],'$'


lea si, input+2
lea di, line

add di, cx
mov [di+1], '$'

lea di, line

;Storing input string to a new string 'line'

while1:
    lodsb
    stosb
  loop while1



;--------------------------------

lea dx, newline
mov ah, 09h
int 21h


lea dx, msg3
mov ah, 09h
int 21h
       

lea dx, newline
mov ah, 09h
int 21h

       
;Calling encryption pro

call encryption




;--------------------------------

;Writing a line to file
        
lea si, input
inc si
mov cl, [si]
mov ch, 0h


        
lea dx, encrypted_line
mov bx, handle


mov ah, 40h
int 21h


;File closing
mov bx, handle
mov ah, 3eh
int 21h


;String output


lea si, input
inc si
mov cl, [si]
mov len, cl         ;length of input
mov ch, 0h
add si, cx
mov [si+1],'$'


lea si, input+2
lea di, encrypted_line

add di, cx
mov [di+1], '$'





lea dx, newline
mov ah, 09h
int 21h



;File opening through read mode
mov al, 0
mov dx, offset fname
mov ah, 3dh
int 21h


;Read from file 

mov bx, handle
mov cl, len
mov ch, 0h
lea dx, read_line

mov ah, 03fh
int 21h

lea di, read_line
mov cl, len
mov ch, 0
add di, cx
mov [di+1], '$'

lea dx, msg5
mov ah, 09h
int 21h

lea dx, read_line
mov ah, 09h
int 21h


;File closing
mov bx, handle
mov ah, 3eh
int 21h


lea dx, newline
mov ah, 09h
int 21h

lea dx, newline
mov ah, 09h
int 21h

lea dx, msg4
mov ah, 09h
int 21h
         
         
         
         
;Calling decryption procedure

call decryption:


;Opening file through write mode

mov al, 1
	mov dx, offset dec_file
	mov ah, 3dh
	int 21h
	
	mov handle_d, ax
  

 
;Writing a line to file
        
lea si, input
inc si
mov cl, [si]
mov ch, 0h


        
lea dx, decrypted_line
mov bx, handle_d


mov ah, 40h
int 21h


;File closing
mov bx, handle_d
mov ah, 3eh
int 21h



;File opening through read mode
mov al, 0
mov dx, offset dec_file
mov ah, 3dh
int 21h


;Read from file 

mov bx, handle_d
mov cl, len
mov ch, 0h
lea dx, read_line2


mov ah, 03fh
int 21h


lea di, read_line2
mov cl, len
mov ch, 0
add di, cx
mov [di+1], '$'


lea dx, msg6
mov ah, 09h
int 21h

lea dx, read_line2
mov ah, 09h
int 21h


;File closing
mov bx, handle
mov ah, 3eh
int 21h 


ret
       