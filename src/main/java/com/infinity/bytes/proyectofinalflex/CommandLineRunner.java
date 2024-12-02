package com.infinity.bytes.proyectofinalflex;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;

/**
 *
 * @author LuisQMHz
 */
public class CommandLineRunner {

    static StringBuilder sb;

    static {
        sb = new StringBuilder();
    }
    
    public static void runCommand(String command, OnTransferData transfer) throws IOException, InterruptedException {

        ProcessBuilder proc = new ProcessBuilder(command.split("\\s"));
        proc.redirectErrorStream(true);

        Process proce = proc.start();
        InputStream inputStream = proce.getInputStream();

        try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {
            String line;
            while ((line = reader.readLine()) != null) {
                transfer.transfer(line);
            }

            proce.waitFor();
            
            //transfer.transfer("Código resultante de ejecución: " + exitCode);
        }
    }
}
