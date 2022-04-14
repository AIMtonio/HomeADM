package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.ActasComiteCreditoBean;

public class ActasComiteCreditoControlador extends SimpleFormController{
	
	public ActasComiteCreditoControlador() {
		setCommandClass(ActasComiteCreditoBean.class);
		setCommandName("actasComite");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,HttpServletResponse response,Object command,BindException errors) throws Exception {
		//actasComiteCreditoServicio.getCastigosCarteraDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		//int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?Integer.parseInt(request.getParameter("tipoTransaccion")):0;			
		
		//ActasComiteCreditoBean ActasCreditoBean = (ActasComiteCreditoBean) command;	
		MensajeTransaccionBean mensaje = null;
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	
}
