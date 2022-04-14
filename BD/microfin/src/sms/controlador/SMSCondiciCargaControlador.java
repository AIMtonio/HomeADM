package sms.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.support.PagedListHolder;
import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import sms.bean.SMSCondiciCargaBean;
import sms.bean.SMSEnvioMensajeBean;
import sms.servicio.SMSCondiciCargaServicio;

public class SMSCondiciCargaControlador extends AbstractCommandController {

	SMSCondiciCargaServicio smsCondiciCargaServicio	=null;
	public SMSCondiciCargaControlador(){
		setCommandClass(SMSEnvioMensajeBean.class);
		setCommandName("smsEnvioMensajeBean");
	}
	
	@Override
	protected ModelAndView handle(HttpServletRequest request,
			HttpServletResponse response, Object command, BindException error)
			throws Exception {
		int tipoLista =(request.getParameter("tipoLista")!=null)?
				Integer.parseInt(request.getParameter("tipoLista")):
					0;	
		String page = request.getParameter("page");
		String tipoPaginacion = "";
		if(page== null){
			tipoPaginacion = "Completa";
		}
		if(tipoPaginacion.equalsIgnoreCase("Completa")){
			tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
			SMSCondiciCargaBean smsCondiciCargaBean = new SMSCondiciCargaBean();
			smsCondiciCargaBean.setFechaInicio(request.getParameter("fechaInicio"));
			smsCondiciCargaBean.setFechaFin(request.getParameter("fechaFin"));
			smsCondiciCargaBean.setPeriodicidad(request.getParameter("periodicidad"));
			smsCondiciCargaBean.setCampaniaID(request.getParameter("campaniaID"));
			List LisFechas = smsCondiciCargaServicio.lista(tipoLista, smsCondiciCargaBean);
			PagedListHolder fechasList = new PagedListHolder(LisFechas);
			fechasList.setPageSize(20);
			request.getSession().setAttribute("ConSimulaFechas_LisFechas", fechasList);
			return new ModelAndView("sms/envioMasivoGridVista", "listaPaginada", fechasList);
		}else{
			PagedListHolder fechasList = null;
			if(request.getSession().getAttribute("ConSimulaFechas_LisFechas") != null){
				fechasList = (PagedListHolder) request.getSession().getAttribute("ConSimulaFechas_LisFechas");
				if ("next".equals(page)) {
					fechasList.nextPage();
				}
				else if ("previous".equals(page)) {
					fechasList.previousPage();
					fechasList.getPage();
				}
			}else{
				fechasList = null;
			}
			return new ModelAndView("sms/envioMasivoGridVista", "listaPaginada", fechasList);
		}
	}

	public void setSmsCondiciCargaServicio(
			SMSCondiciCargaServicio smsCondiciCargaServicio) {
		this.smsCondiciCargaServicio = smsCondiciCargaServicio;
	}
}
