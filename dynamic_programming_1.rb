require 'pp'
# Problem:-> 
# Suppose you’re going camping. You have a knapsack that will hold
# 6 lb, and you can take the following items. Each has a value, and the
# higher the value, the more important the item is:
# • Water, 3 lb, 10
# • Book, 1 lb, 3
# • Food, 2 lb, 9
# • Jacket, 2 lb, 5
# • Camera, 1 lb, 6
# What’s the optimal set of items to take on your camping trip?
#        1      2       3      4            5        6
#       ------------------------------------------------------ 
# water |0() |  0() | 10(w)  |10(w)    | 10()     | 10()     |
# book  |3(b)| 3(b) | 10(w)  |13(w+b)  | 13(w+b)  | 13(w+b)  |
# food  |3(b)| 9(f) | 12(f+b)|13(w+b)  | 19(f+w)  | 22(f+w+b)|
# jacket|3(b)| 9(f) | 12(f+b)|14(f+j)  | 19(f+w)  | 22(f+w+b)|
# camera|6(c)| 9(f) | 15(c+f)|18(c+f+b)| 20(c+f+j)| 25(c+f+w)|

def initialize_items
  items = {}
  items["water"]    = {"w" => 3 ,"v" => 10}
  items["book"]     = {"w" => 1 ,"v" => 3 }
  items["food"]     = {"w" => 2 ,"v" => 9 }
  items["jacket"]   = {"w" => 2 ,"v" => 5 }
  items["camera"]   = {"w" => 1 ,"v" => 6 }
  items
end

def get_grid_value(grid_val, ind, item_d, row, grid, items_chosen, item)
  value_of_rem_space = row == 0 ? item_d["v"] : (item_d["v"] + (grid[row - 1]["#{grid_val - item_d["w"]}"]).to_i) 
  previous_row_val   = row == 0 ? 0 : grid[row - 1]["#{grid_val}"].to_i
  if value_of_rem_space > previous_row_val
    if row == 0 || grid[row - 1]["#{grid_val - item_d["w"]}"].nil?
      chosen_items = item
    else
      chosen_items = (item + "," + items_chosen[row - 1][ind - item_d["w"]])
    end
  else
    chosen_items = row == 0 ? " "  : items_chosen[row - 1][ind]
  end
  if item_d["w"] > grid_val
    return previous_row_val, " " if row == 0
    item_chosen = items_chosen[row -1][ind]
    return previous_row_val, item_chosen
  end
  return [previous_row_val, value_of_rem_space].max, chosen_items
end

def maximize_value(constraint)
  items         = initialize_items
  grid_vals     = (1..constraint).to_a
  grid          = []
  items_chosen  = []
  i         = 0
  items.each do |item, vals|
    items_chosen[i] = []
    grid[i] = {}
    grid_vals.each_with_index do |val,ind|
      grid[i]["#{val}"], items_chosen[i][ind] = get_grid_value(val, ind, vals, i, grid, items_chosen, item)
    end
    i += 1
  end
  pp grid
  # pp items_chosen
  puts "Optimum items to be chosen with the given constraint are: #{items_chosen[-1].last}"
end 


maximize_value(6)