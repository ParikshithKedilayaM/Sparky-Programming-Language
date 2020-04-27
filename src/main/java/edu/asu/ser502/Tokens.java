package edu.asu.ser502;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

/**
 * Class to read a program from a file and generate list of tokens
 *
 * @author Parikshith Kedilaya Mallar
 *
 */
public class Tokens {

	private List<String> tokensList;

	public Tokens() {
		tokensList = new ArrayList<>();
	}

	/**
	 * Reads program from a file and returns arraylist of tokens
	 *
	 * @param fileName - File containing the program
	 * @return - arraylist of generated tokens
	 */
	public List<String> generateTokensFromFile(String fileName) {
		try(BufferedReader buffer = new BufferedReader(new FileReader(fileName))) {
			String line = buffer.readLine();
			while (line != null) {
				if (line.contains("\"")) {
					String[] lineSplit = line.split("\"");
					int length = lineSplit.length;
					int i = 0;
					while (i +2 <= length) {
						line = lineSplit[i];
						generateTokens(line);
						tokensList.add("\"" + lineSplit[i+1] + "\"");
						line = lineSplit[i+2];
						i = i + 2;
					}
				}
				generateTokens(line);
				line = buffer.readLine();
			}
		} catch ( IOException e) {
			e.printStackTrace();
		}
		return tokensList;
	}

	/**
	 * Method to generate tokens
	 *
	 * @param input - one line of code from the program file
	 */
	private void generateTokens(String input) {
		String delimiters = ":!;<>+()=\t \n*-/,|?";
		StringTokenizer tokenizer = new StringTokenizer(input, delimiters, true);
		while (tokenizer.hasMoreTokens()) {
			String nextToken = tokenizer.nextToken();
			if (nextToken != null && !nextToken.trim().equals("")) {
				tokensList.add(nextToken);
			}
		}
	}
}