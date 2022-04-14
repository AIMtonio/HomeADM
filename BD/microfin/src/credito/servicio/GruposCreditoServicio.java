package credito.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import credito.bean.GruposCreditoBean;
import credito.dao.GruposCreditoDAO;


public class GruposCreditoServicio extends BaseServicio {

	private GruposCreditoServicio(){
		super();
	}

	GruposCreditoDAO gruposCreditoDAO = null;
	
	
	public static interface Enum_Tra_GruposCre {
		int alta = 1;
		int modifica =2;
		int	actualiza=3;		
	}
	
	public static interface Enum_Act_GruposCre {
		int Inicio 		= 1;
		int cierre 		= 2;
		int cierreAgro	= 3;
	}
	
	public static interface Enum_Con_GruposCre{
		int principal 			= 1;
		int totalExigible 		= 2;
		int deudaTotal 			= 3;
		int credGrup 			= 4;
		int valInt 				= 5;
		int cicloGpo 			= 6;
		int intGpo				= 8;
		int condonacion			= 9;
		int finiquito 			= 10; 
		int rompimiento 		= 11; 
		int solicitudLiberada 	= 12; 
		int pagareGrupo			= 13; 
		int existenciaGpo 		= 14;
		int esAgropecuario		= 15;
		int desembolsosGrup		= 16;
		int solicitudesInactiva	= 17;
	}
	
	public static interface Enum_Lis_GruposCre{
		int alfanumerica 			= 1;
		int rompimientoGpo 			= 2;
		int grupoSolLiberada 		= 3;
		int grupoCambioPuesto 		= 4;
		int gruposAgro				= 5;
		int grupoDesemCred			= 6;
	}
	
