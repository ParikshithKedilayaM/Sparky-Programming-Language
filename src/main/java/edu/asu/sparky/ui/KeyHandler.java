package edu.asu.sparky.ui;

import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

public class KeyHandler implements KeyListener {
	MenuBar menuBar;

	public KeyHandler(MenuBar menuBar) {
		this.menuBar = menuBar;
	}

	@Override
	public void keyPressed(KeyEvent keyEvent) {
		if ((keyEvent.getKeyCode() == KeyEvent.VK_S) && 
				((keyEvent.getModifiers() & KeyEvent.CTRL_MASK) != 0)) {
			menuBar.saveAsFile();
		} else if ((keyEvent.getKeyCode() == KeyEvent.VK_O) && 
				((keyEvent.getModifiers() & KeyEvent.CTRL_MASK) != 0)) {
			menuBar.openFile();
		} else if ((keyEvent.getKeyCode() == KeyEvent.VK_N) && 
				((keyEvent.getModifiers() & KeyEvent.CTRL_MASK) != 0)) {
			menuBar.createNewEditorWorkspace();
		} else if ((keyEvent.getKeyCode() == KeyEvent.VK_F) && 
				((keyEvent.getModifiers() & KeyEvent.CTRL_MASK) != 0)) {
			menuBar.find();
		} else if ((keyEvent.getKeyCode() == KeyEvent.VK_F) && 
				((keyEvent.getModifiers() & KeyEvent.CTRL_MASK) != 0)
				&& ((keyEvent.getModifiers() & KeyEvent.ALT_MASK) != 0)) {
			menuBar.findAll();
		} else if ((keyEvent.getKeyCode() == KeyEvent.VK_R) && 
				((keyEvent.getModifiers() & KeyEvent.CTRL_MASK) != 0)) {
			menuBar.replace();
		} else if ((keyEvent.getKeyCode() == KeyEvent.VK_R) && 
				((keyEvent.getModifiers() & KeyEvent.CTRL_MASK) != 0)
				&& ((keyEvent.getModifiers() & KeyEvent.ALT_MASK) != 0)) {
			menuBar.replaceAll();
		}
	}

	@Override
	public void keyTyped(KeyEvent keyEvent) {
	}

	@Override
	public void keyReleased(KeyEvent keyEvent) {
	}
}
