package fira.servicio;

import java.util.List;
import java.util.ArrayList;
import java.util.StringTokenizer;


import fira.bean.ConceptosInversionAgroBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import fira.dao.ConceptosInversionAgroDAO;
public class ConceptosInversionAgroServicio extends BaseServicio{

	ConceptosInversionAgroDAO conceptosInversionAgroDAO = null;
	
	public ConceptosInversionAgroServicio() {
		// TODO Auto-generated constructor stub
	}

	public static interface Enum_Tra_ConceptosInversion {
		int altaPrestamo 		= 1;
		int altaSolicitante 	= 2;
		int altaOtrasFuentes 	= 3;
		int bajaPrestamo	 	= 4;
		int bajaSolicitante   	= 5;
		int bajaOtrasFuentes  	= 6;
	}
	
	public static interface Enum_Con_ConceptosInversion {
		int principal 	= 1;
		int fecha	 	= 2;
	}

	public static interface Enum_Lis_ConceptosInversion {
		int prestamo 		= 1;
		int solicitante 	= 2;
		int otraFuentes 	= 3;
	}
	
	public static interface Enum_Lis_TiposRrcurso {
		String tipoRecursoPrestamo		="P";
		String tipoRecursoSolicitante	="S";
		String tipoRecursoOtrasF		="OF";
	}

	
	// Graba transaccion
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConceptosInversionAgroBean conceptosInversion, String listaGridPrestamo, 
			String listaGridSolicita,String listaGridOtrasFuentes){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		
		case Enum_Tra_ConceptosInversion.altaPrestamo:
			 ArrayList listaRegistroGrid = (ArrayList) creaListaGrid(listaGridPrestamo);
			 conceptosInversion.setTipoRecurso(Enum_Lis_TiposRrcurso.tipoRecursoPrestamo);
			 mensaje = conceptosInversionAgroDAO.actualizaListaGrid(conceptosInversion,listaRegistroGrid);
		break;
		
		case Enum_Tra_ConceptosInversion.altaSolicitante:
			 ArrayList listaRegistroGridSol = (ArrayList) creaListaGrid(listaGridSolicita);
			 conceptosInversion.setTipoRecurso(Enum_Lis_TiposRrcurso.tipoRecursoSolicitante);
			 mensaje = conceptosInversionAgroDAO.actualizaListaGrid(conceptosInversion,listaRegistroGridSol);
		break;
		
		case Enum_Tra_ConceptosInversion.altaOtrasFuentes:
			 ArrayList listaRegistroGridOF = (ArrayList) creaListaGrid(listaGridOtrasFuentes);
			 conceptosInversion.setTipoRecurso(Enum_Lis_TiposRrcurso.tipoRecursoOtrasF);
			 mensaje = conceptosInversionAgroDAO.actualizaListaGrid(conceptosInversion,listaRegistroGridOF);
		break;
		
		case Enum_Tra_ConceptosInversion.bajaPrestamo:
			 conceptosInversion.setTipoRecurso(Enum_Lis_TiposRrcurso.tipoRecursoPrestamo);
			 mensaje = conceptosInversionAgroDAO.bajaElementoGrid(conceptosInversion);
			 
		break;
		
		case Enum_Tra_ConceptosInversion.bajaSolicitante:		
			 conceptosInversion.setTipoRecurso(Enum_Lis_TiposRrcurso.tipoRecursoSolicitante);
			 mensaje = conceptosInversionAgroDAO.bajaElementoGrid(conceptosInversion);
		break;
		
		case Enum_Tra_ConceptosInversion.bajaOtrasFuentes:
			 conceptosInversion.setTipoRecurso(Enum_Lis_TiposRrcurso.tipoRecursoOtrasF);
			 mensaje = conceptosInversionAgroDAO.bajaElementoGrid(conceptosInversion);
		break;
		
		}
		return mensaje;
	}
	
	// consulta de cvatalogo concepto de inversion
	public ConceptosInversionAgroBean consulta( ConceptosInversionAgroBean conceptosInversion,int tipoConsulta){
		ConceptosInversionAgroBean conceptosBean = null;
		switch (tipoConsulta) {
		case Enum_Con_ConceptosInversion.principal:	
			conceptosBean = conceptosInversionAgroDAO.consultaConcepto(conceptosInversion, tipoConsulta);				
			break;	
		
		case Enum_Con_ConceptosInversion.fecha:	
			conceptosBean = conceptosInversionAgroDAO.consultaFecha(conceptosInversion, tipoConsulta);				
			break;	
		}	
		
		return conceptosBean;
	}
	
	//Lista para el grid 
	public List listaConcetosInv(ConceptosInversionAgroBean conceptosInversion, int tipoLista){
		List listaParametros = null;
		
		switch(tipoLista){
			case Enum_Lis_ConceptosInversion.prestamo:
				listaParametros = conceptosInversionAgroDAO.listaConceptos(conceptosInversion,tipoLista);
			break;
			
			case Enum_Lis_ConceptosInversion.solicitante:
				listaParametros = conceptosInversionAgroDAO.listaConceptosSol(conceptosInversion,tipoLista);
			break;
			
			case Enum_Lis_ConceptosInversion.otraFuentes:
				listaParametros = conceptosInversionAgroDAO.listaConceptosOF(conceptosInversion,tipoLista);
			break;
		}

		return listaParametros;
	}
	
	//Lista para el grid en la pantala tipos de accion
	public List listaConceptosInversion(ConceptosInversionAgroBean conceptosInversion, int tipoLista){
		List listaParametros = null;
		
		switch(tipoLista){
			case Enum_Lis_ConceptosInversion.prestamo:
				listaParametros = conceptosInversionAgroDAO.listaCatConceptos(conceptosInversion,tipoLista);
			break;
		}

		return listaParametros;
	}

	// crea lista para grid 
	 private List creaListaGrid(String listaGrid){		
			StringTokenizer tokensBean = new StringTokenizer(listaGrid, "[");
			String stringCampos;
			String tokensCampos[];
			ArrayList listaCodigosResp = new ArrayList();
			ConceptosInversionAgroBean conceptosInvBean;
			
			while(tokensBean.hasMoreTokens()){
				conceptosInvBean = new ConceptosInversionAgroBean();
				
				stringCampos = tokensBean.nextToken();		
				tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
				conceptosInvBean.setConceptoInvID(tokensCampos[0]);
				conceptosInvBean.setDescripcion(tokensCampos[1]);
				conceptosInvBean.setNoUnidad(tokensCampos[2]);
				conceptosInvBean.setClaveUnidad(tokensCampos[3]);
				conceptosInvBean.setUnidad(tokensCampos[4]);
				conceptosInvBean.setMonto(tokensCampos[5]);
				conceptosInvBean.setTipoRecurso(tokensCampos[6]);
				
			listaCodigosResp.add(conceptosInvBean);
				
				
			}
			
			return listaCodigosResp;
		 }

	public ConceptosInversionAgroDAO getConceptosInversionAgroDAO() {
		return conceptosInversionAgroDAO;
	}


	public void setConceptosInversionAgroDAO(
			ConceptosInversionAgroDAO conceptosInversionAgroDAO) {
		this.conceptosInversionAgroDAO = conceptosInversionAgroDAO;
	}


	
	
	
}
