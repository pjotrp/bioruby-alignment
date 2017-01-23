class Node
	
	attr_accessor :parent, :edgeLen, :name, :children, :sequence
	
	def initialize(name, edgeLen, sequence,deep)
		@parent = nil
		@name = name
		@edgeLen = edgeLen
		@sequence = sequence
		@deep = deep
		@children = []
	end

	def deep
		@deep
	end

  def addChild(child)
  	child.parent = self
  	@children.push(child)  	
  end

  def countChildren
  	count = 0
  	@children.each do |child|
  		count+= 1
  	end
  	return count
  end

  #checks if there are branches if not returns self
  def findFirstChildFakeNode
  	@children.each do |child|
  		if (child.name =~ /^\d+.*/)
  			return child
  		end
  	end 
  	return self
  end

  #return sibling, only to call if the sibling is a leaf
  def siblingReal
    @parent.children.each do |child|
    	if self != child
    		return child
    	end
    end
    return self
  end

  #returns second branch, if none was found returns self
  def falseSiblings
  	if @parent != nil
  		count = 0
  		@parent.children.each do |child|
  			if (child.name =~ /^\d+.*/)
  				count +=1
  			end
  		end
  		if count > 1
  			@parent.children.each do |child|
  				if (child.name =~ /^(\d+).*/ && child.name != @name)
  					return child
  			  end
  			end
  		end
  	end
  	return self
  end

  #returns array with type of children, 1 leaf, 0 branch
  def typeOfSiblings
    array = Array.new()
    i=0
    @children.each do |child|
    	if (child.name =~ /^seq(\d+).*/)
    		array[i] = 1
    	else
    		array[i] = 0
    	end
    	i+=1
    end
    return array
  end

  #arraychildren child adder 
  def arrayChildren(arrayChildren)
    @children.each do |child|
    	if (child.name =~ /^seq(\d+).*/)
        arrayChildren.push(child)
    	end
    end
    return arrayChildren
  end

  #returns first child edgelen.to_f
  def lengthFirstChild
    @children.each do |child|
    	return child.edgeLen.to_f
    end
  end

  #finds node given if not found returns "Not Found"
  def findNode(number)
    if @name =~ /^seq(\d+).*/
    	if $1.to_i == number
    		return self
    	end
    elsif !@children.empty?
    	node = @children[0].findNode(number)
    	if !node.eql?("Not Found")
    		return node
    	end
    	node = @children[1].findNode(number)
    	if !node.eql?("Not Found")
    		return node
    	end
    end
    return "Not Found"
  end

  #prints children
  def childrento_s
  	@children.each do |child|
  		puts child.to_s
  	end
  end

  def to_s
  	return "\"" + @name.to_s + "\" is \"" + @sequence.to_s + "\""
  end

end


