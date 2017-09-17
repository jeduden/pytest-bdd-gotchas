PIP=venv/bin/pip
PYTEST=venv/bin/py.test

$(PIP):
	python3 -m venv venv

$(PYTEST): $(PIP)
	$(PIP) install pytest==3.2.2 pytest-bdd==2.18.2 

select_marked_params_with_ids/symptom: $(PYTEST)
	$(PYTEST) select_marked_params_with_ids/test_symptom.py -vv -m MarkA

select_marked_params_with_ids/workaround: $(PYTEST)
	$(PYTEST) select_marked_params_with_ids/test_workaround.py -vv -m MarkA

select_marked_params_with_ids/workaround_with_k: $(PYTEST)
	@echo "#################################" 
	@echo "#### Using -k on test_sympton selecting the test\n\n"
	$(PYTEST) select_marked_params_with_ids/test_symptom.py -vv -k MarkA
	@echo "###############\n\n" 
	
	@echo "#################################" 
	@echo "#### Using -k on test_workaround_with_k selecting the test without MarkA\n\n"
	$(PYTEST) select_marked_params_with_ids/test_workaround_with_k.py -vv -k MarkA
	@echo "###############\n\n" 
	
	@echo "#################################" 
	@echo "#### Using -m on test_workaround_with_k selecting the test without MarkA\ works as intendedn\n"
	$(PYTEST) select_marked_params_with_ids/test_workaround_with_k.py -vv -m MarkA
	@echo "###############\n\n" 

select_marked_params_with_ids/workaround_with_dummy_param: $(PYTEST)
	$(PYTEST) select_marked_params_with_ids/workaround_with_dummy_param.py -vv -m MarkA
