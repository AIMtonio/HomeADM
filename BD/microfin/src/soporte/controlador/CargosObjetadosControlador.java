package soporte.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.CargosObjArchivosBean;
import soporte.bean.ResultadoCargaArchivosObjetadosBean;
import soporte.servicio.CargosObjArchivosServicio;
import soporte.servicio.CargosServicio;

public class CargosObjetadosControlador extends SimpleFormController {
	CargosObjArchivosServicio cargosObjArchivosServicio = null;
	
	public CargosObjetadosControlador(){
		setCommandClass(CargosObjArchivosBean.class);
		setCommandName("cargosBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {
		CargosObjArchivosBean cargosObjArchivosBean = (CargosObjArchivosBean)command;
		ResultadoCargaArchivosObjetadosBean mensaje = null;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		mensaje = cargosObjArchivosServicio.grabaTransaccion(tipoTransaccion,cargosObjArchivosBean );
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public CargosObjArchivosServicio getCargosObjArchivosServicio() {
		return cargosObjArchivosServicio;
	}

	public void setCargosObjArchivosServicio(
			CargosObjArchivosServicio cargosObjArchivosServicio) {
		this.cargosObjArchivosServicio = cargosObjArchivosServicio;
	}


}
