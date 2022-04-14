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


public class VerificacionPreguntasGridControlador extends AbstractCommandController{

	VerificacionPreguntasServicio verificacionPreguntasServicio = null;
	
	public VerificacionPreguntasGridControlador(){
 		setCommandClass(VerificacionPreguntasBean.class);
 		setCommandName("verificacionPreguntasBean");
 	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {
		
		
		VerificacionPreguntasBean verificacionPreguntasBean = (VerificacionPreguntasBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List consultaPreguntas = verificacionPreguntasServicio.lista(tipoLista, verificacionPreguntasBean);
		
		List listaResultado = new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(consultaPreguntas);
		
		return new ModelAndView("cuentas/verificacionPreguntasGridVista", "listaResultado", listaResultado);
	}

	// ================== GETTER & SETTER ============== //
	
	public VerificacionPreguntasServicio getVerificacionPreguntasServicio() {
		return verificacionPreguntasServicio;
	}

	public void setVerificacionPreguntasServicio(
			VerificacionPreguntasServicio verificacionPreguntasServicio) {
		this.verificacionPreguntasServicio = verificacionPreguntasServicio;
	}
}
