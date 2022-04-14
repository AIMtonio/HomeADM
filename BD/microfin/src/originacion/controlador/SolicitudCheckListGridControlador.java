package originacion.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import originacion.servicio.SolicitudCheckListServicio;
import originacion.bean.SolicitudCheckListBean;

public class SolicitudCheckListGridControlador  extends AbstractCommandController{
	
	SolicitudCheckListServicio solicitudCheckListServicio  = null;
	
	public SolicitudCheckListGridControlador() {
		setCommandClass(SolicitudCheckListBean.class);
		setCommandName("solCheckListGrid");
	}
		
	protected ModelAndView handle(HttpServletRequest request,
								  HttpServletResponse response,
								  Object command,
								  BindException errors) throws Exception {			
		SolicitudCheckListBean solCheckListBean = (SolicitudCheckListBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		
		List solCheckListGrid = solicitudCheckListServicio.lista(tipoLista, solCheckListBean);

		return new ModelAndView("originacion/solicitudCheckListGridVista", "listaResultado", solCheckListGrid);
	}


	public void setSolicitudCheckListServicio(
			SolicitudCheckListServicio solicitudCheckListServicio) {
		this.solicitudCheckListServicio = solicitudCheckListServicio;
	}

	
	
}






