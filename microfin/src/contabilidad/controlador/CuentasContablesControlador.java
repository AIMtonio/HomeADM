package contabilidad.controlador;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.CuentasContablesBean;
import contabilidad.servicio.CuentasContablesServicio;

public class CuentasContablesControlador extends SimpleFormController {

 	CuentasContablesServicio cuentasContablesServicio = null;

 	public CuentasContablesControlador(){
 		setCommandClass(CuentasContablesBean.class);
 		setCommandName("cuentasContablesBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		CuentasContablesBean cuentasContablesBean = (CuentasContablesBean) command;
 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		mensaje = cuentasContablesServicio.grabaTransaccion(tipoTransaccion, cuentasContablesBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public void setCuentasContablesServicio(
			CuentasContablesServicio cuentasContablesServicio) {
		this.cuentasContablesServicio = cuentasContablesServicio;
	}

 	
 } 
