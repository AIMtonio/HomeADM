package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.OblSolidariosPorSoliciBean;
import credito.bean.ObliSolidariosPorSoliciDetalleBean;
import credito.dao.OblSolidariosPorSoliciDAO;
import credito.servicio.AvalesPorSoliciServicio.Enum_Lis_avales;

public class OblSoliPorSoliciServicio extends BaseServicio {

	private OblSoliPorSoliciServicio(){ 
		super();
	}

	OblSolidariosPorSoliciDAO	 oblSolidariosPorSoliciDAO = null;
	
	
	public static interface Enum_Lis_oblSolidarios{
		int alfanumerica = 1;
		int listReestructura = 2;
	}
	
	public static interface Enum_Con_OblSolidarios{
		int principal = 1;
	}
	
	public static interface Enum_Tra_OblSolidarios {
		int alta = 1;
		int baja = 2;
		int altaReestructura = 3;
		
	}
	
	public static interface Enum_Baj_OblSolidarios {
		int AvPorSol	= 1;	
		int AvPorSolReest	= 2;
	}

	
	public MensajeTransaccionBean grabaListaOblSolidarios(int tipoTransaccion, OblSolidariosPorSoliciBean oblSolidariosPorSoliciBean, String integraDetalle){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		switch(tipoTransaccion){
			case Enum_Tra_OblSolidarios.alta:
				ArrayList listaOblSolidariosDetalle = (ArrayList) creaListaOblSolidarios(oblSolidariosPorSoliciBean, integraDetalle);
				mensaje = oblSolidariosPorSoliciDAO.grabaListaObligadosSolidarios(oblSolidariosPorSoliciBean, listaOblSolidariosDetalle, Enum_Baj_OblSolidarios.AvPorSol);
				break;
			case Enum_Tra_OblSolidarios.altaReestructura:
				ArrayList listaAvalesDetalleReest = (ArrayList) creaListaOblSolidariosRess(oblSolidariosPorSoliciBean, integraDetalle);
				mensaje = oblSolidariosPorSoliciDAO.grabaListaObligadosSolidarios(oblSolidariosPorSoliciBean, listaAvalesDetalleReest, Enum_Baj_OblSolidarios.AvPorSolReest);
				break;
		}
		return mensaje;
	}
	
	public ObliSolidariosPorSoliciDetalleBean consulta(int tipoConsulta, ObliSolidariosPorSoliciDetalleBean avalesBean){
		ObliSolidariosPorSoliciDetalleBean avales = null;
		switch(tipoConsulta){
			case Enum_Con_OblSolidarios.principal:
				avales = oblSolidariosPorSoliciDAO.consultaPrincipal(avalesBean, Enum_Con_OblSolidarios.principal);
			break;
		}
		return avales;
	}
	
