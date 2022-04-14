package tarjetas.servicio;


import tarjetas.bean.TarDebLimiteTipoCteCorpBean;
import tarjetas.dao.TarDebLimiteTipoCteCorpDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TarDebLimiteTipoCteCorpServicio extends BaseServicio {
	TarDebLimiteTipoCteCorpDAO tarDebLimiteTipoCteCorpDAO = null;

	public TarDebLimiteTipoCteCorpServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_Tra_LimiteTarDebCte {
		int alta					=1;
		int modificacion			=2;	
	}
	  
	public static interface Enum_Con_LimiteTarDebCte{
		int contTipoTarjetaCte 		= 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TarDebLimiteTipoCteCorpBean tarDebLimiteTipoCteCorpBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){		
	    	case Enum_Tra_LimiteTarDebCte.alta:
	    		mensaje = tarDebLimiteTipoCteCorpDAO.tipoTarjetaDebitoCte(tipoTransaccion,tarDebLimiteTipoCteCorpBean);
	    		break;
	    case Enum_Tra_LimiteTarDebCte.modificacion:
			   mensaje = tarDebLimiteTipoCteCorpDAO.modtipoTarjetaDebitoCte(tarDebLimiteTipoCteCorpBean);
			break;
		}
		return mensaje;
	}

	public TarDebLimiteTipoCteCorpBean consulta(int tipoConsulta, TarDebLimiteTipoCteCorpBean tarDebLimiteTipoCteCorpBean){
		TarDebLimiteTipoCteCorpBean tarjetaDebito = null;
		switch(tipoConsulta){
			case Enum_Con_LimiteTarDebCte.contTipoTarjetaCte:
				tarjetaDebito = tarDebLimiteTipoCteCorpDAO.consultaTipoTarjetaDebitoCte(Enum_Con_LimiteTarDebCte.contTipoTarjetaCte, tarDebLimiteTipoCteCorpBean);
			break;
			}
		return tarjetaDebito;
	}

	public TarDebLimiteTipoCteCorpDAO getTarDebLimiteTipoCteCorpDAO() {
		return tarDebLimiteTipoCteCorpDAO;
	}

	public void setTarDebLimiteTipoCteCorpDAO(
			TarDebLimiteTipoCteCorpDAO tarDebLimiteTipoCteCorpDAO) {
		this.tarDebLimiteTipoCteCorpDAO = tarDebLimiteTipoCteCorpDAO;
	}


}

