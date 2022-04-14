package seguimiento.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import seguimiento.bean.SegtoArchivoBean;
import seguimiento.servicio.SegtoArchivoServicio;

public class SegtoArchivoGridControlador extends AbstractCommandController {
	SegtoArchivoServicio segtoArchivoServicio = null;
	public SegtoArchivoGridControlador() {
		setCommandClass(SegtoArchivoBean.class);
		setCommandName("segtoArchivo");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		SegtoArchivoBean segtoArchivoBean = (SegtoArchivoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));

		List aclaraArchivoList = segtoArchivoServicio.listaSegtoArchivos(tipoLista, segtoArchivoBean);
		return new ModelAndView("seguimiento/segtoArchivoGridVista", "segtoArchivo", aclaraArchivoList);
	}

	public SegtoArchivoServicio getSegtoArchivoServicio() {
		return segtoArchivoServicio;
	}

	public void setSegtoArchivoServicio(SegtoArchivoServicio segtoArchivoServicio) {
		this.segtoArchivoServicio = segtoArchivoServicio;
	}
	
}