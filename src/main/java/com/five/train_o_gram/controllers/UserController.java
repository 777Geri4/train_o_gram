package com.five.train_o_gram.controllers;

import com.five.train_o_gram.dto.UserDTO;
import com.five.train_o_gram.dto.UserRegistrationDTO;
import com.five.train_o_gram.services.impl.UserServiceImpl;
import com.five.train_o_gram.util.exceptions.ErrorResponse;
import com.five.train_o_gram.util.exceptions.user.UserNotFoundException;
import com.five.train_o_gram.util.exceptions.user.UserNotUpdatedException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/users")
public class UserController {
    private static final String USER_CANNOT_BE_UPDATED = "Користувача з таким логіном не можливо модифікувати";
    private static final String USER_CANNOT_BE_DELETED = "Користувача з таким логіном не можливо видалити";
    public static final String USER_NOT_FOUND = "Користувача з таким логіном не існує";
    private final UserServiceImpl userServiceImpl;

    @Autowired
    public UserController(UserServiceImpl userServiceImpl) {
        this.userServiceImpl = userServiceImpl;
    }

    @GetMapping()
    public ResponseEntity<UserRegistrationDTO> getLoginStatus() {
        return ResponseEntity.ok(userServiceImpl.convertUserToUserRegistrationDTO(userServiceImpl.
                findOne(userServiceImpl.getCurrentUser().getId())));
    }

    @GetMapping("/{id}")
    public ResponseEntity<UserDTO> getUser(@PathVariable("id") int id) {
        return ResponseEntity.ok(userServiceImpl.convertUserToUserDTO(userServiceImpl.findOne(id)));
    }

    @GetMapping("/{id}/edit")
    public ResponseEntity<UserRegistrationDTO> editUser(@PathVariable("id") int id){
        if (userServiceImpl.getCurrentUser().getId() != id) throw new UserNotUpdatedException(USER_CANNOT_BE_UPDATED);
        return ResponseEntity.ok(userServiceImpl.convertUserToUserRegistrationDTO(userServiceImpl.
                findOne(userServiceImpl.getCurrentUser().getId())));
    }

    @PatchMapping("/{id}")
    public ResponseEntity<UserRegistrationDTO> updateUser(@PathVariable("id") int id, @RequestBody UserRegistrationDTO userDTO){
        if (userServiceImpl.getCurrentUser().getId() != id) throw new UserNotUpdatedException(USER_CANNOT_BE_UPDATED);
        return ResponseEntity.ok(userServiceImpl.convertUserToUserRegistrationDTO(userServiceImpl.update(id, userDTO)));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<HttpStatus> deleteUser(@PathVariable("id") int id){
        if (userServiceImpl.getCurrentUser().getId() != id) throw new UserNotUpdatedException(USER_CANNOT_BE_DELETED);
        userServiceImpl.deleteUser(id);
        return ResponseEntity.ok(HttpStatus.OK);
    }

    @ExceptionHandler
    private ResponseEntity<ErrorResponse> handleException(UserNotFoundException userNotFoundException){
        ErrorResponse response = new ErrorResponse(USER_NOT_FOUND, System.currentTimeMillis());
        return new ResponseEntity<>(response, HttpStatus.NOT_FOUND);
    }

    @ExceptionHandler
    private ResponseEntity<ErrorResponse> handleException(UserNotUpdatedException userNotUpdatedException){
        ErrorResponse response = new ErrorResponse(userNotUpdatedException.getMessage(),
                System.currentTimeMillis());
        return new ResponseEntity<>(response, HttpStatus.BAD_REQUEST);
    }
}