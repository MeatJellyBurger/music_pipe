package com.meatjellyburgur.musicpipe.controller;

import com.meatjellyburgur.musicpipe.repository.UserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import javax.websocket.Session;

@Controller
@RequestMapping("/members")
@Slf4j
@RequiredArgsConstructor
public class UserController {
    private  final UserMapper userMapper;
    /*
        해야 될 것
        1. 회원가입
        2. 회원 이메일 , 닉네임 중복 검증 요청
        3. 로그인 요청
        3. 로그아웃 요청 처리
     */

    // 회원가입 처리
    @PostMapping("/sign-up")
    public String signUp(){ // 파라미터로 회원가입 DTO 만들어야함


        log.info("/members/sign-up Post");

        return "";
    }


    // 로그인 양식 요청
    @GetMapping("/sign-in")
    public String signIn(String s){ // 세션 받아야함 파라미터로
        log.info("/members/sign-in GET!!");

        return "";
    }

    // 로그인 검증 요청
    @PostMapping("/sign-in")
    public String signIn(){
        log.info("/members/sign-in POST!!");

        return "redirect:/members/sign-in";
    }

    // 로그아웃 요청 처리

}
