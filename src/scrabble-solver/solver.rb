module Scrabble
  module Solver
    # Reads in the words.txt file and returns an array containing all of the words
    # in that file.
    #
    # Example:
    #
    #   Scrabble::Solver.word_list.each do |word|
    #     puts word
    #   end
    def self.word_list
      @word_list ||= File.open(File.dirname(__FILE__) +
                     "/../../unix-dict-words.txt") do |file|
        file.readlines.map do |line|
          line.chomp
        end.delete_if do |line|
          line.length < 2
        end
      end

      @word_list.clone
    end

    # Gets an array of words that would fit the current board of Scrabble
    # tiles.
    #
    # Example:
    #
    #   Scrabble::Solver.words_for "there"
    #   # => An array of words that the tiles t, h, e, r, e could make.
    #
    #   Scrabble::Solver.words_for "there?"
    #   # => An array of words that the tiles t, h, e, r, e plus a blank tile
    #   #    could make.
    def self.words_for letters, options = Hash.new(nil)
      letters  = letters.downcase.split(//)
      unknowns = letters.count "?"
      letters.delete "?"

      words = word_list.keep_if do |word|
        # Split the word into its letters.
        word = word.split(//)

        # Strip the letters that are in our hand from the word.
        letters.each do |letter|
          unless word.index(letter).nil?
            word.delete_at word.index(letter)
          end
        end

        # Only return the word if the remaining letters is equal to the number
        # of unknowns.
        word.length == unknowns
      end

      if options[:starts_with]
        words.keep_if { |word| word.start_with? options[:starts_with] }
      end

      if options[:ends_with]
        words.keep_if { |word| word.end_with? options[:ends_with] }
      end

      if options[:shorter_than]
        words.keep_if { |word| word.length < options[:shorter_than].to_i }
      end

      if options[:longer_than]
        words.keep_if { |word| word.length > options[:longer_than].to_i }
      end

      if options[:contains] and options[:at]
        words.keep_if { |word| word[options[:at].to_i - 1] == options[:contains] }
      end

      return words
    end
  end
end
