package tarjetas.servicio;

import java.util.List;





import tarjetas.bean.GiroNegocioTarDebBean;
import tarjetas.dao.GiroNegocioTarDebDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GiroNegocioTarDebServicio extends BaseServicio {
	GiroNegocioTarDebDAO giroNegocioTarDebDAO = null;
	
	public GiroNegocioTarDebServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_GiroTarDeb {
	
		int alta=1;
		int modificacion=2;
	}
	
	public static interface Enum_Lis_GiroTarDeb{
		int principal 	= 1;
		int giros		= 2;

	}
	
	public static interface Enum_Con_GiroTarDeb{
	
        int principal	= 1;
        int giros		= 2;
    }

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GiroNegocioTarDebBean giroNegocioTarDebBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
	    case Enum_GiroTarDeb.alta:
		mensaje = giroNegocioTarDebDAO.giroTardeb(tipoTransaccion,giroNegocioTarDebBean);
		break;
        case Enum_GiroTarDeb.modificacion:
  
			mensaje = giroNegocioTarDebDAO.modtipoGiroNeg(giroNegocioTarDebBean);
			break;
	}

		return mensaje;
	}

	public GiroNegocioTarDebBean consulta(int tipoConsulta, GiroNegocioTarDebBean giroNegocioTarDebBean){
		GiroNegocioTarDebBean tarjetaDebito = null;
		switch(tipoConsulta){
			case Enum_Con_GiroTarDeb.principal:
				tarjetaDebito = giroNegocioTarDebDAO.consultaGiroNegocioTarDeb(Enum_Con_GiroTarDeb.principal, giroNegocioTarDebBean);
			break;
			case Enum_Con_GiroTarDeb.giros:
				tarjetaDebito = giroNegocioTarDebDAO.consultaGiroNegocioTarDeb(Enum_Con_GiroTarDeb.giros, giroNegocioTarDebBean);
			break;
		}
		return tarjetaDebito;
	}
	
	public List lista(int tipoLista, GiroNegocioTarDebBean giroNegocioTarDebBean){		
		List listaTipoTarjetaDe = null;
		switch (tipoLista) {
			case Enum_Lis_GiroTarDeb.principal:
				listaTipoTarjetaDe = giroNegocioTarDebDAO.listaPrincipal(giroNegocioTarDebBean, tipoLista);
				break;
			case Enum_Lis_GiroTarDeb.giros:
				listaTipoTarjetaDe = giroNegocioTarDebDAO.listaPrincipal(giroNegocioTarDebBean, tipoLista);
				break;
		}
		return listaTipoTarjetaDe;
	}


//--------------------Getter y setter---------------------------------
	public GiroNegocioTarDebDAO getGiroNegocioTarDebDAO() {
		return giroNegocioTarDebDAO;
	}

	public void setGiroNegocioTarDebDAO(GiroNegocioTarDebDAO giroNegocioTarDebDAO) {
		this.giroNegocioTarDebDAO = giroNegocioTarDebDAO;
	}


}
