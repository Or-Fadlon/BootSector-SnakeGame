org 0x7c00 ; BIOS load into specific address

video_interrupt = 0x10 ; video interrupt
    set_cursor_pos_service = 0x02 ; set cursor position. (DH, DL) - row, column, (BH) - page number
    write_char_service = 0x0A ; write char to screen. (BH) - page number, (AL) - char to write, (CX) - number of times to write
    scroll_active_page_up_service = 0x06 ; scroll active page up. (AL) - number of lines to scroll, (AL) = 0 clear entire screen
system_services_interrupt = 0x15 ; system services interrupt
    wait_service = 0x86 ; wait for a specified number of milliseconds. (CX, DX) - wait time before return to caller, in milliseconds
keyboard_interrupt = 0x16 ; keyboard interrupt
    read_key_service = 0x00 ; read key from keyboard. return: (AL) - ASCII character code, (AH) - scan code
    status_key_service = 0x01 ; check status of keyboard. return: ZF - 1 no code available 0 code is available, (AL) - ASCII code of key pressed, (AH) - scan code of key pressed
    left_arrow_scan_code = 0x4B ; left arrow scan code
    right_arrow_scan_code = 0x4D ; right arrow scan code
    down_arrow_scan_code = 0x50 ; down arrow scan code
    up_arrow_scan_code = 0x48 ; up arrow scan code
clock_interrupt = 0x1A ; clock interrupt
    read_system_timer_service = 0x00 ; read system timer. return: (CX) - high portion (seconds), (DX) - low portion (milliseconds)

snake_row: db 10 ; snake row
snake_col: db 5 ; snake column
food_row: db 5 ; food row
food_col: db 5 ; food column
scan_code: db right_arrow_scan_code ; scan code

start:
    ; wait for 1 milliseconds
    mov ah, wait_service
    mov cx, 1
    mov dx, 0
    int system_services_interrupt
    
    ; clear screen
    call clear_screen

    ; check for key stroke and handle it
    call handle_keyboard
    ; move snake
    call move_snake
    ; handle_food_collision
    call food_collision
    ; draw snake
    call draw_snake
    ; draw food
    call draw_food

    jmp start

clear_screen:
    mov ah, scroll_active_page_up_service ; scroll window up
    mov al, 0x00 ; blank entire window
    mov ch, 0x00 ; row upper left
    mov cl, 0x00 ; column upper left
    mov dh, 0xFF ; row lower right
    mov dl, 0xFF ; column lower right
    mov bh, 0x0F ; attribute
    int video_interrupt ; call video interrupt
    ret

handle_keyboard:
    mov ah, status_key_service ; check status of keyboard
    int keyboard_interrupt ; call keyboard interrupt
    jz .no_key ; no key pressed
    mov ah, read_key_service ; read key from keyboard
    int keyboard_interrupt ; call keyboard interrupt
    mov [scan_code], ah ; save scan code
    .no_key:
    ret

move_snake:
    cmp byte [scan_code], left_arrow_scan_code
    jne .not_left_arrow
    dec byte [snake_col] ; increment column
    jmp .move_snake_finish
    .not_left_arrow:
    cmp byte [scan_code], right_arrow_scan_code
    jne .not_right_arrow
    inc byte [snake_col] ; decrement column
    jmp .move_snake_finish
    .not_right_arrow:
    cmp byte [scan_code], down_arrow_scan_code
    jne .not_down_arrow
    inc byte [snake_row] ; increment row
    jmp .move_snake_finish
    .not_down_arrow:
    cmp byte [scan_code], up_arrow_scan_code
    ; jne failure
    dec byte [snake_row] ; decrement row
    
    .move_snake_finish:

    ret

food_collision:
    ; check if snake collide with food
    mov al, [food_row]
    cmp [snake_row], al
    jne .not_eat
    mov al, [food_col]
    cmp [snake_col], al
    jne .not_eat
    call move_food ; handle food collision
    .not_eat:
    ret

move_food:
    mov ah , read_system_timer_service ; read system timer
    int clock_interrupt ; call clock interrupt
    mov al, 7 ; 111
    and al, dl
    mov byte [food_row], al
    add byte [food_row], 7

    mov ah , read_system_timer_service ; read system timer
    int clock_interrupt ; call clock interrupt
    mov al, 7 ; 111
    and al, dl
    mov byte [food_col], al
    add byte [food_col], 7

    ret

draw_snake:
    mov ah, set_cursor_pos_service ; set cursor position service
    mov dh, [snake_row] ; row
    mov dl, [snake_col] ; column
    mov bh, 0 ; page number
    int video_interrupt ; call video interrupt

    mov ah, write_char_service ; write char to screen service
    mov bh, 0 ; page number
    mov al, '@' ; char to write
    mov cx, 1 ; number of times to write
    int video_interrupt ; call video interrupt

    ret

draw_food:
    mov ah, set_cursor_pos_service ; set cursor position service
    mov dh, [food_row] ; row
    mov dl, [food_col] ; column
    mov bh, 0 ; page number
    int video_interrupt ; call video interrupt

    mov ah, write_char_service ; write char to screen service
    mov bh, 0 ; page number
    mov al, '*' ; char to write
    mov cx, 1 ; number of times to write
    int video_interrupt ; call video interrupt

    ret

failure:
    jmp $

; code
times 510 - ($-$$) db 0 ; fill the rest of the sector with 0
dw 0xAA55 ; boot signature