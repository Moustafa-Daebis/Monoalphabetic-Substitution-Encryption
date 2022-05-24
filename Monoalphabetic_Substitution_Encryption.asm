include 'emu8086.inc'

org 100h


jmp START

;                     'abcdefghijklmnopqrstuvwxyz'

enc_table         DB  'qwertyuiopasdfghjklzxcvbnm' , '$'

dec_table         DB  'kxvmcnophqrszyijadlegwbuft' , '$'

input_msg         DB  'Enter the message : ', '$'

enc_msg           DB  'Encrypted message : ', '$'

dec_msg           DB  'Decrypted message : ', '$'


START:

           

LEA    dx,input_msg
CALL printer  ;print message

LEA    DI,buffer
MOV    DX,3Ch ;size of buffer, number of string to be typed in   size of buffer is 3Ch including ($) 
CALL   GET_STRING

LEA    dx,new_line
CALL printer     ; print new line            
           
                     
                     
; encryption
LEA    bx, enc_table     ;0700:0102
LEA    si, buffer        ;0700:01EF offset from 61 to 7A according to letter
LEA    di, encrypted_str ;0700:022C
CALL encrypter_decrypter
                                          

LEA    dx,enc_msg
CALL printer     ;print message

LEA    dx, encrypted_str
CALL printer     ; show result

LEA    dx,new_line
CALL printer ; print new line   
                
           
                
; decryption
LEA    bx, dec_table          ;0700:011D
LEA    si, encrypted_str      ;0700:022C offset from 61 to 7A according to letter
LEA    di, decrypted_str      ;0700:0269
CALL encrypter_decrypter


LEA    dx,dec_msg
CALL printer      ; show result:

LEA    dx, decrypted_str
CALL printer 

LEA    dx,new_line
CALL printer    ; print new line
           
           
           
; wait for any key to end programme
mov    ah, 0
int    16h
;subroutine to output on screen using interrupt 
printer proc near
  MOV ah,09h
  INT 21h
ret
printer endp
;subroutine to encrypt/decrypt lower case characters using xlat
encrypter_decrypter proc near

next_char:	      cmp    [si], '$'      ; end of string?
	              je     end_of_string
	              cmp    [si], ' '
	              je     skip_to_next_char
	             
	              mov    al, [si]
	              cmp    al, 'a'
	              jb     skip
	              cmp    al, 'z'
	              ja     skip
	              sub    al,61h		
	               
	              xlatb     ; encrypt using table2 and table 1  
skip:	          mov    [di], al
	              inc     di


skip_to_next_char:  inc    si	
	                jmp    next_char


end_of_string:    


ret
encrypter_decrypter endp



new_line          DB  0DH,0AH,'$'              ;for new line

buffer            DB  61 DUP('$')              ;buffer string   60d buffer

encrypted_str     DB  61 DUP('$')              ;encrypted string

decrypted_str     DB  61 DUP('$')              ;decrypted string

DEFINE_GET_STRING       

END

