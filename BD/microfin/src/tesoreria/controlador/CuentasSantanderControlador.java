package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import tesoreria.bean.CuentasSantanderBean;
import tesoreria.servicio.CuentasSantanderServicio;

public class CuentasSantanderControlador extends SimpleFormController {
	
	CuentasSantanderServicio cuentasSantanderServicio =null;

	
	public CuentasSantanderControlador(){
 		setCommandClass(CuentasSantanderBean.class);
 		setCommandName("cuentasSantander");
 	}	
	
	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

		cuentasSantanderServicio.getCuentasSantanderDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		CuentasSantanderBean cuentasSantanderBean = (CuentasSantanderBean) command;
		
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		MensajeTransaccionBean mensaje = null;
		mensaje = cuentasSantanderServicio.grabaTransaccion(tipoTransaccion, cuentasSantanderBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}
	
	public CuentasSantanderServicio getCuentasSantanderServicio() {
		return cuentasSantanderServicio;
	}

	public void setCuentasSantanderServicio(
			CuentasSantanderServicio cuentasSantanderServicio) {
		this.cuentasSantanderServicio = cuentasSantanderServicio;
	}
	
	
	

}
