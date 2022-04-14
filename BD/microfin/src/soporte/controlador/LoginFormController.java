package soporte.controlador;

import general.bean.ParametrosAuditoriaBean;

import org.springframework.validation.BindException;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.MenuAplicacionBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.MenuServicio;


@SuppressWarnings("deprecation")
public class LoginFormController extends SimpleFormController{
	private ParametrosAuditoriaBean parametrosAuditoriaBean;
	
	public LoginFormController() {
		setCommandClass(UsuarioBean.class);
		setCommandName("user");	
	}
	
	protected ModelAndView onSubmit(Object command,
									BindException bindException) throws Exception {
		UsuarioBean user = (UsuarioBean) command;				
		
		//parametrosAuditoriaBean.setUsuario(user.getClave());
		
		MenuServicio menuServicio = new MenuServicio();
		MenuAplicacionBean menuAplicacion = null;;
		UsuarioBean usuarioBean = new UsuarioBean();
		usuarioBean.setRolID("1");
		usuarioBean.setClave("testfchia");
		
		menuAplicacion = menuServicio.consultaMenuPorPerfil(2, usuarioBean);
		
		return new ModelAndView(getSuccessView(), "menuAplicacion", menuAplicacion);
	}
	
	public void setParametrosAuditoriaBean(ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	
	
}
