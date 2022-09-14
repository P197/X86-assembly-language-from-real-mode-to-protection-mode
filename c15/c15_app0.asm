         ;�����嵥15-2
         ;�ļ�����c15_app0.asm
         ;�ļ�˵�����û����� 
         ;�������ڣ�2020-10-30

;===============================================================================
SECTION header vstart=0

         program_length   dd program_end          ;�����ܳ���#0x00

         head_len         dd header_end           ;����ͷ���ĳ���#0x04

         prgentry         dd start                ;�������#0x08
         code_seg         dd section.code.start   ;�����λ��#0x0c
         code_len         dd code_end             ;����γ���#0x10

         data_seg         dd section.data.start   ;���ݶ�λ��#0x14
         data_len         dd data_end             ;���ݶγ���#0x18

         stack_seg        dd section.stack.start  ;ջ��λ��#0x1c
         stack_len        dd stack_end            ;ջ�γ���#0x20
;-------------------------------------------------------------------------------
         ;���ŵ�ַ������
         salt_items       dd (header_end-salt)/256 ;#0x24
         
         salt:                                     ;#0x28
         PrintString      db  '@PrintString'
                     times 256-($-PrintString) db 0
                     
         TerminateProgram db  '@TerminateProgram'
                     times 256-($-TerminateProgram) db 0
                     
         ReadDiskData     db  '@ReadDiskData'
                     times 256-($-ReadDiskData) db 0

         InitTaskSwitch   db  '@InitTaskSwitch'
                     times 256-($-InitTaskSwitch) db 0
                 
header_end:
  
;===============================================================================
SECTION data vstart=0                

         message_1        db  0x0d,0x0a
                          db  '[USER TASK]: Hi! nice to meet you,'
                          db  'I am run at CPL=',
         cpl              db  0
                          db  '.',0x0d,0x0a,0
                          
         message_2        db  '[USER TASK]: I needs to have a rest...'
                          db  0x0d,0x0a,0

         message_3        db  '[USER TASK]: I am back again.'
                          db  'Now,I must exit...',0x0d,0x0a,0

data_end:

;===============================================================================
SECTION stack vstart=0

        times 2048        db 0                    ;����2KB��ջ�ռ�

stack_end:

;===============================================================================
      [bits 32]
;===============================================================================
SECTION code vstart=0
start:
         ;��������ʱ��DSָ��ͷ���Σ�Ҳ����Ҫ���ö�ջ 
         mov eax,ds
         mov fs,eax
     
         mov ax,[data_seg]
         mov ds,ax
     
         mov ax,cs
         and al,0000_0011B
         or al,0x30
         mov [cpl],al

         mov ebx,message_1
         call far [fs:PrintString]

         mov ebx,message_2
         call far [fs:PrintString]

         call far [fs:InitTaskSwitch]        ;�������������л�

         mov ebx,message_3
         call far [fs:PrintString]

         call far [fs:TerminateProgram]      ;�˳�����������Ȩ���ص����� 
    
code_end:

;-------------------------------------------------------------------------------
SECTION trail
;-------------------------------------------------------------------------------
program_end: