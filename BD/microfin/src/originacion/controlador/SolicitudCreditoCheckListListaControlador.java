package originacion.controlador;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.bean.SolicitudCheckListBean;
import originacion.servicio.SolicitudCheckListServicio;

public class SolicitudCreditoCheckListListaControlador extends AbstractCommandController {

	SolicitudCheckListServicio solicitudCheckListServicio = null;

	public SolicitudCreditoCheckListListaControlador(){
		setCommandClass(SolicitudCheckListBean.class);
		setCommandName("solicitudCheckList");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  HttpServletResponse response,
			  Object command,
			  BindException errors) throws Exception {

		String tp=request.getParameter("tipoLista");
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		String controlID = request.getParameter("controlID");
		   
		SolicitudCheckListBean solicitudCheckListBean = (SolicitudCheckListBean) command;
		
		List solicitudCheckLista = solicitudCheckListServicio.lista(tipoLista, solicitudCheckListBean);
		
		List listaResultado = (List)new ArrayList();
		listaResultado.add(tipoLista);
		listaResultado.add(controlID);
		listaResultado.add(solicitudCheckLista);
            
		return new ModelAndView("originacion/checkListSolicitudCreditoListaVista", "listaResultado", listaResultado);
	}
	
	public void setSolicitudCheckListServicio(
			SolicitudCheckListServicio solicitudCheckListServicio) {
		this.solicitudCheckListServicio = solicitudCheckListServicio;
	}
}
