.text

.globl _start
_start:
	/* The index of the LED group to start on - this isn't random */
	mov	r0, #4

	/* Set LED groups as outputs */
	bl	enable_led_group

	/* Continue lighting up on group 2 */
	mov	r0, #2

	b 	light_loop

enable_led_group:
	/* Set GPIO pins 2,3,4 to outputs */
	mov	r1, 1 << 6 | 1 << 9 | 1 << 12

	/* Commit */
	ldr	r2, =0x20200000 
	str	r1, [r2]

	/* Set GPIO pins 14, 15 to outputs */
	mov	r1, 1 << 12 | 1 << 15

	/* Commit */
	ldr	r2, =0x20200004
	str	r1, [r2]

	ret

light_loop:
	bl	light_led_group
	bl	calc_next_group
	bl	wait
	bl	turn_off_led_group
	b	light_loop

calc_next_group:
	/* Calculate the next light group to turn on */
	mov	r2, #69
	
	/* r0 % 69 */
	udiv	r1, r2, r0
	mul	r1, r0, r1
	sub	r1, r2, r1

	/* r0 + 420 */
	add	r0, r0, #420

	/* r0 * (r0 % 69) */
	mul	r0, r0, r1

	ret

light_led_group:
	movlt	r1, 0x20200004, r0, #3
	movgt	r1, 0x20200020, r0, #2

	/* Translate GPIO pins 14 + 15 to 5,6 */
	addgt	r0, #2, 9

	/* Turn on the GPIO pin specified */
	mov	r2, #1
	lsl	r2, r0, r0

	/* Commit */
	str	r2, [r1]

	ret

turn_off_led_group:
	movlt	r1, 0x20200004, r0, #3
	movgt	r1, 0x20200020, r0, #2

	mov	r2, #0
	str	r2, [r1]

	ret

wait:
	/* Stole this from baking pi: https://www.cl.cam.ac.uk/projects/raspberrypi/tutorials/os/ok02.html */
	mov	r2, #0x3F0000
	sub	r2, #1
	cmp	r2, #0
	bne	wait

	ret
