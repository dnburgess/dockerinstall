DB Tech's Docker Install Method
===

## This Method Uses Root
(Non-root method below)

To install the newest versions of Docker and docker compose, simply ssh into your server, then clone this repository with: 

```
git clone https://github.com/dnburgess/dockerinstall.git
```

change into the new directory 
```
cd dockerinstall
```

make the file executable
```
chmod +x dockerinstall.sh
```

execute the file 
```
./dockerinstall.sh
```

## Non-Root Method
If you don't want to use root/sudo, you can do the following:

Clone the repository
```
git clone https://github.com/dnburgess/dockerinstall.git
```

change into the new directory
```
cd dockerinstall
```

make the file executable
```
chmod +x dockerinstallnoroot.sh
```

execute the file
```
./dockerinstallnoroot.sh
```
