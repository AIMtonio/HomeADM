package cliente.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cliente.bean.ApoyoEscolarSolBean;
import cliente.servicio.ApoyoEscolarSolServicio;

public class ApoyoEscolarSolGridListaControlador extends AbstractCommandController{
	
	ApoyoEscolarSolServicio apoyoEscolarSolServicio = null;

	public ApoyoEscolarSolGridListaControlador() {
		setCommandClass(ApoyoEscolarSolBean.class);
		setCommandName("apoyoEscolarSolBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
							  HttpServletResponse response,
							  Object command,
							  BindException errors) throws Exception {
	
		ApoyoEscolarSolBean apoyoEscolarSolBean = (ApoyoEscolarSolBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listSolicitudes = apoyoEscolarSolServicio.lista(tipoLista,apoyoEscolarSolBean);
	
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(listSolicitudes);
		
		return new ModelAndView("cliente/apoyoEscolarSolGridLista", "listaResultado", listaResultado);
	
	}

	public ApoyoEscolarSolServicio getApoyoEscolarSolServicio() {
		return apoyoEscolarSolServicio;
	}

	public void setApoyoEscolarSolServicio(
			ApoyoEscolarSolServicio apoyoEscolarSolServicio) {
		this.apoyoEscolarSolServicio = apoyoEscolarSolServicio;
	}

}