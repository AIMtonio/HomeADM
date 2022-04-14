package tesoreria.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.MotivoCancelacionChequesBean;
import tesoreria.servicio.MotivoCancelacionChequesServicio;

public class MotivoCancelacionChequesGridControlador extends AbstractCommandController{
	
MotivoCancelacionChequesServicio motivoCancelacionChequesServicio = null;
	
	public MotivoCancelacionChequesGridControlador() {
		setCommandClass(MotivoCancelacionChequesBean.class);
		setCommandName("gridmotivoCancelacionCheques");
	}
	
	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {	
		MotivoCancelacionChequesBean motivoCancelacionChequesBean = (MotivoCancelacionChequesBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List listaResultado = motivoCancelacionChequesServicio.listaMotivos(tipoLista, motivoCancelacionChequesBean);

		
		return new ModelAndView("tesoreria/motivosCancelaChequesGridVista", "listaResultado", listaResultado);
	}

	public MotivoCancelacionChequesServicio getMotivoCancelacionChequesServicio() {
		return motivoCancelacionChequesServicio;
	}

	public void setMotivoCancelacionChequesServicio(
			MotivoCancelacionChequesServicio motivoCancelacionChequesServicio) {
		this.motivoCancelacionChequesServicio = motivoCancelacionChequesServicio;
	}


}
