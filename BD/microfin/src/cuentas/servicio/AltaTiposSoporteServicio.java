package cuentas.servicio;

import java.util.List;

import cuentas.bean.AltaTiposSoporteBean;
import cuentas.dao.AltaTiposSoporteDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class AltaTiposSoporteServicio extends BaseServicio{
	AltaTiposSoporteDAO altaTiposSoporteDAO = null;
	
	private AltaTiposSoporteServicio (){
		super();
	}

	// Consulta de Tipos de Soporte
	public static interface Enum_Con_AltaSoporte {
		int principal = 1;
	}
	
	// Lista de Tipos de Soporte
	public static interface Enum_Lis_ListaSoporte{
		int principal = 1;	
	}
	
	// Transaccion de Tipos de Soporte
	public static interface Enum_Tra_AltaSoporte{
		int alta = 1;		
	}
	
	// Transacciones Tipos de Soporte
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,AltaTiposSoporteBean altaTiposSoporteBean) { 
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_AltaSoporte.alta:
			mensaje = altaTiposSoporteDAO.altaTiposSoporte(altaTiposSoporteBean);
			break;
		}
		return mensaje;
	}
	
	// Consulta de Tipos de Soporte
	public AltaTiposSoporteBean consulta(int tipoConsulta,AltaTiposSoporteBean altaTiposSoporteBean){
		AltaTiposSoporteBean consultaSoporte = null;
		switch (tipoConsulta) {
		case Enum_Con_AltaSoporte.principal:
			consultaSoporte = altaTiposSoporteDAO.consultaPrincipal(altaTiposSoporteBean, tipoConsulta);
			break;
		}		
		return consultaSoporte;
	}
	
	// Lista de Tipos de Soporte
	public List lista(int tipoLista, AltaTiposSoporteBean altaTiposSoporteBean) {
		List listaSoporte = null;
		switch (tipoLista) {
		case Enum_Lis_ListaSoporte.principal:
			listaSoporte = altaTiposSoporteDAO.listaPrincipal(altaTiposSoporteBean, tipoLista);
			break;	

		}
		return listaSoporte;
	}
	
	// ---------------  GETTER y SETTER -------------------- 
	public AltaTiposSoporteDAO getAltaTiposSoporteDAO() {
		return altaTiposSoporteDAO;
	}

	public void setAltaTiposSoporteDAO(AltaTiposSoporteDAO altaTiposSoporteDAO) {
		this.altaTiposSoporteDAO = altaTiposSoporteDAO;
	}

}
