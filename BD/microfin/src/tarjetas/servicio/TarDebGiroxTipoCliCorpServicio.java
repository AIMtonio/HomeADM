package tarjetas.servicio;

import java.util.ArrayList;
import java.util.List;

import tarjetas.bean.TarDebGiroxTipoCliCorpBean;
import tarjetas.dao.TarDebGiroxTipoCliCorpDAO;
import tarjetas.servicio.TarDebGirosAcepIndividualServicio.Enum_Tra_GirosTarjetaIndividual;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TarDebGiroxTipoCliCorpServicio extends BaseServicio{	
	TarDebGiroxTipoCliCorpDAO tarDebGiroxTipoCliCorpDAO=null;

	public TarDebGiroxTipoCliCorpServicio() {
		super();
	}
	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Tra_GiroNegocioTar {
		int alta = 1;
		int modificacion=2;
	}
	public static interface Enum_Lis_GiroNegocioTar {
		int listaGiroNegocioTarxTipoContrato = 1;
	}
	public static interface Enum_Baj_GiroNegocioTar {
		int bajaPorGiro = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,	TarDebGiroxTipoCliCorpBean tarDebGiroxTipoCliCorpBean){
	
		ArrayList listaGiroNegocio = (ArrayList) creaListaDetalle(tarDebGiroxTipoCliCorpBean);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_GiroNegocioTar.alta:		
				mensaje = tarDebGiroxTipoCliCorpDAO.grabaGiroNegocio(tarDebGiroxTipoCliCorpBean,listaGiroNegocio);									
				break;	
			case Enum_Tra_GiroNegocioTar.modificacion:
		   mensaje = tarDebGiroxTipoCliCorpDAO.modificarGiroNegocio(tarDebGiroxTipoCliCorpBean,listaGiroNegocio);
		   		break;
		
		}
	
		return mensaje;
	}
	public List lista(int tipoLista,TarDebGiroxTipoCliCorpBean tarDebGiroxTipoCliCorpBean){		
		List TarDebGiroxTipoCliCorp = null;
		switch (tipoLista) {	
			case Enum_Lis_GiroNegocioTar.listaGiroNegocioTarxTipoContrato:		
				TarDebGiroxTipoCliCorp = tarDebGiroxTipoCliCorpDAO.listaTarDebGiroXtipoTar(tarDebGiroxTipoCliCorpBean, tipoLista);			
				break;			 
		}				
		return TarDebGiroxTipoCliCorp;
	}
	
	
	public List creaListaDetalle(TarDebGiroxTipoCliCorpBean tarDebGiroxTipoCliCorpBean) {
			List<String> giro  = tarDebGiroxTipoCliCorpBean.getLnumGiro();
	ArrayList listaDetalle = new ArrayList();
		TarDebGiroxTipoCliCorpBean giroNegocio = null;	
		if(giro != null){
			int tamanio = giro.size();			
			for (int i = 0; i < tamanio; i++) {
				giroNegocio = new TarDebGiroxTipoCliCorpBean();
				giroNegocio.setTipoTarjetaDebID(tarDebGiroxTipoCliCorpBean.getTipoTarjetaDebID());
				giroNegocio.setCoorporativo(tarDebGiroxTipoCliCorpBean.getCoorporativo());
				giroNegocio.setGiroID(giro.get(i));
				listaDetalle.add(giroNegocio);
			}
			
		}
	return listaDetalle;
		
	}
	
	//------------getter y setter--------------

	public TarDebGiroxTipoCliCorpDAO getTarDebGiroxTipoCliCorpDAO() {
		return tarDebGiroxTipoCliCorpDAO;
	}
	public void setTarDebGiroxTipoCliCorpDAO(
			TarDebGiroxTipoCliCorpDAO tarDebGiroxTipoCliCorpDAO) {
		this.tarDebGiroxTipoCliCorpDAO = tarDebGiroxTipoCliCorpDAO;
	}
}
