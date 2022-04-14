package cliente.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import cliente.dao.IdentifiClienteDAO;
import cliente.servicio.DireccionesClienteServicio.Enum_Tra_DireccionesCliente;
import cliente.bean.DireccionesClienteBean;
import cliente.bean.IdentifiClienteBean;
public class IdentifiClienteServicio extends BaseServicio{

	private IdentifiClienteServicio(){
		super();
	}

	IdentifiClienteDAO identifiClienteDAO = null;
	ParametrosSisServicio		parametrosSisServicio	= null;

	public static interface Enum_Tra_IdentifiCliente {
		int alta = 1;
		int modificacion = 2;
		int elimina = 3;
	}

	public static interface Enum_Con_IdentifiCliente{
		int principal = 1;
		int foranea = 2;
		int oficial = 3;
		int tieneTipoIden = 4;
		
	}

	public static interface Enum_Lis_IdentifiCliente{
		int principal = 1;
		int foranea = 2;
	}
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, IdentifiClienteBean identifiCliente){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_DireccionesCliente.alta:		
				mensaje = altaIdentificacion(identifiCliente);				
				break;				
			case Enum_Tra_DireccionesCliente.modificacion:
				mensaje = modificaIdentificacion(identifiCliente);				
				break;
			case Enum_Tra_DireccionesCliente.elimina:
				mensaje = bajaIdentificacion(identifiCliente);				
				break;
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaIdentificacion(IdentifiClienteBean identifiCliente){
		MensajeTransaccionBean mensaje = null;
		mensaje = identifiClienteDAO.alta(identifiCliente);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaIdentificacion(IdentifiClienteBean identifiCliente){
		MensajeTransaccionBean mensaje = null;
		
		mensaje = identifiClienteDAO.modifica(identifiCliente);		

		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean.setEmpresaID("1");
		parametrosSisBean = parametrosSisServicio.consulta(1, parametrosSisBean);
		
		if(mensaje.getNumero() == 0 ) {
			if(parametrosSisBean.getReplicaAct().equalsIgnoreCase("S")) {
				mensaje = identifiClienteDAO.modificaReplica(identifiCliente, parametrosSisBean.getOrigenReplica());
			}
		}
		
		return mensaje;
	}	
	
	public MensajeTransaccionBean bajaIdentificacion(IdentifiClienteBean identifiCliente){
		MensajeTransaccionBean mensaje = null;
		mensaje = identifiClienteDAO.baja(identifiCliente);		
		return mensaje;
	}	
	
	public IdentifiClienteBean consulta(int tipoConsulta,IdentifiClienteBean identifiCliente){
		IdentifiClienteBean identifiClient = null;

		switch(tipoConsulta){
			case Enum_Con_IdentifiCliente.principal:
				identifiClient = identifiClienteDAO.consultaPrincipal(identifiCliente,tipoConsulta);
			break;
			case Enum_Con_IdentifiCliente.foranea:
				identifiClient = identifiClienteDAO.consultaForanea(identifiCliente,tipoConsulta);
			break;
			case Enum_Con_IdentifiCliente.oficial:
				identifiClient = identifiClienteDAO.consultaIdentiOficial(identifiCliente,tipoConsulta);
			break;
			case Enum_Con_IdentifiCliente.tieneTipoIden:
				identifiClient = identifiClienteDAO.consultaTieneTipoIden(identifiCliente,tipoConsulta);
			break;
		}
		return identifiClient;
	}
	
	
	/*
	public IdentifiClienteBean consultaOficialIdent(int tipoConsulta, IdentifiClienteBean identi){
		IdentifiClienteBean identifiCliente = null;
		identifiCliente = identifiClienteDAO.consultaIdentiOficial(identi, Enum_Con_IdentifiCliente.oficial);
		return identifiCliente;
	}*/

	public List lista(int tipoLista, IdentifiClienteBean identifiCliente){

		List identifiClienteLista = null;

		switch (tipoLista) {
		case Enum_Lis_IdentifiCliente.principal:
			identifiClienteLista = identifiClienteDAO.lista(identifiCliente, tipoLista);
			break;
         case Enum_Lis_IdentifiCliente.foranea:
			identifiClienteLista = identifiClienteDAO.lista(identifiCliente, tipoLista);
                 break;
		}
		return identifiClienteLista;
	}

	public void setIdentifiClienteDAO(IdentifiClienteDAO identifiClienteDAO ){
		this.identifiClienteDAO = identifiClienteDAO;
	}


	public IdentifiClienteDAO getIdentifiClienteDAO() {
		return identifiClienteDAO;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}