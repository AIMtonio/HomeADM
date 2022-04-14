package originacion.servicio;

import java.util.List;

import originacion.bean.CasasComercialesBean;
import originacion.dao.CasasComercialesDAO;
import soporte.servicio.ParamGeneralesServicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class CasasComercialesServicio extends BaseServicio {
	public CasasComercialesServicio() {
		super();
	}
	
	CasasComercialesDAO casasComercialesDAO = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	
	// ---- Tipos de acciones
	public static interface Enum_Tra_CasaComer{
		int alta = 1;
		int modificacion =2;
	}
	public static interface Enum_Con_CasaComer{
		int principal 	= 1;
	}
	public static interface Enum_Lis_CasaComer{
		int alfanumerica = 1;
		int casasActivas=2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CasasComercialesBean casasComerciales) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion) {
		case Enum_Tra_CasaComer.alta:
			mensaje = altaConceptoDispersion(casasComerciales);
			break;
		case Enum_Tra_CasaComer.modificacion:
			mensaje = modificaConceptoDispersion(casasComerciales);
			break;
		}

		return mensaje;
	}

	public MensajeTransaccionBean altaConceptoDispersion(CasasComercialesBean casasComerciales) {
		MensajeTransaccionBean mensaje = null;
		mensaje = casasComercialesDAO.altaCasa(casasComerciales);
		return mensaje;
	}

	public MensajeTransaccionBean modificaConceptoDispersion(CasasComercialesBean casasComerciales) {
		MensajeTransaccionBean mensaje = null;
		mensaje = casasComercialesDAO.modificaCasa(casasComerciales);
		return mensaje;
	}
	
	public CasasComercialesBean consulta(int tipoConsulta, CasasComercialesBean casasComerciales){
		CasasComercialesBean consultabean = null;

		switch(tipoConsulta){
			case Enum_Con_CasaComer.principal:
				consultabean = casasComercialesDAO.consultaCasas(tipoConsulta, casasComerciales);
				break;
		}
		return consultabean;

	}

	public List lista(int tipoLista, CasasComercialesBean casasComerciales){
		List listaTipoGas = null;
		switch (tipoLista) {
			case Enum_Lis_CasaComer.alfanumerica:
				listaTipoGas=  casasComercialesDAO.listaAlfanumerica(casasComerciales,Enum_Lis_CasaComer.alfanumerica);
				break;
			case Enum_Lis_CasaComer.casasActivas:
				listaTipoGas=  casasComercialesDAO.listaCasasAct(casasComerciales,Enum_Lis_CasaComer.casasActivas);
				break;
		}
		return listaTipoGas;
	}
	
	public CasasComercialesDAO getCasasComercialesDAO(){
		return casasComercialesDAO;
	}
	
	public void setCasasComercialesDAO(CasasComercialesDAO casasComercialesDAO){
		this.casasComercialesDAO = casasComercialesDAO;
	}
	
	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}
}
