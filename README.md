## Description
This repo is a gollum wiki template. This wiki will be hosted automatically when you start ubuntu. 
## Install  
Run install script in the repo. This install script has only been tested on ubuntu 14.04 LTS.

```bash
git clone https://github.com/yuzhangbit/wiki-Barebone.git
cd wiki-Barebone  
bash install.bash  
```    

Reboot or run command below:
```
start wiki
```
Open your browser and check the wiki.
```bash
localhost:4444
```



## Adjustable Parameters
You can modify the port number of your wiki in **install.script** before installation,
```bash
PORT=4444    # hosting port 
```
or modify the port number in the generated **service.bash** after running install script 

Below is your service name of your wiki.
```bash
COMMAND=wiki   # default value is wiki
```

## Start and Stop wiki 
This wiki will be hosted automatically when you start ubuntu. You don't need to run commands below. 
```bash
start wiki  # start to host wiki, wiki is defined by COMMAND
stop wiki   # stop to host wiki,  wiki is defined by COMMAND
```
## The Gollum Configuration used by this repo:
```ruby
Gollum::Page.send :remove_const, :FORMAT_NAMES if defined? Gollum::Page::FORMAT_NAMES
wiki_options = {
  :live_preview => true,
  :allow_uploads => true,
  :per_page_uploads => true,
  :allow_editing => true,
  :css => true,
  :js => true,
  :mathjax => true,
  :h1_title => true,
  :emoji => true
}
Precious::App.set(:wiki_options, wiki_options)
```
