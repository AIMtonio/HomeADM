package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import sms.bean.SMSCodigosRespBean;
import soporte.bean.OrganoIntegraBean;
import soporte.dao.OrganoIntegraDAO;



public class OrganoIntegraServicio extends BaseServicio {
	OrganoIntegraDAO organoIntegraDAO =null;	

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_OrganoIntegra {
		int alta = 1;
		int actualiza = 2;
		int baja = 3;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_OrganoIntegra {
		
		int principal = 1;
	}

	public OrganoIntegraServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,OrganoIntegraBean organoIntegraBean, String listaDatos) {
		MensajeTransaccionBean mensaje = null;	
	ArrayList listaPuestos = (ArrayList) creaListaPuestos(listaDatos);
	 switch(tipoTransaccion){		
		case Enum_Tra_OrganoIntegra.alta:
			mensaje = organoIntegraDAO.altaOrganoInetgra(tipoTransaccion,organoIntegraBean, listaPuestos);
			


			break;	
		}
		
		return mensaje;
	
	}
	
	
	//lista para el grid				
public List lista(int tipoLista, OrganoIntegraBean organoIntegraBean){		
	List listaOrganoIntegra = null;
	switch (tipoLista) {
		case Enum_Lis_OrganoIntegra.principal:		
			listaOrganoIntegra = organoIntegraDAO.listaOrganoIntegra(organoIntegraBean, tipoLista);				
			break;	
	}		
	return listaOrganoIntegra;
}


private List creaListaPuestos(String datoPuesto){		
	StringTokenizer tokensBean = new StringTokenizer(datoPuesto, "[");
	String stringCampos;
	String tokensCampos[];
	ArrayList listaPuestos = new ArrayList();
	OrganoIntegraBean organoIntegraBean;
	
	while(tokensBean.hasMoreTokens()){
		organoIntegraBean = new OrganoIntegraBean();
		
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");

		organoIntegraBean.setClavePuestoID(tokensCampos[0]);
		organoIntegraBean.setAsignado(tokensCampos[1]);
						
		listaPuestos.add(organoIntegraBean);
		
	}			
	return listaPuestos;
}




	
// ---------------setter y getter----------------------------------

	public OrganoIntegraDAO getOrganoIntegraDAO() {
		return organoIntegraDAO;
	}

	public void setOrganoIntegraDAO(OrganoIntegraDAO organoIntegraDAO) {
		this.organoIntegraDAO = organoIntegraDAO;
	}
}
