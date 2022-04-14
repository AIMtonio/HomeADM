package contabilidad.servicio;


import contabilidad.bean.CuentasBalanzaBean;
import contabilidad.dao.CuentasBalanzaDAO;
import general.servicio.BaseServicio;

public class CuentasBalanzaServicio extends BaseServicio {

	private CuentasBalanzaServicio(){
		super();
	}

	CuentasBalanzaDAO cuentasBalanzaDAO = null;

	public static interface Enum_Con_CuentasBalanza{
			int foranea = 2;
	}

	public CuentasBalanzaBean consulta(int tipoConsulta, CuentasBalanzaBean cuentasBalanza){
		CuentasBalanzaBean cuentasBalanzaBean = null;
		switch(tipoConsulta){
			case Enum_Con_CuentasBalanza.foranea:
				cuentasBalanzaBean = cuentasBalanzaDAO.consultaForanea(cuentasBalanza, Enum_Con_CuentasBalanza.foranea);
			break;
		}
		return cuentasBalanzaBean;
	}

	
	public void setCuentasBalanzaDAO(CuentasBalanzaDAO cuentasBalanzaDAO ){
		this.cuentasBalanzaDAO = cuentasBalanzaDAO;
	}
	

}


