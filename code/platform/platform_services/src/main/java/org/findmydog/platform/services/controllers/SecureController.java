/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.findmydog.platform.services.controllers;

import javax.servlet.http.HttpServletRequest;
import org.findmydog.platform.module.model.User;
import org.findmydog.platform.module.repository.UserRepository;
import org.findmydog.platform.module.util.CryptoAlgorithms;
import org.findmydog.platform.services.exceptions.APIKeyNotFoundException;
import org.findmydog.platform.services.exceptions.SignNotFoundException;
import org.findmydog.platform.services.exceptions.UnauthorizedUserException;
import org.findmydog.platform.services.security.SecurityContext;

import org.springframework.beans.factory.annotation.Autowired;

/**
 *
 * @author rabasco
 */
public class SecureController implements SecurityContext {

    @Autowired
    protected HttpServletRequest request;
    @Autowired
    private UserRepository userRepository;

    public String getSign(String url, String secret) throws Exception {
        // Codificamos el mensaje añadiendole el secreto del usuario
        return CryptoAlgorithms.sha256(url + secret);
    }

    public User getAutenticatedUser() throws Exception {

        // Obtenemos el apiKey de la llamada
        String apiKey = request.getParameter("apikey");
        if (apiKey == null) {
            throw new APIKeyNotFoundException();
        }

        // Obtenemos la firma
        String requestSign = request.getParameter("sign");
        if (requestSign == null) {
            throw new SignNotFoundException();
        }

        // Obtenemos la url sin la ? inicial y le quitamos la firma (sign)
        String url = request.getRequestURI() + "?" + request.getQueryString();
        url = url.substring(0, url.indexOf("&sign="));

        // Obtenemos el usuario
        User user = userRepository.getUserByApikey(apiKey);

        // Obtenemos la firma calculada por el servidor
        String serverSign = getSign(url, user.getSecret());

        // Comprobamos si es el mismo
        if (!serverSign.equals(requestSign)) {
            throw new UnauthorizedUserException();
        }

        return user;
    }

    public boolean checkSign(User user) throws Exception {

        // Obtenemos la firma
        String requestSign = request.getParameter("sign");
        if (requestSign == null) {
            throw new SignNotFoundException();
        }

        // Obtenemos la url sin la ? inicial y le quitamos la firma (sign)
        String url = request.getRequestURI() + "?" + request.getQueryString();
        url = url.substring(0, url.indexOf("&sign="));

        // Obtenemos la firma calculada por el servidor
        String serverSign = getSign(url, user.getSecret());

        // Comprobamos si es el mismo
        if (!serverSign.equals(requestSign)) {
            throw new UnauthorizedUserException();
        }

        return true;
    }
}
