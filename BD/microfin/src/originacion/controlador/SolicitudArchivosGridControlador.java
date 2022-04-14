
package originacion.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;


import originacion.bean.SolicitudesArchivoBean;
import originacion.servicio.SolicitudArchivoServicio;

public class SolicitudArchivosGridControlador extends AbstractCommandController{
	
	SolicitudArchivoServicio solicitudArchivoServicio = null;
	
public SolicitudArchivosGridControlador() {
	setCommandClass(SolicitudesArchivoBean.class);
	setCommandName("archivoGrid");
}
	
protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {	
	
	SolicitudesArchivoBean solicitudesArchivoBean = (SolicitudesArchivoBean) command;
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	
	List credArchivoList = solicitudArchivoServicio.listaArchivosSolCredito(tipoLista, solicitudesArchivoBean);

	return new ModelAndView("originacion/solicitudArchivoGridVista", "listaResultado", credArchivoList);
}

public SolicitudArchivoServicio getSolicitudArchivoServicio() {
	return solicitudArchivoServicio;
}

public void setSolicitudArchivoServicio(
		SolicitudArchivoServicio solicitudArchivoServicio) {
	this.solicitudArchivoServicio = solicitudArchivoServicio;
}




}
