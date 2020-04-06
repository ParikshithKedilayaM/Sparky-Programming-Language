package edu.asu.ser502;

import java.util.ArrayList;
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
		app.consultFile("Intepreter.pl");
		String fileName = "InputFile.txt";
		Term parseTree = app.createParseTree(fileName);
		System.out.println("Parse Tree -> " + parseTree);
		app.evaluateProgram(parseTree);
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
		ArrayList<String> tokensGenerated = tokens.generateTokensFromFile(fileName);
		String query = "";
		for (String token : tokensGenerated) {
			query += token + ",";
		}
		query = query.substring(0, query.length() - 1);
		query = query.replaceAll("[(]", "'('");
		query = query.replaceAll("[)]", "')'");
		Query parseTreeQuery = new Query("expr(R, [" + query + "],[]).");
		return parseTreeQuery.oneSolution().get("R");
	}

	/**
	 * Method to create runtime execution environment. Takes parse tree and produces
	 * the calculated output
	 * 
	 * @param parseTree - parse tree generated in createParseTree()
	 */
	private void evaluateProgram(Term parseTree) {
		Query evaluationQuery = new Query("eval_expr(" + parseTree + ",[(x,2),(y,3),(z,5)],S)");
		Map<String, Term>[] result = evaluationQuery.allSolutions();
		for (int i = 0; i < result.length; i++) {
			System.out.println("Result = " + result[i].get("S"));
		}
	}
}