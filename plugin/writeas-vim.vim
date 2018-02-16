if has('python')
        let s:hd = "python << EOF"
elseif has('python3')
        let s:hd = "python3 << EOF"
else
        finish
endif

exec s:hd
import requests
import vim
import string

# Shorten Libraries
v = vim
rq = requests 

# Constants
useragent = "write.as-vim v 1.0.0"

#Define Variables
try:
    user = vim.eval("g:writeas_u")
except:
    pass
try:
    pword = vim.eval("g:writeas_p")
except:
    pass
blog = vim.eval("g:writeas_b")
try:
    token = vim.eval("g:writeas_t")
except:
    pass

def _authenticate(outputToken):

    # Prompt for username if necessary
    try:
        user
        username = user
    except NameError:
        vim.command("let g:writeas_u = input('Username: ')")
        username = vim.eval('g:writeas_u')
        vim.command("echo '\r'")

    # Prompt for password if necessary
    try:
        pword
        password = pword
        print("Authenticating...")
    except NameError:
        vim.command("let g:writeas_p = inputsecret('Password: ')")
        password = vim.eval('g:writeas_p')
        print('...')

    # Authenticate User
    url = "https://write.as/api/auth/login"
    payload = {"alias": username, "pass": password}
    head = {'User-Agent': useragent}
    auth = rq.post(url, json=payload, headers=head)  # Authentication request
    response = auth.json()  # Interpret JSON response
    if response['code'] != 200:
        print(response['error_msg'])
        quit()
    else:
        token = response['data']['access_token']
        if outputToken:
            print("Success. Add to .vimrc:")
            print("let g:writeas_t = '{}'".format(token))
        else:
            print("Authenticated.")

    return token

def _anonpost(title):

    global token
    try:
        token
    except NameError:
        token = _authenticate(False)

    # Post!!!

    url = "https://write.as/api/posts"
    head = {"Authorization": "Token {}".format(token), "Content-Type": "application/json", "User-Agent": useragent}
    post = "\n".join(v.current.buffer)
    payload = {"body": post, "title": title}
    response = rq.post(url, json=payload, headers=head)
    output = response.json()
    if output['code'] != 201:
        print ("Error: {}".format(output['error_msg']))
    else:
        print ("Post Uploaded")
        v.current.buffer.append("write.as/{} \n".format(output['data']['id']))
        v.current.buffer.append("posted: {} \n".format(output['data']['created'])) 

def _blogpost(title):
    
    global token
    try:
        token
    except NameError:
        token = _authenticate(False)

    # Post!!!

    url = "https://write.as/api/collections/{}/posts".format(blog)
    head = {"Authorization": "Token {}".format(token), "Content-Type": "application/json", "User-Agent": useragent}
    post = "\n".join(v.current.buffer)
    payload = {"body": post, "title": title} 
    response = rq.post(url, json=payload, headers=head)
    output = response.json()
    if output['code'] != 201:
        print ("Error: {}".format(output['error_msg']))
    else:
        print ("Post Uploaded")
        v.current.buffer.append("write.as/{}/{} \n".format(blog, output['data']['slug']))
        v.current.buffer.append("posted: {} \n".format(output['data']['created']))
EOF

if has('python')
        command! -nargs=1 AnonPost :python _anonpost(<f-args>)
        command! -nargs=1 BlogPost :python _blogpost(<f-args>)
        command! -nargs=0 WriteAsAuth :python _authenticate(True)
elseif has('python3')
        command! -nargs=1 AnonPost :python3 _anonpost(<f-args>)
        command! -nargs=1 BlogPost :python3 _blogpost(<f-args>)
        command! -nargs=0 WriteAsAuth :python3 _authenticate(True)
endif
