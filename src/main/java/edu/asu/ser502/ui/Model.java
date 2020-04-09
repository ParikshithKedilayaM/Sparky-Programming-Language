package edu.asu.ser502.ui;

import java.util.Observable;

import javax.swing.JTextArea;

public class Model extends Observable{
	
	private static Model instance = null;
	
	public static Model getInstance() {
		if (instance == null) {
			instance = new Model();
		}
		return instance;
	}
	
	private String fileName;

	public String getFileName() {
		return fileName;
	}

	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	
	public JTextArea getTextArea() {
		return textArea;
	}

	public void setTextArea(JTextArea textArea) {
		this.textArea = textArea;
	}
	
	public void setText(String text) {
		this.textArea.setText(text);
	}
	
	public String getText() {
		return this.textArea.getText();
	}

	public String getDisplayMessage() {
		return displayMessage;
	}

	public void setDisplayMessage(String displayMessage) {
		this.displayMessage = displayMessage;
		notifyObserver();
	}
	
	private void notifyObserver() {
		setChanged();
		notifyObservers();
	}

	private JTextArea textArea;
	
	private String displayMessage;
}
