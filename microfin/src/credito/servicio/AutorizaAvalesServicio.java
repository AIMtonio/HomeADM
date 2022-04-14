package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.AutorizaAvalesBean;
import credito.dao.AutorizaAvalesDAO;
import credito.servicio.AvalesPorSoliciServicio.Enum_Lis_avales;

public class AutorizaAvalesServicio extends BaseServicio {

	private AutorizaAvalesServicio(){
		super();
	}

	AutorizaAvalesDAO autorizaAvalesDAO = null;
	
	
	public static interface Enum_Lis_avales{
		int alfanumerica = 1;
		int listReestructura = 2;
	}
	
	/*public static interface Enum_Con_Empleados{
		int principal = 1;
	}*/
	
	public static interface Enum_Tra_Avales {
		int alta = 1;
		int baja = 2;
		int actualiza = 3;
		
	}
	
	public static interface Enum_Baj_Avales {
		int AvPorSol	= 1;
	}

	
	public MensajeTransaccionBean grabaListaAvales(int tipoTransaccion, AutorizaAvalesBean autorizaAvalesBean, String integraDetalle){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaAvalesDetalle = (ArrayList) creaListaAvales(autorizaAvalesBean, integraDetalle);
		switch(tipoTransaccion){
			case Enum_Tra_Avales.alta:
				mensaje = autorizaAvalesDAO.grabaListaAvales(autorizaAvalesBean, listaAvalesDetalle, Enum_Baj_Avales.AvPorSol);
				break;
			case Enum_Tra_Avales.actualiza:
				mensaje = autorizaAvalesDAO.actualizaListaAvales(autorizaAvalesBean, listaAvalesDetalle, Enum_Baj_Avales.AvPorSol);
				break;
		}
		return mensaje;
	}
	
	private List creaListaAvales(AutorizaAvalesBean integra, String IntegraDetalle){		
		StringTokenizer tokensBean = new StringTokenizer(IntegraDetalle, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaAvalesDetalle = new ArrayList();
		AutorizaAvalesBean autorizaAvalesBean;
		
		while(tokensBean.hasMoreTokens()){
			autorizaAvalesBean = new AutorizaAvalesBean();
		
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

		autorizaAvalesBean.setSolicitudCreditoID(tokensCampos[0]);
		autorizaAvalesBean.setAvalID(tokensCampos[1]);
		autorizaAvalesBean.setClienteID(tokensCampos[2]);
		autorizaAvalesBean.setProspectoID(tokensCampos[3]);
		autorizaAvalesBean.setTiempoConocido(tokensCampos[4]);
		autorizaAvalesBean.setParentescoID(tokensCampos[5]);
		
		
		listaAvalesDetalle.add(autorizaAvalesBean);
		}
		
		return listaAvalesDetalle;
	}
	
	public List lista(int tipoLista, AutorizaAvalesBean avales){		
		List listaAvales = null;
		switch (tipoLista) {
			case Enum_Lis_avales.alfanumerica:		
				listaAvales=  autorizaAvalesDAO.listaAlfanumerica(avales, Enum_Lis_avales.alfanumerica);				
				break;	
			case Enum_Lis_avales.listReestructura:		
				listaAvales=  autorizaAvalesDAO.listaAvalesReest(avales, Enum_Lis_avales.listReestructura);				
				break;	
		}		
		return listaAvales;
	}

	public AutorizaAvalesDAO getAutorizaAvalesDAO() {
		return autorizaAvalesDAO;
	}

	public void setAutorizaAvalesDAO(AutorizaAvalesDAO autorizaAvalesDAO) {
		this.autorizaAvalesDAO = autorizaAvalesDAO;
	}

	

	
}

