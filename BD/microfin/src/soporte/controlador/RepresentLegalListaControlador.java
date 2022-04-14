package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;

public class RepresentLegalListaControlador extends AbstractCommandController{
	ParametrosSisServicio parametrosSisServicio=null;
	public RepresentLegalListaControlador(){
		setCommandClass(ParametrosSisBean.class);
		setCommandName("parametrosLis");
	}
	
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response,
									Object command,BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		ParametrosSisBean parametrosBean = (ParametrosSisBean) command;
		
		List representList =	parametrosSisServicio.lista(tipoLista, parametrosBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(representList);

		return new ModelAndView("soporte/representLegalListaVista", "listaResultado", listaResultado);
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}
