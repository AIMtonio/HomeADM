package cuentas.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import org.springframework.core.task.TaskExecutor;

import soporte.bean.ParamGeneralesBean;
import soporte.servicio.CorreoServicio;
import soporte.servicio.ParamGeneralesServicio;
import cuentas.bean.CuentasPersonaBean;
import cuentas.dao.CuentasPersonaDAO;

public class CuentasPersonaServicio extends BaseServicio {

	CuentasPersonaDAO cuentasPersonaDAO = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	
	private CuentasPersonaServicio(){
		super();
	}


	public static interface Enum_Tra_CuentasPersona {
		int alta = 1;
		int modificacion = 2;
		int elimina	=3;
	}

	public static interface Enum_Con_CuentasPersona{
		int consulta = 1;
		int foranea  = 2;
		int firmante = 3;
		int existe	 = 4;
	
	}

	public static interface Enum_Lis_CuentasPersona{
		int principal = 1;
		int firmante = 2;
		int apoderado = 3;
		int firmante2 = 4;
		int cotitular = 5;
		int benefiario = 6;
		int anexoApoderado = 7;
		int relacionadosCta = 8;

	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CuentasPersonaBean cuentasPersona){
		MensajeTransaccionBean mensaje = null;	
		switch(tipoTransaccion){
		case Enum_Tra_CuentasPersona.alta:
			mensaje = cuentasPersonaDAO.alta(cuentasPersona);
			break;
		case Enum_Tra_CuentasPersona.modificacion:
			mensaje = cuentasPersonaDAO.modifica(cuentasPersona);
			break;
		case Enum_Tra_CuentasPersona.elimina:
			mensaje = cuentasPersonaDAO.elimina(cuentasPersona);
		}

		return mensaje;
	}

	public CuentasPersonaBean consultaCuentasPersona(int tipoConsulta, CuentasPersonaBean personaID){
		CuentasPersonaBean cuentasPersona = null;
		switch(tipoConsulta){
			case Enum_Con_CuentasPersona.consulta:
				cuentasPersona = cuentasPersonaDAO.consultaPrincipal(personaID, Enum_Con_CuentasPersona.consulta);
			break;
			case Enum_Con_CuentasPersona.foranea:
					cuentasPersona = cuentasPersonaDAO.consultaPrincipal(personaID, Enum_Con_CuentasPersona.foranea);
			break;
			case Enum_Con_CuentasPersona.firmante:
				cuentasPersona = cuentasPersonaDAO.consultaFirmante(personaID, Enum_Con_CuentasPersona.firmante);
			break;
			case Enum_Con_CuentasPersona.existe:
				cuentasPersona = cuentasPersonaDAO.consultaExiste(personaID, Enum_Con_CuentasPersona.existe);
			break;
		}
		return cuentasPersona;
	}

	public List lista(int tipoLista, CuentasPersonaBean cuentasPersona){
		List cuentasPersonaLista = null;

		switch (tipoLista) {
			case Enum_Lis_CuentasPersona.principal:
				cuentasPersonaLista = cuentasPersonaDAO.listaPrincipal(cuentasPersona, tipoLista);
			break;
			case Enum_Lis_CuentasPersona.firmante:
				cuentasPersonaLista = cuentasPersonaDAO.listaFirmante(cuentasPersona, tipoLista);
			break;
			case Enum_Lis_CuentasPersona.apoderado:
				cuentasPersonaLista = cuentasPersonaDAO.listaApoderados(cuentasPersona, tipoLista);
			break;
			case Enum_Lis_CuentasPersona.firmante2:
				cuentasPersonaLista = cuentasPersonaDAO.listaFirmantes2(cuentasPersona, tipoLista);
			break;
			case Enum_Lis_CuentasPersona.cotitular:
				cuentasPersonaLista = cuentasPersonaDAO.listaCotitulares(cuentasPersona, tipoLista);
			break;
			case Enum_Lis_CuentasPersona.benefiario:
				cuentasPersonaLista = cuentasPersonaDAO.listaBeneficiarios(cuentasPersona, tipoLista);
			break;
			case Enum_Lis_CuentasPersona.anexoApoderado:
				cuentasPersonaLista = cuentasPersonaDAO.listaAnexoPortadaContrato(cuentasPersona, tipoLista);
			break;
			case Enum_Lis_CuentasPersona.relacionadosCta:
				cuentasPersonaLista = cuentasPersonaDAO.listaRelacionadosCta(cuentasPersona, tipoLista);
			break;
		}
		return cuentasPersonaLista;
	}
	
//-----------------getter y setter-------------------------
	public void setCuentasPersonaDAO(CuentasPersonaDAO cuentasPersonaDAO ){
		this.cuentasPersonaDAO = cuentasPersonaDAO;
	}

	public CuentasPersonaDAO getCuentasPersonaDAO() {
		return cuentasPersonaDAO;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}
	
}
