package contabilidad.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.PolizaBean;
import contabilidad.servicio.PolizaServicio;;
public class PolizaControlador extends SimpleFormController {

 	PolizaServicio polizaServicio = null;


 	public PolizaControlador(){
 		setCommandClass(PolizaBean.class);
 		setCommandName("polizaBean");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {
 		polizaServicio.getPolizaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

 		PolizaBean polizaBean = (PolizaBean) command;
 		polizaBean.setConcepto(request.getParameter("concepto"));

 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
 								Integer.parseInt(request.getParameter("tipoTransaccion")):
								0;
		String poliza = request.getParameter("detallePoliza");

		String desPlantilla = request.getParameter("desPlantilla");		
 		MensajeTransaccionBean mensaje = null;
 		mensaje = polizaServicio.grabaListaPoliza(tipoTransaccion,desPlantilla, polizaBean, poliza);

 		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 	}
	
	 	
 	public PolizaServicio getPolizaServicio() {
		return polizaServicio;
	}
	
	public void setPolizaServicio(PolizaServicio polizaServicio) {
		this.polizaServicio = polizaServicio;
	}
 } 
