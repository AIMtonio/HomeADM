package credito.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.SeguroVidaBean;
import credito.servicio.SeguroVidaServicio;

public class SeguroVidaListaControlador extends AbstractCommandController {
	
	SeguroVidaServicio seguroVidaServicio = null;
	
	public SeguroVidaListaControlador() {
			setCommandClass(SeguroVidaBean.class);
			setCommandName("seguroVidaBean");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	seguroVidaServicio.getSeguroVidaDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
	
	SeguroVidaBean seguroVidaBean = (SeguroVidaBean) command;
	List listaSeguroVida =	seguroVidaServicio.lista(tipoLista,seguroVidaBean);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(listaSeguroVida);
			
	return new ModelAndView("credito/seguroVidaListaVista", "listaResultado", listaResultado);
	}

	
	//------------------setter-------------------------
	public void setSeguroVidaServicio(SeguroVidaServicio seguroVidaServicio) {
		this.seguroVidaServicio = seguroVidaServicio;
	}

	

	
}



