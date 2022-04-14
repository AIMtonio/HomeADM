package soporte.servicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import soporte.bean.InstitucionesBean;
import soporte.bean.OrganoDecisionBean;
import soporte.bean.OrganoIntegraBean;

import soporte.dao.OrganoDecisionDAO;
import soporte.servicio.InstitucionesServicio.Enum_Lis_Institucion;
import soporte.servicio.OrganoIntegraServicio.Enum_Lis_OrganoIntegra;

import java.util.List;

import originacion.bean.SolicitudCheckListBean;
import originacion.servicio.SolicitudCheckListServicio.Enum_Lis_SolCheckList;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio.Enum_Lis_Creditos;

public class OrganoDecisionServicio extends BaseServicio{

	OrganoDecisionDAO organoDecisionDAO =null;	

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_OrganoDecision {
		int alta = 1;
		int actualiza = 2;
		int baja = 3;
	}
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_OrganoDecision{
		int principal = 1;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_OrganoDecision {
		int grid = 1;
		int principal = 2;
		//int combo = 3;
	}

	public OrganoDecisionServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,OrganoDecisionBean organoDecisionBean) {
		MensajeTransaccionBean mensaje = null;		
		switch(tipoTransaccion){		
		case Enum_Tra_OrganoDecision.alta:
			mensaje = organoDecisionDAO.altaOrganoDecision(tipoTransaccion,organoDecisionBean);			
			break;	
		case Enum_Tra_OrganoDecision.actualiza:
			mensaje = organoDecisionDAO.actualizaOrganosDecision(organoDecisionBean,tipoTransaccion);			
			break;
		case Enum_Tra_OrganoDecision.baja:
			mensaje = organoDecisionDAO.bajaOrganosDecision(organoDecisionBean,tipoTransaccion);			
			break;
		}
		
		return mensaje;
	
	}
	//consulta
	public OrganoDecisionBean consulta(int tipoConsulta, OrganoDecisionBean organoDecisionBean){		
		OrganoDecisionBean organoDecision = null;
		switch(tipoConsulta){
			case Enum_Con_OrganoDecision.principal:
				organoDecision = organoDecisionDAO.consultaPrincipal(organoDecisionBean, tipoConsulta);
			break;
		}
		return organoDecision;
	}
	
		//lista para el grid				
	public List lista(int tipoLista, OrganoDecisionBean organoDecisionBean){		
		List listaOrgano = null;
		switch (tipoLista) {
			case Enum_Lis_OrganoDecision.grid:		
				listaOrgano = organoDecisionDAO.listaOrganoDecision(organoDecisionBean, tipoLista);				
				break;	
			case Enum_Lis_OrganoDecision.principal:		
				listaOrgano = organoDecisionDAO.listaOrganoDecision(organoDecisionBean, tipoLista);				
				break;	
		}		
		return listaOrgano;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {		
		List listaOrgano = null;
		switch(tipoLista){
		case Enum_Lis_OrganoDecision.grid:		
			listaOrgano = organoDecisionDAO.listaOrganoDecisionCombo(tipoLista);				
			break;
		}
		return listaOrgano.toArray();		
	}

// ---------------setter y getter----------------------------------
	public OrganoDecisionDAO getOrganoDecisionDAO() {
		return organoDecisionDAO;
	}

	public void setOrganoDecisionDAO(OrganoDecisionDAO organoDecisionDAO) {
		this.organoDecisionDAO = organoDecisionDAO;
	} 	
	
	
}
