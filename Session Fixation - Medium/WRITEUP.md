# CTF Challenge Writeup: Session Fixation - Medium

## Objective

Exploit a broken authentication vulnerability involving session fixation to gain admin access and retrieve the flag from the SecureGov Vault.

## Step 1: Discovering Login Credentials

Inspect the inital login page and you fill find a hidden html variable under <main> --> <div class> --> <form method>.
It will show "johnsucks123 - bob", which will reveal bobs username and password. 

## Step 2: Finding the Admin Credentials

After reading through the various reports that have been submitted, you will see some hints on what to do next.
The first hint will be that John is different from the rest, as he can specifically see a bug others can't. Next you will
see that there is a leftover js file within the log in page, you should logout and check whats in it (johns pass and user).
The finally hint will be towards a session fixation issue that has been happening.

## Step 3: Exploiting Session Fixation

Have 2 local host tabs open, log into one as the admin john. On the tab that isn't logged in as john, click dashboard, and you will
be able to view the admin dashboard. Here you simply access the vault and get the flag.