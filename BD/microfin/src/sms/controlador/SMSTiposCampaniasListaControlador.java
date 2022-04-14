package sms.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import sms.bean.SMSTiposCampaniasBean;
import sms.servicio.SMSTiposCampaniasServicio;



public class SMSTiposCampaniasListaControlador extends AbstractCommandController {
	
	SMSTiposCampaniasServicio smsTiposCampaniasServicio = null;
	
	public SMSTiposCampaniasListaControlador() {
		setCommandClass(SMSTiposCampaniasBean.class);
		setCommandName("smsTiposCampanias");
	}
			
	protected ModelAndView handle(HttpServletRequest request,
									  HttpServletResponse response,
									  Object command,
									  BindException errors) throws Exception {
			
	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");

	SMSTiposCampaniasBean smsTiposCampanias = (SMSTiposCampaniasBean) command;
	smsTiposCampaniasServicio.getSmsTiposCampaniasDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());

	List tiposCampanias =	smsTiposCampaniasServicio.lista(tipoLista, smsTiposCampanias);
	
	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(tiposCampanias);
			
	return new ModelAndView("sms/tiposCampaniasListaVista", "listaResultado", listaResultado);
	}

	
	public void setSmsTiposCampaniasServicio(
			SMSTiposCampaniasServicio smsTiposCampaniasServicio) {
		this.smsTiposCampaniasServicio = smsTiposCampaniasServicio;
	}
}

