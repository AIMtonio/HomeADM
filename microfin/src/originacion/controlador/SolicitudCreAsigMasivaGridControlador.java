
package originacion.controlador;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import originacion.bean.SolicitudesCreAsigBean;
import originacion.servicio.SolicitudesCreAsigServicio;



public class SolicitudCreAsigMasivaGridControlador extends SimpleFormController {



	SolicitudesCreAsigServicio solicitudesCreAsigServicio = null;

	public SolicitudCreAsigMasivaGridControlador(){
		setCommandClass(SolicitudesCreAsigBean.class);
		setCommandName("solicitudesCreAsigBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		SolicitudesCreAsigBean solicitudesCreAsigBean = (SolicitudesCreAsigBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<SolicitudesCreAsigBean> lista = solicitudesCreAsigServicio.lista(tipoLista, solicitudesCreAsigBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}
	
	public void setSolicitudesCreAsigServicio(SolicitudesCreAsigServicio solicitudesCreAsigServicio){
                    this.solicitudesCreAsigServicio = solicitudesCreAsigServicio;
	}

	public SolicitudesCreAsigServicio getSolicitudesCreAsigServicio() {
		return solicitudesCreAsigServicio;
	}
}
