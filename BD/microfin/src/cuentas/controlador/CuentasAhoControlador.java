package cuentas.controlador; 

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cuentas.bean.CuentasAhoBean;
import cuentas.servicio.CuentasAhoServicio;;


 public class CuentasAhoControlador extends SimpleFormController {

 	CuentasAhoServicio cuentasAhoServicio = null;


 	public CuentasAhoControlador(){
 		setCommandClass(CuentasAhoBean.class);
 		setCommandName("cuentasAhoBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		CuentasAhoBean cuentasAhoBean = (CuentasAhoBean) command;

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 		
 		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
 								Integer.parseInt(request.getParameter("tipoActualizacion")):
 								0;
 									
 		MensajeTransaccionBean mensaje = null;
 		mensaje = cuentasAhoServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, cuentasAhoBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio){
                     this.cuentasAhoServicio = cuentasAhoServicio;
 	}
 } 
