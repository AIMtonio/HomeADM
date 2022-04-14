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

public class ParamGuardaValoresGridControlador extends AbstractCommandController {

	ParamGuardaValoresServicio paramGuardaValoresServicio = null;

	public ParamGuardaValoresGridControlador() {
		setCommandClass(ParamGuardaValoresBean.class);
		setCommandName("paramGuardaValoresBean");
	}

	@Override
	protected ModelAndView handle(HttpServletRequest request,HttpServletResponse response, Object command, BindException errors) throws Exception {
		// TODO Auto-generated method stub
		
		ParamGuardaValoresBean paramGuardaValoresBean = (ParamGuardaValoresBean) command;		
		int tipoLista = (request.getParameter("tipoLista")!=null) ? Integer.parseInt(request.getParameter("tipoLista")) : 0;
		
		List<ParamGuardaValoresBean> lista  = paramGuardaValoresServicio.lista(tipoLista, paramGuardaValoresBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(lista);

		return new ModelAndView("guardaValores/paramGuardaValoresGridVista", "listaResultado", listaResultado);
	}

	public ParamGuardaValoresServicio getParamGuardaValoresServicio() {
		return paramGuardaValoresServicio;
	}

	public void setParamGuardaValoresServicio(ParamGuardaValoresServicio paramGuardaValoresServicio) {
		this.paramGuardaValoresServicio = paramGuardaValoresServicio;
	}
	
}
