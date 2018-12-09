import os.path
import csv

the_lst = []
with open('election_data.csv', 'r') as f:
    reader = csv.reader(f)
    for row in reader:
        the_lst.append(row)
        
print(the_lst[0])
lst = the_lst[1:]

# The total number of votes cast
total = len(lst)
print("Total number of votes cast: ",total)

#A complete list of candidates who received votes
candidates = set()
for entry in lst:
    candidates.add(entry[2])
    
print("List of candidates: ",candidates)

vote_counter = dict()

# The percentage of votes each candidates won
for entry in lst:
    if entry[2] in vote_counter:
        vote_counter[entry[2]] += (1/total)
    else:
        vote_counter[entry[2]] = (1/total)
        
print("Print vote percentage ",vote_counter)


# The total number of votes each candidate won
tmp_vote_counter = dict()
for entry in lst:
    if entry[2] in tmp_vote_counter:
        tmp_vote_counter[entry[2]] += 1
    else:
        tmp_vote_counter[entry[2]] = 1
print("Print votes count ",tmp_vote_counter)

# The winner of the election based on popular vote

max_key = None
max_val = 0

for key,val in tmp_vote_counter.items():
    if val > max_val:
        max_val = val
        max_key = key

print("Winner of the election based on votes: ",max_key)

print("Election Results")
print("----------------")
print("Total Votes: ",total)
print("-----------------")

for key, val in vote_counter.items():
    print(key,":","%.2f"%(val*100),"%(",tmp_vote_counter[key],")")
print("-----------------")
print("Winner: ",max_key)
print('')


with open("Results_elec.txt","w") as text_file:
    text_file.write("ElectionResults\n")
    text_file.write("----------------\n")
    text_file.write("Total Votes: "+str(total)+str("\n"))
    text_file.write("------------------\n")
    for key,val in vote_counter.items():
        text_file.write(str(key)+":"+"%.2f"%(val*100)+"%("+str(tmp_vote_counter[key])+")\n")
    text_file.write("-------------------\n")
    text_file.write("Winner: "+str(max_key)+str("\n"))
    text_file.write("-------------------\n")                    
    
