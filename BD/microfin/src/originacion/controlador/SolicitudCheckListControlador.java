package originacion.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.SolicitudCreditoBean;
import originacion.servicio.SolicitudCheckListServicio;
//import originacion.servicio.SolicitudCreditoServicio;
import originacion.bean.SolicitudCheckListBean;

public class SolicitudCheckListControlador extends SimpleFormController {

	SolicitudCheckListServicio	solicitudCheckListServicio=null;

	public SolicitudCheckListControlador(){
		setCommandClass(SolicitudCheckListBean.class);
		setCommandName("solicitudCheckList");
	}

	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		SolicitudCheckListBean solicitudCheck = (SolicitudCheckListBean) command;
		
		solicitudCheckListServicio.getSolicitudCheckListDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
				0;
		
		String datosGrid = request.getParameter("datosGrid");	
	
		MensajeTransaccionBean mensaje = null;
		mensaje = solicitudCheckListServicio.grabaTransaccion(tipoTransaccion, solicitudCheck,datosGrid);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}

	public void setSolicitudCheckListServicio(
			SolicitudCheckListServicio solicitudCheckListServicio) {
		this.solicitudCheckListServicio = solicitudCheckListServicio;
	}

	
	
	
} 
