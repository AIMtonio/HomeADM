package soporte.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import soporte.bean.ParamApoyoEscolarBean;
import soporte.servicio.ParamApoyoEscolarServicio;

public class ParamApoyoEscolarGridListaControlador extends AbstractCommandController{
	
	ParamApoyoEscolarServicio paramApoyoEscolarServicio = null;

	public ParamApoyoEscolarGridListaControlador() {
		setCommandClass(ParamApoyoEscolarBean.class);
		setCommandName("paramApoyoEscolarBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		ParamApoyoEscolarBean paramApoyoEscolarBean = (ParamApoyoEscolarBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listParamApoyoEscolar = paramApoyoEscolarServicio.lista(tipoLista,paramApoyoEscolarBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listParamApoyoEscolar);
		
		return new ModelAndView("soporte/paramApoyoEscolarGridVista", "listaResultado", listaResultado);
	
	}

	public ParamApoyoEscolarServicio getParamApoyoEscolarServicio() {
		return paramApoyoEscolarServicio;
	}

	public void setParamApoyoEscolarServicio(ParamApoyoEscolarServicio paramApoyoEscolarServicio) {
		this.paramApoyoEscolarServicio = paramApoyoEscolarServicio;
	}




}