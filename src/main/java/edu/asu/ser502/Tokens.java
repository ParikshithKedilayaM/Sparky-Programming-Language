package edu.asu.ser502;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.StringTokenizer;

/**
 * Class to read a program from a file and generate list of tokens
 * 
 * @author Parikshith Kedilaya Mallar
 *
 */
public class Tokens {

	private ArrayList<String> tokens;

	public Tokens() {
		tokens = new ArrayList<String>();
	}

	/**
	 * Reads program from a file and returns arraylist of tokens
	 * 
	 * @param fileName - File containing the program
	 * @return - arraylist of generated tokens
	 */
	public ArrayList<String> generateTokensFromFile(String fileName) {
		BufferedReader buffer = null;
		try {
			buffer = new BufferedReader(new FileReader(fileName));
			String line = buffer.readLine();
			while (line != null) {
				generateTokens(line);
				line = buffer.readLine();
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (buffer != null) {
				try {
					buffer.close();
				} catch (IOException e) {
				}
			}
		}
		return tokens;
	}

	/**
	 * Method to generate tokens
	 * 
	 * @param input - one line of code from the program file
	 */
	private void generateTokens(String input) {
		String delimiters = ":!;.<>+()=\t \n*-/'\"|";
		StringTokenizer tokenizer = new StringTokenizer(input, delimiters, true);
		while (tokenizer.hasMoreTokens()) {
			String nextToken = tokenizer.nextToken();
			if (nextToken != null && !nextToken.trim().equals("")) {
				tokens.add(nextToken);
			}
		}
	}
}