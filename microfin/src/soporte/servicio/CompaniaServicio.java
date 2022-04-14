package soporte.servicio;

import general.servicio.BaseServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.CompaniaBean;
import soporte.bean.UsuarioBean;
import soporte.dao.CompaniasDAO;
import soporte.dao.UsuarioDAO;

public class CompaniaServicio extends BaseServicio {
	UsuarioDAO usuarioDAO = null;
	CompaniasDAO companiasDAO = null;
	String estInactivo	= "I";

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Compania {
		int principal = 1;	
		int estMulticompania = 2;
	}
	public static interface Enum_Con_Usuario {
		int clave = 3;
	}

	public CompaniaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	

	public CompaniaBean consulta(int tipoConsulta, UsuarioBean usuarioBean){
		System.out.println("compania consulta ");
		UsuarioBean usuario = null;
		CompaniaBean companiaBean = null;
		switch (tipoConsulta) { 
		case Enum_Con_Compania.principal:	
			usuario = usuarioDAO.consultaPorClaveBDPrincipal(usuarioBean, Enum_Con_Usuario.clave);			
			if(usuario!=null){
				usuarioBean.setOrigenDatos(usuario.getOrigenDatos());
				System.out.println("Logo Pantalla Principal BD="+usuarioBean.getOrigenDatos());
				companiaBean	= companiasDAO.consultaPorClave(usuarioBean, tipoConsulta);
				
				if (companiaBean != null){
					companiaBean.setSubdominio(usuario.getSubdominio());
				}
			}
			
			break;
		case Enum_Con_Compania.estMulticompania:
			companiaBean = estatusMulticompania(usuarioBean);
			break;
		}
		return companiaBean;
	}
	
	/*
	 * Consulta si Esta encendido el Parametro de Multicompañias
	 */
	public CompaniaBean estatusMulticompania( UsuarioBean usuarioBean){
		CompaniaBean compania = new CompaniaBean();
		
		String estatusMulticompania = PropiedadesSAFIBean.propiedadesSAFI.getProperty("estMulticompania") == null ? 
														  estInactivo : PropiedadesSAFIBean.propiedadesSAFI.getProperty("estMulticompania");
		
		compania.setEstMulticompania(estatusMulticompania);		
				
		return compania;
	}

	//------------------ Geters y Seters ------------------------------------------------------	

	public UsuarioDAO getUsuarioDAO() {
		return usuarioDAO;
	}


	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}


	public CompaniasDAO getCompaniasDAO() {
		return companiasDAO;
	}


	public void setCompaniasDAO(CompaniasDAO companiasDAO) {
		this.companiasDAO = companiasDAO;
	}


	

	
	
	
	



}
