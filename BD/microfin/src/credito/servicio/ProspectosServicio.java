package credito.servicio;

import java.util.Iterator;
import java.util.List;

import cliente.bean.EmpleadoNominaBean;

import credito.bean.ProspectosBean;
import credito.beanWS.request.ListaProspectoRequest;
import credito.beanWS.response.ListaProspectoResponse;
import credito.dao.ProspectosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class ProspectosServicio extends BaseServicio {
	ProspectosDAO  prospectosDAO = null;
	String codigo= "";
	
	public static interface Enum_Tra_Prospecto {
		int alta = 1;
		int modificacion 	=2;
		int altaWS	=	3;
	}
	public static interface Enum_Con_Prospecto {
		int principal 		=1;
		int foranea			=2;
		int prospectoCliente=3;
		int calificacion	=4;
		int nombre			=5;
		int personaFisica	= 6;
		int guardaValores	= 7;
	}
	public static interface Enum_Lis_Prospecto {
		int principal = 1;
		int foranea =2;
		int lisPersonaFisica = 3;
	}
	public static interface Enum_Tra_ProspectoWS {
		int altaWS = 1;
		int modificacionWS = 2;
	}
	public static interface Enum_Con_ProspectoWS {
		int principal = 1;
	}
	public static interface Enum_Lis_ProspectoWS{
		int listaProspectoWS 		= 1;
	}
	
	public ProspectosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ProspectosBean prospectos){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_Prospecto.alta:						
				mensaje = altaProspecto(prospectos);								
				break;		
			case Enum_Tra_Prospecto.altaWS:						
				mensaje = altaProspectoWS(prospectos);								
				break;		
			case Enum_Tra_Prospecto.modificacion:						
				mensaje = modificacionProspecto(prospectos);								
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean grabaTransaccionWS(int tipoTransaccion, ProspectosBean prospectos){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_ProspectoWS.altaWS:						
				mensaje = prospectosDAO.altaProspectWS(prospectos);								
				break;					
			case Enum_Tra_ProspectoWS.modificacionWS:						
				mensaje = prospectosDAO.modificacionProspectoWS(prospectos);								
				break;
		}
		return mensaje;
	}
	
	public ProspectosBean consulta(int tipoConsulta, ProspectosBean prospectosBean){
		ProspectosBean lineasCreditoBean = null;
		switch(tipoConsulta){
			case Enum_Con_Prospecto.principal:
				lineasCreditoBean = prospectosDAO.consultaPrincipal(prospectosBean, Enum_Con_Prospecto.principal);
			break;
			case Enum_Con_Prospecto.foranea:
				lineasCreditoBean = prospectosDAO.consultaForanea(prospectosBean, Enum_Con_Prospecto.foranea);
			break;
			case Enum_Con_Prospecto.prospectoCliente:
				lineasCreditoBean = prospectosDAO.consultaProspectoPorCliente(prospectosBean, Enum_Con_Prospecto.prospectoCliente);
			break;
			case Enum_Con_Prospecto.calificacion:
				lineasCreditoBean = prospectosDAO.consultaCalificacionProspectos(prospectosBean, Enum_Con_Prospecto.calificacion);
			break;
			case Enum_Con_Prospecto.nombre:
				lineasCreditoBean = prospectosDAO.consultaNombreProspecto(prospectosBean, Enum_Con_Prospecto.nombre);
			break;
			case Enum_Con_Prospecto.personaFisica:
				lineasCreditoBean = prospectosDAO.consultaProspectoPF(prospectosBean, Enum_Con_Prospecto.personaFisica);
			break;
			case Enum_Con_Prospecto.guardaValores:
				lineasCreditoBean = prospectosDAO.consultaForanea(prospectosBean, Enum_Con_Prospecto.guardaValores);
			break;
			
		}
		return lineasCreditoBean;
	}
	
	public ProspectosBean consultaWS(int tipoConsulta, ProspectosBean prospectosBean){
		ProspectosBean lineasCreditoBean = null;
		switch(tipoConsulta){
			case Enum_Con_ProspectoWS.principal:
				lineasCreditoBean = prospectosDAO.consultaPrincipalWS(prospectosBean, Enum_Con_ProspectoWS.principal);
			break;
			
		}
		return lineasCreditoBean;
	}
	
	public MensajeTransaccionBean altaProspecto(ProspectosBean prospectos){
		MensajeTransaccionBean mensaje = null;
		mensaje = prospectosDAO.altaProspecto(prospectos);		
		return mensaje;
	}
	public MensajeTransaccionBean altaProspectoWS(ProspectosBean prospectos){
		MensajeTransaccionBean mensaje = null;
		mensaje = prospectosDAO.altaProspectoWS(prospectos);		
		return mensaje;
	}
	public MensajeTransaccionBean modificacionProspecto(ProspectosBean prospectos){
		MensajeTransaccionBean mensaje = null;
		mensaje = prospectosDAO.modificacionProspecto(prospectos);		
		return mensaje;
	}

	public Object listaProspectoWS(ListaProspectoRequest listaProspectoRequest){
		Object obj= null;
		String cadena= "";
		codigo = "01";
		ListaProspectoResponse resultadoProspecto=new ListaProspectoResponse();
		List<ListaProspectoResponse> lisProspecto = prospectosDAO.listaProspectoWS(listaProspectoRequest);
		if (lisProspecto != null ){
			cadena = transformArray(lisProspecto);							
		}
		resultadoProspecto.setListaProspecto(cadena);
		resultadoProspecto.setCodigoRespuesta("0");
		resultadoProspecto.setMensajeRespuesta("Consulta Exitosa");
		obj=(Object)resultadoProspecto;
		
		return obj;
	}

	private String transformArray(List  listaProspectos){
		String resultadoProspecto = "";
	    String separadorCampos = "[";  
	    String separadorRegistros = "]";
 
        ProspectosBean prospectosBean;
	    if(listaProspectos != null) {   
	        Iterator<ProspectosBean> it = listaProspectos.iterator();
	        while(it.hasNext()){    
	        	prospectosBean = (ProspectosBean)it.next();
	        	resultadoProspecto += prospectosBean.getProspectoID() + separadorCampos +
	        			              prospectosBean.getNombreCompleto() + separadorRegistros;
	        }
	    }
	    if(resultadoProspecto.length() != 0){
	    	resultadoProspecto = resultadoProspecto.substring(0,resultadoProspecto.length()-1);
	    }
	    return resultadoProspecto;
    }
	
	public List lista(int tipoLista, ProspectosBean prospectosBean){
		List ProspectosLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_Prospecto.principal:
	        	ProspectosLista = prospectosDAO.listaPrincipal(prospectosBean, tipoLista);
	        break;  
	        case  Enum_Lis_Prospecto.lisPersonaFisica:
	        	ProspectosLista = prospectosDAO.listaPrincipal(prospectosBean, tipoLista);
	        break;  
		}
		return ProspectosLista;
	}
	
	public void setProspectosDAO(ProspectosDAO prospectosDAO) {
		this.prospectosDAO = prospectosDAO;
	}

	public ProspectosDAO getProspectosDAO() {
		return prospectosDAO;
	}

}
