package cuentas.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import cuentas.bean.VerificacionPreguntasBean;
import cuentas.servicio.VerificacionPreguntasServicio;

public class SeguimientoFolioJPMovilGridControlador extends AbstractCommandController{
	
VerificacionPreguntasServicio verificacionPreguntasServicio = null;
	
	public SeguimientoFolioJPMovilGridControlador(){
 		setCommandClass(VerificacionPreguntasBean.class);
 		setCommandName("verificacionPreguntasBean");
 	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		
		VerificacionPreguntasBean verificacionPreguntasBean = (VerificacionPreguntasBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List listaComentarios = verificacionPreguntasServicio.listaFolio(tipoLista, verificacionPreguntasBean);
		
		                                 
		return new ModelAndView("cuentas/seguimientoFolioJPMovilGridVista", "listaResultado", listaComentarios);
	}

	public VerificacionPreguntasServicio getVerificacionPreguntasServicio() {
		return verificacionPreguntasServicio;
	}

	public void setVerificacionPreguntasServicio(
			VerificacionPreguntasServicio verificacionPreguntasServicio) {
		this.verificacionPreguntasServicio = verificacionPreguntasServicio;
	}
	
}
