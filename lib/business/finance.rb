module Business
	module Finance
		path = "lib/assets/files/business_finance.yml"
		info = YAML.load_file(path)

		ServiceFee = info["ServiceFee"]
		InterestRate = info["InterestRate"]
	end
end