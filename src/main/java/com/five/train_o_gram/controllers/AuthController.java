package com.five.train_o_gram.controllers;

import com.five.train_o_gram.dto.AuthenticationDTO;
import com.five.train_o_gram.dto.UserRegistrationDTO;
import com.five.train_o_gram.models.User;
import com.five.train_o_gram.security.jwt.JwtTokenProvider;
import com.five.train_o_gram.services.UserService;
import com.five.train_o_gram.util.exceptions.ErrorResponse;
import com.five.train_o_gram.util.exceptions.user.UserNotCreatedException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.AuthenticationException;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/auth")
public class AuthController {
    private final UserService userService;
    private final JwtTokenProvider jwtTokenProvider;
    private final AuthenticationManager authenticationManager;

    @Autowired
    public AuthController(UserService userService, JwtTokenProvider jwtTokenProvider,
                          AuthenticationManager authenticationManager){
        this.userService = userService;
        this.jwtTokenProvider = jwtTokenProvider;
        this.authenticationManager = authenticationManager;
    }

    @GetMapping("/login")
    public AuthenticationDTO loginPage() {
        return new AuthenticationDTO();
    }

    @PostMapping("/login")
    public ResponseEntity<Map<String, String>> performLogin(@RequestBody AuthenticationDTO authenticationDTO) {
        String username = authenticationDTO.getUsername();
        String password = authenticationDTO.getPassword();
        try {
            authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(username, password));
            String token = jwtTokenProvider.createToken(username);
            return ResponseEntity.ok(Map.of("username", username, "token", token));
        } catch (AuthenticationException e) {
            throw new BadCredentialsException("Invalid username or password");
        }
    }

    @GetMapping("/registration")
    public UserRegistrationDTO registrationPage (){
        return new UserRegistrationDTO();
    }

    @PostMapping("/registration")
    public ResponseEntity<Map<String, String>> performRegistration (@RequestBody UserRegistrationDTO userRegistrationDTO){

        String newUserLogin = userRegistrationDTO.getLogin();
        if (userService.findByLogin(newUserLogin) != null)
            throw new UserNotCreatedException("User with login " + newUserLogin + " is already exist");

        User registeredUser = userService.registrationUser(userRegistrationDTO);
        String token = jwtTokenProvider.createToken(registeredUser.getLogin());
        return ResponseEntity.ok(Map.of("username", userRegistrationDTO.getLogin(), "token", token));
    }

    @ExceptionHandler
    private ResponseEntity<ErrorResponse> handleException(UserNotCreatedException userNotCreatedException){
        ErrorResponse response = new ErrorResponse(userNotCreatedException.getMessage(),
                System.currentTimeMillis());
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }

    @ExceptionHandler
    private ResponseEntity<ErrorResponse> handleException(BadCredentialsException badCredentialsException){
        ErrorResponse response = new ErrorResponse(badCredentialsException.getMessage(),
                System.currentTimeMillis());
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }
}