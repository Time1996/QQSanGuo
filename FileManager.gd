extends Node

## 返回 Unit 的 csv 文件数据
func get_unit_data() -> Dictionary:
	var data_list = parse_csv_file("res://UnitData.csv")
	return data_list


## 解析 csv 文件
## @path 文件路径
## @key 以数据中的哪个值作为 key 值记录到字典中
## @return 以第一行数据作为 key 值，记录成字典形式
func parse_csv_file(path: String) -> Dictionary:
	var file = File.new()
	file.open(path, File.READ)
	# 没有数据则返回空字典
	var temp = file.get_csv_line(',')	## 以 , 进行分隔每个表格的数据，可以自己打开 csv 查看自己的 csv 数据是哪种分隔符
	if temp.size() == 0:
		return {}
	# 第一行做为 key 
	var keys = []
	for i in temp:
		keys.push_back(i)
	
	# 读取一行，但不对数据进行操作（这样等于是跳过了这一行）
#	file.get_csv_line(',')
	
	# 获取数据到字典中
	var data_list = {}
	var err_count = 0	# 数据错误次数
	temp = file.get_csv_line(',')

#	print(temp)
	while temp.size() >= 1:
		# 数据列数和 key 数量不一致，则跳过
		if temp.size() != keys.size():
			err_count += 1
			if err_count > 10:	# 错误超过 10 次，则不再读取
				break
			temp = file.get_csv_line(',')
			print_debug("数据有误，与第一行不一致 n: %d, k: %d" % [temp.size(), keys.size()])
			continue
		
		# 每行数据保存到字典中
		var data = {}
		for idx in range(temp.size()):
			data[keys[idx]] = temp[idx]
			print(keys[idx] + " " + data[keys[idx]] + "哈哈")
			data_list[keys[idx]] = temp[idx]
		# 读取下一行数据
		temp = file.get_csv_line(',')
	
	file.close()
	return data_list

