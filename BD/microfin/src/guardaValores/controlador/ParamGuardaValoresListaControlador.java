package guardaValores.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import guardaValores.bean.ParamGuardaValoresBean;
import guardaValores.servicio.ParamGuardaValoresServicio;

public class ParamGuardaValoresListaControlador extends	AbstractCommandController {

	ParamGuardaValoresServicio paramGuardaValoresServicio = null;
	
	public ParamGuardaValoresListaControlador() {
		setCommandClass(ParamGuardaValoresBean.class);
		setCommandName("paramGuardaValoresBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		ParamGuardaValoresBean paramGuardaValoresBean = (ParamGuardaValoresBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");

		List<ParamGuardaValoresBean> listaParamGuardaValoresBean = paramGuardaValoresServicio.lista(tipoLista, paramGuardaValoresBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(listaParamGuardaValoresBean);
		
		return new ModelAndView("guardaValores/paramGuardaValoresListaVista", "listaResultado", listaResultado);
	}

	public ParamGuardaValoresServicio getParamGuardaValoresServicio() {
		return paramGuardaValoresServicio;
	}

	public void setParamGuardaValoresServicio(ParamGuardaValoresServicio paramGuardaValoresServicio) {
		this.paramGuardaValoresServicio = paramGuardaValoresServicio;
	}
}
