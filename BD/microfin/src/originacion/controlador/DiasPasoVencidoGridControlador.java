package originacion.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.DiasPasoVencidoBean;
import originacion.servicio.DiasPasoVencidoServicio;

public class DiasPasoVencidoGridControlador extends AbstractCommandController{
	DiasPasoVencidoServicio	diasPasoVencidoServicio=null;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	
	public DiasPasoVencidoGridControlador() {
		setCommandClass(DiasPasoVencidoBean.class);
		setCommandName("diasPasoVencido");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		DiasPasoVencidoBean diasPasoVencidoBean = (DiasPasoVencidoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = diasPasoVencidoServicio.lista(tipoLista, diasPasoVencidoBean);

		return new ModelAndView("originacion/diasPasoVencidoGridVista", "listaResultado", listaResultado);
	}
//------------------setter-------------
	public void setDiasPasoVencidoServicio(
			DiasPasoVencidoServicio diasPasoVencidoServicio) {
		this.diasPasoVencidoServicio = diasPasoVencidoServicio;
	}
	
	
}
