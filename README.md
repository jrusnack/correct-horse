# Correct Horse

This is yet another password generator based on XKCD`s Correct Horse Battery
Staple idea. Given wordlist file with one word per line, it generates weak,
medium and strong passwords consisting of several random words from wordlist.

## Usage

1. Review the code. Seriously, this is going to generate your password, what if 
   it sent the password to pastebin, too ? If you are not sure about the code,
   don't use it.

2. Read https://subrabbit.wordpress.com/2011/08/26/how-much-entropy-in-that-password/
   If you don't understand some of it, don't use this.

3. If you are not using password manager yet, pick one and use it.

4. Get a good wordlist.

5. Generate passwords with

		./correct-horse <wordlist>

   Optionally pass `-c` argument to generate CamelCase passwords.


## License

The MIT License (MIT)

Copyright (c) 2014 Jan Rusnacko

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.