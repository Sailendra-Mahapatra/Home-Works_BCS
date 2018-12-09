import os.path
import csv
the_lst = []
with open ('budget_data.csv', 'r') as f:
    reader = csv.reader(f)
    for row in reader:
        if row[0] != 'Date':
            the_lst.append(row)
# The total number of months included in the dataset.
print('Total months included in the dataset = ', len(the_lst))

#The total net amount of profit/losses over the entire period.
sum = 0
for entry in the_lst:
    sum +=int(entry[1])
print("Total Profit/Losses over the entire period = ${}".format(sum))
# The average change in "Profit/Losses" between months over the entire period

max_change = 0
max_month = None
min_change = 0
min_month = None
total_change = 0

for i in range(len(the_lst)-1):
    val = (int(the_lst[i+1][1])-int(the_lst[i][1]))
    if val  > max_change:
        max_change = val
        max_month = the_lst[i+1][0]
    if val < min_change:
        min_change = val
        min_month = the_lst[i+1][0]
    total_change += val

print("Average Change: $",round(total_change/(len(the_lst)-1),2))

# The greatest increase in profits (date and amount)

print("Greatest increase in profits: ",max_month,"($",max_change,")")

# The greatest decrease in profits (date and amount)

print("Greatest decrease in profits: ",min_month, "($",min_change,")")

with open("PyBank.txt","w") as text_file:
    text_file.write("---------------\n")
    text_file.write("Total Months: " +str(len(the_lst))+"\n")
    text_file.write("Total: $" +str(sum)+"\n")
   
    text_file.write("Average Change: $"+str(round((total_change/(len(the_lst)-1)),2))+"\n")
    text_file.write("Greatest Increase in Profits: "+str(max_month)+"($"+str(max_change)+")\n")
    text_file.write("Greatest decrease in Profits: "+str(min_month)+"($"+str(min_change)+")\n")
