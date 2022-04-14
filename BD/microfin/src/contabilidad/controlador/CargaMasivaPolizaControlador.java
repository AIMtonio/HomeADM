package contabilidad.controlador;

import general.bean.MensajeTransaccionArchivoBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import contabilidad.bean.PolizaArchivosBean;
import contabilidad.servicio.PolizaArchivosServicio;

public class CargaMasivaPolizaControlador extends SimpleFormController{
	
	PolizaArchivosServicio polizaArchivosServicio = null;

	public CargaMasivaPolizaControlador() {
		setCommandClass(PolizaArchivosBean.class);
		setCommandName("polizaArchivosBean");
}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {	
			polizaArchivosServicio.getPolizaArchivosDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
				 String directorio ="";
		PolizaArchivosBean polizaArchivosBean = (PolizaArchivosBean) command;
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = polizaArchivosServicio.grabaTransaccion(tipoTransaccion, polizaArchivosBean, directorio);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* Declaracion de getter y setters */
	public PolizaArchivosServicio getPolizaArchivosServicio() {
		return polizaArchivosServicio;
	}
	public void setPolizaArchivosServicio(
			PolizaArchivosServicio polizaArchivosServicio) {
		this.polizaArchivosServicio = polizaArchivosServicio;
	}

}
