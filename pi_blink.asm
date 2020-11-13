.text

.globl _start
_start:
	/* Set pin 47 as an output */
	mov	r0, #1
	lsl	r0, #21

	/* 4th GPIO register, FSEL47 */
	ldr	r1, =0x20200010
	str	r1, r0

	/* Set pin 47 to on */
	mov	r0, #1
	lsl	r0, #16
	
	/* GPIO output set register 1 */
	ldr	r1, =0x20200020
	str	r1, r0
