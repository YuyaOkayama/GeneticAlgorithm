$flag = false

class Genes
    attr_reader :score
    attr_accessor :text
    
    GENE_COUNT = 10
    
    def initialize()
        @score = 0
        @text = ("a".."z").to_a.sample(GENE_COUNT).join     
    end
    
    def evaluation
        answerArr = GeneticAlgorithm::ANSWER.split("")
        textArr = @text.split("")
        
        total = 0
#         total += (answerArr & textArr).length
        answerArr.each_with_index do |an, index|
            if an == textArr[index]
                total += 1
            end
        end
        
        @score = total
        if @score >= GENE_COUNT
            $flag = true
        end
        #return total
    end
    
    def self.crossover(text1, text2)
        mother = text1.split("")
        father = text2.split("")     
        
        child = []
        i = rand(0..GENE_COUNT - 1)
        n = GENE_COUNT - i
        
        child[0, i] = mother[0, i]
        child[i, n] = father[i, n]
        
        childText = child.join
        
        return childText
    end
    
    def mutation
        textArr = @text.split("")
        textArr[rand(0..GENE_COUNT - 1)] = ("a".."z").to_a.sample
        @text = textArr.join
    end
end

class GeneticAlgorithm
    ANSWER = "helloworld"
    COLONY = 15
    DESTROY = 5
    
    def initialize
        @generation = 1
        @genes = []
        
        COLONY.times do
            @genes << Genes.new()
        end
    end
    
    def delete
        DESTROY.times do
            small_key = 0
            small_point = 0
            @genes.each_with_index do |g, index|
               if index == 0
                   small_point = g.score
               elsif small_point > g.score
                   small_key = index
                   small_point = g.score
               end
            end
            @genes.delete_at(small_key)
        end
    end
    
    def show_all
        puts "generation: #{@generation}"
        @genes.each do |g|
            puts "#{g.text}:  #{g.score}"
        end
    end
    
    def evaluations
        @genes.each do |g|
            g.evaluation
        end
    end
    
    def crossovers
        DESTROY.times do
            rnd1 = rand(0..COLONY - DESTROY - 1)
            rnd2 = rand(0..COLONY - DESTROY - 1)
            child = Genes.new()
            child.text = Genes::crossover(@genes[rnd1].text, @genes[rnd2].text) 
            @genes << child
        end
    end
    
    def mutations
        @genes.each do |g|
            rnd = rand(0..10)
            if rnd == 1
                g.mutation
            end
        end
    end
    
    def next_generation
        @generation += 1
    end
end

#main
algo = GeneticAlgorithm.new()
while true
    algo.evaluations()
    
    algo.show_all()
    
    algo.delete()
    algo.crossovers()
    algo.mutations()
    algo.next_generation()
    
    if $flag == true
        puts "finish"
        break
    end
end