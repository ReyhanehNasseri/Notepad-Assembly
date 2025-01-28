org 100h   

start: 

    mov ah,0
    mov al ,00h
    int 10h   
   
   
 
data:
 
    pagenumber db 0
    scrollupcount db 0 
                                         
    
input_loop:

    mov ah, 00h   ; read the key pressed (export to ah/al)     
    int 16h                                  
             
    cmp al, 1Bh   ; press esc to end the programm        
    je exit 
    
    cmp ah, 48h   ;arrow up(move the cursor up)     
    je arrowup
    
    cmp ah, 50h        
    je arrowdown  ;arrow down(move the cursor down) 
       
    cmp al, 08h
    je backspace  ;backspace
    
    cmp al, 0Dh
    je enter      ;enter
    
    cmp ah,49h
    je pageup     ;page up (go to previous page)
    
    cmp ah,51h
    je pagedown   ;page down (go to next page)
    
    cmp al,3dh
    je scrollup   ; + (move the written texts up)
    
    cmp al, 2dh
    je scrolldown ; - (move the written texts down) 
      
    
    mov ah, 0Eh   ; write the character down in terminal      
    int 10h
    
     
    jmp input_loop          
    
    
    
backspace: 
 
    mov ah, 3
    mov bh, pagenumber
    int 10h       ; read the cursor location
    
    cmp dl, 0
    je lineup
   
    mov ah, 2 
    mov dl, 8
    int 21h       ; write backspace (the cursor shift to left)
    
    mov ah, 2 
    mov dl, 0
    int 21h       ; write null in the location
          
    mov ah, 2
    mov dl, 8
    int 21h       ; write backspace (the cursor shift to left)
    
    jmp input_loop
    
    
lineup:

    mov ah, 3
    mov bh,, pagenumber
    int 10h
    
    dec dh
    mov dl,0
    mov ah, 2  
    int 10h       ; move the cursor at the firt of prev line and set it 
    
    jmp lineend
    
    
    
    
lineend:
    
    mov ah, 8
    mov bh, pagenumber
    int 10h       ; read character at cursor position
    
    cmp al,0
    je input_loop
                      
    mov ah, 3
    mov bh, pagenumber
    int 10h
    
    inc dl
    mov bh,pagenumber
                        
    mov ah, 2  
    int 10h 
    
    jmp lineend
    
    
originloc: 

    mov dl,00h
    mov dh,00h
    mov bh,pagenumber
    mov ah,02h
    int 10h
     
    jmp columndown 
        

    
columndown: 

    mov ah, 8
    mov bh, pagenumber
    int 10h
    
    cmp al, 0
    je  lineup
                      
    mov ah, 3
    mov bh, pagenumber
    int 10h
    
    inc dh
    mov bh,pagenumber
                        
    mov ah, 2  
    int 10h 
    
    jmp columndown      
    
    
enter:

   mov ah, 03h 
   int 10h
   
   cmp dh, 18h
   je pagedown
             
   inc dh 
   mov dl , 00h
   mov ah , 02h
   int 10h 
   
   jmp input_loop 
   
   
pageup:

   mov ah, 05h
   mov al, pagenumber 
   
   cmp al, 0
   je input_loop 
   
   dec al
   dec pagenumber
   int 10h            ; move to menssioned page number
   
   jmp originloc
   
   

pagedown:

   mov ah, 05h
   mov al, pagenumber 
   
   cmp al, 7
   je input_loop
   
   inc al
   inc pagenumber
   int 10h            ; move to menssioned page numbe
   
   jmp originloc
   
   
scrollup: 
 
 cmp scrollupcount , 0h
 je input_loop
 
 mov ah,06
 mov al,01
 mov cx,0000h
 mov dx,1827h
 int 10h              ; move the written texts one line up
 
 mov ah , 3
 int 10h
 
 dec dh
 mov bh , pagenumber 
 mov ah ,2
 int 10h
  
 dec scrollupcount
 
 jmp input_loop  
 
 
scrolldown: 
 
 mov ah , 3
 int 10h 
 
 cmp dh , 18h
 je input_loop 
 
 mov ah,07
 mov al,01
 mov cx,0000h
 mov dx,1827h
 int 10h  
 
 mov ah , 3
 int 10h  
 
 inc dh
 mov bh , pagenumber 
 mov ah ,2
 int 10h 
 
 inc scrollupcount
 
 jmp input_loop
 
 
arrowup: 

 mov ah ,3
 int 10h 
 
 cmp dh,0
 je pageup
 
 dec dh
 mov bh ,pagenumber
 mov ah,2
 int 10h 
 
 jmp input_loop 
 
 
 
 
arrowdown: 

 mov ah ,3
 int 10h 
 
 cmp dh,18h
 je pagedown
 
 inc dh
 mov bh ,pagenumber
 mov ah,2
 int 10h 
 
 jmp input_loop 
  
    
   


exit:
 mov ah, 4Ch        
 int 21h            
