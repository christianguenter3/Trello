require 'test/unit'

class Float
	def has_no_remainder?
		self % 1 == 0.0
	end
end

class Trello_Hash

	LETTERS   = 'acdegilmnoprstuw'
	INIT_HASH = 7.0
	SALT      = 37.0

	public

	def get_hash(input_string)
		h = INIT_HASH
		input_string.split(//).each_with_index do |c,index|
			h = h * SALT + LETTERS.index(c)
		end
		return h
	end

	def unhash(hash,len)
		result = [[hash,""]]

		len.times { result = _filter(_extend(result)) }

		_final_result_filter(result)
	end

	private

	def _extend(array)
		array.map do |hash, string|
			(0..LETTERS.length-1).to_a.map{|x| [hash,string,x]}
		end[0]
	end

	def _filter(array)
		array.map!{ |hash, string, x| [(hash - x) / SALT, string + LETTERS[x]]}
		.select!{ |hash,string| hash.has_no_remainder? }
	end
	

	def _final_result_filter(array)
		array.select{|hash,string| hash == INIT_HASH}.map{|hash,string| string.reverse}[0]
	end
end

class Test_Hash < Test::Unit::TestCase
	def setup
		@hash = Trello_Hash.new
	end

	TEST_CASES_HASH = {	'leepadg' 	=> 680131659347,
						'ra'  	 	=> 9990,
						'e' 	 	=> 262,
						'r' 	 	=> 270,
						'ear'  		=> 358689,
						'wuli' 	 	=> 13898315}

	def test_hash
		TEST_CASES_HASH.each do |input,output|
			assert_equal(output, @hash.get_hash(input))
		end
	end

	TEST_CASES_UNHASH = { 	[680131659347,7] 	=> 'leepadg',
						 [262,1] 			=> 'e',
						 [270,1] 			=> 'r',
						 [358689,3] 			=> 'ear',
						 [9990,2] 			=> 'ra',
						 [13898315,4] 		=> 'wuli',
						 [956446786872726,9] => 'trellises' }

	def test_unhash
		TEST_CASES_UNHASH.each do |input,output|
			assert_equal(output,@hash.unhash(input[0],input[1]))
		end
	end
end
