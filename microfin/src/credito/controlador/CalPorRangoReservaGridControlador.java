package credito.controlador;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.CalPorRangoBean;
import credito.servicio.CalPorRangoServicio;

public class CalPorRangoReservaGridControlador extends AbstractCommandController{
	
	CalPorRangoServicio calPorRangoServicio = null;

	public CalPorRangoReservaGridControlador() {
		setCommandClass(CalPorRangoBean.class);
		setCommandName("calPorRangoBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		CalPorRangoBean calPorRangoBean = (CalPorRangoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List califReservaList = calPorRangoServicio.lista(tipoLista, calPorRangoBean);
		
		return new ModelAndView("credito/califRangoReservaGridVista", "califReserva", califReservaList);
	}

	public CalPorRangoServicio getCalPorRangoServicio() {
		return calPorRangoServicio;
	}

	public void setCalPorRangoServicio(CalPorRangoServicio calPorRangoServicio) {
		this.calPorRangoServicio = calPorRangoServicio;
	}

}
