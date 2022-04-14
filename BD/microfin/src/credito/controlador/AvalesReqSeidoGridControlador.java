package credito.controlador;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.AvalesBean;
import credito.servicio.AvalesServicio;


public class AvalesReqSeidoGridControlador extends  AbstractCommandController{	
	
	AvalesServicio avalesServicio =null;
	public AvalesReqSeidoGridControlador() {
		setCommandClass(AvalesBean.class);
		setCommandName("avalesBean");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
				
		AvalesBean avalesBean = (AvalesBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List creditosAva = avalesServicio.lista(tipoLista, avalesBean);
				
		return new ModelAndView("credito/avalesReqSeidoGridVista", "listaResultado", creditosAva);
	}

	public AvalesServicio getAvalesServicio() {
		return avalesServicio;
	}

	public void setAvalesServicio(AvalesServicio avalesServicio) {
		this.avalesServicio = avalesServicio;
	}
}
