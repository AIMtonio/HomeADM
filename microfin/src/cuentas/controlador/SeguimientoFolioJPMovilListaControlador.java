package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.AltaTiposSoporteBean;
import cuentas.bean.VerificacionPreguntasBean;
import cuentas.servicio.VerificacionPreguntasServicio;

public class SeguimientoFolioJPMovilListaControlador extends AbstractCommandController{
	
	VerificacionPreguntasServicio verificacionPreguntasServicio = null;
	
	public SeguimientoFolioJPMovilListaControlador() {
		setCommandClass(VerificacionPreguntasBean.class);
		setCommandName("verificacionPreguntasBean");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		
		int tipoLista =(request.getParameter("tipoLista")!=null)?
		Integer.parseInt(request.getParameter("tipoLista")): 0;
		String controlID = request.getParameter("controlID");
		VerificacionPreguntasBean verificacionPreguntasBean = (VerificacionPreguntasBean)command;
		List<VerificacionPreguntasBean>listaFolios = verificacionPreguntasServicio.listaFolio(tipoLista, verificacionPreguntasBean);
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		
		listaResultado.add(controlID);
		listaResultado.add(listaFolios);
		
		return new ModelAndView("cuentas/seguimientoFolioJPMovilListaVista", "listaResultado",listaResultado);
	}

	public VerificacionPreguntasServicio getVerificacionPreguntasServicio() {
		return verificacionPreguntasServicio;
	}

	public void setVerificacionPreguntasServicio(
			VerificacionPreguntasServicio verificacionPreguntasServicio) {
		this.verificacionPreguntasServicio = verificacionPreguntasServicio;
	}
	
}
