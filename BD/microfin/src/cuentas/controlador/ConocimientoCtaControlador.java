package cuentas.controlador; 

 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.SimpleFormController;

 import cuentas.bean.ConocimientoCtaBean;
 import cuentas.servicio.ConocimientoCtaServicio;

 public class ConocimientoCtaControlador extends SimpleFormController {

 	ConocimientoCtaServicio conocimientoCtaServicio = null;

 	public ConocimientoCtaControlador(){
 		setCommandClass(ConocimientoCtaBean.class);
 		setCommandName("conocimientoCtaBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		ConocimientoCtaBean conocimientoCtaBean = (ConocimientoCtaBean) command;

 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 		MensajeTransaccionBean mensaje = null;
 		mensaje = conocimientoCtaServicio.grabaTransaccion(tipoTransaccion, conocimientoCtaBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	public void setConocimientoCtaServicio(ConocimientoCtaServicio conocimientoCtaServicio){
                     this.conocimientoCtaServicio = conocimientoCtaServicio;
 	}
 } 
