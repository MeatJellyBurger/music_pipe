package com.meatjellyburgur.musicpipe.service;

import com.meatjellyburgur.musicpipe.common.Page;
import com.meatjellyburgur.musicpipe.common.PageMaker;
import com.meatjellyburgur.musicpipe.dto.request.AutoLoginDTO;
import com.meatjellyburgur.musicpipe.dto.request.SignInRequestDTO;
import com.meatjellyburgur.musicpipe.dto.request.SignUpRequestDTO;
import com.meatjellyburgur.musicpipe.dto.response.FindUserResponseDTO;
import com.meatjellyburgur.musicpipe.dto.response.SignInUserResponseDTO;
import com.meatjellyburgur.musicpipe.entity.PersonalAbility;
import com.meatjellyburgur.musicpipe.entity.User;
import com.meatjellyburgur.musicpipe.repository.PersonalAbilityMapper;
import com.meatjellyburgur.musicpipe.repository.UserMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.web.util.WebUtils;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import static com.meatjellyburgur.musicpipe.service.SigninResult.*;
import static com.meatjellyburgur.musicpipe.util.SignInUtils.*;

@Service
@Slf4j
@RequiredArgsConstructor
public class UserService {
    private final UserMapper userMapper;
    private final PersonalAbilityMapper personalAbilityMapper;
    private final PasswordEncoder encoder;

    // 이메일 주면 해당하는 유저 보내줌
    public User getUser(String email) {
        // 여기서 찾기
        return userMapper.findUser(email);
    }

    // 회원가입
    public boolean join(SignUpRequestDTO dto) {
        return userMapper.save(dto.toEntity(encoder));

    }

    // 로그인 검증 처라
    public SigninResult authenticate(SignInRequestDTO dto, HttpServletRequest request, HttpServletResponse response) {
        User foundUser = getUser(dto.getEmail());
        // 회원가입 안한 상태
        if (foundUser == null) {
            log.info("회원가입이 필요합니다.");
            return NO_ACC;
        }

        if (!encoder.matches(dto.getPassword(), foundUser.getPassword())) {
            log.info("비밀번호가 일치하지 않습니다!");
            return NO_PW;
        }

        // 자동 로그인 처리
        if(dto.isAutoLogin()){
            String sessionId = request.getSession().getId();
            Cookie autoLogin = new Cookie(AUTO_LOGIN_COOKIE, sessionId);
            autoLogin.setPath("/");
            int limitTime = 60 * 60 * 24 * 90;
            autoLogin.setMaxAge(limitTime);
            response.addCookie(autoLogin);
            userMapper.saveAutoLogin(AutoLoginDTO.builder()
                            .sessionId(sessionId)
                            .limitTime(LocalDateTime.now().plusDays(90))
                            .userId(userMapper.findUser(dto.getEmail()).getUserId())
                    .build());
            System.out.println("사용자 이름: " + userMapper.findUser(dto.getEmail()).getUserId());
        }
        

        return SUCCESS;
    }
    

    // 유저 클라이언트에 session에 dto 넣어줌
    public void maintainLoginState(HttpSession session, String email) {
        User user = getUser(email);
        SignInUserResponseDTO dto = SignInUserResponseDTO.builder()
                .userId(user.getUserId())
                .age(user.getAge())
                .email(user.getEmail())
                .sex(user.getSex())
                .nickname(user.getNickname())
                .profileImagePath(user.getProfileImagePath())
                .build();
        session.setAttribute(LOGIN_KEY, dto);
        session.setMaxInactiveInterval(60 * 60);
    }

    // 이메일, 아이디 중복검사
    public boolean duplicate(String type, String keyword) {
        boolean duplicate = userMapper.isDuplicate(type, keyword);
        return duplicate;
    }

    //팀 아이디에 해당하는 유저 리스트 가져오는 메서드
    public List<User> findAllUserByTeamId(int teamId){
        return userMapper.findUseByTeamId(teamId);
    }

