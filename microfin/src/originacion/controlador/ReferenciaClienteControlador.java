package originacion.controlador; 

 import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

 import general.bean.MensajeTransaccionBean;

 import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

 import originacion.bean.ReferenciaClienteBean;
import originacion.servicio.ReferenciaClienteServicio;

 public class ReferenciaClienteControlador extends SimpleFormController {

 	ReferenciaClienteServicio referenciaClienteServicio = null;

 	public ReferenciaClienteControlador(){
 		setCommandClass(ReferenciaClienteBean.class);
 		setCommandName("referenciaClienteBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
		MensajeTransaccionBean mensaje = null;
		ReferenciaClienteBean referenciaClienteBean = (ReferenciaClienteBean) command;
		int tipoTransaccion = (request.getParameter("tipoTransaccion") != null) ? Integer.parseInt(request.getParameter("tipoTransaccion")) : 0;
		referenciaClienteServicio.getReferenciaClienteDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		String detalles = request.getParameter("detalle");
		mensaje=referenciaClienteServicio.grabaDetalle(tipoTransaccion,referenciaClienteBean,detalles);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

 	public void setReferenciaClienteServicio(ReferenciaClienteServicio referenciaClienteServicio){
                     this.referenciaClienteServicio = referenciaClienteServicio;
 	}
 } 
