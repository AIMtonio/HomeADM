package cliente.controlador; 

 import javax.servlet.http.HttpServletRequest;
 import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
 import org.springframework.web.servlet.ModelAndView;
 import org.springframework.web.servlet.mvc.SimpleFormController;

 import cliente.bean.EscrituraPubBean;
import cliente.servicio.EscrituraPubServicio;

 public class EscrituraPubControlador extends SimpleFormController {

 	EscrituraPubServicio escrituraPubServicio = null;

 	public EscrituraPubControlador(){
 		setCommandClass(EscrituraPubBean.class);
 		setCommandName("escrituraPubBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		EscrituraPubBean escrituraPubBean = (EscrituraPubBean) command;
 		escrituraPubServicio.getEscrituraPubDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

 		
 		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
 			
 		MensajeTransaccionBean mensaje = null;
 		mensaje = escrituraPubServicio.grabaTransaccion(tipoTransaccion, escrituraPubBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	public void setEscrituraPubServicio(EscrituraPubServicio escrituraPubServicio){
                     this.escrituraPubServicio = escrituraPubServicio;
 	}
 } 
