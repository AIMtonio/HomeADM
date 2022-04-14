package cliente.servicio;

import cliente.bean.SocioMenorBean;
import cliente.dao.SocioMenorDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SocioMenorServicio extends BaseServicio{

	SocioMenorDAO socioMenorDAO = null;
	
	public static interface Enum_Tra_Socio{
		int alta = 1;
		int modificacion = 2;
	}
	public static interface Enum_Con_Socio {
		int principal = 1;
		int foranea = 2;
		int tutor	= 12;
	}
	public SocioMenorServicio(){
		super();
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, SocioMenorBean socio){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Socio.alta:
				mensaje = altaSocio(socio);
				break;
			case Enum_Tra_Socio.modificacion:
				mensaje = modificaSocio(socio);
				break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean altaSocio(SocioMenorBean socio){
		MensajeTransaccionBean mensaje = null;
		mensaje = socioMenorDAO.altaSocioMenor(socio);
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaSocio(SocioMenorBean socio){
		MensajeTransaccionBean mensaje = null;
		mensaje = socioMenorDAO.modificaSocioMenor(socio);
		return mensaje;
	}
	
	public SocioMenorBean consulta(int tipoConsulta, SocioMenorBean socioBean,String numeroCliente){
		SocioMenorBean socio= null;
		switch (tipoConsulta) {
			case Enum_Con_Socio.principal:		
				socio = socioMenorDAO.consultaPrincipal(tipoConsulta, socioBean);				
				break;			
		}
		return socio;
	}
	
	public SocioMenorBean consultaTutor(int tipoConsulta,String numeroCliente){
		SocioMenorBean socio= null;
		switch (tipoConsulta) {
			case Enum_Con_Socio.tutor:		
				socio = socioMenorDAO.consultaDatosTutor(Integer.parseInt(numeroCliente),tipoConsulta);				
				break;
		}
		return socio;
	}

	public SocioMenorDAO getSocioMenorDAO() {
		return socioMenorDAO;
	}

	public void setSocioMenorDAO(SocioMenorDAO socioMenorDAO) {
		this.socioMenorDAO = socioMenorDAO;
	}
	
}
