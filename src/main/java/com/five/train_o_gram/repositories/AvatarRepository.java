package com.five.train_o_gram.repositories;

import com.five.train_o_gram.models.Avatar;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AvatarRepository extends JpaRepository<Avatar, Integer> {
    List<Avatar> findAllIdByOwnerId(int id);
}