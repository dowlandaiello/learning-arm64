.data

prompt:
	.ascii	"> "
len = . - prompt

.bss

in:
	/* Allow 80 chars to be inputted per line */
	.skip	80

.text

.globl	_start
_start:
	/* Print a prompt */
	mov	x8, #64
	mov	x0, #1
	ldr	x1, =prompt
	ldr	x2, =len
	svc	#0

	bl	read_input

	mov	x0, #0
	mov	x8, #93
	svc	#0

read_input:
	/* Get up to 80 chars */
	mov	x8, #63
	mov	x0, #0
	ldr	x1, =in
	mov	x2, #79
	svc	#0

	bl echo_input

	bl _start

echo_input:
	/* Print the input */
	mov	x8, #64
	mov	x0, #1
	ldr	x1, =in
	mov	x2, #80
	svc	#0

	ret
