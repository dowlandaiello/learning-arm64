.equ	MAILBOX_BASE, 0x2000B880
.equ	MAILBOX_STATUS, #(MAILBOX_BASE + 0x18)
.equ	MAILBOX_WRITE, #(MAILBOX_BASE + 0x20)

.equ	FRAMEBUFFER, #1

.equ	FULL,  0x80000000
.equ	EMPTY, 0x40000000
.equ	LEVEL, 0x40000000

.text

globl	_start
_start:
	ldr	r0, =MAILBOX_WRITE
	bl	write_mailbox

block_until_mailbox_writable:
	push	{r0}

	# Keep asking the mailbox if we can read from it
	ldr	r2, =MAILBOX_STATUS
	ldr	r1, [r2]

	and	r1, FULL
	cmp	r1, 0
	be	block_until_mailbox_writable

	# If status is one, we can read
	ret

write_mailbox:
	# Lock the mailbox + write the value in r0 to it
	bl	block_until_mailbox_writable

	and	r1, ~(0xF)
	or	r1, r2

	str	r0, [r1]
