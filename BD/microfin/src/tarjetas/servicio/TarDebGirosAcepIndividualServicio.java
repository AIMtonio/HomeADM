package tarjetas.servicio;


import java.util.ArrayList;
import java.util.List;

import tarjetas.bean.TarDebGirosAcepIndividualBean;
import tarjetas.dao.TarDebGirosAcepIndividualDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TarDebGirosAcepIndividualServicio extends BaseServicio {
	TarDebGirosAcepIndividualDAO tarDebGirosAcepIndividualDAO = null;

	public TarDebGirosAcepIndividualServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_Tra_GirosTarjetaIndividual {
		int altaLista					=1;
		int modificaLista				=2;
	}
	  
	public static interface Enum_Lis_GirosTarjetaIndividual{
		int listaGirosTarjIndiv    = 2;
	}
	public static interface Enum_Con_GirosTarjetaIndividual{
        int giroTarDebIndiv		   =14;
	}
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean){
		ArrayList listaGirosTarIndividual = (ArrayList) creaListaDetalle(tarDebGirosAcepIndividualBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch(tipoTransaccion){		
	    	case Enum_Tra_GirosTarjetaIndividual.altaLista:
	    		mensaje = tarDebGirosAcepIndividualDAO.grabaGiroTarIndividual(tarDebGirosAcepIndividualBean,listaGirosTarIndividual);
	    		break;
	    case Enum_Tra_GirosTarjetaIndividual.modificaLista:
			   mensaje = tarDebGirosAcepIndividualDAO.modgiroTarjetaIndividual(tarDebGirosAcepIndividualBean,listaGirosTarIndividual);
			break;
		}
		return mensaje;
	}

	public TarDebGirosAcepIndividualBean consulta(int tipoConsulta, TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean){
		TarDebGirosAcepIndividualBean tarjetaAceptadosIndividual = null;
		switch(tipoConsulta){
			case Enum_Con_GirosTarjetaIndividual.giroTarDebIndiv:
				tarjetaAceptadosIndividual = tarDebGirosAcepIndividualDAO.consultaTarjetaIndividual(tipoConsulta, tarDebGirosAcepIndividualBean);
			break;
			}
		return tarjetaAceptadosIndividual;
	}
	public List lista(int tipoLista, TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean){
		List girosTarjetasIndiv = null;
		switch (tipoLista) {
			case Enum_Lis_GirosTarjetaIndividual.listaGirosTarjIndiv:
				girosTarjetasIndiv = tarDebGirosAcepIndividualDAO.listaGirosTarjIndividual(tarDebGirosAcepIndividualBean, tipoLista);
				break;
		}
		return girosTarjetasIndiv;
	}
	
	public List creaListaDetalle(TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean) {
			
		List<String> giroID  = tarDebGirosAcepIndividualBean.getLgiroID();

		ArrayList listaDetalle = new ArrayList();
		TarDebGirosAcepIndividualBean giroTarIndiv = null;	
		if(giroID != null){
			int tamanio = giroID.size();			
			for (int i = 0; i < tamanio; i++) {
				giroTarIndiv = new TarDebGirosAcepIndividualBean();
				giroTarIndiv.setTarjetaID(tarDebGirosAcepIndividualBean.getTarjetaID());
				giroTarIndiv.setGiroID(giroID.get(i));
				listaDetalle.add(giroTarIndiv);
			}
		}
		return listaDetalle;		
	}
	// --------------------getter y setter---------------------
	public TarDebGirosAcepIndividualDAO getTarDebGirosAcepIndividualDAO() {
		return tarDebGirosAcepIndividualDAO;
	}

	public void setTarDebGirosAcepIndividualDAO(
			TarDebGirosAcepIndividualDAO tarDebGirosAcepIndividualDAO) {
		this.tarDebGirosAcepIndividualDAO = tarDebGirosAcepIndividualDAO;
	}

}

