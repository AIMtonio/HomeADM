package credito.controlador;
     
import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.CreditosBean;
import credito.servicio.ReporteCastigosQuitasCNBVServicio;

public class RepCastigosQuitasCNBVControlador extends SimpleFormController {
	ReporteCastigosQuitasCNBVServicio reporteCastigosQuitasCNBVServicio = null;
	String nombreReporte = null;
	String successView = null;		

 	public RepCastigosQuitasCNBVControlador(){
 		setCommandClass(CreditosBean.class);
 		setCommandName("CarteraCastigosCNBV");
 	}
   
 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		CreditosBean creditosBean = (CreditosBean) command;
 		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		int tipoActualizacion = (request.getParameter("tipoActualizacion")!=null)?
						   Integer.parseInt(request.getParameter("tipoActualizacion")):
							   0;		
						   
		 MensajeTransaccionBean mensaje = null;
			
	return new ModelAndView(getSuccessView(), "mensaje", mensaje);
 		

}


	public String getNombreReporte() {
		return nombreReporte;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

	public ReporteCastigosQuitasCNBVServicio getReporteCastigosQuitasCNBVServicio() {
		return reporteCastigosQuitasCNBVServicio;
	}

	public void setReporteCastigosQuitasCNBVServicio(
			ReporteCastigosQuitasCNBVServicio reporteCastigosQuitasCNBVServicio) {
		this.reporteCastigosQuitasCNBVServicio = reporteCastigosQuitasCNBVServicio;
	}

	


}

