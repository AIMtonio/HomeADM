package arrendamiento.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import general.bean.MensajeTransaccionBean;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import arrendamiento.bean.DepositoRefereArrendaBean;
import arrendamiento.servicio.DepositoRefereArrendaServicio;


 public class AplicaDepositoArrendaControlador extends SimpleFormController {

 	DepositoRefereArrendaServicio depositoRefereArrendaServicio = null;


 	public AplicaDepositoArrendaControlador(){
 		setCommandClass(DepositoRefereArrendaBean.class);
 		setCommandName("depositoRefereArrendaBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		depositoRefereArrendaServicio.getDepositoRefereArrendaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
 		DepositoRefereArrendaBean depositoRefereArrendaBean = (DepositoRefereArrendaBean) command;

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
 		
 		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
 								Integer.parseInt(request.getParameter("tipoActualizacion")):
 								0;
 									
 		MensajeTransaccionBean mensaje = null;
 		mensaje = depositoRefereArrendaServicio.grabaTransaccion(tipoTransaccion, tipoActualizacion, depositoRefereArrendaBean);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}

	public DepositoRefereArrendaServicio getDepositoRefereArrendaServicio() {
		return depositoRefereArrendaServicio;
	}

	public void setDepositoRefereArrendaServicio(
			DepositoRefereArrendaServicio depositoRefereArrendaServicio) {
		this.depositoRefereArrendaServicio = depositoRefereArrendaServicio;
	}
 	
 } 
