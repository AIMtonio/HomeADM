package cobranza.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import cobranza.bean.AsignaCarteraBean;
import cobranza.bean.RepCarteraCobranzaBean;
import cobranza.dao.AsignaCarteraDAO;

public class AsignaCarteraServicio extends BaseServicio {
	AsignaCarteraDAO asignaCarteraDAO = null;
	
	public static interface Enum_Trans_AsignaCartera{
		int asignar 	= 1;
	}
	
	public static interface Enum_Lis_CreditosGrid{
		int principal = 1;
		int consulta = 2;
	}

	public static interface Enum_Rep_AsignaCartera{
		int excelRep = 1;		// Reporte Asignaciones cobranza
		int excelRepGestor = 2;	// Reporte Asignacion por gestor
		int excelRepCartera = 3;// Reporte Cartera por cobranza
	}
	
	public static interface Enum_Con_AsignaCartera{
		int principal = 1;
	}
	
	public static interface Enum_Lis_Asignaciones{
		int principal = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,AsignaCarteraBean asignaCartera, String credAsig){
		MensajeTransaccionBean mensaje = null;
		ArrayList ListaBeanCredAsig =(ArrayList) creaListaDetalle(credAsig);
		switch (tipoTransaccion) {
			case Enum_Trans_AsignaCartera.asignar:
				mensaje= asignaCarteraDAO.altaAsignacionCreditos(asignaCartera,ListaBeanCredAsig);
				break;
		}
		return mensaje;
	}
	
	private List creaListaDetalle(String credAsig){		
		StringTokenizer tokensBean = new StringTokenizer(credAsig, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDetalleCred = new ArrayList();
		AsignaCarteraBean credAsigna;
		while(tokensBean.hasMoreTokens()){
				credAsigna = new AsignaCarteraBean();
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			credAsigna.setClienteID(tokensCampos[0]);
			credAsigna.setCreditoID(tokensCampos[1]);
			credAsigna.setEstatusCred(tokensCampos[2]);	
			credAsigna.setDiasAtraso(tokensCampos[3]);	
			credAsigna.setMontoCredito(tokensCampos[4]);
			
			credAsigna.setFechaDesembolso(tokensCampos[5]);	
			credAsigna.setFechaVencimien(tokensCampos[6]);	
			credAsigna.setSaldoCapital(tokensCampos[7]);	
			credAsigna.setSaldoInteres(tokensCampos[8]);	
			credAsigna.setSaldoMoratorio(tokensCampos[9]);
				
			credAsigna.setSucursalID(tokensCampos[10]);	
			credAsigna.setNombreCompleto(tokensCampos[11]);	
			credAsigna.setAsignado(tokensCampos[12]);
			
			listaDetalleCred.add(credAsigna);
		}
		return listaDetalleCred;
	}
	
	public List listaGrid(int tipoLista,AsignaCarteraBean asignaCartera){		
		List listaCred = null;
		switch(tipoLista){
		case Enum_Lis_CreditosGrid.principal:
			listaCred = asignaCarteraDAO.listaAsignaCreditos(tipoLista,asignaCartera);
			break;
		case Enum_Lis_CreditosGrid.consulta:
			listaCred = asignaCarteraDAO.listaAsignaCreditos(tipoLista,asignaCartera);
			break;
		}

		return listaCred;
	}
	
	public AsignaCarteraBean consulta(int tipoConsulta, AsignaCarteraBean asignaCartera){
		AsignaCarteraBean asigna = null;
		
		switch(tipoConsulta){
			case Enum_Con_AsignaCartera.principal:
				asigna = asignaCarteraDAO.consultaPrincipal(tipoConsulta,asignaCartera);
				break;
		}
		
		return asigna;
	}	

	public List listaCreditosAsignados(int tipoLista,AsignaCarteraBean asignaCartera){		
		List listaCred = null;
		switch(tipoLista){
		case Enum_Rep_AsignaCartera.excelRep:
			listaCred = asignaCarteraDAO.reporteCreditosAsignados(tipoLista,asignaCartera);
			break;
		}

		return listaCred;
	}
	
	
	public List lista(int tipoLista,AsignaCarteraBean asignacion){
		List listaAsigna = null;
			
		switch(tipoLista){
			case Enum_Lis_Asignaciones.principal:
				listaAsigna = asignaCarteraDAO.listaAsignacion(tipoLista,asignacion);
				break;
		}
		return listaAsigna;
	}
	
	public List listaCarteraCobranza(int tipoLista,RepCarteraCobranzaBean repCarteraCobranzaBean){	
		
		
		List listaCred = null;
		switch(tipoLista){
		case Enum_Rep_AsignaCartera.excelRep:
			listaCred = asignaCarteraDAO.reporteCarteraCobranza(tipoLista,repCarteraCobranzaBean);
			break;
		}

		return listaCred;
	}
	
	

	public AsignaCarteraDAO getAsignaCarteraDAO() {
		return asignaCarteraDAO;
	}

	public void setAsignaCarteraDAO(AsignaCarteraDAO asignaCarteraDAO) {
		this.asignaCarteraDAO = asignaCarteraDAO;
	}
	
	
}
