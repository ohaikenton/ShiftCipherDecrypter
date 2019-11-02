# ShiftCipherDecrypter
Shift cipher is a simple encryption method. When encrypting a message, every letter in the original message is replaced by a different letter k positions down the alphabet (modulo by 26), where k is an integer.
In the following example for k = 8,
Original message:	WORK HARD, PLAY HARD!
								 	Shifting k positions down the alphabet (modulo by 26)
Cipher text: 		EWZS PIZL, XTIG PIZL!
Note:
1.	Assume that the message only contains upper case letters, space characters and punctuation marks.
2.	Space characters and punctuation marks remain unchanged during the encryption.
A shift cipher decrypter can guess the message without knowing k. If a message is long enough, the most frequent letter will be ‘E’.
