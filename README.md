# asm_xor

## What is this project about?
I wanted to start learning assembly to improve my Reverse Engineering skills. Thus, I've decided to write a simple xor cipher program in NASM. 

It's **clearly not** a well written assembly code, nor a well constructed one. Basically, it's a bad assembly xor_cipher. But I don't care, I've learnt a lot.

## Negative point

Although I've found fun to write and debug my program, the only downside of this project was that I've been quite inconsistent, probably because the step was too high. It happened that for some weeks, I didn't work on my project. Every time I had to come back to it, I had to debug my program from scratch to understand what I was trying to do. I've also spent a lot of time reading docs.

I've told myself multiple times that I should have write some sort of "What_the_heck_I_m_trying_to_do.txt". I'll definitely do that next time.

## Wanna try?
```sh
make && ./bin/asm_xor
```

If you use `Hell` as the string that you want to encrypt and `0x20 0x20 0x20 0x20` (4 spaces) as the key. It will print you hELL.

> It's actually working for any strings but it has a really high probability that it will not result as a printable string.

So you could use `gdb` to get your xored string.

## What's next
*Will I improve this code?*
Probably not

*Will I write other nasm program?*
Absolutely yes
