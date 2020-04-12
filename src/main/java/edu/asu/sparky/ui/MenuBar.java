package edu.asu.sparky.ui;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

import javax.swing.JFileChooser;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JOptionPane;
import javax.swing.text.DefaultHighlighter;
import javax.swing.text.DefaultHighlighter.DefaultHighlightPainter;
import javax.swing.text.Highlighter.HighlightPainter;

import edu.asu.sparky.App;

public class MenuBar extends JMenuBar implements ActionListener {

	private static final long serialVersionUID = 1L;
	private FileManager fileManager;
	private FindReplace findReplace;
	private JMenu fileMenu = null;
	private JMenu editMenu = null;
	private JMenu runMenu = null;
	
	public MenuBar() {
		this.fileManager = new FileManager();
		this.findReplace = new FindReplace();
		createMenu();
		setVisible(true);
	}
	
	private void createMenu() {
		fileMenu = new JMenu("File");
		editMenu = new JMenu("Edit");
		runMenu = new JMenu("Run");
		createMenuItems();
		this.add(fileMenu);
		this.add(editMenu);
		this.add(runMenu);
	}

	private void createMenuItems() {
		String[] fileMenuOptions = { "New", "Open", "Save" };
		String[] editMenuOptions = { "Cut", "Copy", "Paste", "Find", "FindAll", "Replace", "ReplaceAll" };
		String[] runMenuOptions = {"Run"};
		for (String option : fileMenuOptions) {
			fileMenu.add(createMenuItem(option));
		}
		for (String option : editMenuOptions) {
			editMenu.add(createMenuItem(option));
		}
		for (String option : runMenuOptions) {
			runMenu.add(createMenuItem(option));
		}
	}

	private JMenuItem createMenuItem(String option) {
		JMenuItem newMenuItem = new JMenuItem(option);
		newMenuItem.addActionListener(this);
		return newMenuItem;
	}

	public void actionPerformed(ActionEvent e) {
		String eventPerformed = e.getActionCommand();
		switch (eventPerformed) {
		case "Open":
			openFile();
			break;
		case "Save":
			saveAsFile();
			break;
		case "New":
			createNewEditorWorkspace();
			break;
		case "Cut":
			cutOperation();
			break;
		case "Copy":
			copyOperation();
			break;
		case "Paste":
			pasteOperation();
			break;
		case "Find":
			find();
			break;
		case "FindAll":
			findAll();
			break;
		case "Replace":
			replace();
			break;
		case "ReplaceAll":
			replaceAll();
			break;
		case "Run":
			runApi();
			break;
		}
	}
	
	public void saveAsFile() {
		String chooseFile = chooseFile();
		if (chooseFile != null && !chooseFile.equals("")) {
			fileManager.saveAsFile(chooseFile);
		}
	}
	
	public void openFile() {
		fileManager.loadFile(chooseFile());
	}
	
	public void cutOperation() {
		Model.getInstance().getTextArea().cut();
	}
	
	public void copyOperation() {
		Model.getInstance().getTextArea().copy();
	}
	
	public void pasteOperation() {
		Model.getInstance().getTextArea().paste();
	}
	
	private DefaultHighlightPainter getPainter() {
		return new DefaultHighlighter.DefaultHighlightPainter(
				Model.getInstance().getTextArea().getSelectionColor());
	}
	
	public void find() {
		String userInput = getUserInput("Enter characters to Search");
		search(userInput, getPainter());
	}
	
	public void findAll() {
		String userInput = getUserInput("Enter characters to Search");
		searchAll(userInput, getPainter());
	}
	
	public void search(String searchText, HighlightPainter painter) {
		findReplace.searchOne(searchText, painter);
	}
	
	public void searchAll(String searchText, HighlightPainter painter) {
		findReplace.searchAll(searchText, painter);
	}
	
	public void replace() {
		String replaceString = getUserInput("Enter characters to be replaced: ");
		if (!replaceString.equals("")) {
			String replaceNewString = getUserInput("Enter new characters to be replaced with: ");
			if (!replaceNewString.equals("")) {
				findReplace.replaceText(replaceString, replaceNewString);
			}
		}
	}
	
	public void replaceAll() {
		String replaceAllString = getUserInput("Enter characters to be replaced: ");
		if (!replaceAllString.equals("")) {
			String replaceAllNewString = getUserInput("Enter new characters to be replaced with: ");
			if (!replaceAllNewString.equals("")) {
				findReplace.replaceAll(replaceAllString, replaceAllNewString);
			}
		}
	}

	private String getUserInput(String message) {
		String userText = JOptionPane.showInputDialog(message);
		return userText == null ? "" : userText;
	}
	
	private void runApi() {
		String savedFile = Model.getInstance().getFileName();
		if (savedFile == null || savedFile.equals("")) {
			fileManager.saveAsFile(chooseFile());
		}
		if (fileManager.saveFile(Model.getInstance().getFileName())) {
			callPlugin();
		}
	}
	
	private void callPlugin() {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		PrintStream ps = new PrintStream(baos);
		PrintStream old = System.out;
		System.setOut(ps);
		App app = new App();
		app.run(Model.getInstance().getFileName());
		System.out.flush();
		Model.getInstance().setDisplayMessage(baos.toString());
		System.setOut(old);
	}
	
	public void createNewEditorWorkspace() {
		String text = Model.getInstance().getText();
		if (text == null || text.equals("")) {} else {
			int showConfirmDialog = JOptionPane.showConfirmDialog(null, 
					"Are you sure to clear a new workspace? Any unsaved changes will be discarded");
			if (showConfirmDialog == 0) {
				Model.getInstance().setText("");
			}
		}
	}

	private String chooseFile() {
		JFileChooser chosenFile = new JFileChooser();
		int showOpenDialog = chosenFile.showOpenDialog(null);
		if (showOpenDialog == JFileChooser.APPROVE_OPTION) {
			return chosenFile.getSelectedFile().getAbsolutePath();
		}
		return "";
	}
}
