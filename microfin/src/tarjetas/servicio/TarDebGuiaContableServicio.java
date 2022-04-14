package tarjetas.servicio;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import tarjetas.bean.TarDebCuentasMayorBean;
import tarjetas.dao.TarDebGuiaContableDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TarDebGuiaContableServicio extends BaseServicio{

	TarDebGuiaContableDAO tarDebGuiaContableDAO = null;
	
	public TarDebGuiaContableServicio(){
		super();
	}	
	public static interface Enum_Tra_Guia{
		int alta		=	1;
		int elimina		=	2;
		int modifica	=	3;
	}
	
	public static interface Enum_Con_Guia{
		int principal	=	1;		
	}
	
	public static interface Enum_Lis_Guia{
		int principal	=	1;
		int listaCombo 	= 	3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccionCM, HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
														
		TarDebCuentasMayorBean cuentasMayormon = new TarDebCuentasMayorBean();
		switch(tipoTransaccionCM){
		case Enum_Tra_Guia.alta:
			cuentasMayormon.setConceptoTarDebID(request.getParameter("conceptoTarDeb"));
			cuentasMayormon.setCuenta(request.getParameter("cuenta"));
			cuentasMayormon.setNomenclatura(request.getParameter("nomenclatura"));
			cuentasMayormon.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
			mensaje = tarDebGuiaContableDAO.alta(cuentasMayormon);
			break;
		case Enum_Tra_Guia.elimina:
			cuentasMayormon.setConceptoTarDebID(request.getParameter("conceptoTarDeb"));
			mensaje = tarDebGuiaContableDAO.elimina(cuentasMayormon);
			break;
		case Enum_Tra_Guia.modifica:
			cuentasMayormon.setConceptoTarDebID(request.getParameter("conceptoTarDeb"));
			cuentasMayormon.setCuenta(request.getParameter("cuenta"));
			cuentasMayormon.setNomenclatura(request.getParameter("nomenclatura"));
			cuentasMayormon.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
			mensaje = tarDebGuiaContableDAO.modifica(cuentasMayormon);
			break;
		}
		return mensaje;
	}

	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista, TarDebCuentasMayorBean tarDebCuentasMayorBean) {
		List listaConceptos = null;
		switch(tipoLista){
			case Enum_Lis_Guia.listaCombo: 
				listaConceptos = tarDebGuiaContableDAO.listaConceptosTarDeb(tipoLista);	
			break;
		}
		return listaConceptos.toArray();
	}	

	public TarDebCuentasMayorBean consulta(int tipoConsulta,TarDebCuentasMayorBean cuentaMayorCajasBean){
		TarDebCuentasMayorBean  tarDebCuentasBean = null;
		switch(tipoConsulta){
			case Enum_Con_Guia.principal:
				tarDebCuentasBean = tarDebGuiaContableDAO.consultaPrincipal(cuentaMayorCajasBean, tipoConsulta);
			break;		
		}
		return tarDebCuentasBean;
	}
	
	public TarDebGuiaContableDAO getTarDebGuiaContableDAO() {
		return tarDebGuiaContableDAO;
	}

	public void setTarDebGuiaContableDAO(TarDebGuiaContableDAO tarDebGuiaContableDAO) {
		this.tarDebGuiaContableDAO = tarDebGuiaContableDAO;
	}
}