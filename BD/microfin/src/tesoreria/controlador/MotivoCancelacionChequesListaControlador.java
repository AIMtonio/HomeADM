package tesoreria.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import tesoreria.bean.MotivoCancelacionChequesBean;
import tesoreria.servicio.MotivoCancelacionChequesServicio;


public class MotivoCancelacionChequesListaControlador extends AbstractCommandController{
	
MotivoCancelacionChequesServicio motivoCancelacionChequesServicio = null;
	
	public MotivoCancelacionChequesListaControlador() {
		setCommandClass(MotivoCancelacionChequesBean.class);		
		setCommandName("motivosCancelacion");
		
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {
		
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		
		MotivoCancelacionChequesBean motivoCancelChequeBean = (MotivoCancelacionChequesBean) command;		
		List motivosLis =	motivoCancelacionChequesServicio.listaMotivos(tipoLista, motivoCancelChequeBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(motivosLis);
		
		return new ModelAndView("tesoreria/motivosCancelacionListaVista", "listaResultado",listaResultado);
	}

	public MotivoCancelacionChequesServicio getMotivoCancelacionChequesServicio() {
		return motivoCancelacionChequesServicio;
	}

	public void setMotivoCancelacionChequesServicio(
			MotivoCancelacionChequesServicio motivoCancelacionChequesServicio) {
		this.motivoCancelacionChequesServicio = motivoCancelacionChequesServicio;
	}


}
