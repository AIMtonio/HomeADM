package cuentas.controlador; 

 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.SimpleFormController;

 import cuentas.bean.CuentasMayorAhoBean;
 import cuentas.servicio.CuentasMayorAhoServicio;

public class CuentasMayorAhoControlador  extends SimpleFormController {

 	CuentasMayorAhoServicio cuentasMayorAhoServicio = null;

 	public CuentasMayorAhoControlador(){
 		setCommandClass(CuentasMayorAhoBean.class);
 		setCommandName("cuentaMayorAhoBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		CuentasMayorAhoBean cuentasMayorAhoBean = (CuentasMayorAhoBean) command;

 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		mensaje = cuentasMayorAhoServicio.grabaTransaccion(tipoTransaccion, cuentasMayorAhoBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public void setCuentasMayorAhoServicio(
			CuentasMayorAhoServicio cuentasMayorAhoServicio) {
		this.cuentasMayorAhoServicio = cuentasMayorAhoServicio;
	}
 } 

