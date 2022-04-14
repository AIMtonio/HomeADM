package cuentas.servicio;

import javax.servlet.http.HttpServletRequest;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.dao.CuentasMayorAhoDAO;
import cuentas.dao.SubCtaClasifAhoDAO;
import cuentas.dao.SubCtaMonedaAhoDAO;
import cuentas.dao.SubCtaRendiAhoDAO;
import cuentas.dao.SubCtaTiPerAhoDAO;
import cuentas.dao.SubCtaTiProAhoDAO;
import cuentas.bean.CuentasMayorAhoBean;
import cuentas.bean.SubCtaClasifAhoBean;
import cuentas.bean.SubCtaMonedaAhoBean;
import cuentas.bean.SubCtaRendiAhoBean;
import cuentas.bean.SubCtaTiPerAhoBean;
import cuentas.bean.SubCtaTiProAhoBean;
public class GuiaContableAhoServicio extends BaseServicio {

	private GuiaContableAhoServicio(){
		super();
	}

	CuentasMayorAhoDAO cuentasMayorAhoDAO = null;
	SubCtaRendiAhoDAO subCtaRendiAhoDAO = null;
	SubCtaTiProAhoDAO subCtaTiProAhoDAO = null;
	SubCtaTiPerAhoDAO subCtaTiPerAhoDAO = null;
	SubCtaMonedaAhoDAO subCtaMonedaAhoDAO = null;
	SubCtaClasifAhoDAO subCtaClasifAhoDAO = null;
	
	public static interface Enum_Tra_GuiaContableAho {
		int alta= 1;
		int modifica = 2;
		int baja = 3;
	}

