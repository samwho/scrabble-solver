require File.dirname(__FILE__) + "/../spec_helper"

module Scrabble
  describe Solver do
    # Specify the name of the test word file.
    let(:test_word_file) do
      File.dirname(__FILE__) + "/../assets/test_word_list.txt"
    end

    # Path to the solver executable
    let (:executable) do
      File.dirname(__FILE__) + "/../../bin/scrabble-solver"
    end

    context "Direct" do
      it "should return a list of words that can be made" do
        words = Solver.words_for "there"
        words.should include "three", "there", "ether", "the", "thee", "tee"
      end

      it "should be able to use blank tiles with ?" do
        words = Solver.words_for "g?me"
        words.should include "game", "egg", "peg", "gel", "germ", "get", "go", "gum"
      end

      it "should be able to use a start_with argument successfully" do
        words = Solver.words_for "geg", starts_with: "eg"
        words.should include "egg"
      end

      it "should be able to use an ends_with argument successfully" do
        words = Solver.words_for "pngi", ends_with: "ing"
        words.should include "ping"
      end

      it "should be able to use a combination of starts_with and ends_with" do
        words = Solver.words_for "crcak", starts_with: "cr", ends_with: "k"
        words.should include "crack"
      end

      it "should be able to filter words by length" do
        words = Solver.words_for "diegtlkwj", longer_than: "4"
        words.each do |word|
          word.length.should be > 4
        end

        # Ensure that some words were actually checked in the above loop.
        words.length.should be > 0, "No words scanned."
      end

      it "should be able to filter by length, less than" do
        words = Solver.words_for "diegtlkwj", shorter_than: "4"
        words.each do |word|
          word.length.should be < 4
        end

        # Ensure that some words were actually checked in the above loop.
        words.length.should be > 0, "No words scanned."
      end

      it "should be able to filter by length both less than and greater than" do
        words = Solver.words_for "diegtlkwj", shorter_than: "6", longer_than: "4"
        words.each do |word|
          word.length.should be > 4 and word.length.should be < 6
        end

        # Ensure that some words were actually checked in the above loop.
        words.length.should be > 0, "No words scanned."
      end

      it "should be able to return only words that have a specific letter at " +
        "a given index" do
        words = Solver.words_for "diegti?wj", contains: "i", at: "2"
        words.each do |word|
          word[1].should == "i"
        end

        # Ensure that some words were actually checked in the above loop.
        words.length.should be > 0, "No words scanned."
        end

      it "should be able to return only words that have a specific middle part" do
        words = Solver.words_for "diegti?wj", contains: "it", at: "2"
        words.each do |word|
          word[1, 2].should == "it"
        end

        # Ensure that some words were actually checked in the above loop.
        words.length.should be > 0, "No words scanned."
      end

      it "should be able to take a new word file if specified" do
        words = Solver.words_for "????", word_file: test_word_file
        words.should be_empty
      end
    end

    context "Command-line" do
      it "should return a list of words that can be made" do
        words = `#{executable} tehre`.split(/\n/)
        words.should include "three", "there", "ether", "the", "thee", "tee"
      end

      it "should be able to use blank tiles with ?" do
        words = `#{executable} g?me`.split(/\n/)
        words.should include "game", "egg", "peg", "gel", "germ", "get", "go", "gum"
      end

      it "should be able to use a start_with argument successfully" do
        words = `#{executable} geg --starts-with eg`.split(/\n/)
        words.should include "egg"
      end

      it "should be able to use an ends_with argument successfully" do
        words = `#{executable} pngi --ends-with ing`.split(/\n/)
        words.should include "ping"
      end

      it "should be able to use a combination of starts_with and ends_with" do
        words = `#{executable} crcak --starts-with cr --ends-with k`.split(/\n/)
        words.should include "crack"
      end

      it "should be able to filter words by length" do
        words = `#{executable} diegtlkwj --longer-than 4`.split(/\n/)
        words.each do |word|
          word.length.should be > 4
        end

        # Ensure that some words were actually checked in the above loop.
        words.length.should be > 0, "No words scanned."
      end

      it "should be able to filter by length, less than" do
        words = `#{executable} diegtlkwj --shorter-than 4`.split(/\n/)
        words.each do |word|
          word.length.should be < 4
        end

        # Ensure that some words were actually checked in the above loop.
        words.length.should be > 0, "No words scanned."
      end

      it "should be able to filter by length both less than and greater than" do
        words = `#{executable} diegtlkwj --shorter-than 6 --longer-than 4`.split(/\n/)
        words.each do |word|
          word.length.should be > 4 and word.length.should be < 6
        end

        # Ensure that some words were actually checked in the above loop.
        words.length.should be > 0, "No words scanned."
      end

      it "should be able to return only words that have a specific letter at " +
        "a given index" do
        words = `#{executable} diegtlkwj --contains i --at 2`.split(/\n/)
        words.each do |word|
          word[1].should == "i"
        end

        # Ensure that some words were actually checked in the above loop.
        words.length.should be > 0, "No words scanned."
        end

      it "should be able to return only words that have a specific middle part" do
        words = `#{executable} diegti?wj --contains it --at 2`.split(/\n/)
        words.each do |word|
          word[1, 2].should == "it"
        end

        # Ensure that some words were actually checked in the above loop.
        words.length.should be > 0, "No words scanned."
      end

      it "should be able to take a new word file if specified" do
        words = `#{executable} ???? --word-file #{test_word_file}`.split(/\n/)
        words.should be_empty
      end
    end
  end
end
