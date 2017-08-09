import time, re, subprocess

template = """
<html>
    <head>
        <title>ecoROV preview</title>
        <style>
            {style}
        </style>
    </head>
    <body>
        <br>{disk}<br><br>
        {img_grid}
    </body>
</html>
"""

css = """
    .floated_img{float: left; margin: 10px;}
    .thumb{width: 256px;}
   
"""


img_blk = """
        <div class="floated_img">
            <a target="_blank" href="{doc_org}"><img src="{img_th}" class="thumb"></a>
            <p>{doc_name}</p>
        </div> """

        
        
def update_preview():
    df_disk  = re.sub(r"/dev/root *| /\n","", subprocess.check_output("df -h | grep root", shell=True)).split("  ")
    df_used  = "Total size: <b>%s</b>; Used: <b>%s</b>; Available:<b>%s</b>; Percentage:<b>%s</b>;"  % tuple(df_disk)
    img_ths  = subprocess.check_output("cd /var/www/ && find media -type f -name *.th.jpg", shell=True).split('\n')[:-1]
    img_ths.sort()
    doc_orgs = [re.sub(r'\..{5}\.th\.jpg$', "", img) for img in img_ths]
    img_blks = [img_blk.format(img_th = img_ths[i], doc_org = doc_orgs[i], doc_name = re.sub(r'^media/', "", doc_orgs[i])) for i in range(len(img_ths))]
    pag_html = template.format(style = css, disk = df_used, img_grid = ''.join(img_blks))
    with open("/var/www/preview.html", "w") as f:
        f.write(pag_html)
        f.close()


state_init = subprocess.check_output("cd /var/www/ && find media -type f -name *.th.jpg", shell=True).split('\n')[:-1]
while True:
    state_now = subprocess.check_output("cd /var/www/ && find media -type f -name *.th.jpg", shell=True).split('\n')[:-1]
    if state_now != state_init:
        state_init = state_now
        update_preview()
    time.sleep(2)

 
 
