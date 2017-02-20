
def construct_graph
  graph = {}
  graph["start"]  = {"a" => 5, "b" => 2}
  graph["a"]      = {"c" => 2, "d" => 4}
  graph["b"]      = {"a" => 8, "c" => 7}
  graph["c"]      = {"finish" => 1}
  graph["d"]      = {"c" => 6, "finish" => 3}
  graph["finish"] = {nil => nil}
  return graph
end

def initialize_cost
  inf             = 1.0/0.0
  cost            = {}
  cost["a"]       = 5
  cost["b"]       = 2 
  cost["c"]       = inf
  cost["d"]       = inf
  cost["finish"]  = inf
  return cost
end

def initialize_parents
  parents            = {}
  parents["a"]       = "start"
  parents["b"]       = "start"
  parents["c"]       = nil
  parents["d"]       = nil
  parents["finish"]  = nil
  return parents
end

def all_nodes_processed?(processed_nodes)
  (processed_nodes.length == 4) ? true : false
end

def find_lowest_cost_node(cost, processed_nodes)
  eligible_nodes = cost.keys.select {|i| not processed_nodes.include?(i)} - ["finish"]
  min_cost_node  = eligible_nodes.first
  eligible_nodes.each do |node|
    if cost[node] < cost[min_cost_node]
      min_cost_node = node
    end
  end 
  return min_cost_node, cost[min_cost_node]
end

def fastest_path(parents, c_node = "finish", path = "Finish")
  return path if c_node == "start" 
  path += "<==" + parents[c_node]
  fastest_path(parents, parents[c_node], path)
end

def dijkstra
  graph             = construct_graph
  cost              = initialize_cost
  parents           = initialize_parents
  processed_nodes   = []
  loop do
    puts cost
    puts parents
    puts "------------------------"
    break if all_nodes_processed?(processed_nodes) 
    l_cost_node, current_cost = find_lowest_cost_node(cost,processed_nodes)
    graph[l_cost_node].keys.each do |node|
      new_cost_to_neighbour = current_cost + graph[l_cost_node][node]
      if new_cost_to_neighbour < cost[node]
        cost[node]    = new_cost_to_neighbour
        parents[node] = l_cost_node
      end
    end
    processed_nodes << l_cost_node
  end
  puts "fastest path is shown below:"
  puts fastest_path(parents)
end


dijkstra()