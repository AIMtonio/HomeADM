package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import credito.bean.ObligadosSolidariosBean;
import credito.dao.ObligadosSolidariosDAO;
import credito.servicio.OblSoliPorSoliciServicio.Enum_Lis_oblSolidarios;

public class ObligadosSolidariosServicio extends BaseServicio {

	private ObligadosSolidariosServicio(){
		super();
	}
	
	ObligadosSolidariosDAO obligadosSolidariosDAO = null;
	
	public static interface Enum_Tra_Obligados {
		int alta = 1;
		int modificacion = 2;
	}
	public static interface Enum_Con_Obligados {
		int principal = 1;
		int conCredObligado = 2;
		int ConCredCliente = 3;
		int ConCredProspecto = 4;
	}
	public static interface Enum_Lis_Obligados{
		int alfanumerica 	= 1;
		int creditosAva 	= 2;
		int obligadosxcliente 	= 3;
		int obligadosSol		= 4;
	}
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ObligadosSolidariosBean obligados){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_Obligados.alta:
			
				mensaje = altaObligadoSolidario(obligados);								
				break;					
			case Enum_Tra_Obligados.modificacion:		
				
				mensaje = modificacionObligadoSolidario(obligados);								
				break;
		}
		return mensaje;
	}
	
	public ObligadosSolidariosBean consulta(int tipoConsulta, ObligadosSolidariosBean obligadosSolidariosBean){
		ObligadosSolidariosBean obligadosSolidarios = null;
		switch(tipoConsulta){
			case Enum_Con_Obligados.principal:
				obligadosSolidarios = obligadosSolidariosDAO.consultaPrincipal(obligadosSolidariosBean, Enum_Con_Obligados.principal);
			break;
			case Enum_Con_Obligados.conCredObligado:
				obligadosSolidarios = obligadosSolidariosDAO.consultaCreditosOblSolidarios(obligadosSolidariosBean, Enum_Con_Obligados.conCredObligado);
			break;
			
			case Enum_Con_Obligados.ConCredCliente:
				obligadosSolidarios = obligadosSolidariosDAO.consultaCreditosOblSolidarios(obligadosSolidariosBean, Enum_Con_Obligados.ConCredCliente);
			break;
			
			case Enum_Con_Obligados.ConCredProspecto:
				obligadosSolidarios = obligadosSolidariosDAO.consultaCreditosOblSolidarios(obligadosSolidariosBean, Enum_Con_Obligados.ConCredProspecto);
			break;
			
		}
		return obligadosSolidarios;
	}
	
	public MensajeTransaccionBean altaObligadoSolidario(ObligadosSolidariosBean obligadosSolidariosBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = obligadosSolidariosDAO.altaObligadoSolidario(obligadosSolidariosBean);		
		return mensaje;
	}
	public MensajeTransaccionBean modificacionObligadoSolidario(ObligadosSolidariosBean obligadosSolidariosBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = obligadosSolidariosDAO.modificacionObligadoSOlidario(obligadosSolidariosBean);		
		return mensaje;
	}

	public List lista(int tipoLista, ObligadosSolidariosBean obligadosSolidariosBean){
		List listObligados = null;
		switch (tipoLista) {
			case Enum_Lis_Obligados.alfanumerica:
				listObligados=  obligadosSolidariosDAO.listaAlfanumerica(obligadosSolidariosBean, Enum_Lis_Obligados.alfanumerica);				
				break;	
			case Enum_Lis_Obligados.creditosAva:
				listObligados=  obligadosSolidariosDAO.listaCreditos(obligadosSolidariosBean, tipoLista);				
				break;
			case Enum_Lis_Obligados.obligadosxcliente:
				listObligados=  obligadosSolidariosDAO.listaObligadosSolidariosxCliente(obligadosSolidariosBean, Enum_Lis_Obligados.obligadosxcliente);
				break;
			case Enum_Lis_Obligados.obligadosSol:		
				listObligados=  obligadosSolidariosDAO.listaObligadosSolidariosSol(obligadosSolidariosBean, Enum_Lis_Obligados.obligadosSol);				
				break;
		}		
		return listObligados;
	}

	
	public ObligadosSolidariosDAO getObligadosSolidariosDAO() {
		return obligadosSolidariosDAO;
	}

	public void setObligadosSolidariosDAO(ObligadosSolidariosDAO obligadosSolidariosDAO) {
		this.obligadosSolidariosDAO = obligadosSolidariosDAO;
	}	
	
	
	
	
	
	
}
