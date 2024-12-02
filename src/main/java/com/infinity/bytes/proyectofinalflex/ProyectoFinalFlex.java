package com.infinity.bytes.proyectofinalflex;

import com.formdev.flatlaf.FlatDarculaLaf;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
/**
 *
 * @author LuisQMHz
 */
public class ProyectoFinalFlex {

  public static void main(String[] args) {

        java.awt.EventQueue.invokeLater(() -> {
            try {
                UIManager.setLookAndFeel(new FlatDarculaLaf());
                new MainController(new MainForm()).initWindow();
                
            } catch (UnsupportedLookAndFeelException ex) {
                Logger.getLogger(ProyectoFinalFlex.class.getName()).log(Level.SEVERE, null, ex);
            }
            
        });

    }
}
