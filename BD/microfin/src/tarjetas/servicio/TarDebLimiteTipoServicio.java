package tarjetas.servicio;


import tarjetas.bean.TarDebLimiteTipoBean;
import tarjetas.dao.TarDebLimiteTipoDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TarDebLimiteTipoServicio extends BaseServicio {
	TarDebLimiteTipoDAO tarDebLimiteTipoDAO = null;
	
	public TarDebLimiteTipoServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_Tra_LimTarjetaDebito {
		int alta					=1;
		int modificacion			=2;	
	}
	  
	public static interface Enum_Con_LimTipoTarjetaDebito{
		int contTipoTarjeta 		= 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TarDebLimiteTipoBean tarDebLimiteTipoBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){		
	    	case Enum_Tra_LimTarjetaDebito.alta:
	    		mensaje = tarDebLimiteTipoDAO.tipoTarjetaDebito(tipoTransaccion,tarDebLimiteTipoBean);
	    		break;
	    case Enum_Tra_LimTarjetaDebito.modificacion:
			   mensaje = tarDebLimiteTipoDAO.modtipoTarjetaDebito(tarDebLimiteTipoBean);
			break;
		}
		return mensaje;
	}

	public TarDebLimiteTipoBean consulta(int tipoConsulta, TarDebLimiteTipoBean tarDebLimiteTipoBean){
		TarDebLimiteTipoBean tarjetaDebito = null;
		switch(tipoConsulta){
			case Enum_Con_LimTipoTarjetaDebito.contTipoTarjeta:
				tarjetaDebito = tarDebLimiteTipoDAO.consultaTipoTarjetaDebito(Enum_Con_LimTipoTarjetaDebito.contTipoTarjeta, tarDebLimiteTipoBean);
			break;
			}
		return tarjetaDebito;
	}


	//--------------------Getter y setter---------------------------------


	public TarDebLimiteTipoDAO getTarDebLimiteTipoDAO() {
		return tarDebLimiteTipoDAO;
	}

	public void setTarDebLimiteTipoDAO(TarDebLimiteTipoDAO tarDebLimiteTipoDAO) {
		this.tarDebLimiteTipoDAO = tarDebLimiteTipoDAO;
	}
	
}

