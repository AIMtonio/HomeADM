package contabilidad.reporte;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.CuentasContablesBean;
import contabilidad.servicio.CuentasContablesServicio;

public class MaestroCuentasRepControlador extends SimpleFormController {
	
	CuentasContablesServicio cuentasContablesServicio = null;	
	String nombreReporte = null;
		 
		
 	public MaestroCuentasRepControlador(){
 		setCommandClass(CuentasContablesBean.class);
 		setCommandName("cuentasContablesBean");
 	}


 	protected ModelAndView onSubmit(HttpServletRequest request,
				HttpServletResponse response,
				Object command,
				BindException errors) throws Exception {

 		CuentasContablesBean reporteCuentasBean = (CuentasContablesBean) command;
		String htmlString = cuentasContablesServicio.reporteMaestroContable(reporteCuentasBean, 
																			nombreReporte); 		 		
		
		return new ModelAndView(getSuccessView(), "reporte", htmlString);
 	}
 	 	
	public void setCuentasContablesServicio(
			CuentasContablesServicio cuentasContablesServicio) {
		this.cuentasContablesServicio = cuentasContablesServicio;
	}

	public void setNombreReporte(String nombreReporte) {
		this.nombreReporte = nombreReporte;
	} 	
 	
}
