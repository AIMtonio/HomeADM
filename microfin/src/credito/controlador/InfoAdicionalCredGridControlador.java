package credito.controlador;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractCommandController;

import credito.bean.InfoAdicionalCredBean;
import credito.servicio.InfoAdicionalCredServicio;

public class InfoAdicionalCredGridControlador extends AbstractCommandController{
	InfoAdicionalCredServicio infoAdicionalCredServicio = null;
	
	public InfoAdicionalCredGridControlador(){
		setCommandClass(InfoAdicionalCredBean.class);
		setCommandName("relacionCred");
	}

	protected ModelAndView handle(HttpServletRequest request,
			  					HttpServletResponse response,
			  					Object command,
			  					BindException errors) throws Exception {

		InfoAdicionalCredBean relacionCred = (InfoAdicionalCredBean) command;
		int tipoLista = Integer.parseInt(request.getParameter("tipoLista"));
		List relacionesCredList = infoAdicionalCredServicio.lista(tipoLista, relacionCred);
		return new ModelAndView("credito/infoAdicionalCredGridVista", "relacionCred", relacionesCredList);
	}
	
	public InfoAdicionalCredServicio getInfoAdicionalCredServicio() {
		return infoAdicionalCredServicio;
	}

	public void setInfoAdicionalCredServicio(
			InfoAdicionalCredServicio infoAdicionalCredServicio) {
		this.infoAdicionalCredServicio = infoAdicionalCredServicio;
	}
}