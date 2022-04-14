package spei.servicio;

import java.util.List;

import cardinal.seguridad.mars.Encryptor20;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import seguridad.servicio.SeguridadRecursosServicio;
import spei.bean.ParametrosSpeiBean;
import spei.dao.ParametrosSpeiDAO;

public class ParametrosSpeiServicio extends BaseServicio {


	//---------- Variables ------------------------------------------------------------------------
	ParametrosSpeiDAO parametrosSpeiDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_Param{
		int principal   	= 1;
		int ctaTesoreria    = 2;
		int remitentes 		= 3;

	}

	public static interface Enum_Con_Param{
		int principal   = 1;

	}

	public static interface Enum_Tra_Param{
		int grabar = 1;
		int modificar = 2;

	}
	
	public static interface Enum_Tra_Usuario {
		 int valida    	= 3;
	 }

	public ParametrosSpeiServicio () {
		super();
		// TODO Auto-generated constructor stub
	}

	// Consulta principal de tipo de pago spei
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosSpeiBean parametrosSpeiBean) {
		MensajeTransaccionBean mensaje = null;

		switch(tipoTransaccion){
		case Enum_Tra_Param.modificar:
			mensaje = modificarParametros(parametrosSpeiBean);
			break;
		}

		return mensaje;
	}

	// Consulta principal de tipo de pago spei
	public ParametrosSpeiBean consulta(int tipoConsulta, ParametrosSpeiBean parametrosSpeiBean){
		ParametrosSpeiBean parametrosSpei= null;
		
		switch(tipoConsulta){
			case Enum_Con_Param.principal:
				parametrosSpei = consultaPrincipal(tipoConsulta, parametrosSpeiBean);
			break;

		}
		return parametrosSpei;
	}

	public List lista(int tipoLista, ParametrosSpeiBean parametrosSpeiBean){
		List listaParametrosSpei = null;
		switch (tipoLista) {
			case Enum_Lis_Param.principal:
				listaParametrosSpei = parametrosSpeiDAO.listaPrincipal(parametrosSpeiBean, tipoLista);
			break;
			case Enum_Lis_Param.ctaTesoreria:
				listaParametrosSpei = parametrosSpeiDAO.listaTesoreria(parametrosSpeiBean, tipoLista);
			break;
			case Enum_Lis_Param.remitentes:
				listaParametrosSpei = parametrosSpeiDAO.listaRemitentes(parametrosSpeiBean, tipoLista);
			break;

		}
		return listaParametrosSpei;
	}
	
	private MensajeTransaccionBean modificarParametros(ParametrosSpeiBean parametrosSpeiBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		try {
			Encryptor20 encryptor = new Encryptor20();
			parametrosSpeiBean.setPasswordKeystoreStp(encryptor.encrypt(parametrosSpeiBean.getPasswordKeystoreStp()));
			mensaje = parametrosSpeiDAO.modificaParametrosSpei(parametrosSpeiBean);
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al Encryptar la contraseña del Keystore", e);
			if (mensaje.getNumero() == 0) {
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
		}
		
		return mensaje;
	}
	
	private ParametrosSpeiBean consultaPrincipal(int tipoConsulta, ParametrosSpeiBean parametrosSpeiBean) {
		ParametrosSpeiBean parametrosSpei = new ParametrosSpeiBean();
		
		try {
			Encryptor20 encryptor = new Encryptor20();
			parametrosSpei = parametrosSpeiDAO.consultaPrincipal(parametrosSpeiBean, tipoConsulta);
			parametrosSpei.setPasswordKeystoreStp(encryptor.decrypt(parametrosSpei.getPasswordKeystoreStp()));
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al Desencryptar la contraseña del Keystore", e);
			parametrosSpei = null;
		}
		
		return parametrosSpei;
	}

	//------------------ Geters y Seters ------------------------------------------------------

	public ParametrosSpeiDAO getParametrosSpeiDAO() {
		return parametrosSpeiDAO;
	}

	public void setParametrosSpeiDAO(ParametrosSpeiDAO parametrosSpeiDAO) {
		this.parametrosSpeiDAO = parametrosSpeiDAO;
	}
}