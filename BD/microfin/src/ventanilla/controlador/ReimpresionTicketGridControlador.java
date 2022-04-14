package ventanilla.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import ventanilla.bean.ReimpresionTicketBean;
import ventanilla.servicio.ReimpresionTicketServicio;

public class ReimpresionTicketGridControlador extends AbstractCommandController{
		ReimpresionTicketServicio reimpresionTicketServicio=null;
		
		public ReimpresionTicketGridControlador(){
			setCommandClass(ReimpresionTicketBean.class);
			setCommandName("ReimpresionBean");
		}
		
		protected ModelAndView handle(HttpServletRequest request, HttpServletResponse response, 
										Object command,BindException errors)throws Exception{
			
			ReimpresionTicketBean reimpresionTicketBean = (ReimpresionTicketBean) command;
			int tipoConsulta = Integer.parseInt(request.getParameter("tipoConsulta"));
			
			List reimpresionTicket = reimpresionTicketServicio.lista(tipoConsulta,reimpresionTicketBean);				
	        
			return new ModelAndView("ventanilla/reimpresionTicketGrid","reimpresionTicket",reimpresionTicket);
		}
		
		public ReimpresionTicketServicio getReimpresionTicketServicio() {
			return reimpresionTicketServicio;
		}
		public void setReimpresionTicketServicio(
				ReimpresionTicketServicio reimpresionTicketServicio) {
			this.reimpresionTicketServicio = reimpresionTicketServicio;
		}
		
}
