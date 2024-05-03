package kr.co.dingdong.common;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.lang.Nullable;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import kr.co.dingdong.domain.Member;

public class AdminAuthenticationInterceptor implements HandlerInterceptor{
	
	private final Logger log = LoggerFactory.getLogger(AdminAuthenticationInterceptor.class);
	
//	컨트롤러에 가기 전 요청을 가로채는 메서드
	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

//		세션을 가져온다. 
		HttpSession session = request.getSession();
		
		Member member = (Member)session.getAttribute("member");
		
		log.info("[login user] {}", member);
		

		
		
//		if(session.getAttribute("admin") == null) {
//			System.out.println("admin is null");
////			로그인으로 가세요
//			response.sendRedirect(request.getContextPath() + "/adminLogin");
//			
////			세션에 어드민 없으면(로그인 되어있지 않으면) 지나가지 마세요~ 
//			return false;
//		}
		
		if(member == null || member.getGrade() == 0) {
			log.info("not admin");
//			response.sendRedirect(request.getContextPath() + "/adminLogin");
			
//			스크립트 출력 
			PrintWriter w = response.getWriter();
			
//			한글 깨짐 -> utf-8 설정 
			response.setCharacterEncoding("utf-8");
			response.setContentType("text/html; charset=UTF-8");
			w.println("<script>");
			w.println("alert('올바른 접근이 아닙니다.')");
			w.println("history.back();");
			w.println("</script>");
			
			return false;
		}
		
//		지나가도 돼용~ 
		return true;
	}
	
	
	
//	예외가 발생하지 않으면 호출되는 메서드 (예외가 터지지 않았을 때만 실행됨) 
	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler,
			@Nullable ModelAndView modelAndView) throws Exception {
	}

	
	
//	예외 발생 여부에 상관 없이 Controller가 작업이 끝나면 호출되는 메서드 (예외가 터지든 말든 실행됨) 
	@Override
	public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex)
			throws Exception {
		HandlerInterceptor.super.afterCompletion(request, response, handler, ex);
	}

}
