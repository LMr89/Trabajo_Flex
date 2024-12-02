package com.infinity.bytes.proyectofinalflex;

import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;

/**
 *
 * @author LuisQMHz
 */
public class MainController implements ActionListener{

    MainForm mainFrame;

    public MainController(MainForm mainFrame) {
        this.mainFrame = mainFrame;
        initiComponentes();
    }

    void initiComponentes() {

        mainFrame.setTitle("CODIFICADOR");
        ImageIcon imgIcon = new ImageIcon("imagenes\\cryptographic-key.png");
        mainFrame
                .getLblImage()
                .setIcon(new ImageIcon(imgIcon.getImage().getScaledInstance(
                        mainFrame.getLblImage().getWidth(), mainFrame.getLblImage().getHeight(), Image.SCALE_SMOOTH)));

        mainFrame.getBtnCodificar().addActionListener(this);
    }

    void initWindow() {
        this.mainFrame.setVisible(true);
    }
    
    boolean verificarSiEsMorse(String data){
        Pattern pate = Pattern.compile("[\\.]+[\\s\\/\\s]+");
        
        Matcher matches = pate.matcher(data);
        return matches.find();
        
    }
    
    
    
    @Override
    public void actionPerformed(ActionEvent e) {
      
        String data = mainFrame.getTxtClearText().getText();
        if (data.isEmpty()) {
            JOptionPane.showMessageDialog(null, "No ha ingresado un texto a codificar", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }
        //Verificar si el texto ingresado no este ya codificado pese a seleccionar la opcion de codificacion
        
        if (verificarSiEsMorse(data) && mainFrame.getRdCodificar().isSelected()) {
            JOptionPane.showMessageDialog(null, "El texto al parecer ya se encuentra codificado, operacion cancelada", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }
        
       
        //Continua el flujo con normalidad
        String commando = String.format("%s %s ",
                mainFrame.getRdCodificar().isSelected() ? "Codigo_flex\\codificador.exe"
                : "Codigo_flex\\decodificador.exe", data);

        try {
            System.out.println(commando);
            CommandLineRunner
                    .runCommand(commando, new OnTransferData() {
                        @Override
                        public void transfer(Object da) {
                           // mainFrame.getTxtOut().setText(da + "");
                            imprimirData(da+"");
                        }
                    });
        } catch (Exception ex) {
            JOptionPane.showMessageDialog(null, ex.getMessage(), "Error al codificar", JOptionPane.ERROR_MESSAGE);
        }
        
    }
    
    void imprimirData(String data){
        mainFrame.getTxtOut().append(data+"\n");
    }


}
