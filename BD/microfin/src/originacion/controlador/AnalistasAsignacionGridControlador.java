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

import originacion.bean.AnalistasAsignacionBean;
import originacion.servicio.AnalistasAsignacionServicio;


public class AnalistasAsignacionGridControlador extends SimpleFormController {


	AnalistasAsignacionServicio analistasAsignacionServicio = null;


	public AnalistasAsignacionGridControlador(){
		setCommandClass(AnalistasAsignacionBean.class);
		setCommandName("analistasAsignacionBean");
	}
	
	protected ModelAndView onSubmit(HttpServletRequest request, HttpServletResponse response, Object command, BindException errors) throws Exception {
		AnalistasAsignacionBean analistasAsignacionBean = (AnalistasAsignacionBean) command;
		int tipoLista = Utileria.convierteEntero(request.getParameter("tipoLista"));
		List<AnalistasAsignacionBean> lista = analistasAsignacionServicio.lista(tipoLista, analistasAsignacionBean);
		return new ModelAndView(getSuccessView(), "listaResultado", lista);
	}
	
	public void setAnalistasAsignacionServicio(AnalistasAsignacionServicio analistasAsignacionServicio){
                    this.analistasAsignacionServicio = analistasAsignacionServicio;
	}

	public AnalistasAsignacionServicio getAnalistasAsignacionServicio() {
		return analistasAsignacionServicio;
	}
}
