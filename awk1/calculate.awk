NF == 2 { salary[$1] = $2 }

NF == 2 { hource[$1] += $3-$2 }


END {
				for (p in salary){
								printf "|%3s|%3d|%4d|$%d|\n", p,salary[p],hources[p],salary[p]*hource[p]

								}

}
