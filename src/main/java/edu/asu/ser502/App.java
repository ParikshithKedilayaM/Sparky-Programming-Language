package edu.asu.ser502;

import java.util.List;
import java.util.Map;

import org.jpl7.Atom;
import org.jpl7.Query;
import org.jpl7.Term;

/**
 * Binding class for lexer, parser and compiler.
 *
 * @author Parikshith Kedilaya Mallar
 *
 */
public class App {
	public static void main(String[] args) {
		App app = new App();
		app.run("InputFile.txt");
	}

	public void run(String fileName) {
		consultFile("Intepreter.pl");
		Term parseTree = createParseTree(fileName);
		System.out.println("Parse Tree -> " + parseTree);
		evaluateProgram(parseTree);
	}

	/**
	 * Consults Intepreter.pl file in the prolog environment
	 *
	 * @param fileName - File with DCG or Prolog code
	 */
	private void consultFile(String fileName) {
		String fileSeparator = System.getProperty("file.separator");
		Query consultQuery = new Query("consult",
				new Term[] { new Atom("src" + fileSeparator + "resources" + fileSeparator + fileName) });
		System.out.println("Consult " + (consultQuery.hasSolution() ? "succeeded" : "failed"));
	}

	/**
	 * Method to create parse tree for the given program in the input file
	 *
	 * @param fileName - File which has program written
	 * @return - returns the generated parse tree
	 */
	private Term createParseTree(String fileName) {
		Tokens tokens = new Tokens();
		List<String> tokensGenerated = tokens.generateTokensFromFile(fileName);
		String tokensList = "";
		for (String token : tokensGenerated) {
			if(token.contains("\"")) {
				String newToken =  token.substring(1, token.length() -1);
				token = "\",\'"+newToken+"\',\"";
			}
			tokensList += token + ",";
		}
		if (tokensList != null) {
			tokensList = tokensList.substring(0, tokensList.length() - 1);
			tokensList = tokensList.replaceAll(",,,", ",\',\',");
			tokensList = tokensList.replaceAll("[(]", "'('");
			tokensList = tokensList.replaceAll("[)]", "')'");
			tokensList = tokensList.replaceAll("[\"]", "\'\"\'");
			System.out.println(tokensList);
		}
		Query parseTreeQuery = new Query("program(R, [" + tokensList + "],[]).");
		return parseTreeQuery.hasSolution() ? parseTreeQuery.oneSolution().get("R") : null;
	}

	/**
	 * Method to create runtime execution environment. Takes parse tree and produces
	 * the calculated output
	 *
	 * @param parseTree - parse tree generated in createParseTree()
	 */
	private void evaluateProgram(Term parseTree) {
		Query evaluationQuery = new Query("eval_program(" + parseTree + ",S)");
		Map<String, Term>[] result = evaluationQuery.allSolutions();
		for (int i = 0; i < result.length; i++) {
			System.out.println("Result = " + result[i].get("S"));
		}
		if (result.length == 0) {
			System.out.println("Failed");
		}
	}
}