    public HashMap<Object, Object> findAllUserByInstrumentId(int equipmentId, Page page) {
        List<Integer> userIdByEquipmentId = personalAbilityMapper.findUserIdByEquipmentId(equipmentId);
        log.info(""+userIdByEquipmentId);
        List<FindUserResponseDTO> users = new ArrayList<>();
        PageMaker pageMaker = new PageMaker(page, userIdByEquipmentId.size());
        for(int i:userIdByEquipmentId){
            User userByUserId = userMapper.findUserByUserId(i);
            log.info("user: {}", userByUserId);
            List<Integer> equipmentList = new ArrayList<>();
            List<PersonalAbility> personalAbilityList = personalAbilityMapper.findPersonalAbilityList(userByUserId.getUserId());
            personalAbilityList.forEach(personalAbility -> {
                equipmentList.add(personalAbility.getEquipmentId());
            });
            if(userByUserId!=null){
                FindUserResponseDTO build = FindUserResponseDTO.builder()
                        .teamId(userByUserId.getTeamId())
                        .email(userByUserId.getEmail())
                        .sex(userByUserId.getSex())
                        .regDate(userByUserId.getRegdate())
                        .age(userByUserId.getAge())
                        .nickname(userByUserId.getNickname())
                        .email(userByUserId.getEmail())
                        .userProfileImagePath(userByUserId.getProfileImagePath())
                        .introduceText(userByUserId.getIntroduceText())
                        .equipmentList(equipmentList)
                        .build();
                users.add(build);
            }
        }
        int fromIndex = (page.getPageNo()-1) * page.getAmount();
        if(userIdByEquipmentId.size()<fromIndex+ page.getAmount()){
            log.warn("악기 리스트보다 가져오는 양이 많습니다");
            // 자료 없는데 요구 할 때
            if(userIdByEquipmentId.size()<fromIndex){
                return null;
            }
            List<FindUserResponseDTO> findUserResponseDTOS = users.subList(fromIndex, userIdByEquipmentId.size());
            HashMap<Object, Object> objectObjectHashMap = new HashMap<>();
            objectObjectHashMap.put("users", findUserResponseDTOS);
            objectObjectHashMap.put("pageInfo",pageMaker);
            return objectObjectHashMap;
        }
        List<FindUserResponseDTO> findUserResponseDTO = users.subList(fromIndex, fromIndex + page.getAmount());
        HashMap<Object, Object> objectObjectHashMap = new HashMap<>();
        objectObjectHashMap.put("users", findUserResponseDTO);
        objectObjectHashMap.put("pageInfo",pageMaker);
        return objectObjectHashMap;
    }

    public void autoLoginClear(HttpServletRequest request, HttpServletResponse response) {
        // 1. 자동로그인 쿠키를 가져온다
        Cookie c = WebUtils.getCookie(request, AUTO_LOGIN_COOKIE);

        // 2. 쿠키를 삭제한다
        // -> 쿠키의 수명을 0초로 설정하여 다시 클라이언트에 전송
        if (c != null) {
            c.setMaxAge(0);
            c.setPath("/");
            response.addCookie(c);

            // 3. 데이터베이스에서도 세션아이디와 만료시간을 제거한다.
            userMapper.saveAutoLogin(
                    AutoLoginDTO.builder()
                            .sessionId("none")
                            .limitTime(LocalDateTime.now())
                            .userId(getCurrentLoginUserId(request.getSession()))
                            .build()
            );
        }

    }

    public boolean changeProfileImagePath(String savedPath, HttpSession session) {
        SignInUserResponseDTO dto= (SignInUserResponseDTO)session.getAttribute(LOGIN_KEY);

        if(dto==null){
            log.info(""+session.getAttribute(LOGIN_KEY));
            log.info("SignInUserResponseDTO가 널입니다 {}", dto);
        }
        return userMapper.changeProfileImagePath(dto.getUserId(), savedPath);
    }

    public void modifyUserIntroduceText(String introduceText, HttpSession session) {
        SignInUserResponseDTO dto = (SignInUserResponseDTO) session.getAttribute(LOGIN_KEY);
        boolean b = userMapper.updateIntroduceText(introduceText, dto.getUserId());
        if(b)log.info("유저 자기소개 수정 성공!!!");

    }
}
