require File.dirname(__FILE__) + "/../spec_helper"

module Scrabble
  describe Solver do
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
        (word.length > 4).should == true
      end
    end

    it "should be able to filter by length, less than" do
      words = Solver.words_for "diegtlkwj", shorter_than: "4"
      words.each do |word|
        (word.length < 4).should == true
      end
    end

    it "should be able to filter by length both less than and greater than" do
      words = Solver.words_for "diegtlkwj", shorter_than: "6", longer_than: "4"
      words.each do |word|
        (word.length > 4 and word.length < 6).should == true
      end
    end

    it "should be able to return only words that have a specific letter at " +
      "a given index" do
      words = Solver.words_for "diegti?wj", contains: "i", at: "2"
      words.each do |word|
        word[1].should == "i"
      end
    end
  end
end
