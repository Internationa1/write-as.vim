if !has('python')
        finish
endif

python << EOF
import requests
import vim
import string

# Shorten Libraries
v = vim
rq = requests 

#Define Variables
user = vim.eval("g:writeas_u")
pword = vim.eval("g:writeas_p")
blog = vim.eval("g:writeas_b")

def _anonpost(title):

    # Authenticate User
    url = "https://write.as/api/auth/login"
    payload = {"alias": user, "pass": pword}
    auth = rq.post(url, json=payload)  # Authentication request
    response = auth.json()  # Interpret JSON response
    if response['code'] != 200:
        print(response['error_msg'])
        quit()
    else:
        token = response['data']['access_token']
        print("Authenticated.")

    # Post!!!

    url = "https://write.as/api/posts"
    head = {"Authorization": "Token {}".format(token), "Content-Type": "application/json"}
    post = string.join(v.current.buffer, "\n")
    payload = {"body": post, "title": title}
    response = rq.post(url, json=payload, headers=head)
    output = response.json()
    if output['code'] != 201:
        print ("Error: {}".format(output['error_msg']))
    else:
        print ("Post Uploaded")
        v.current.buffer.append("write.as/{} \n".format(output['data']['id']))
        v.current.buffer.append("posted: {} \n".format(output['data']['created']))
        v.current.buffer.append("token: {} \n".format(output['data']['token']))
        v.current.buffer.append("auth: {} \n".format(token))

def _blogpost(title):
    
    # Authenticate User
    url = "https://write.as/api/auth/login"
    payload = {"alias": user, "pass": pword}
    auth = rq.post(url, json=payload)  # Authentication request
    response = auth.json()  # Interpret JSON response
    if response['code'] != 200:
        print(response['error_msg'])
        quit()
    else:
        token = response['data']['access_token']
        print("Authenticated.")

    # Post!!!

    url = "https://write.as/api/collections/{}/posts".format(blog)
    head = {"Authorization": "Token {}".format(token), "Content-Type": "application/json"}
    post = string.join(v.current.buffer, "\n")
    payload = {"body": post, "title": title}
    response = rq.post(url, json=payload, headers=head)
    output = response.json()
    if output['code'] != 201:
        print ("Error: {}".format(output['error_msg']))
    else:
        print ("Post Uploaded")
        v.current.buffer.append("write.as/{}{} \n".format(blog, output['data']['slug']))
        v.current.buffer.append("posted: {} \n".format(output['data']['created']))
        v.current.buffer.append("token: {} \n".format(output['data']['token']))
        v.current.buffer.append("auth: {} \n".format(token))
EOF

command! -nargs=1 AnonPost :python _anonpost(<f-args>)
command! -nargs=1 BlogPost :python _blogpost(<f-args>)
