package originacion.controlador;


import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;
import originacion.bean.ClasificaTipDocBean;
import originacion.servicio.ClasificaTipDocServicio;

public class DocumentosPorClasificaControlador extends SimpleFormController {
	ClasificaTipDocServicio clasificaTipDocServicio = null;
	
	public DocumentosPorClasificaControlador(){
		setCommandClass(ClasificaTipDocBean.class);
		setCommandName("clasificaDocumentos");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception {

		ClasificaTipDocBean clasificacion = (ClasificaTipDocBean) command;
		
		clasificaTipDocServicio.getClasificaTipDocDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
		Integer.parseInt(request.getParameter("tipoTransaccion")):0;
		
		int clasDocID =(request.getParameter("clasDocID")!=null)?
				Integer.parseInt(request.getParameter("clasDocID")):
			0;
				
		
		MensajeTransaccionBean mensaje = null;
		mensaje = clasificaTipDocServicio.grabaGrid(tipoTransaccion, clasDocID, clasificacion);
		
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
		
	}


	//---------------setter-------------
	public void setClasificaTipDocServicio(
			ClasificaTipDocServicio clasificaTipDocServicio) {
		this.clasificaTipDocServicio = clasificaTipDocServicio;
	}

	
}
