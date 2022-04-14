
package cliente.servicio;

import java.util.List;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cliente.dao.EscrituraPubDAO;
import cliente.bean.EscrituraPubBean;
public class EscrituraPubServicio extends BaseServicio {

	private EscrituraPubServicio(){
		super();
	}

	EscrituraPubDAO escrituraPubDAO = null;

	public static interface Enum_Tra_EscrituraPub {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_EscrituraPub{
		int principal = 1;
		int foranea = 2;
		int poderes = 3;
		int escPubCli = 4;
	}

	public static interface Enum_Lis_EscrituraPub{
		int principal				= 1;
		int poderes					= 2;
		int listaEscPublicaCliente	=3;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EscrituraPubBean escrituraPub){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_EscrituraPub.alta:
			mensaje = altaEscritura(escrituraPub);
			break;
		case Enum_Tra_EscrituraPub.modificacion:
			mensaje = modificaEscritura(escrituraPub);
			break;
		}

		return mensaje;
	}
	
	
	
	public MensajeTransaccionBean altaEscritura(EscrituraPubBean escrituraPub){
		MensajeTransaccionBean mensaje = null;
		mensaje = escrituraPubDAO.alta(escrituraPub);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaEscritura(EscrituraPubBean escrituraPub){
		MensajeTransaccionBean mensaje = null;
		mensaje = escrituraPubDAO.modifica(escrituraPub);		
		return mensaje;
	}	

	public EscrituraPubBean consulta(int tipoConsulta,EscrituraPubBean escrituraPubBean){
		EscrituraPubBean escrituraPub = null;

		switch(tipoConsulta){
			case Enum_Con_EscrituraPub.principal:
				escrituraPub = escrituraPubDAO.consultaPrincipal(escrituraPubBean,Enum_Con_EscrituraPub.principal);
			break;
			case Enum_Con_EscrituraPub.foranea:
				escrituraPub = escrituraPubDAO.consultaForanea(escrituraPubBean, Enum_Con_EscrituraPub.foranea);
			break;
			case Enum_Con_EscrituraPub.poderes:
				escrituraPub = escrituraPubDAO.consultaPoderes(escrituraPubBean, Enum_Con_EscrituraPub.poderes);
			break;			
			case Enum_Con_EscrituraPub.escPubCli:
				escrituraPub = escrituraPubDAO.consultaEscPubCliente(escrituraPubBean, Enum_Con_EscrituraPub.escPubCli);
			break;
			
			
			
		}
		return escrituraPub;
	}

	public List lista(int tipoLista, EscrituraPubBean escrituraPub){

		List escrituraPubLista = null;

		switch (tipoLista) {
		case Enum_Lis_EscrituraPub.principal:
			escrituraPubLista = escrituraPubDAO.listaEscritura(escrituraPub, tipoLista);
			break; 
		case Enum_Lis_EscrituraPub.poderes:
			escrituraPubLista = escrituraPubDAO.listaPoderes(escrituraPub, tipoLista);
			break; 
		case Enum_Lis_EscrituraPub.listaEscPublicaCliente:
			escrituraPubLista = escrituraPubDAO.listaEscPublicaCliente(escrituraPub, tipoLista);
			break; 
		}
		
		return escrituraPubLista;
	}

	public void setEscrituraPubDAO(EscrituraPubDAO escrituraPubDAO ){
		this.escrituraPubDAO = escrituraPubDAO;
	}



	public EscrituraPubDAO getEscrituraPubDAO() {
		return escrituraPubDAO;
	}

}
