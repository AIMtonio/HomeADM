package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.AutorizaSolicitudGrupoBean;
import originacion.servicio.AutorizaSolicitudGrupoServicio;

public class IntegraSolicitudGrupoGridControlador extends AbstractCommandController{
	
AutorizaSolicitudGrupoServicio autorizaSolicitudGrupoServicio = null;
	
	public IntegraSolicitudGrupoGridControlador() {
		setCommandClass(AutorizaSolicitudGrupoBean.class);
		setCommandName("integraGrupoBean");	
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		
		AutorizaSolicitudGrupoBean integraGrupoBean = (AutorizaSolicitudGrupoBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List gruposList = autorizaSolicitudGrupoServicio.lista(tipoLista, integraGrupoBean);
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(gruposList);
		
		return new ModelAndView("originacion/integraSolicitudGrupoGridVista", "listaResultado", listaResultado);
	}

	//* ============== Getter & Setter =============  //*	
	public AutorizaSolicitudGrupoServicio getAutorizaSolicitudGrupoServicio() {
		return autorizaSolicitudGrupoServicio;
	}

	public void setAutorizaSolicitudGrupoServicio(
			AutorizaSolicitudGrupoServicio autorizaSolicitudGrupoServicio) {
		this.autorizaSolicitudGrupoServicio = autorizaSolicitudGrupoServicio;
	}
	

}
