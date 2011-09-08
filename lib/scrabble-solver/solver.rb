module Scrabble
  module Solver
    # The name of the file to use as a word dictionary. This file can be any
    # file that contains a list of words, one word per line.
    @word_file_name = File.dirname(__FILE__) + "/../../assets/words.txt"

    # Set a new word file. Exit the program if the file does not exist.
    #
    # If the file does exist, the cached word list is cleared out and the
    # next time the word list is requested, the new list from the new file
    # is returned and subsequently cached.
    def self.word_file_name= file_name
      if File.exists? file_name
        # Reset the word list
        @word_list      = nil
        @word_file_name = file_name
      else
        puts "The file name #{file_name} is not valid."
        exit
      end
    end

    # Reads in the words.txt file and returns an array containing all of the words
    # in that file.
    #
    # Example:
    #
    #   Scrabble::Solver.word_list.each do |word|
    #     puts word
    #   end
    def self.word_list
      @word_list ||= File.open(@word_file_name) do |file|
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

      # Set a new word file if the option has been specified
      if options[:word_file]
        self.word_file_name = options[:word_file]
      end

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

      # Filter only words that start with a specific sequence.
      if options[:starts_with]
        words.keep_if { |word| word.start_with? options[:starts_with] }
      end

      # Filter words that only end in a certain sequence.
      if options[:ends_with]
        words.keep_if { |word| word.end_with? options[:ends_with] }
      end

      # Fitler only words shorter than a given amount.
      if options[:shorter_than]
        words.keep_if { |word| word.length < options[:shorter_than].to_i }
      end

      # Filter words only longer than a given amount.
      if options[:longer_than]
        words.keep_if { |word| word.length > options[:longer_than].to_i }
      end

      # Filter words that contain a specific sequence at a given 1-based index.
      if options[:contains] and options[:at]
        words.keep_if do |word|
          word[options[:at].to_i - 1, options[:contains].length] == options[:contains]
        end
      end

      return words
    end
  end
end
