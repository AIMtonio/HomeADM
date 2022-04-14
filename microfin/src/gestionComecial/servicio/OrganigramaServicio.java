package gestionComecial.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import gestionComecial.bean.OrganigramaBean;
import gestionComecial.bean.OrganigramaDetalleBean;
import gestionComecial.dao.OrganigramaDAO;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import contabilidad.bean.DetallePolizaBean;
import contabilidad.bean.PolizaBean;
import contabilidad.servicio.PolizaServicio.Enum_Tra_Poliza;
import cuentas.bean.CuentasFirmaBean;

public class OrganigramaServicio extends BaseServicio {

	private OrganigramaServicio(){
		super();
	}

	OrganigramaDAO organigramaDAO = null;

	public static interface Enum_Lis_Organigrama{
		int alfanumerica = 1;
	}
	
	/*public static interface Enum_Con_Empleados{
		int principal = 1;
	}*/
	
	public static interface Enum_Tra_Organigrama {
		int alta = 1;
		int baja = 2;
		
	}

	
	public MensajeTransaccionBean grabaListaOrganigrama(int tipoTransaccion, OrganigramaBean organigramaBean, String organigramaDetalle){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaOrganigramaDetalle = (ArrayList) creaListaOrganigrama(organigramaBean, organigramaDetalle);
		switch(tipoTransaccion){
			case Enum_Tra_Organigrama.alta:
				mensaje = organigramaDAO.grabaListaOrganigrama(organigramaBean, listaOrganigramaDetalle);
				break;
			case Enum_Tra_Organigrama.baja:
				mensaje = organigramaDAO.grabaListaOrganigrama(organigramaBean, listaOrganigramaDetalle);
				break;
		}			
		return mensaje;		 
	}
	
	private List creaListaOrganigrama(OrganigramaBean organigrama, String Organigramadetalle){		
		StringTokenizer tokensBean = new StringTokenizer(Organigramadetalle, "]");
		
		String stringCampos;
		String tokensCampos[] = new String[3];
		ArrayList<OrganigramaBean> listaOrganigramaDetalle = new ArrayList<OrganigramaBean>();
		OrganigramaBean organigramaBean;
		
		while(tokensBean.hasMoreTokens()){
			organigramaBean = new OrganigramaBean();
		
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, ",");

			organigramaBean.setPuestoPadreID(organigrama.getPuestoPadreID());
			organigramaBean.setPuestoHijoID(tokensCampos[0]);
			organigramaBean.setCentroCostoID(tokensCampos[1]);
			if(organigrama.getRequiereCtaConta().equals("S")) {
				organigramaBean.setCtaContable(tokensCampos[2]);
			}else{
				organigramaBean.setCtaContable("");
			}
			organigramaBean.setRequiereCtaConta(organigrama.getRequiereCtaConta());

		
			listaOrganigramaDetalle.add(organigramaBean);
		}
		
		return listaOrganigramaDetalle;
	}
	
	public List lista(int tipoLista, OrganigramaBean organigrama){		
		List listaOrganigrama = null;
		switch (tipoLista) {
			case Enum_Lis_Organigrama.alfanumerica:		
				listaOrganigrama=  organigramaDAO.listaAlfanumerica(organigrama, Enum_Lis_Organigrama.alfanumerica);				
				break;	
		}		
		return listaOrganigrama;
	}
	
		
	public void setOrganigramaDAO(OrganigramaDAO organigramaDAO ){
		this.organigramaDAO = organigramaDAO;
	}

	public OrganigramaDAO getOrganigramaDAO() {
		return organigramaDAO;
	}

}


