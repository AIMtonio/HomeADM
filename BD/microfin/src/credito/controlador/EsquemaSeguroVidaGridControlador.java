package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.EsquemaSeguroVidaBean;
import credito.servicio.EsquemaSeguroVidaServicio;


public class EsquemaSeguroVidaGridControlador extends AbstractCommandController{
		
	EsquemaSeguroVidaServicio esquemaSeguroVidaServicio = null;
	public EsquemaSeguroVidaGridControlador() {
		setCommandClass(EsquemaSeguroVidaBean.class);
		setCommandName("autorizaGrid");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {	
		
		EsquemaSeguroVidaBean bean = (EsquemaSeguroVidaBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listEsquemas = esquemaSeguroVidaServicio.lista(bean,tipoLista);

		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listEsquemas);
		
		return new ModelAndView("credito/esquemaSeguroVidaGridVista", "listaResultado", listaResultado);
	}

	

	public void setEsquemaSeguroVidaServicio(
			EsquemaSeguroVidaServicio esquemaSeguroVidaServicio) {
		this.esquemaSeguroVidaServicio = esquemaSeguroVidaServicio;
	}

	
}
