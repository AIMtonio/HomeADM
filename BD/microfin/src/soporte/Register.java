package soporte;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.octo.captcha.service.CaptchaServiceException;

public class Register extends HttpServlet {

 public Register() {
  super();
 }

 public void destroy() {
  super.destroy(); // Just puts "destroy" string in log
  // Put your code here
 }

 public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

  response.setContentType("text/html");
  PrintWriter out = response.getWriter();

  //out.println("<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">");
 // out.println("<HTML>");
//  out.println(" <HEAD><TITLE>A Servlet</TITLE></HEAD>");
 // out.println(" <BODY>");
//  out.print(" This is ");
////  out.print(this.getClass());
 // out.println(", using the POST method");
//  out.println("<br />");

  Boolean isResponseCorrect = Boolean.FALSE;
  // remenber that we need an id to validate!
  String captchaId = request.getSession().getId();
  // retrieve the response
  String response2 = request.getParameter("j_captcha_response");
  // Call the Service method
  try {
   isResponseCorrect = CaptchaServiceSingleton.getInstance().validateResponseForID(captchaId,response2);
   if (isResponseCorrect)
   //out.println(" Your Code is matched with captcha..." + captchaId);
   out.print("true");
   else
//    out.println(" Your Code is not matched with captcha..." + captchaId);
   out.print("false");

  } catch (CaptchaServiceException e) {
   // should not happen, may be thrown if the id is not valid
   out.println("false");
  }

 // out.println("<br />");
 // out.println(" </BODY>");
 // out.println("</HTML>");
  out.flush();
  out.close();
 }

 public void init() throws ServletException {
 }
}