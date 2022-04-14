package activos.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import activos.bean.CargaMasivaActivosBean;
import activos.servicio.CargaArchivoMasivoActivoServicio;

public class CargaArchivoMasivoActivoControlador extends SimpleFormController{
	CargaArchivoMasivoActivoServicio cargaArchivoMasivoActivoServicio = null;

	public CargaArchivoMasivoActivoControlador() {
		setCommandClass(CargaMasivaActivosBean.class);
		setCommandName("cargaMasivaActivosBean");
	}
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
			
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?		
				Integer.parseInt(request.getParameter("tipoTransaccion")):0;
	
		cargaArchivoMasivoActivoServicio.getCargaArchivoMasivoActivoDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

		CargaMasivaActivosBean cargaMasivaActivosBean = (CargaMasivaActivosBean) command;

		MensajeTransaccionBean mensaje = null;
		mensaje = cargaArchivoMasivoActivoServicio.grabaTransaccion(tipoTransaccion,cargaMasivaActivosBean);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	/* Declaracion de getter y setters */
	public CargaArchivoMasivoActivoServicio getCargaArchivoMasivoActivoServicio() {
		return cargaArchivoMasivoActivoServicio;
	}
	public void setCargaArchivoMasivoActivoServicio(
			CargaArchivoMasivoActivoServicio cargaArchivoMasivoActivoServicio) {
		this.cargaArchivoMasivoActivoServicio = cargaArchivoMasivoActivoServicio;
	}
}
