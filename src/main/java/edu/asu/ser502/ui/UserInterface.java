package edu.asu.ser502.ui;

import java.awt.BorderLayout;
import java.awt.Color;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.Observable;
import java.util.Observer;

import javax.swing.JFrame;
import javax.swing.JOptionPane;
import javax.swing.JScrollPane;
import javax.swing.JTextArea;
import javax.swing.ScrollPaneConstants;
import javax.swing.border.EtchedBorder;
import javax.swing.border.TitledBorder;
import javax.swing.text.DefaultHighlighter;
import javax.swing.text.Highlighter.HighlightPainter;

public class UserInterface extends JFrame implements Observer {

	private static final long serialVersionUID = 1L;
	private MenuBar menuBar = null;

	public UserInterface() {
		Model.getInstance().addObserver(this);
		setExtendedState(getExtendedState() | JFrame.MAXIMIZED_BOTH);
		setTitle(" Language ");
		setLayout(new BorderLayout());
		setDefaultCloseOperation(EXIT_ON_CLOSE);
		menuBar = new MenuBar();
		setJMenuBar(menuBar);
		addTextArea();
		setVisible(true);
	}
	
	private void addTextArea() {
		JTextArea textArea = new JTextArea();
		Model.getInstance().setTextArea(textArea);
		textArea.addMouseListener(new MouseAdapter() {
			public void mouseClicked(MouseEvent e) {
				HighlightPainter painter = new DefaultHighlighter.DefaultHighlightPainter(
						Color.YELLOW);
				if (e.getClickCount() == 2) {
					String selectedText = Model.getInstance().getTextArea().getSelectedText();
					if (selectedText != null) {
						menuBar.searchAll(selectedText, painter);
					}
				} else {
					Model.getInstance().getTextArea().getHighlighter().removeAllHighlights();
				}
			}
		});
		textArea.addKeyListener(new KeyHandler(menuBar));
		JScrollPane scrollPane = new JScrollPane(textArea);
		scrollPane.setHorizontalScrollBarPolicy(ScrollPaneConstants.HORIZONTAL_SCROLLBAR_AS_NEEDED);
		scrollPane.setVerticalScrollBarPolicy(ScrollPaneConstants.VERTICAL_SCROLLBAR_AS_NEEDED);
		
	    scrollPane.setBorder(new TitledBorder(new EtchedBorder(),"Text Editor"));
		this.add(scrollPane);
	}
	
	private void displayMessage(String message) {
		JOptionPane.showMessageDialog(null, message);
	}

	public void update(Observable o, Object arg) {
		displayMessage(Model.getInstance().getDisplayMessage());
	}

	public static void main(String[] args) {
		new UserInterface();
	}
	
}
