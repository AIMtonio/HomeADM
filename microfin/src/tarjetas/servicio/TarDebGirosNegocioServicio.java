package tarjetas.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;

import tarjetas.bean.TarDebGirosNegocioBean;
import tarjetas.dao.TarDebGirosNegocioDAO;



public class TarDebGirosNegocioServicio extends BaseServicio {
	TarDebGirosNegocioDAO tarDebGirosNegocioDAO = null;

	public TarDebGirosNegocioServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_Tra_GirosNegocioTipoTarjeta {
		int altaLista					=1;
		int modificaLista				=2;
	}
	  
	public static interface Enum_Lis_GirosNegocioTipoTarjeta{
		int listaNegociosTipoTar    	= 2;
	}
	public static interface Enum_Con_GirosNegocioTipoTarjeta{
        int giroNegocioTipoTar		   = 2;
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TarDebGirosNegocioBean tarDebGirosNegocioBean){
		ArrayList listaGirosTipoTarjeta = (ArrayList) creaListaDetalle(tarDebGirosNegocioBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch(tipoTransaccion){		
	    	case Enum_Tra_GirosNegocioTipoTarjeta.altaLista:
	    		mensaje = tarDebGirosNegocioDAO.grabaGiroTipoTarjeta(tarDebGirosNegocioBean,listaGirosTipoTarjeta);
	    		break;
	    case Enum_Tra_GirosNegocioTipoTarjeta.modificaLista:
			    mensaje = tarDebGirosNegocioDAO.modGiroTipoTarjeta(tarDebGirosNegocioBean,listaGirosTipoTarjeta);
			break;
		}
		return mensaje;
	}

	public TarDebGirosNegocioBean consulta(int tipoConsulta, TarDebGirosNegocioBean tarDebGirosNegocioBean){
		TarDebGirosNegocioBean tarjetaGiroTipoTarjeta = null;
		switch(tipoConsulta){
			case Enum_Con_GirosNegocioTipoTarjeta.giroNegocioTipoTar:
				tarjetaGiroTipoTarjeta = tarDebGirosNegocioDAO.consultaGiroTipoTarjeta(Enum_Con_GirosNegocioTipoTarjeta.giroNegocioTipoTar, tarDebGirosNegocioBean);
			break;
			}
		return tarjetaGiroTipoTarjeta;
	}
	public List lista(int tipoLista, TarDebGirosNegocioBean tarDebGirosNegocioBean){		
		List girosNegocioTipoTarjeta = null;
		switch (tipoLista) {	
			case Enum_Lis_GirosNegocioTipoTarjeta.listaNegociosTipoTar:		
				girosNegocioTipoTarjeta = tarDebGirosNegocioDAO.listaGiroTipoTarjeta(tarDebGirosNegocioBean, tipoLista);			
				break;			 
		}				
		return girosNegocioTipoTarjeta;
	}
	
	public List creaListaDetalle(TarDebGirosNegocioBean tarDebGirosNegocioBean) {
			
		List<String> giroID  = tarDebGirosNegocioBean.getLgiroID();

		ArrayList listaDetalle = new ArrayList();
		TarDebGirosNegocioBean giroNegocioTarjeta = null;	
		if(giroID != null){
			int tamanio = giroID.size();			
			for (int i = 0; i < tamanio; i++) {
				giroNegocioTarjeta = new TarDebGirosNegocioBean();
				giroNegocioTarjeta.setTipoTarjetaDebID(tarDebGirosNegocioBean.getTipoTarjetaDebID());
				giroNegocioTarjeta.setGiroID(giroID.get(i));
				listaDetalle.add(giroNegocioTarjeta);
			}
		}
		return listaDetalle;		
	}
	// --------------------getter y setter---------------------

	public TarDebGirosNegocioDAO getTarDebGirosNegocioDAO() {
		return tarDebGirosNegocioDAO;
	}

	public void setTarDebGirosNegocioDAO(TarDebGirosNegocioDAO tarDebGirosNegocioDAO) {
		this.tarDebGirosNegocioDAO = tarDebGirosNegocioDAO;
	}	
}