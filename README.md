My Chef Repository
==================

### Prepared

  ```
sudo ln -s /Users/k-goto/Documents/chef/chef-docker /bin/chef-docker
sudo ln -s /Users/k-goto/Documents/chef/.chef-docker-env ~/.chef-docker-env
```

### 1. initialize

 - knife cookbook create XXXXX -o site-cookbooks/

### 2. file modify

 - recipes/default.rb

### 3. deploy

 - knife solo cook <ssh>
