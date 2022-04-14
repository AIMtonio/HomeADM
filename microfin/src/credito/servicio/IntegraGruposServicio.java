package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import credito.bean.IntegraGruposBean;
import credito.dao.IntegraGruposDAO;

public class IntegraGruposServicio extends BaseServicio {

	private IntegraGruposServicio(){
		super();
	}

	IntegraGruposDAO integraGruposDAO = null;
	
	
	public static interface Enum_Lis_Grupos{
		int alfanumerica = 1;					//Lista Principal, usada para Asignacion de Integrantes al Grupo
		int altaCredGrupal = 2;					//Lista para Alta de Creditos, apartir del Grupo
		int autorCredGrupal = 3;				//Lista de Instrumentacion del Grupo: Pagare, Desembolso
		int solCredGrupal = 4;					//Lista para alta de Solicitud en Base al Grupo
		int autorCredGrupalDocEntregados = 5; 	//Lista usada en la pantalla mesa de control
		int integrantesActivos = 6; 			//Lista de Integrantes Activos, usada en la Cobranza Automatica
		int integrantesRevDesembolso = 7;		//Lista usada en la pantalla ReversaDesembolso
		int integrantesPagoAdela = 8;			//Lista usada en la pantalla Ventanilla para finiquito grupal
		int cuentaPrin = 9;
		int cambioCondCal = 10;					// se usa en la pantalla de cambio de condiciones del calendario de pagos
		int cancelacion = 14;					// Se usa en la pantalla de cancelación de creditos
		int ciclosClienteGrupal = 15;			// Consulta que se utiliza en la pantalla de ciclos clientes grupal
	}
	
	public static interface Enum_Con_InteGrupo {
		int principal = 1;
		int foranea = 2;
		int tipoIntegrante = 3;
		int solGrupal = 5;
	}
	/*public static interface Enum_Con_Empleados{
		int principal = 1;
	}*/
	
	public static interface Enum_Tra_Grupos {
		int alta = 1;
		int baja = 2;		
	}

	
	public MensajeTransaccionBean grabaListaGrupos(int tipoTransaccion, IntegraGruposBean integraGruposBean, String integraDetalle){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList listaGruposDetalle = (ArrayList) creaListaGrupos(integraGruposBean, integraDetalle);
		switch(tipoTransaccion){
			case Enum_Tra_Grupos.alta:
				mensaje = integraGruposDAO.grabaListaGrupos(integraGruposBean, listaGruposDetalle);
				break;
			case Enum_Tra_Grupos.baja:
				mensaje = integraGruposDAO.grabaListaGrupos(integraGruposBean, listaGruposDetalle);
				break;
		}			
		return mensaje;		 
	}
	
	public IntegraGruposBean consulta(int tipoConsulta, IntegraGruposBean integraGruposBean){
		IntegraGruposBean integraGrupos = null;
		switch (tipoConsulta) {
			case Enum_Con_InteGrupo.tipoIntegrante:		
				integraGrupos = integraGruposDAO.consultaTipoIntegrante(integraGruposBean, tipoConsulta);				
				break;
			case Enum_Con_InteGrupo.solGrupal:		
				integraGrupos = integraGruposDAO.consultaSolicitud(integraGruposBean, tipoConsulta);				
				break;
		}
		return integraGrupos;
	}
	
