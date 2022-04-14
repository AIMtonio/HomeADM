package regulatorios.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import regulatorios.bean.ParamRegulatoriosBean;
import regulatorios.servicio.ParamRegulatoriosServicio;

public class ParamRegulatoriosControlador extends SimpleFormController {
	
	ParamRegulatoriosServicio paramRegulatoriosServicio = null;
	
	String successView = null;		

 	public ParamRegulatoriosControlador(){
 		setCommandClass(ParamRegulatoriosBean.class);
 		setCommandName("paramRegulatoriosBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
 		
 		paramRegulatoriosServicio.getParamRegulatoriosDAO().getParametrosAuditoriaBean().setNombrePrograma(
				request.getRequestURI().toString()
				);

 		ParamRegulatoriosBean paramRegulatoriosBean = (ParamRegulatoriosBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
	
		mensaje = paramRegulatoriosServicio.grabaTransaccion(tipoTransaccion, paramRegulatoriosBean );
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);		
 		
 	}

	public ParamRegulatoriosServicio getParamRegulatoriosServicio() {
		return paramRegulatoriosServicio;
	}

	public void setParamRegulatoriosServicio(
			ParamRegulatoriosServicio paramRegulatoriosServicio) {
		this.paramRegulatoriosServicio = paramRegulatoriosServicio;
	}


	
}
