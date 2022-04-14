package cliente.controlador;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import herramientas.Utileria;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import cliente.bean.CheckListRegistroBean;
import cliente.servicio.CheckListRegistroServicio;

public class CheckListRegistroControlador extends SimpleFormController {
	
	CheckListRegistroServicio checkListRegistroServicio = null;
 	private ParametrosSesionBean parametrosSesionBean = null;

	public CheckListRegistroControlador() {
		setCommandClass(CheckListRegistroBean.class);
		setCommandName("check");
	}
		
	
	protected ModelAndView onSubmit(HttpServletRequest request,
									HttpServletResponse response,
									Object command,
									BindException errors) throws Exception {
		
		checkListRegistroServicio.getCheckListRegistroDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		
		CheckListRegistroBean check = (CheckListRegistroBean) command;
		int tipoTransaccion = Integer.parseInt(request.getParameter("tipoTransaccion"));
		String  ListaCheck = request.getParameter("datosGridDocEnt");
		MensajeTransaccionBean mensaje = null;
		mensaje = checkListRegistroServicio.grabaTransaccion(tipoTransaccion,check,ListaCheck);
																
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}



	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}


	public CheckListRegistroServicio getCheckListRegistroServicio() {
		return checkListRegistroServicio;
	}


	public void setCheckListRegistroServicio(
			CheckListRegistroServicio checkListRegistroServicio) {
		this.checkListRegistroServicio = checkListRegistroServicio;
	}

	
}
