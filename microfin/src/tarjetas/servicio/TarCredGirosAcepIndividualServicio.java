package tarjetas.servicio;


import java.util.ArrayList;
import java.util.List;


import tarjetas.bean.TarCredGirosAcepIndividualBean;
import tarjetas.bean.TarDebGirosAcepIndividualBean;
import tarjetas.dao.TarCredGirosAcepIndividualDAO;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TarCredGirosAcepIndividualServicio extends BaseServicio {
	TarCredGirosAcepIndividualDAO tarCredGirosAcepIndividualDAO = null;

	public TarCredGirosAcepIndividualServicio() {
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
        int giroTarDebIndiv		   =5;
	}
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TarDebGirosAcepIndividualBean tarDebGirosAcepIndividualBean){
		ArrayList listaGirosTarIndividual = (ArrayList) creaListaDetalle(tarDebGirosAcepIndividualBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch(tipoTransaccion){		
	    	case Enum_Tra_GirosTarjetaIndividual.altaLista:
	    		mensaje = tarCredGirosAcepIndividualDAO.grabaGiroTarcCredIndividual(tarDebGirosAcepIndividualBean,listaGirosTarIndividual);
	    		break;
	    	case Enum_Tra_GirosTarjetaIndividual.modificaLista:
				   mensaje = tarCredGirosAcepIndividualDAO.modgiroTarjetaIndividual(tarDebGirosAcepIndividualBean,listaGirosTarIndividual);
				break;
	
		}
		return mensaje;
	}
	
	public TarCredGirosAcepIndividualBean consulta(int tipoConsulta, TarCredGirosAcepIndividualBean tarCredGirosAcepIndividualBean){
		TarCredGirosAcepIndividualBean tarjetaAceptadosIndividual = null;
		switch(tipoConsulta){
			case Enum_Con_GirosTarjetaIndividual.giroTarDebIndiv:
				tarjetaAceptadosIndividual = tarCredGirosAcepIndividualDAO.consultaTarjetaIndividual(tipoConsulta, tarCredGirosAcepIndividualBean);
			break;
			}
		return tarjetaAceptadosIndividual;
	}

	public List lista(int tipoLista, TarCredGirosAcepIndividualBean tarCredGirosAcepIndividualBean){
		List girosTarjetasIndiv = null;
		switch (tipoLista) {
			case Enum_Lis_GirosTarjetaIndividual.listaGirosTarjIndiv:
				girosTarjetasIndiv = tarCredGirosAcepIndividualDAO.listaGirosTarjIndividual(tarCredGirosAcepIndividualBean, tipoLista);
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
	public TarCredGirosAcepIndividualDAO getTarCredGirosAcepIndividualDAO() {
		return tarCredGirosAcepIndividualDAO;
	}
	public void setTarCredGirosAcepIndividualDAO(
			TarCredGirosAcepIndividualDAO tarCredGirosAcepIndividualDAO) {
		this.tarCredGirosAcepIndividualDAO = tarCredGirosAcepIndividualDAO;
	}

	
	
	
}

