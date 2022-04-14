package cuentas.controlador; 

 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.SimpleFormController;

 import cuentas.bean.CuentasFirmaBean;
import cuentas.servicio.CuentasFirmaServicio;

 public class CuentasFirmaControlador extends SimpleFormController {

 	CuentasFirmaServicio cuentasFirmaServicio = null;

 	public CuentasFirmaControlador(){
 		setCommandClass(CuentasFirmaBean.class);
 		setCommandName("cuentasFirmaBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		CuentasFirmaBean cuentasFirmaBean = (CuentasFirmaBean) command;

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;

		String firmantes = request.getParameter("firmantes");
		
 		MensajeTransaccionBean mensaje = null;
 		
 		mensaje = cuentasFirmaServicio.grabaListaFirmantes(tipoTransaccion, cuentasFirmaBean, firmantes);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	public void setCuentasFirmaServicio(CuentasFirmaServicio cuentasFirmaServicio){
                     this.cuentasFirmaServicio = cuentasFirmaServicio;
 	}
 } 
