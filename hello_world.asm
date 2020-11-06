.data

msg:
	.ascii "Hello, World!\n"
len = . - msg

.text

.globl _start
_start:
	// STDOUT uses fd 1
	mov 	x0, #1
	ldr	x1, =msg
	ldr	x2, =m_len

	// write syscall is #64
	mov	x8, #64
	// Run write()
	svc	#0

	// Exit
	mov	x8, #93
	// No error:
	mov	x0, #0
	svc	#0