	public static interface Enum_Con_GuiaContableAho{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_GuiaContableAho{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		int  tipoTransaccionCM = (request.getParameter("tipoTransaccionCM")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionCM")):
										0;
		int tipoTransaccionSR = (request.getParameter("tipoTransaccionSR")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionSR")):
										0;
		int tipoTransaccionTPR = (request.getParameter("tipoTransaccionTPR")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionTPR")):
										0;
		int tipoTransaccionTPE = (request.getParameter("tipoTransaccionTPE")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionTPE")):
										0;
		int tipoTransaccionSM = (request.getParameter("tipoTransaccionSM")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionSM")):
										0;
		int tipoTransaccionSCT = (request.getParameter("tipoTransaccionSCT")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionSCT")):
					0;
		CuentasMayorAhoBean cuentasMayorAho = new CuentasMayorAhoBean();
		switch(tipoTransaccionCM){
			case Enum_Tra_GuiaContableAho.alta:
				cuentasMayorAho.setConceptoAhoID(request.getParameter("conceptoAhoID"));
				cuentasMayorAho.setCuenta(request.getParameter("cuenta"));
				cuentasMayorAho.setNomenclatura(request.getParameter("nomenclatura"));
				cuentasMayorAho.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				mensaje = cuentasMayorAhoDAO.alta(cuentasMayorAho);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				cuentasMayorAho.setConceptoAhoID(request.getParameter("conceptoAhoID"));
				mensaje = cuentasMayorAhoDAO.baja(cuentasMayorAho);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				cuentasMayorAho.setConceptoAhoID(request.getParameter("conceptoAhoID"));
				cuentasMayorAho.setCuenta(request.getParameter("cuenta"));
				cuentasMayorAho.setNomenclatura(request.getParameter("nomenclatura"));
				cuentasMayorAho.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				mensaje = cuentasMayorAhoDAO.modifica(cuentasMayorAho);
				break;
		}
			
		SubCtaRendiAhoBean subCtaRendiAho = new SubCtaRendiAhoBean();
		switch(tipoTransaccionSR){
			case Enum_Tra_GuiaContableAho.alta:
				subCtaRendiAho.setConceptoAhoID(request.getParameter("conceptoAhoID2"));
				subCtaRendiAho.setPaga(request.getParameter("paga"));
				subCtaRendiAho.setNoPaga(request.getParameter("noPaga"));
				mensaje = subCtaRendiAhoDAO.alta(subCtaRendiAho);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				subCtaRendiAho.setConceptoAhoID(request.getParameter("conceptoAhoID2"));
				mensaje = subCtaRendiAhoDAO.baja(subCtaRendiAho);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				subCtaRendiAho.setConceptoAhoID(request.getParameter("conceptoAhoID2"));
				subCtaRendiAho.setPaga(request.getParameter("paga"));
				subCtaRendiAho.setNoPaga(request.getParameter("noPaga"));
				mensaje = subCtaRendiAhoDAO.modifica(subCtaRendiAho);
				break;
		}
		
		SubCtaTiProAhoBean subCtaTiProAho = new SubCtaTiProAhoBean();
		switch(tipoTransaccionTPR){
			case Enum_Tra_GuiaContableAho.alta:
				subCtaTiProAho.setConceptoAhoID(request.getParameter("conceptoAhoID3"));
				subCtaTiProAho.setTipoProductoID(request.getParameter("tipoProductoID"));
				subCtaTiProAho.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subCtaTiProAhoDAO.alta(subCtaTiProAho);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				subCtaTiProAho.setConceptoAhoID(request.getParameter("conceptoAhoID3"));
				subCtaTiProAho.setTipoProductoID(request.getParameter("tipoProductoID"));
				mensaje = subCtaTiProAhoDAO.baja(subCtaTiProAho);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				subCtaTiProAho.setConceptoAhoID(request.getParameter("conceptoAhoID3"));
				subCtaTiProAho.setTipoProductoID(request.getParameter("tipoProductoID"));
				subCtaTiProAho.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subCtaTiProAhoDAO.modifica(subCtaTiProAho);
				break;
		}	
			
		SubCtaTiPerAhoBean subCtaTiPerAhoBean = new SubCtaTiPerAhoBean();
		switch(tipoTransaccionTPE){
			case Enum_Tra_GuiaContableAho.alta:
				subCtaTiPerAhoBean.setConceptoAhoID(request.getParameter("conceptoAhoID4"));
				subCtaTiPerAhoBean.setFisica(request.getParameter("fisica"));
				subCtaTiPerAhoBean.setMoral(request.getParameter("moral"));
				mensaje = subCtaTiPerAhoDAO.alta(subCtaTiPerAhoBean);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				subCtaTiPerAhoBean.setConceptoAhoID(request.getParameter("conceptoAhoID4"));
				mensaje = subCtaTiPerAhoDAO.baja(subCtaTiPerAhoBean);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				subCtaTiPerAhoBean.setConceptoAhoID(request.getParameter("conceptoAhoID4"));
				subCtaTiPerAhoBean.setFisica(request.getParameter("fisica"));
				subCtaTiPerAhoBean.setMoral(request.getParameter("moral"));
				mensaje = subCtaTiPerAhoDAO.modifica(subCtaTiPerAhoBean);
				break;
		}	
		
		SubCtaMonedaAhoBean subCtaMonedaAhoBean = new SubCtaMonedaAhoBean();
		switch(tipoTransaccionSM){
			case Enum_Tra_GuiaContableAho.alta:
				subCtaMonedaAhoBean.setConceptoAhoID(request.getParameter("conceptoAhoID5"));
				subCtaMonedaAhoBean.setMonedaID(request.getParameter("monedaID"));
				subCtaMonedaAhoBean.setSubCuenta(request.getParameter("subCuenta2"));
				mensaje = subCtaMonedaAhoDAO.alta(subCtaMonedaAhoBean);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				subCtaMonedaAhoBean.setConceptoAhoID(request.getParameter("conceptoAhoID5"));
				subCtaMonedaAhoBean.setMonedaID(request.getParameter("monedaID"));
				mensaje = subCtaMonedaAhoDAO.baja(subCtaMonedaAhoBean);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				subCtaMonedaAhoBean.setConceptoAhoID(request.getParameter("conceptoAhoID5"));
				subCtaMonedaAhoBean.setMonedaID(request.getParameter("monedaID"));
				subCtaMonedaAhoBean.setSubCuenta(request.getParameter("subCuenta2"));
				mensaje = subCtaMonedaAhoDAO.modifica(subCtaMonedaAhoBean);
				break;
		}
		
		SubCtaClasifAhoBean subCtaClasifAhoBean = new SubCtaClasifAhoBean();
		switch(tipoTransaccionSCT){
			case Enum_Tra_GuiaContableAho.alta:
				subCtaClasifAhoBean.setConceptoAhoID(request.getParameter("conceptoAhoID1"));
				subCtaClasifAhoBean.setClasificacion(request.getParameter("clasificacion"));
				subCtaClasifAhoBean.setSubCuenta(request.getParameter("subCuenta3"));
				mensaje = subCtaClasifAhoDAO.alta(subCtaClasifAhoBean);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				subCtaClasifAhoBean.setConceptoAhoID(request.getParameter("conceptoAhoID1"));
				subCtaClasifAhoBean.setClasificacion(request.getParameter("clasificacion"));
				mensaje = subCtaClasifAhoDAO.baja(subCtaClasifAhoBean);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				subCtaClasifAhoBean.setConceptoAhoID(request.getParameter("conceptoAhoID1"));
				subCtaClasifAhoBean.setClasificacion(request.getParameter("clasificacion"));
				subCtaClasifAhoBean.setSubCuenta(request.getParameter("subCuenta3"));
				mensaje = subCtaClasifAhoDAO.modifica(subCtaClasifAhoBean);
				break;
		}
		return mensaje;
	}

	public void setCuentasMayorAhoDAO(CuentasMayorAhoDAO cuentasMayorAhoDAO) {
		this.cuentasMayorAhoDAO = cuentasMayorAhoDAO;
	}

	public void setSubCtaRendiAhoDAO(SubCtaRendiAhoDAO subCtaRendiAhoDAO) {
		this.subCtaRendiAhoDAO = subCtaRendiAhoDAO;
	}

	public void setSubCtaTiProAhoDAO(SubCtaTiProAhoDAO subCtaTiProAhoDAO) {
		this.subCtaTiProAhoDAO = subCtaTiProAhoDAO;
	}

	public void setSubCtaTiPerAhoDAO(SubCtaTiPerAhoDAO subCtaTiPerAhoDAO) {
		this.subCtaTiPerAhoDAO = subCtaTiPerAhoDAO;
	}

	public void setSubCtaMonedaAhoDAO(SubCtaMonedaAhoDAO subCtaMonedaAhoDAO) {
		this.subCtaMonedaAhoDAO = subCtaMonedaAhoDAO;
	}

	public SubCtaClasifAhoDAO getSubCtaClasifAhoDAO() {
		return subCtaClasifAhoDAO;
	}

	public void setSubCtaClasifAhoDAO(SubCtaClasifAhoDAO subCtaClasifAhoDAO) {
		this.subCtaClasifAhoDAO = subCtaClasifAhoDAO;
	}

	public CuentasMayorAhoDAO getCuentasMayorAhoDAO() {
		return cuentasMayorAhoDAO;
	}

	public SubCtaRendiAhoDAO getSubCtaRendiAhoDAO() {
		return subCtaRendiAhoDAO;
	}

	public SubCtaTiProAhoDAO getSubCtaTiProAhoDAO() {
		return subCtaTiProAhoDAO;
	}

	public SubCtaTiPerAhoDAO getSubCtaTiPerAhoDAO() {
		return subCtaTiPerAhoDAO;
	}

	public SubCtaMonedaAhoDAO getSubCtaMonedaAhoDAO() {
		return subCtaMonedaAhoDAO;
	}
	
}