class Tree 
	attr_accessor :root, :orderArray

	def initialize(array,msaArray,orderArray)
		@root = Node.new("root",0,nil,0)
		@orderArray = orderArray
		buildTree(@root,array,msaArray,array.length-1,0)
	end


  def buildTree(parent,array,msaArray,i,index)

  	#base case, one sequence
  	if (array[i].to_s[index..array[i].length-1] =~ /^seq(\d+):(\d+\.\d+)$/)
  		node = Node.new("seq" + $1,$2,msaArray[$1.to_i-1],(parent.deep+1))
  		parent.addChild(node)
  			
  	#sequence, (sequence/(number))
  	elsif (array[i].to_s[index..array[i].length-1] =~ /^seq(\d+):(\d+\.\d+),.+/)
  		node = Node.new("seq" + $1,$2,msaArray[$1.to_i-1],(parent.deep+1))
  		parent.addChild(node)
  		indexComma = array[i].to_s.index(",")
  		child = buildTree(parent,array,msaArray,i,indexComma+1)

    #(number)
    elsif (array[i].to_s[index..array[i].length-1] =~ /^\((\d+)\):(\d+\.\d+)$/)
     	node = Node.new($1,$2,nil,(parent.deep+1))
     	parent.addChild(node)
     	child = buildTree(node,array,msaArray,$1.to_i,0)

    #(number), (sequence/(number))
    elsif (array[i].to_s[index..array[i].length-1] =~ /^\((\d+)\):(\d+\.\d+),.+/)
    	node = Node.new($1,$2,nil,(parent.deep+1))
    	parent.addChild(node)
    	child = buildTree(node,array,msaArray,$1.to_i,0) 
    	indexComma = array[i].to_s.index(",")
    	child = buildTree(parent,array,msaArray,i,indexComma+1)	
    end
  end

  #finds the deepest branch
  def deepestFakeNode(node)
  	array = node.typeOfSiblings
  	if @root.countChildren < 1 
  		return @root
  	else
  		if array[0] == 0 && array[1] == 0
  			node1 = deepestFakeNode(node.children[0])
  			node2 = deepestFakeNode(node.children[1])
  			if node1.deep > node2.deep
  				return node1
  			else
  				return node2
  			end
  		elsif array[0] == 0 && array[1] == 1
  			return deepestFakeNode(node.children[0])
  		elsif array[0] == 1 && array[1] == 0
  			return deepestFakeNode(node.children[1])	
  		end
  		return node
  	end
  end

  #creates an array with sequences names and msa
  def arrayForPrint(node,array,flag,parent)
    index = 0
    node.children.each do |child|
    	if (child.name =~ /^seq(\d+).*/)
    		index = child.name[3..3+($1.to_s.length-1)].to_i
    		if array[index] == nil
    			array[index] = "  " + child.to_s
    		end 
    	end
    end 
    if flag
    	if (node != node.falseSiblings)
    		nodeT = deepestFakeNode(node.falseSiblings)                 
    		array = arrayForPrint(nodeT,array,false,node.parent)
    	end       
    	if node.parent == nil
    		return array
    	else
    		return arrayForPrint(node.parent,array,true,nil)
    	end
    else
    	if node.parent == parent
    		return array
    	else
    		return arrayForPrint(node.parent,array,false,parent)
    	end
    end
  end

  #orders arraychildren by drawing order
  def orderArrayChildren(arrayChildren)    	
    for i in (arrayChildren.length-1).downto(1)
    	for j in 0..@orderArray.length-1
    		if @orderArray[j] == arrayChildren[i].name[3..arrayChildren[i].name.length]
    			index1 = j
    		elsif @orderArray[j] == arrayChildren[i-1].name[3..arrayChildren[i].name.length]
    			index2 = j
    		end      
    	end
    	if index1<index2
    		t = arrayChildren[i-1]
    		arrayChildren[i-1] = arrayChildren[i]
    		arrayChildren[i] = t
    	end
    end
    return arrayChildren
  end

  #drawing function
  def symbolsAdder(array,arrayChildren,arraySiblingsType,arrayFlag,nodeArray)

	  count=0
	  index=0
	  indexBranch1=0
	  indexBranch2=0
	  indexOfBranch2InArrayChildren=0
	  indexOfBranch1InArrayChildren=0
	  found=false

    #if both nodes are leaves, the first leaf "," and the second "+"
    if arraySiblingsType[0] == 1 && arraySiblingsType[1] == 1 #leaf-leaf
  	  arrayChildren.each do |child|
  		  count+=1
  		  index = child.name[3..child.name.length].to_i
  		  if count == 1
  			  if !nodeArray.empty? && nodeArray[0].edgeLen.to_f != 0.0
  				  array[index] = "+--" + nodeArray[1].edgeLen.to_f.round(2).to_s + "-" + array[index]
  			  elsif child.edgeLen.to_f != 0.0
  				  array[index] = "+---" + array[index]
  			  else
  				  array[index] = ",---" + array[index]
  			  end
  		  elsif count == arrayChildren.length     
  			  if !nodeArray.empty? && nodeArray[0].edgeLen.to_f != 0.0
  				  array[index] = "`--" + nodeArray[0].edgeLen.to_f.round(2).to_s + "-" + array[index]
  			  elsif child.edgeLen.to_f != 0.0
  				  array[index] = "`---" + array[index]
  			  else
  				  array[index] = "+---" + array[index]
  			  end
  		  end
  		  arrayFlag[index] = 1 
      end

    #if nodes are branch and leaf, adds "," to the leaf and searches for "I" at the lowest position possible for "`---"
    elsif arraySiblingsType[0] == 0 && arraySiblingsType[1] == 1 #branch-leaf ,leaf is first
      indexBranch1 = arrayChildren[0].name[3..arrayChildren[0].name.length].to_i
      if nodeArray.empty?
        array[indexBranch1] = ",---" + array[indexBranch1]
      else
        array[indexBranch1] = ",--" + nodeArray[1].edgeLen.to_f.round(2).to_s + "-" + array[indexBranch1]
      end
      for i in (arrayChildren.length-1).downto(0)
        if array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] =~ /^I.*/
          found = true
      	  if nodeArray.empty?
        	  array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] = "`---" + array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i]
          else
        	  array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] = "`--" + nodeArray[0].edgeLen.to_f.round(2).to_s + "-" + array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i]
          end
        	indexBranch2 = arrayChildren[i].name[3..arrayChildren[i].name.length].to_i
        	break
        end
      end
      if !found
        indexBranch2 = arrayChildren[arrayChildren.length-1].name[3..arrayChildren[i].name.length].to_i
        if nodeArray.empty?
          array[indexBranch2] = "`---" + array[indexBranch2]
        else
          array[indexBranch2] = "`--" + nodeArray[0].edgeLen.to_f.round(2).to_s + "-" + array[indexBranch2]
        end
      end
      for i in 0..arrayChildren.length-1
        if arrayChildren[i].name[3..arrayChildren[i].name.length].to_i == indexBranch2
          indexOfBranch2InArrayChildren = i
        end
      end
      for i in 0..arrayChildren.length-1
        index = arrayChildren[i].name[3..arrayChildren[i].name.length].to_i
        if i>indexOfBranch2InArrayChildren
          if nodeArray.empty?
        	  array[index] = "    " + array[index]
          else
        	  array[index] = "        " + array[index]
          end
        elsif index != indexBranch1 && index != indexBranch2
          if nodeArray.empty?
        	  array[index] = "I   " + array[index]
          else
        	  array[index] = "I       " + array[index]
          end
        end
        arrayFlag[index] = 1 
      end

    #if nodes are leaf and branch searches "I" at the highest position for "," and the leaf is "`---"
    elsif arraySiblingsType[0] == 1 && arraySiblingsType[1] == 0 #leaf-branch
      indexBranch1 = arrayChildren[arrayChildren.length-1].name[3..arrayChildren[arrayChildren.length-1].name.length].to_i
      if nodeArray.empty?
        array[indexBranch1] = "`---" + array[indexBranch1]
      else
        array[indexBranch1] = "`--" + nodeArray[0].edgeLen.to_f.round(2).to_s + "-" + array[indexBranch1]
      end
      for i in 0..arrayChildren.length-1
        if array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] =~ /^I.*/
        	found = true
        	if nodeArray.empty?
        		array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] = ",---" + array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i]
        	else
        		array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] = ",--" + nodeArray[1].edgeLen.to_f.round(2).to_s + "-" + array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i]
        	end
        	indexBranch2 = arrayChildren[i].name[3..arrayChildren[i].name.length].to_i
        	break
        end  
      end
      if !found
        indexBranch2 = arrayChildren[0].name[3..arrayChildren[i].name.length].to_i
        if nodeArray.empty?
        	array[indexBranch2] = ",---" + array[indexBranch2]
        else
        	array[indexBranch2] = ",--" + nodeArray[1].edgeLen.to_f.round(2).to_s + "-" + array[indexBranch2]
        end
      end
      for i in 0..arrayChildren.length-1
        if arrayChildren[i].name[3..arrayChildren[i].name.length].to_i == indexBranch2
        	indexOfBranch2InArrayChildren = i
        end
      end
      for i in 0..arrayChildren.length-1
        index = arrayChildren[i].name[3..arrayChildren[i].name.length].to_i
        if i<indexOfBranch2InArrayChildren
        	if nodeArray.empty?
        		array[index] = "    " + array[index]
        	else
        		array[index] = "        " + array[index]
        	end
        elsif index != indexBranch1 && index != indexBranch2
        	if nodeArray.empty?
        		array[index] = "I   " + array[index]
        	else
        		array[index] = "I       " + array[index]
        	end
        end
        arrayFlag[index] = 1 
      end

    #if both nodes are branches searches "I" at the highest position for ",", and "I" at the lowest position for "+"
    elsif arraySiblingsType[0] == 0 && arraySiblingsType[1] == 0 #branch-branch
      for i in 0..arrayChildren.length-1
        if array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] =~ /^I.*/ || array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] =~ /^\+.*/
        	found = true
        	if nodeArray.empty?
        		array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] = ",---" + array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i]
        	else
        		array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] = ",--" + nodeArray[1].edgeLen.to_f.round(2).to_s + "-" + array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i]
        	end
        	indexBranch2 = arrayChildren[i].name[3..arrayChildren[i].name.length].to_i
        	break
        end  
      end
      if !found
        indexBranch2 = arrayChildren[0].name[3..arrayChildren[i].name.length].to_i
        if nodeArray.empty?
        	array[indexBranch2] = ",---" + array[indexBranch2]
        else
        	array[indexBranch2] = ",--" + nodeArray[1].edgeLen.to_f.round(2).to_s + "-" + array[indexBranch2]
        end
      end
      found = false
      for i in 0..arrayChildren.length-1
        if arrayChildren[i].name[3..arrayChildren[i].name.length].to_i == indexBranch2
          indexOfBranch2InArrayChildren = i
        end
      end
      for i in (arrayChildren.length-1).downto(indexOfBranch2InArrayChildren+1)
        if array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] =~ /^I.*/ || array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] =~ /^\+.*/
        	found = true
        	if nodeArray.empty?
        		array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] = "`---" + array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i]
        	else
        		array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i] = "`--" + nodeArray[0].edgeLen.to_f.round(2).to_s + "-" + array[arrayChildren[i].name[3..arrayChildren[i].name.length].to_i]
        	end
        	indexBranch1 = arrayChildren[i].name[3..arrayChildren[i].name.length].to_i
        	break
        end
      end
      if !found
        indexBranch1 = arrayChildren[arrayChildren.length-2].name[3..arrayChildren[i].name.length].to_i
        if nodeArray.empty?
        	array[indexBranch1] = "`---" + array[indexBranch1]
        else
        	array[indexBranch1] = "`--" + nodeArray[0].edgeLen.to_f.round(2).to_s + "-" + array[indexBranch1]
        end
      end
      for i in 0..arrayChildren.length-1
        if arrayChildren[i].name[3..arrayChildren[i].name.length].to_i == indexBranch1
        	indexOfBranch1InArrayChildren = i
        end
      end
      for i in 0..arrayChildren.length-1
        index = arrayChildren[i].name[3..arrayChildren[i].name.length].to_i
        if i<indexOfBranch2InArrayChildren || i>indexOfBranch1InArrayChildren
        	if nodeArray.empty?
        		array[index] = "    " + array[index]
        	else
        		array[index] = "        " + array[index]
        	end
        elsif index != indexBranch1 && index != indexBranch2
        	if nodeArray.empty?
        		array[index] = "I   " + array[index]
        	else
        		array[index] = "I       " + array[index]
        	end
        end
        arrayFlag[index] = 1 
      end
    end
    return array,arrayFlag
  end

  #to draw the tree it recursively cicles the array to print and adds all symbols with symbolsAdder from the bottom
  def print(node,array,arrayChildren,arrayChildrenFake,flag,parent,deep,lengthOption)
  	index = 0
  	arrayFlag = Array.new(array.length) 
  	arraySiblingsType = node.typeOfSiblings
  	if flag
  		arrayChildren = node.arrayChildren(arrayChildren)
  		arrayChildren = orderArrayChildren(arrayChildren)
  		if lengthOption
  			array,arrayFlag = symbolsAdder(array,arrayChildren,arraySiblingsType,arrayFlag,node.children)
  		else
  			array,arrayFlag = symbolsAdder(array,arrayChildren,arraySiblingsType,arrayFlag,[])
  		end
      #dashes for all the entries without + - I
      for i in 1..array.length-1
        if arrayFlag[i] == nil 
        	if node.lengthFirstChild != 0.0 && lengthOption
        		array[i] = "--------" + array[i]
        	else
        		array[i] = "----" + array[i]
        	end
        end
      end
    else
    	arrayChildrenFake = node.arrayChildren(arrayChildrenFake)
    	arrayChildrenFake = orderArrayChildren(arrayChildrenFake)
    	if lengthOption
    		arrayChildrenFake.each do |child|
    			index = child.name[3..child.name.length].to_i
    			for i in 1..(deep)
    				if array[index] =~ /^-.*/
    					array[index]= array[index][8...array[index].length]
    				end
    			end
    		end
    		array,arrayFlag = symbolsAdder(array,arrayChildrenFake,arraySiblingsType,arrayFlag,node.children)
    	else
    		arrayChildrenFake.each do |child|
    			index = child.name[3..child.name.length].to_i
    			for i in 1..(deep)
    				if array[index] =~ /^-.*/
    					array[index]= array[index][4...array[index].length]
    				end
    			end
    		end
    		array,arrayFlag = symbolsAdder(array,arrayChildrenFake,arraySiblingsType,arrayFlag,[])
    	end
    end  
    if flag
    	if (node != node.falseSiblings)
    		nodeT = deepestFakeNode(node.falseSiblings)
    		array = print(nodeT,array,arrayChildren,arrayChildrenFake,false,node.parent,deep-node.deep,lengthOption)
    	end
    	if node.parent == nil
    		return array
    	else
    		return print(node.parent,array,arrayChildren,arrayChildrenFake,true,nil,deep,lengthOption)
    	end
    else
    	if node.parent == parent
    		arrayChildrenFake.each do |entry|
    			arrayChildren[arrayChildren.length] = entry
    			arraychildren = orderArrayChildren(arrayChildren)
    		end
    		return array
    	else
    		return print(node.parent,array,arrayChildren,arrayChildrenFake,false,parent,deep-1,lengthOption)
    	end
    end
  end

  def to_s(node)
    return node.to_s
  end

  def child(node)
    return node.childrento_s
  end

  def count(node)
    return node.countChildren
  end

  def printNolength
    deepNode = deepestFakeNode(@root)
    array = Array.new()
    array = arrayForPrint(deepNode,array,true,nil)
    arrayChildren = Array.new()
    arrayChildrenFake = Array.new()
    arrayT = print(deepNode,array,arrayChildren,arrayChildrenFake,true,nil,deepNode.deep,false)
    @orderArray.each do |entry|
    	puts arrayT[entry.to_i]
    end
  end

  def printWithlength
    deepNode = deepestFakeNode(@root)
    array = Array.new()
    array = arrayForPrint(deepNode,array,true,nil)
    arrayChildren = Array.new()
    arrayChildrenFake = Array.new()
    arrayT = print(deepNode,array,arrayChildren,arrayChildrenFake,true,nil,deepNode.deep,true)
    @orderArray.each do |entry|
    	puts arrayT[entry.to_i]
    end
  end
