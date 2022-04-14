package credito.controlador;

import general.bean.MensajeTransaccionBean;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import credito.bean.InfoAdicionalCredBean;
import credito.servicio.InfoAdicionalCredServicio;

public class InfoAdicionalCredControlador extends SimpleFormController{
	InfoAdicionalCredServicio infoAdicionalCredServicio = null;
	
	public InfoAdicionalCredControlador(){
		setCommandClass(InfoAdicionalCredBean.class);
		setCommandName("infoAdicionalCredBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {

		infoAdicionalCredServicio.getInfoAdicionalCredDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		InfoAdicionalCredBean relacionCred = (InfoAdicionalCredBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		
		String lisPlacas = request.getParameter("lisPlacas");
		String lisGnv = request.getParameter("lisGnv");
		String lisVin = request.getParameter("lisVin");
		String lisEst = request.getParameter("lisEst");


		MensajeTransaccionBean mensaje = null;
		mensaje = infoAdicionalCredServicio.grabaTransaccion(tipoTransaccion, relacionCred, lisPlacas, lisGnv, lisVin, lisEst);

		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}
	
	public InfoAdicionalCredServicio getInfoAdicionalCredServicio() {
		return infoAdicionalCredServicio;
	}

	public void setInfoAdicionalCredServicio(
			InfoAdicionalCredServicio infoAdicionalCredServicio) {
		this.infoAdicionalCredServicio = infoAdicionalCredServicio;
	}
}