	private List creaListaOblSolidarios(OblSolidariosPorSoliciBean integra, String IntegraDetalle){
		StringTokenizer tokensBean = new StringTokenizer(IntegraDetalle, "[");
		
		String stringCampos;
		String tokensCampos[];
		ArrayList listaOblSolidariossDetalle = new ArrayList();
		OblSolidariosPorSoliciBean oblSolidariosPorSoliciBean;
		
		while(tokensBean.hasMoreTokens()){
			oblSolidariosPorSoliciBean = new OblSolidariosPorSoliciBean();
		
	
		
		
			
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
		
		
		
		oblSolidariosPorSoliciBean.setSolicitudCreditoID(tokensCampos[0]);
		oblSolidariosPorSoliciBean.setOblSolidID(tokensCampos[1]);
		oblSolidariosPorSoliciBean.setClienteID(tokensCampos[2]);
		oblSolidariosPorSoliciBean.setProspectoID(tokensCampos[3]);
		oblSolidariosPorSoliciBean.setTiempoConocido(tokensCampos[4]);
		oblSolidariosPorSoliciBean.setParentescoID(tokensCampos[5]);
		listaOblSolidariossDetalle.add(oblSolidariosPorSoliciBean);
		}
		
		
		
		return listaOblSolidariossDetalle;
	}
	
	
	private List creaListaOblSolidariosRess(OblSolidariosPorSoliciBean integra, String IntegraDetalle){
		StringTokenizer tokensBean = new StringTokenizer(IntegraDetalle, "[");
		
		String stringCampos;
		String tokensCampos[];
		ArrayList listaOblSolidariossDetalle = new ArrayList();
		OblSolidariosPorSoliciBean oblSolidariosPorSoliciBean;
		
		while(tokensBean.hasMoreTokens()){
			oblSolidariosPorSoliciBean = new OblSolidariosPorSoliciBean();
		
	
		
		
			
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
		
	
		
		oblSolidariosPorSoliciBean.setSolicitudCreditoID(tokensCampos[0]);
		oblSolidariosPorSoliciBean.setOblSolidID(tokensCampos[1]);
		oblSolidariosPorSoliciBean.setClienteID(tokensCampos[2]);
		oblSolidariosPorSoliciBean.setProspectoID(tokensCampos[3]);
		oblSolidariosPorSoliciBean.setTiempoConocido(tokensCampos[5]);
		oblSolidariosPorSoliciBean.setParentescoID(tokensCampos[6]);
		
		
		
		listaOblSolidariossDetalle.add(oblSolidariosPorSoliciBean);
		}
		return listaOblSolidariossDetalle;
	}
	
	
	
	
	
	private List creaListaAvalesReest(OblSolidariosPorSoliciBean integra, String IntegraDetalle){
		StringTokenizer tokensBean = new StringTokenizer(IntegraDetalle, "[");
		
		String stringCampos;
		String tokensCampos[];
		ArrayList listaAvalesDetalle = new ArrayList();
		OblSolidariosPorSoliciBean oblSolidariosPorSoliciBean;
		
		while(tokensBean.hasMoreTokens()){
			oblSolidariosPorSoliciBean = new OblSolidariosPorSoliciBean();
		
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

		oblSolidariosPorSoliciBean.setSolicitudCreditoID(tokensCampos[0]);
		oblSolidariosPorSoliciBean.setOblSolidID(tokensCampos[1]);
		oblSolidariosPorSoliciBean.setClienteID(tokensCampos[2]);
		oblSolidariosPorSoliciBean.setProspectoID(tokensCampos[3]);
		oblSolidariosPorSoliciBean.setEstatusSolicitud(tokensCampos[4]);
		oblSolidariosPorSoliciBean.setTiempoConocido(tokensCampos[5]);
		oblSolidariosPorSoliciBean.setParentescoID(tokensCampos[6]);
		
		listaAvalesDetalle.add(oblSolidariosPorSoliciBean);
		}
		
		return listaAvalesDetalle;
	}
	
	
	
	public List lista(int tipoLista, OblSolidariosPorSoliciBean oblSolid){		
		List listaAvales = null;
		switch (tipoLista) {
			case Enum_Lis_oblSolidarios.alfanumerica:		
				listaAvales=  oblSolidariosPorSoliciDAO.listaAlfanumerica(oblSolid, Enum_Lis_oblSolidarios.alfanumerica);				
				break;
			case Enum_Lis_oblSolidarios.listReestructura:		
				listaAvales=  oblSolidariosPorSoliciDAO.listaOblSolidReest(oblSolid, Enum_Lis_oblSolidarios.listReestructura);				
				break;	
		}		
		return listaAvales;
	}

	

	public OblSolidariosPorSoliciDAO getOblSolidariosPorSoliciDAO() {
		return oblSolidariosPorSoliciDAO;
	}

	public void setOblSolidariosPorSoliciDAO(OblSolidariosPorSoliciDAO oblSolidariosPorSoliciDAO) {
		this.oblSolidariosPorSoliciDAO = oblSolidariosPorSoliciDAO;
	}
	
	
}