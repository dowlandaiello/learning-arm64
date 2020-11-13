.text

.globl	_start
_start:
	/* Set pin 47 as an output */
	mov	w0, #1
	lsl	w0, w0, #21

	/* 4th GPIO register, FSEL47 */
	ldr	x1, =0x20200010
	str	w0, [x1]

	/* Set pin 47 to on */
	mov	w0, #1
	lsl	w0, w0, #16

	/* GPIO output set register 1 */
	ldr	x1, =0x20200020
	str	w0, [x1]
