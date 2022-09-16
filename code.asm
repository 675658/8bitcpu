mov ps,f0h      ;初始化栈顶指针
mov r0,00h      ;r0清零
add r0,01h      ;r0+1
mov [ffh],r0    ;显示r0到led灯组
call 8d         ;delay(1.8s)
jmp 2d          ;跳转到第三行继续执行
nop             ;空指令
nop             ;空指令
push r0         ;保护r0
push r1         ;保护r1
push r2         ;保护r2
mov r2,200d     ;r2=200
mov r1,200d     ;r1=200
mov r0,22d      ;r0=22
sub r0,1d       ;r0-1
jnz 14d         ;若r0不为0,跳转到第15行
sub r1,1d       ;r1-1
jnz 13d         ;若r1不为0,跳转到第14行
sub r2,1d       ;r2-1
jnz 12d         ;若r2不为0,跳转到第13行
pop r2          ;恢复r2
pop r1          ;恢复r1
pop r0          ;恢复r0
ret             ;回到上一层函数