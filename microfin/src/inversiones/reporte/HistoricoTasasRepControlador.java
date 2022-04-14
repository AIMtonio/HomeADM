package inversiones.reporte;


import inversiones.bean.HistoricoTasasInvBean;
import inversiones.servicio.TasasInversionServicio;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

public class HistoricoTasasRepControlador extends SimpleFormController {

	TasasInversionServicio tasasInversionServicio = null;
	String nombreReporte = null;	

 	public HistoricoTasasRepControlador(){
 		setCommandClass(HistoricoTasasInvBean.class);
 		setCommandName("historicoTasasInv");
 	}

 	protected ModelAndView onSubmit(HttpServletRequest request,
 									HttpServletResponse response,
 									Object command,
 									BindException errors) throws Exception {

 		HistoricoTasasInvBean historicoTasasInvBean = (HistoricoTasasInvBean) command;
 		String htmlString = tasasInversionServicio.reporteHistoricoTasas(historicoTasasInvBean, nombreReporte); 		 		
 		return new ModelAndView(getSuccessView(), "reporte", htmlString);
 	}

 	
	public void setTasasInversionServicio(
			TasasInversionServicio tasasInversionServicio) {
		this.tasasInversionServicio = tasasInversionServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	}

}
