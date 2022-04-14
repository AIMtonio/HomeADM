
package tesoreria.servicio;


import java.util.List;

import javax.servlet.http.HttpServletRequest;

import tesoreria.bean.CuentaMayorCajasBean;
import tesoreria.dao.GuiaContableCajaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GuiaContableCajasServicio extends BaseServicio {
	
	private GuiaContableCajasServicio(){
		super();
	}
	
	GuiaContableCajaDAO guiaContableCajaDAO =null;
	
	public static interface Enum_Tra_GuiaContableCaj {
		int alta	= 1;
	    int elimina 	= 2;
		int modifica= 3;
	}

	public static interface Enum_Con_GuiaContableCaj {
		int principal	= 1;
		int foranea 	= 2;
	}

	public static interface Enum_Lis_GuiaContableCaj {
		int principal 	= 1;
		int foranea 	= 2;
	}
	public static interface Enum_Lis_ConceptosCaj {
		int conceptosCaj   = 1;
	}

	
	public MensajeTransaccionBean grabaTransaccion(int  tipoTransaccionCM,HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
														
		CuentaMayorCajasBean cuentasMayormon = new CuentaMayorCajasBean();
		switch(tipoTransaccionCM){
		case Enum_Tra_GuiaContableCaj.alta:
			cuentasMayormon.setConceptoCajaID(request.getParameter("conceptoCajaID"));
			cuentasMayormon.setCuenta(request.getParameter("cuenta"));
			cuentasMayormon.setNomenclatura(request.getParameter("nomenclatura"));
			cuentasMayormon.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
			mensaje = guiaContableCajaDAO.alta(cuentasMayormon);
			break;
		case Enum_Tra_GuiaContableCaj.elimina:
			cuentasMayormon.setConceptoCajaID(request.getParameter("conceptoCajaID"));
			mensaje = guiaContableCajaDAO.elimina(cuentasMayormon);
			break;
		case Enum_Tra_GuiaContableCaj.modifica:
			cuentasMayormon.setConceptoCajaID(request.getParameter("conceptoCajaID"));
			cuentasMayormon.setCuenta(request.getParameter("cuenta"));
			cuentasMayormon.setNomenclatura(request.getParameter("nomenclatura"));
			cuentasMayormon.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
			mensaje = guiaContableCajaDAO.modifica(cuentasMayormon);
			break;			
		}
				
		return mensaje;
	}

	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaConceptosCaj = null;
		switch(tipoLista){
			case (Enum_Lis_ConceptosCaj.conceptosCaj): 
					listaConceptosCaj =  guiaContableCajaDAO.listaConceptosCaj(tipoLista);
				break;
		}
		return listaConceptosCaj.toArray();		
	}


	//------------------------
	public 	CuentaMayorCajasBean consulta(int tipoConsulta,CuentaMayorCajasBean cuentaMayorCajasBean){
		CuentaMayorCajasBean  cuentasContableBean = null;
		switch(tipoConsulta){
			case Enum_Con_GuiaContableCaj.principal:
				cuentasContableBean = guiaContableCajaDAO.consultaPrincipal(cuentaMayorCajasBean, Enum_Con_GuiaContableCaj.principal);
			break;		
		}
		return cuentasContableBean;
	}
	
	
//--------------getter y setter--------------
	public GuiaContableCajaDAO getGuiaContableCajaDAO() {
		return guiaContableCajaDAO;
	}

	public void setGuiaContableCajaDAO(GuiaContableCajaDAO guiaContableCajaDAO) {
		this.guiaContableCajaDAO = guiaContableCajaDAO;
	}
	
	
	
}