	public GruposCreditoBean consulta(int tipoConsulta, GruposCreditoBean GruposCredito){
		GruposCreditoBean gruposCreditoBean = null;
		switch(tipoConsulta){
			case Enum_Con_GruposCre.principal:
				gruposCreditoBean = gruposCreditoDAO.consultaPrincipal(GruposCredito, Enum_Con_GruposCre.principal);
			break;
			case Enum_Con_GruposCre.totalExigible:
				gruposCreditoBean = gruposCreditoDAO.consultaTotalExigible(GruposCredito, Enum_Con_GruposCre.totalExigible);
			break;
			case Enum_Con_GruposCre.deudaTotal:
				gruposCreditoBean = gruposCreditoDAO.consultaDeudaTotal(GruposCredito, Enum_Con_GruposCre.deudaTotal);
			break;
			case Enum_Con_GruposCre.valInt:
				gruposCreditoBean = gruposCreditoDAO.consultaVerificaInte(GruposCredito, Enum_Con_GruposCre.valInt);
			break;
			case Enum_Con_GruposCre.cicloGpo:
				gruposCreditoBean = gruposCreditoDAO.consultaCicloGrupo(GruposCredito, Enum_Con_GruposCre.cicloGpo);
			break;
			case Enum_Con_GruposCre.intGpo:
				gruposCreditoBean = gruposCreditoDAO.consultaIntegrantesGrupo(GruposCredito, Enum_Con_GruposCre.intGpo);
			break;
			case Enum_Con_GruposCre.finiquito:
				gruposCreditoBean = gruposCreditoDAO.consultaFiniquito(GruposCredito, Enum_Con_GruposCre.finiquito);
			break;
			case Enum_Con_GruposCre.condonacion:
				gruposCreditoBean = gruposCreditoDAO.consultaCondonacion(GruposCredito, Enum_Con_GruposCre.condonacion);
			break;
			case Enum_Con_GruposCre.rompimiento:
				gruposCreditoBean = gruposCreditoDAO.consultaRompimiento(GruposCredito, Enum_Con_GruposCre.rompimiento);
			break;
			case Enum_Con_GruposCre.solicitudLiberada:
				gruposCreditoBean = gruposCreditoDAO.consultaSolicitudLiberada(GruposCredito, Enum_Con_GruposCre.solicitudLiberada);
			break;
			case Enum_Con_GruposCre.pagareGrupo:
				gruposCreditoBean = gruposCreditoDAO.consultaPagareGrupo(GruposCredito, Enum_Con_GruposCre.pagareGrupo);
			break;
			case Enum_Con_GruposCre.existenciaGpo:
				gruposCreditoBean = gruposCreditoDAO.consultaExistenciaGrupo(GruposCredito, Enum_Con_GruposCre.existenciaGpo);
			break;
			case Enum_Con_GruposCre.esAgropecuario:
				gruposCreditoBean = gruposCreditoDAO.consultaPrincipalAgro(GruposCredito, Enum_Con_GruposCre.esAgropecuario);
			break;	
			case Enum_Con_GruposCre.desembolsosGrup:
				gruposCreditoBean = gruposCreditoDAO.consultaDesembolsosGrupo(GruposCredito, Enum_Con_GruposCre.desembolsosGrup);
			break;
			case Enum_Con_GruposCre.solicitudesInactiva:
				gruposCreditoBean = gruposCreditoDAO.consultaSolicitudLiberada(GruposCredito, Enum_Con_GruposCre.solicitudesInactiva);
			break;

		}
		return gruposCreditoBean;
		
	}
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,  int tipoActualizacion, GruposCreditoBean gruposCredito){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_GruposCre.alta:
				mensaje = alta(gruposCredito);				
				break;
			case Enum_Tra_GruposCre.modifica:
				mensaje = modifica(gruposCredito);				
				break;
			case Enum_Tra_GruposCre.actualiza:
				mensaje = actualiza(gruposCredito, tipoActualizacion);				
				break;
		}
		return mensaje;
	}
	
	// Lista para la consulta que dado un grupo devuelve los creditos relacionados
	public  Object[] listaConsulta(int tipoConsulta, GruposCreditoBean gruposCreditoBean){
		List listCreditosGrupo = null;
		switch(tipoConsulta){
			case Enum_Con_GruposCre.credGrup:
				listCreditosGrupo = gruposCreditoDAO.consultaCreditosIntegranGrupo(gruposCreditoBean, tipoConsulta);
			break;
		}
		return listCreditosGrupo.toArray();
		
	}
	
	public MensajeTransaccionBean alta(GruposCreditoBean gruposCredito){
		MensajeTransaccionBean mensaje = null;
		mensaje = gruposCreditoDAO.altaGrupos(gruposCredito);		
		return mensaje;
	}
	
	public MensajeTransaccionBean modifica(GruposCreditoBean gruposCredito){
		MensajeTransaccionBean mensaje = null;
		mensaje = gruposCreditoDAO.ModificaGrupo(gruposCredito);		
		return mensaje;
	}
	
	public MensajeTransaccionBean actualiza(GruposCreditoBean gruposCredito, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
		case Enum_Act_GruposCre.Inicio:
			mensaje = gruposCreditoDAO.ActualizaGrupo(gruposCredito, tipoActualizacion);	
		break;
		case Enum_Act_GruposCre.cierre:
			mensaje = gruposCreditoDAO.ActualizaGrupoCierre(gruposCredito, tipoActualizacion);	
		break;
		case Enum_Act_GruposCre.cierreAgro:
			mensaje = gruposCreditoDAO.ActualizaGrupoCierre(gruposCredito, tipoActualizacion);	
		break;
		}
				
		return mensaje;
	}
	
	public List lista(int tipoLista, GruposCreditoBean grupos){		
		List listaGrupos = null;
		switch (tipoLista) {
			case Enum_Lis_GruposCre.alfanumerica:		
				listaGrupos=  gruposCreditoDAO.listaAlfanumerica(grupos, Enum_Lis_GruposCre.alfanumerica);				
				break;	
			case Enum_Lis_GruposCre.rompimientoGpo:		
				listaGrupos=  gruposCreditoDAO.listaRompimientoGrupos(grupos, Enum_Lis_GruposCre.rompimientoGpo);				
				break;	
			case Enum_Lis_GruposCre.grupoSolLiberada:		
				listaGrupos=  gruposCreditoDAO.listaSolicitudLiberada(grupos, Enum_Lis_GruposCre.grupoSolLiberada);				
				break;	
			case Enum_Lis_GruposCre.grupoCambioPuesto:		
				listaGrupos=  gruposCreditoDAO.listaCambioPuestosGrupos(grupos, Enum_Lis_GruposCre.grupoCambioPuesto);				
				break;
			case Enum_Lis_GruposCre.gruposAgro:		
				listaGrupos=  gruposCreditoDAO.listaAlfanumerica(grupos, Enum_Lis_GruposCre.gruposAgro);				
				break;
			case Enum_Lis_GruposCre.grupoDesemCred:		
				listaGrupos=  gruposCreditoDAO.listaAlfanumerica(grupos, Enum_Lis_GruposCre.grupoDesemCred);				
				break;	
		}		
		return listaGrupos;
	}

	public GruposCreditoDAO getGruposCreditoDAO() {
		return gruposCreditoDAO;
	}

	public void setGruposCreditoDAO(GruposCreditoDAO gruposCreditoDAO) {
		this.gruposCreditoDAO = gruposCreditoDAO;
	}
	
	
}
