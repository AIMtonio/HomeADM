package sms.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import sms.bean.SMSPlantillaBean;
import sms.servicio.SMSPlantillaServicio;

public class SMSPlantillaListaControlador extends AbstractCommandController {

	SMSPlantillaServicio smsPlantillaServicio = null;
	
	public SMSPlantillaListaControlador(){
		setCommandClass(SMSPlantillaBean.class);
		setCommandName("smsPlantillaBean");
	}
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

	int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
	String controlID = request.getParameter("controlID");
	SMSPlantillaBean smsPlantillaBean = (SMSPlantillaBean) command;
	List plantillaList = smsPlantillaServicio.lista(tipoLista, smsPlantillaBean);

	List listaResultado = (List)new ArrayList();
	listaResultado.add(tipoLista);
	listaResultado.add(controlID);
	listaResultado.add(plantillaList);

	return new ModelAndView("sms/plantillaListaVista", "listaResultado", listaResultado);
}
	public SMSPlantillaServicio getSmsPlantillaServicio() {
		return smsPlantillaServicio;
	}
	public void setSmsPlantillaServicio(SMSPlantillaServicio smsPlantillaServicio) {
		this.smsPlantillaServicio = smsPlantillaServicio;
	}

}
