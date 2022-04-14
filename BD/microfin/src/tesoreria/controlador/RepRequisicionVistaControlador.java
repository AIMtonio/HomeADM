
package tesoreria.controlador;



import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import tesoreria.servicio.ReqGastosSucServicio;
import tesoreria.bean.FacturaprovBean;
 
 
public class RepRequisicionVistaControlador extends SimpleFormController {
	ReqGastosSucServicio reqGastosSucServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public RepRequisicionVistaControlador(){
 		setCommandClass(FacturaprovBean.class);
 		setCommandName("requisicionBean");
 	}
    
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 			
						   
		MensajeTransaccionBean mensaje = null;
		mensaje = new MensajeTransaccionBean();
		mensaje.setNumero(0);

		mensaje.setDescripcion("Reporte de Requisicion de gastos");
								
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}


	public void setReqGastosSucServicio(ReqGastosSucServicio reqGastosSucServicio) {
		this.reqGastosSucServicio = reqGastosSucServicio;
	}

	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}

