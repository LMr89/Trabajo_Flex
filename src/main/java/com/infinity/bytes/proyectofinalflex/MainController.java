package com.infinity.bytes.proyectofinalflex;

import java.awt.Image;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.swing.ImageIcon;
import javax.swing.JOptionPane;

/**
 * Clase constroladora del patron MVC el cual se encarga de manejar los clicks de los componentes de la interfaz
 * @author LuisQMHz
 */
public class MainController implements ActionListener{

    MainForm mainFrame;

    /**
     * Constructor de la clase
     * @param mainFrame  Objeto del formulario principal
     */
    public MainController(MainForm mainFrame) {
        this.mainFrame = mainFrame;
        initiComponentes();
    }

    /**
     * Metodo que inicia la condifuracion para la interfaz
     */
    void initiComponentes() {

        mainFrame.setTitle("CODIFICADOR");
        ImageIcon imgIcon = new ImageIcon("imagenes\\cryptographic-key.png");
        mainFrame
                .getLblImage()
                .setIcon(new ImageIcon(imgIcon.getImage().getScaledInstance(
                        mainFrame.getLblImage().getWidth(), mainFrame.getLblImage().getHeight(), Image.SCALE_SMOOTH)));

        mainFrame.getBtnCodificar().addActionListener(this);
    }

    /**
     * Inicializador de la interfaz
     */
    void initWindow() {
        this.mainFrame.setVisible(true);
    }
    
    /**
     * Metodo encargado de verificar si el texto de entrada corresponde a un codigo morse
     * @param data Data de entrada 
     * @return  true si lo es de lo contrario false
     */
    boolean verificarSiEsMorse(String data){
        Pattern pate = Pattern.compile("[\\.]+[\\s\\/\\s]+");
        
        Matcher matches = pate.matcher(data);
        return matches.find();
        
    }
    
    
    /**
     * Encargado de manejar el click del boton en la interfaz
     * @param e Evento click
     */
    @Override
    public void actionPerformed(ActionEvent e) {
        //Se obtiene el texto ingresado
        String data = mainFrame.getTxtClearText().getText();
        
        //Se verifica que lo ingresado no este vacio si lo esta imprime un mensaje de error
        if (data.isEmpty()) {
            JOptionPane.showMessageDialog(null, "No ha ingresado un texto a codificar", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }
        //Verificar si el texto ingresado no este ya codificado pese a seleccionar la opcion de codificacion       
        if (verificarSiEsMorse(data) && mainFrame.getRdCodificar().isSelected()) {
            JOptionPane.showMessageDialog(null, "El texto al parecer ya se encuentra codificado, operacion cancelada", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }
        
       
        //Continua el flujo con normalidad, aqui segun el radio buton seleccionado se envia el tipo de orden si es codificar o decodificar y se escoge el programa
        String commando = String.format("%s %s ",
                mainFrame.getRdCodificar().isSelected() ? "Codigo_flex\\codificador.exe"
                : "Codigo_flex\\decodificador.exe", data);

        //Pieza de codigo en el cual se ejecutara el comando
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
    
    /**
     * Metodo encargado de imprimir caracteres en el componente principal de la intefaz
     * @param data 
     */
    void imprimirData(String data){
        mainFrame.getTxtOut().append(data+"\n");
    }


}
