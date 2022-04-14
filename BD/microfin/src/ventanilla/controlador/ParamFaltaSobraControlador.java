package ventanilla.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;


import ventanilla.bean.ParamFaltaSobraBean;
import ventanilla.servicio.ParamFaltaSobraServicio;

public class ParamFaltaSobraControlador  extends SimpleFormController{

	ParamFaltaSobraServicio paramFaltaSobraServicio =null;

	public ParamFaltaSobraControlador(){
 		setCommandClass(ParamFaltaSobraBean.class);
 		setCommandName("paramFaltaSobraBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		ParamFaltaSobraBean  parametros = (ParamFaltaSobraBean) command; 		
 		paramFaltaSobraServicio.getParamFaltaSobraDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 	
 		MensajeTransaccionBean mensaje = null;
 		mensaje = paramFaltaSobraServicio.grabaTransaccion(tipoTransaccion,parametros);
 		
 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}		
 	
	// ----------setter-----------
	public void setParamFaltaSobraServicio(
			ParamFaltaSobraServicio paramFaltaSobraServicio) {
		this.paramFaltaSobraServicio = paramFaltaSobraServicio;
	}
	
	
	
}