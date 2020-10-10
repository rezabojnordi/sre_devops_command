SHELL = bash

.DEFAULT_GOAL :=all

#using .PHONY not file just name 

MY_DIRS = foo bar baz

.PHONY : all setup remove add $(MY_DIRS)		

#-----------variable in makefile ---------                                                                       
PY = python                                                                                                      
                                                                                                                 
variable_test:                                                                                                   
	${PY} setup.py 

##-----------------------help---------------
help:
	@cat $(MAKEFILE_LIST) | egrep "^[a-zA-Z0-9_]+:.*" 
##==================================
##$(MY_DIRA):
##	@mkdir -P $@
##	@touch ./$@/file.txt
	##dynamic variable make reza
#================================ foo bar  ==========================
foo: ## foo create directory and file
	@mkdir foo
	@touch ./foo/file.txt
bar:
	@mkdir bar
	@touch ./bar/file.txt
#==================================
## dependancy file 
setup: setup.py
	python setup.py

#=====================================
#setup:
#	python setup.py

all: add remove

add:
       #ls -al

	@touch ./file--{1.2}.txt
	#@echo "add...."
remove:
	@echo "remove .."

