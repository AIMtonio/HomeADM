package general.servicio;

import general.bean.ParametrosSesionBean;
import general.dao.ParametrosAplicacionDAO;
import soporte.bean.UsuarioBean;

public class ParametrosAplicacionServicio {
	
	/* Variables */	
	ParametrosAplicacionDAO parametrosAplicacionDAO = null;
	private ParametrosSesionBean parametrosSesionBean;
	
	private ParametrosAplicacionServicio(){
		super();
	}

	public static interface Enum_Con_ParAplicacion{
		int principal = 1;
		int loginSession = 2;	
		int fechaSucursal =11;
		int reportesFinancieros = 20;
	}
	
	public ParametrosSesionBean consultaParametrosSession(int tipoConsulta, UsuarioBean usuarioBean){
		ParametrosSesionBean parametrosSesionBean;
		parametrosSesionBean = parametrosAplicacionDAO.consultaParaSession(usuarioBean, tipoConsulta);
		return parametrosSesionBean;
	}
	
	/* Consulta los Parametros de la Session Activa del Usario que se encuentre logeado en la Aplicacion */
	public ParametrosSesionBean consultaParametrosSessionLocal(){
		return parametrosSesionBean;
	}
	
	// ------------------- Setter y Getters  -------------------------------------------------------------
	
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
		
	public void setParametrosAplicacionDAO(
			ParametrosAplicacionDAO parametrosAplicacionDAO) {
		this.parametrosAplicacionDAO = parametrosAplicacionDAO;
	}
	
}
