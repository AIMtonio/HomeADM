package nomina.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import nomina.bean.CalendarioIngresosBean;
import nomina.servicio.CalendarioIngresosServicio;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

public class CalendarioIngresosGridControlador extends AbstractCommandController {
	CalendarioIngresosServicio calendarioIngresosServicio = null;
	public CalendarioIngresosGridControlador(){
		setCommandClass(CalendarioIngresosBean.class);
		setCommandName("calendarioIngresos");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		CalendarioIngresosBean calendarioIngresosBean = (CalendarioIngresosBean) command;
		int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		
		List calendarioIngresos = calendarioIngresosServicio.lista(tipoLista, calendarioIngresosBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(calendarioIngresos);
				
		return new ModelAndView("nomina/calendarioIngresosGrid",  "listaResultado", listaResultado);
	}

	public CalendarioIngresosServicio getCalendarioIngresosServicio() {
		return calendarioIngresosServicio;
	}

	public void setCalendarioIngresosServicio(
			CalendarioIngresosServicio calendarioIngresosServicio) {
		this.calendarioIngresosServicio = calendarioIngresosServicio;
	}
	
}