	private List creaListaGrupos(IntegraGruposBean integra, String IntegraDetalle){		
		StringTokenizer tokensBean = new StringTokenizer(IntegraDetalle, "[");		
		String stringCampos;
		String tokensCampos[];
		ArrayList listaGruposDetalle = new ArrayList();
		IntegraGruposBean integraGruposBean;
		
		while(tokensBean.hasMoreTokens()){
			integraGruposBean = new IntegraGruposBean();
		
		stringCampos = tokensBean.nextToken();		
		tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
		
		integraGruposBean.setGrupoID(tokensCampos[0]);
		integraGruposBean.setSolicitudCreditoID(tokensCampos[1]);
		integraGruposBean.setClienteID(tokensCampos[2]);
		integraGruposBean.setProspectoID(tokensCampos[3]);
		integraGruposBean.setEstatus(tokensCampos[4]);
		integraGruposBean.setFechaRegistro(tokensCampos[5]);
		integraGruposBean.setCiclo(tokensCampos[6]);
		integraGruposBean.setProductoCreditoID(tokensCampos[7]);
		integraGruposBean.setCargo(tokensCampos[8]);
		
						
		listaGruposDetalle.add(integraGruposBean);
		}
		
		return listaGruposDetalle;
	}
	
	public List lista(int tipoLista, IntegraGruposBean integra) {
		List listaGrupos = null;
		switch (tipoLista) {
			case Enum_Lis_Grupos.alfanumerica :
				listaGrupos = integraGruposDAO.listaAlfanumerica(integra, Enum_Lis_Grupos.alfanumerica);
				break;
			case Enum_Lis_Grupos.altaCredGrupal :
				listaGrupos = integraGruposDAO.listaAltaCreditoGrupal(integra, Enum_Lis_Grupos.altaCredGrupal);
				break;
			case Enum_Lis_Grupos.autorCredGrupal :
				listaGrupos = integraGruposDAO.listaAutorizaCreditoGrupal(integra, Enum_Lis_Grupos.autorCredGrupal);
				break;
			
			case Enum_Lis_Grupos.autorCredGrupalDocEntregados :
				listaGrupos = integraGruposDAO.listaAutorizaCreditoGrupalDocCom(integra, Enum_Lis_Grupos.autorCredGrupalDocEntregados);
				break;
			
			case Enum_Lis_Grupos.solCredGrupal :
				listaGrupos = integraGruposDAO.listaSolicitudCreditoGrupal(integra, Enum_Lis_Grupos.solCredGrupal);
				break;
			
			case Enum_Lis_Grupos.integrantesActivos :
				listaGrupos = integraGruposDAO.listaSolicitudCreditoGrupal(integra, Enum_Lis_Grupos.solCredGrupal);
				break;
			case Enum_Lis_Grupos.integrantesRevDesembolso :
				listaGrupos = integraGruposDAO.listaIntegrantesReversaDes(integra, Enum_Lis_Grupos.integrantesRevDesembolso);
				break;
			case Enum_Lis_Grupos.integrantesPagoAdela :
				listaGrupos = integraGruposDAO.listaIntegrantesPagoAdela(integra, Enum_Lis_Grupos.integrantesPagoAdela);
				break;
			case Enum_Lis_Grupos.cambioCondCal :
				listaGrupos = integraGruposDAO.listaCambioCondicionesCalendario(integra, Enum_Lis_Grupos.cambioCondCal);
				break;
			case Enum_Lis_Grupos.cancelacion :
				listaGrupos = integraGruposDAO.listaIntegrantesCanc(integra, Enum_Lis_Grupos.cancelacion);
				break;
			case Enum_Lis_Grupos.ciclosClienteGrupal:
				listaGrupos = integraGruposDAO.listaAlfanumerica(integra, Enum_Lis_Grupos.alfanumerica);
				break;
		}
		return listaGrupos;
	}
	
	public  Object[] listaConsulta(int tipoConsulta, IntegraGruposBean integraGrupo){
		List listaGrupos = null;
		switch(tipoConsulta){
			case Enum_Lis_Grupos.cuentaPrin:
			listaGrupos= integraGruposDAO.listaCuentaPrin(integraGrupo, Enum_Lis_Grupos.cuentaPrin);
			break;
		}
		return listaGrupos.toArray();
		
	}


	public IntegraGruposDAO getIntegraGruposDAO() {
		return integraGruposDAO;
	}

	public void setIntegraGruposDAO(IntegraGruposDAO integraGruposDAO) {
		this.integraGruposDAO = integraGruposDAO;
	}

	
}
