package contabilidad.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import contabilidad.servicio.PolizaArchivosServicio;
import contabilidad.bean.PolizaArchivosBean;

public class PolizaArchivosGridControlador  extends AbstractCommandController {
	PolizaArchivosServicio polizaArchivosServicio=null;
	
	public PolizaArchivosGridControlador() {
		setCommandClass(PolizaArchivosBean.class);
		setCommandName("polizaArchivosBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		PolizaArchivosBean polizaArchivosBean = (PolizaArchivosBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List listaResultado = polizaArchivosServicio.lista(tipoLista, polizaArchivosBean);
		

		return new ModelAndView("contabilidad/polizaArchivosGridVista", "listaResultado", listaResultado);
	}

	//---------------------setter-----------------
	public void setPolizaArchivosServicio(
			PolizaArchivosServicio polizaArchivosServicio) {
		this.polizaArchivosServicio = polizaArchivosServicio;
	}


}
