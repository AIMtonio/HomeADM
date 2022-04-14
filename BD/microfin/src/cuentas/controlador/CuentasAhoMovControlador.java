package cuentas.controlador; 

 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.SimpleFormController;

 import cuentas.bean.CuentasAhoMovBean;
 import cuentas.servicio.CuentasAhoMovServicio;

 public class CuentasAhoMovControlador extends SimpleFormController {

 	CuentasAhoMovServicio cuentasAhoMovServicio = null;

 	public CuentasAhoMovControlador(){
 		setCommandClass(CuentasAhoMovBean.class);
 		setCommandName("cuentasAhoMovBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		CuentasAhoMovBean cuentasAhoMovBean = (CuentasAhoMovBean) command;

 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		//mensaje = cuentasAhoMovServicio.grabaTransaccion(tipoTransaccion, cuentasAhoMovBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	public void setCuentasAhoMovServicio(CuentasAhoMovServicio cuentasAhoMovServicio){
                     this.cuentasAhoMovServicio = cuentasAhoMovServicio;
 	}
 } 
