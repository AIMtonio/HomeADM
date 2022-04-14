package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.AvalesPorSoliciBean;
import credito.bean.AvalesPorSoliciDetalleBean;
import credito.dao.AvalesPorSoliciDAO;

public class AvalesPorSoliciServicio extends BaseServicio {

	private AvalesPorSoliciServicio(){ 
		super();
	}

	AvalesPorSoliciDAO avalesPorSoliciDAO = null;
	
	
	public static interface Enum_Lis_avales{
		int alfanumerica = 1;
		int listReestructura = 2;
	}
	
	public static interface Enum_Con_Avales{
		int principal = 1;
	}
	
	public static interface Enum_Tra_Avales {
		int alta = 1;
		int baja = 2;
		int altaReestructura = 3;
		
	}
	
	public static interface Enum_Baj_Avales {
		int AvPorSol	= 1;	
		int AvPorSolReest	= 2;
	}

	
	public MensajeTransaccionBean grabaListaAvales(int tipoTransaccion, AvalesPorSoliciBean avalesPorSoliciBean, String integraDetalle){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		
		switch(tipoTransaccion){
			case Enum_Tra_Avales.alta:
				ArrayList listaAvalesDetalle = (ArrayList) creaListaAvales(avalesPorSoliciBean, integraDetalle);
				mensaje = avalesPorSoliciDAO.grabaListaAvales(avalesPorSoliciBean, listaAvalesDetalle, Enum_Baj_Avales.AvPorSol);
				break;
			case Enum_Tra_Avales.altaReestructura:
				ArrayList listaAvalesDetalleReest = (ArrayList) creaListaAvalesReest(avalesPorSoliciBean, integraDetalle);
				mensaje = avalesPorSoliciDAO.grabaListaAvalesReest(avalesPorSoliciBean, listaAvalesDetalleReest, Enum_Baj_Avales.AvPorSolReest);
				break;
		}
		return mensaje;
	}
	
	public AvalesPorSoliciDetalleBean consulta(int tipoConsulta, AvalesPorSoliciDetalleBean avalesBean){
		AvalesPorSoliciDetalleBean avales = null;
		switch(tipoConsulta){
			case Enum_Con_Avales.principal:
				avales = avalesPorSoliciDAO.consultaPrincipal(avalesBean, Enum_Con_Avales.principal);
			break;
		}
		return avales;
	}
	
	private List creaListaAvales(AvalesPorSoliciBean integra, String IntegraDetalle){
		StringTokenizer tokensBean = new StringTokenizer(IntegraDetalle, "[");
		
		String stringCampos;
		String tokensCampos[];
		ArrayList listaAvalesDetalle = new ArrayList();
		AvalesPorSoliciBean avalesPorSoliciBean;
		
		while(tokensBean.hasMoreTokens()){
			avalesPorSoliciBean = new AvalesPorSoliciBean();
		
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
		avalesPorSoliciBean.setSolicitudCreditoID(tokensCampos[0]);
		avalesPorSoliciBean.setAvalID(tokensCampos[1]);
		avalesPorSoliciBean.setClienteID(tokensCampos[2]);
		avalesPorSoliciBean.setProspectoID(tokensCampos[3]);
		avalesPorSoliciBean.setTiempoConocido(tokensCampos[4]);
		avalesPorSoliciBean.setParentescoID(tokensCampos[5]);
		listaAvalesDetalle.add(avalesPorSoliciBean);
		}
		
		return listaAvalesDetalle;
	}
	
	private List creaListaAvalesReest(AvalesPorSoliciBean integra, String IntegraDetalle){
		StringTokenizer tokensBean = new StringTokenizer(IntegraDetalle, "[");
		
		String stringCampos;
		String tokensCampos[];
		ArrayList listaAvalesDetalle = new ArrayList();
		AvalesPorSoliciBean avalesPorSoliciBean;
		
		while(tokensBean.hasMoreTokens()){
			avalesPorSoliciBean = new AvalesPorSoliciBean();
		
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

		avalesPorSoliciBean.setSolicitudCreditoID(tokensCampos[0]);
		avalesPorSoliciBean.setAvalID(tokensCampos[1]);
		avalesPorSoliciBean.setClienteID(tokensCampos[2]);
		avalesPorSoliciBean.setProspectoID(tokensCampos[3]);
		avalesPorSoliciBean.setEstatusSolicitud(tokensCampos[4]);
		avalesPorSoliciBean.setTiempoConocido(tokensCampos[5]);
		avalesPorSoliciBean.setParentescoID(tokensCampos[6]);
		
		listaAvalesDetalle.add(avalesPorSoliciBean);
		}
		
		return listaAvalesDetalle;
	}
	
	
	
	public List lista(int tipoLista, AvalesPorSoliciBean avales){		
		List listaAvales = null;
		switch (tipoLista) {
			case Enum_Lis_avales.alfanumerica:		
				listaAvales=  avalesPorSoliciDAO.listaAlfanumerica(avales, Enum_Lis_avales.alfanumerica);				
				break;
			case Enum_Lis_avales.listReestructura:		
				listaAvales=  avalesPorSoliciDAO.listaAvalesReest(avales, Enum_Lis_avales.listReestructura);				
				break;	
		}		
		return listaAvales;
	}

	

	public AvalesPorSoliciDAO getAvalesPorSoliciDAO() {
		return avalesPorSoliciDAO;
	}

	public void setAvalesPorSoliciDAO(AvalesPorSoliciDAO avalesPorSoliciDAO) {
		this.avalesPorSoliciDAO = avalesPorSoliciDAO;
	}
	
	
}