end

#MAIN

def msaToArray(msa)
	i = 0
	msaArray = Array.new()
	msa.each_line do |line|
		if (line =~ /^seq\d+\s+([a-zA-Z-]*)/) # extracts (----SNSFSRPTIIFSGCSTACSGK--SELVCGFRSFMLSDV)
			msaArray[i] = $1 
			puts i.to_s + " " + msaArray[i].to_s
		end
		i += 1	
	end
	return msaArray
end

def sortMsa(orderString,i)
	orderArray = Array.new()
	until i<0 do
    #the order in which the sequences are encountered is opposite of the order in which they need to be printed
    #e.g. first sequence is the last one to print
    if (orderString =~ /[\(\.:,\)\d]*seq(\d+)(.*)/) 
    	orderArray[i] = $1
    	orderString = $2
    end
    puts i.to_s + " " + orderArray[i].to_s
    i -=1
end
return orderArray
end

def parseNewickToArray(msaArray,treeString)
	i = 0
	index = 0
	treeArray = Array.new()
	until i>msaArray.length-1 do	
    #searches for the rightmost "(" and extracts the content passing by the new string 
    if (treeString =~ /([a-zA-Z0-9\.:,\()]*)\(([a-zA-Z0-9\.:,]*)\)([a-zA-Z0-9\.:,\()]*)/)
    	treeArray[i] = $2
    	treeString = $1 + i.to_s + $3
      index = treeArray[i].to_s.index(",") 
      #if the first char at the beginning of after the comma is a number a branch must be created
      #to mark a branch the number is put inside brackets 
      if (treeArray[i].to_s[index+1] =~ /^(\d+).*/)
      	number2 = $1
        if (treeArray[i].to_s[0] =~ /^(\d+).*/)
        	treeArray[i] = "(" + number2.to_s + ")" + treeArray[i].to_s[number2.to_s.length..treeArray[i].to_s.length]
        	treeArray[i] =  treeArray[i].to_s[0..index+2] + "(" + $1.to_s + ")" + treeArray[i].to_s[index+3+$1.to_s.length..treeArray[i].to_s.length]
        else
        	treeArray[i] =  treeArray[i].to_s[0..index] + "(" + number2.to_s + ")" + treeArray[i].to_s[index+2+$1.to_s.length..treeArray[i].to_s.length]
        end
    elsif (treeArray[i].to_s[0] =~ /^(\d+).*/)
    	treeArray[i] = "(" + $1.to_s + ")" + treeArray[i].to_s[$1.to_s.length..treeArray[i].to_s.length]
    end
    puts i.to_s + " " + treeArray[i].to_s
end
i += 1
end
return treeArray
end

msa = File.new("MSA.txt", "r")
tree = File.new("Tree.txt", "r")
treeString = ""

tree.each_line do |line|
	treeString = line	
end

puts "-----------------"
puts "MSAARRAY        |"
puts "-----------------"
puts
msaArray = msaToArray(msa)
puts
puts "-----------------"
puts "ORDERARRAY      |"
puts "-----------------"
puts
orderArray = sortMsa(treeString,msaArray.length-1)
puts
puts "-----------------"
puts "TREEARRAY       |"
puts "-----------------"
puts
treeArray = parseNewickToArray(msaArray,treeString)

newick = Tree.new(treeArray,msaArray,orderArray)
puts
puts "-----------------"
puts "PRINT NO LENGTH |"
puts "-----------------"
puts
newick.printNolength
puts
puts "-----------------"
puts "PRINT LENGTH    |"
puts "-----------------"
puts
newick.printWithlength
puts
puts "-----------------"
puts "GOOD            |"
puts "-----------------"
puts
