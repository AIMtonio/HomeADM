package cuentas.controlador; 

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import cuentas.bean.TasasAhorroBean;
import cuentas.servicio.TasasAhorroServicio;


public class TasasAhorroControlador extends SimpleFormController {

	 	TasasAhorroServicio tasasAhorroServicio = null;

	 	public TasasAhorroControlador(){
	 		setCommandClass(TasasAhorroBean.class);
	 		setCommandName("tasasAhorroBean");
	 	}

	 	protected ModelAndView onSubmit(HttpServletRequest request,
	 									HttpServletResponse response,
	 									Object command,
	 									BindException errors) throws Exception {

	 		TasasAhorroBean tasasAhorroBean = (TasasAhorroBean) command;

	 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
	 		MensajeTransaccionBean mensaje = null;
	 		mensaje = tasasAhorroServicio.grabaTransaccion(tipoTransaccion, tasasAhorroBean);

	 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	 	}

	 	public void setTasasAhorroServicio(TasasAhorroServicio tasasAhorroServicio){
	                     this.tasasAhorroServicio = tasasAhorroServicio;
	 	}
	 } 
