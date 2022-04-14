package soporte.servicio;

import general.servicio.BaseServicio;

import general.bean.MensajeTransaccionBean;
import java.util.List;

import soporte.bean.TarEnvioCorreoParamBean;
import soporte.dao.TarEnvioCorreoParamDAO;

public class TarEnvioCorreoParamServicio extends BaseServicio {
	
	
	private TarEnvioCorreoParamServicio(){
		super();
	}
	
	TarEnvioCorreoParamDAO tarEnvioCorreoParamDAO= null;
	
	public static interface Enum_Tra_Correo {
		int alta = 1;
		int modificacion = 2;
		int baja =3;
	}
	public static interface Enum_Con_Correo {
		int principal = 1;
		int conCorreoUsu = 2;
		int usuarioAct = 3;
	}
	public static interface Enum_Lis_Correo{
		int lista		= 1;
		int listagrid	= 2;
		int listaUsuCorr = 3;
		
	}
	
	public static interface Enum_Act_Correo{
		int estatusBaj		= 1;
		
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TarEnvioCorreoParamBean tarEnvioCorreoParam){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		switch (tipoTransaccion) {
			case Enum_Tra_Correo.alta:
			
				mensaje = altaCorreo(tarEnvioCorreoParam);								
				break;					
			case Enum_Tra_Correo.modificacion:		
				
				mensaje = modificacionCorreo(tarEnvioCorreoParam);								
				break;
			case Enum_Tra_Correo.baja:		
				
				mensaje = bajaCorreo(tarEnvioCorreoParam);								
				break;	
			
				
		}
		return mensaje;
	}
	
	public TarEnvioCorreoParamBean consulta (int tipoConsulta, TarEnvioCorreoParamBean tarEnvioCorreoParam){
		TarEnvioCorreoParamBean tarEnvioCorreoParamBean = null;
		
		switch(tipoConsulta){
			case Enum_Con_Correo.principal:
				tarEnvioCorreoParamBean = tarEnvioCorreoParamDAO.consultaCorreo(tarEnvioCorreoParam, Enum_Con_Correo.principal);
			break;
			case Enum_Con_Correo.conCorreoUsu:
				tarEnvioCorreoParamBean = tarEnvioCorreoParamDAO.consultaCorreoUsuario(tarEnvioCorreoParam, Enum_Con_Correo.conCorreoUsu);
			case Enum_Con_Correo.usuarioAct:
				tarEnvioCorreoParamBean = tarEnvioCorreoParamDAO.consultaCorreoUsuarioAct(tarEnvioCorreoParam, tipoConsulta);
			break;
		}
		return tarEnvioCorreoParamBean;
	}
	
	
	public MensajeTransaccionBean altaCorreo(TarEnvioCorreoParamBean tarEnvioCorreoParam){
	
		MensajeTransaccionBean mensaje = null;
		mensaje = getTarEnvioCorreoParamDAO().altaCorreo(tarEnvioCorreoParam);		
		return mensaje;
	}
	public MensajeTransaccionBean modificacionCorreo(TarEnvioCorreoParamBean tarEnvioCorreoParam){
		MensajeTransaccionBean mensaje = null;
		mensaje = getTarEnvioCorreoParamDAO().modificacionCorreo(tarEnvioCorreoParam);		
		return mensaje;
	}
	
	public MensajeTransaccionBean bajaCorreo(TarEnvioCorreoParamBean tarEnvioCorreoParam){
		MensajeTransaccionBean mensaje = null;
		mensaje = getTarEnvioCorreoParamDAO().bajaCorreo(tarEnvioCorreoParam,Enum_Act_Correo.estatusBaj);		
		return mensaje;
	}
	public List lista(int tipoLista, TarEnvioCorreoParamBean tarEnvioCorreoParam){		
		List listaCorreo = null;
		switch (tipoLista) {
		
			case Enum_Lis_Correo.lista:
			
				listaCorreo=  tarEnvioCorreoParamDAO.listaCorreo(tarEnvioCorreoParam, Enum_Lis_Correo.lista);
				
				break;	
			
			case Enum_Lis_Correo.listagrid:
				listaCorreo=  tarEnvioCorreoParamDAO.listaCorreoGrid(tarEnvioCorreoParam, Enum_Lis_Correo.listagrid);
					
				break;
			case Enum_Lis_Correo.listaUsuCorr:
				
				listaCorreo=  tarEnvioCorreoParamDAO.listaUsuariosDestinatarios(tarEnvioCorreoParam, Enum_Lis_Correo.listaUsuCorr);
				
				break;	
			
		}		
		return listaCorreo;
	}

	public TarEnvioCorreoParamDAO getTarEnvioCorreoParamDAO() {
		return tarEnvioCorreoParamDAO;
	}

	public void setTarEnvioCorreoParamDAO(
			TarEnvioCorreoParamDAO tarEnvioCorreoParamDAO) {
		this.tarEnvioCorreoParamDAO = tarEnvioCorreoParamDAO;
	}


}
