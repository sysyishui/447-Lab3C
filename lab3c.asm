    .data
prompt_guess:    .asciiz "Enter a number between 0 and 99: "
too_high:        .asciiz "Your guess is too high.\n"
too_low:         .asciiz "Your guess is too low.\n"
close_msg:       .asciiz "You're close!\n"
far_msg:         .asciiz "You're far.\n"
congrats:        .asciiz "Congratulations! You win!\n"
loss_msg:        .asciiz "You lose. The number was: "
newline:         .asciiz "\n"

    .text
    .globl main
main:
    # Seed the random number generator (optional)
    # li v0, 40        # syscall to set seed
    # li a0, 42        # some seed value
    # syscall

    # Generate random number between 0 and 99
    li v0, 42         # random number syscall
    li a0, 0          # RNG 0
    li a1, 100        # upper bound (0-99)
    syscall
    move t0, v0       # store random number in t0

    # Initialize guess count
    li t1, 0          # guess counter (t1)

guess_loop:
    # Check if max guesses reached
    li t2, 6          # max guesses
    beq t1, t2, game_over

    # Prompt for guess
    li v0, 4          # print string syscall
    la a0, prompt_guess
    syscall

    # Read user's guess
    li v0, 5          # read integer syscall
    syscall
    move t3, v0       # store guess in t3

    # Compare guess to random number
    beq t3, t0, win   # if guess is correct, win

    # Check if guess is too high
    bgt t3, t0, guess_high

guess_low:
    li v0, 4          # print string syscall
    la a0, too_low
    syscall
    j check_close     # jump to close/far check

guess_high:
    li v0, 4          # print string syscall
    la a0, too_high
    syscall

check_close:
    # Check if the guess is within 10 of the target number
    sub t4, t0, t3    # calculate difference (t0 - t3)
    abs t4, t4        # absolute value of the difference
    li t5, 10         # threshold for "close"
    bge t4, t5, far   # if difference >= 10, guess is far

    li v0, 4          # print string syscall
    la a0, close_msg
    syscall
    j next_guess

far:
    li v0, 4          # print string syscall
    la a0, far_msg
    syscall

next_guess:
    addi t1, t1, 1    # increment guess counter
    j guess_loop      # loop back for another guess

win:
    li v0, 4          # print string syscall
    la a0, congrats
    syscall
    j exit_game

game_over:
    li v0, 4          # print string syscall
    la a0, loss_msg
    syscall
    li v0, 1          # print number syscall
    move a0, t0       # number was stored in t0
    syscall
    li v0, 4          # print newline
    la a0, newline
    syscall

exit_game:
    li v0, 10         # exit syscall
    syscall
