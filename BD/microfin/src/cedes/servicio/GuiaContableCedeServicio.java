package cedes.servicio;

import javax.servlet.http.HttpServletRequest;

import cedes.bean.CuentasMayorCedeBean;
import cedes.bean.SubCtaMonedaCedeBean;
import cedes.bean.SubCtaPlazoCedeBean;
import cedes.bean.SubCtaTiPerCedeBean;
import cedes.bean.SubCtaTiProCedeBean;
import cedes.dao.CuentasMayorCedeDAO;
import cedes.dao.SubCtaMonedaCedeDAO;
import cedes.dao.SubCtaPlazoCedeDAO;
import cedes.dao.SubCtaTiPerCedeDAO;
import cedes.dao.SubCtaTiProCedeDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
 
public class GuiaContableCedeServicio extends BaseServicio{
	
	private GuiaContableCedeServicio(){
		super();
	}
	
	CuentasMayorCedeDAO	cuentasMayorCedeDAO = null;
	SubCtaTiProCedeDAO 	subCtaTiProCedeDAO 	= null;
	SubCtaTiPerCedeDAO 	subCtaTiPerCedeDAO 	= null;
	SubCtaMonedaCedeDAO subCtaMonedaCedeDAO = null;
	SubCtaPlazoCedeDAO 	subCtaPlazoCedeDAO 	= null;
	
	public static interface Enum_Tra_GuiaContableCede {
		int alta	= 1;
		int modifica= 2;
		int baja 	= 3;
	}

	public static interface Enum_Con_GuiaContableCede{
		int principal	= 1;
		int foranea 	= 2;
	}

	public static interface Enum_Lis_GuiaContableCede{
		int principal 	= 1;
		int foranea 	= 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		int  tipoTransaccionCM = (request.getParameter("tipoTransaccionCM")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionCM")):
										0;
		int tipoTransaccionSM = (request.getParameter("tipoTransaccionSM")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionSM")):
					0;
		int tipoTransaccionTPE = (request.getParameter("tipoTransaccionTPE")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionTPE")):
										0;
		int tipoTransaccionTPR = (request.getParameter("tipoTransaccionTPR")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionTPR")):
					0;
		int tipoTransaccionSP = (request.getParameter("tipoTransaccionSP")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionSP")):
					0;

		CuentasMayorCedeBean cuentasMayorCede = new CuentasMayorCedeBean();
		switch(tipoTransaccionCM){
			case Enum_Tra_GuiaContableCede.alta:
				cuentasMayorCede.setConceptoCedeID(request.getParameter("conceptoCedeID"));
				cuentasMayorCede.setCuenta(request.getParameter("cuenta"));
				cuentasMayorCede.setNomenclatura(request.getParameter("nomenclatura"));
				cuentasMayorCede.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				mensaje = cuentasMayorCedeDAO.alta(cuentasMayorCede);
				break;
			case Enum_Tra_GuiaContableCede.baja:
				cuentasMayorCede.setConceptoCedeID(request.getParameter("conceptoCedeID"));
				mensaje = cuentasMayorCedeDAO.baja(cuentasMayorCede);
				break;
			case Enum_Tra_GuiaContableCede.modifica:
				cuentasMayorCede.setConceptoCedeID(request.getParameter("conceptoCedeID"));
				cuentasMayorCede.setCuenta(request.getParameter("cuenta"));
				cuentasMayorCede.setNomenclatura(request.getParameter("nomenclatura"));
				cuentasMayorCede.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				mensaje = cuentasMayorCedeDAO.modifica(cuentasMayorCede);
				break;
		}
		SubCtaTiProCedeBean subCtaTiProCede = new SubCtaTiProCedeBean();
		switch(tipoTransaccionTPR){
			case Enum_Tra_GuiaContableCede.alta:
				subCtaTiProCede.setConceptoCedeID(request.getParameter("conceptoCedeID3"));
				subCtaTiProCede.setTipoCedeID(request.getParameter("tipoProductoID"));
				subCtaTiProCede.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subCtaTiProCedeDAO.alta(subCtaTiProCede);
				break;
			case Enum_Tra_GuiaContableCede.baja:
				subCtaTiProCede.setConceptoCedeID(request.getParameter("conceptoCedeID3"));
				subCtaTiProCede.setTipoCedeID(request.getParameter("tipoProductoID"));
				mensaje = subCtaTiProCedeDAO.baja(subCtaTiProCede);
				break;
			case Enum_Tra_GuiaContableCede.modifica:
				subCtaTiProCede.setConceptoCedeID(request.getParameter("conceptoCedeID3"));
				subCtaTiProCede.setTipoCedeID(request.getParameter("tipoProductoID"));
				subCtaTiProCede.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subCtaTiProCedeDAO.modifica(subCtaTiProCede);
				break;
		}	
			
		SubCtaTiPerCedeBean subCtaTiPerCedeBean = new SubCtaTiPerCedeBean();
		switch(tipoTransaccionTPE){
			case Enum_Tra_GuiaContableCede.alta:
				subCtaTiPerCedeBean.setConceptoCedeID(request.getParameter("conceptoCedeID4"));
				subCtaTiPerCedeBean.setFisica(request.getParameter("fisica"));
				subCtaTiPerCedeBean.setFisicaActEmp(request.getParameter("fisicaActEmp"));
				subCtaTiPerCedeBean.setMoral(request.getParameter("moral"));
				mensaje = subCtaTiPerCedeDAO.alta(subCtaTiPerCedeBean);
				break;
			case Enum_Tra_GuiaContableCede.baja:
				subCtaTiPerCedeBean.setConceptoCedeID(request.getParameter("conceptoCedeID4"));
				mensaje = subCtaTiPerCedeDAO.baja(subCtaTiPerCedeBean);
				break;
			case Enum_Tra_GuiaContableCede.modifica:
				subCtaTiPerCedeBean.setConceptoCedeID(request.getParameter("conceptoCedeID4"));
				subCtaTiPerCedeBean.setFisica(request.getParameter("fisica"));
				subCtaTiPerCedeBean.setFisicaActEmp(request.getParameter("fisicaActEmp"));
				subCtaTiPerCedeBean.setMoral(request.getParameter("moral"));
				mensaje = subCtaTiPerCedeDAO.modifica(subCtaTiPerCedeBean);
				break;
		}	
		
		SubCtaMonedaCedeBean subCtaMonedaCedeBean = new SubCtaMonedaCedeBean();
		switch(tipoTransaccionSM){
			case Enum_Tra_GuiaContableCede.alta:
				subCtaMonedaCedeBean.setConceptoCedeID(request.getParameter("conceptoCedeID5"));
				subCtaMonedaCedeBean.setMonedaID(request.getParameter("monedaID"));
				subCtaMonedaCedeBean.setSubCuenta(request.getParameter("subCuenta2"));
				mensaje = subCtaMonedaCedeDAO.alta(subCtaMonedaCedeBean);
				break;
			case Enum_Tra_GuiaContableCede.baja:
				subCtaMonedaCedeBean.setConceptoCedeID(request.getParameter("conceptoCedeID5"));
				subCtaMonedaCedeBean.setMonedaID(request.getParameter("monedaID"));
				mensaje = subCtaMonedaCedeDAO.baja(subCtaMonedaCedeBean);
				break;
			case Enum_Tra_GuiaContableCede.modifica:
				subCtaMonedaCedeBean.setConceptoCedeID(request.getParameter("conceptoCedeID5"));
				subCtaMonedaCedeBean.setMonedaID(request.getParameter("monedaID"));
				subCtaMonedaCedeBean.setSubCuenta(request.getParameter("subCuenta2"));
				mensaje = subCtaMonedaCedeDAO.modifica(subCtaMonedaCedeBean);
				break;
		}		
		SubCtaPlazoCedeBean subCtaPlazoCede = new SubCtaPlazoCedeBean();
		switch(tipoTransaccionSP){
			case Enum_Tra_GuiaContableCede.alta:
				subCtaPlazoCede.setConceptoCedeID(request.getParameter("conceptoCedeID2"));
				subCtaPlazoCede.setTipoCedeID(request.getParameter("tipoCedeID"));
				subCtaPlazoCede.setPlazoInferior(request.getParameter("plazoInferior"));
				subCtaPlazoCede.setPlazoSuperior(request.getParameter("plazoSuperior"));
				subCtaPlazoCede.setSubCuenta(request.getParameter("subCuentaP"));
				mensaje = subCtaPlazoCedeDAO.alta(subCtaPlazoCede);	
				break;
			case Enum_Tra_GuiaContableCede.baja:
				subCtaPlazoCede.setConceptoCedeID(request.getParameter("conceptoCedeID2"));
				subCtaPlazoCede.setTipoCedeID(request.getParameter("tipoCedeID"));
				subCtaPlazoCede.setPlazoInferior(request.getParameter("plazoInferior"));
				subCtaPlazoCede.setPlazoSuperior(request.getParameter("plazoSuperior"));
				mensaje = subCtaPlazoCedeDAO.baja(subCtaPlazoCede);
				break;
			case Enum_Tra_GuiaContableCede.modifica:
				subCtaPlazoCede.setConceptoCedeID(request.getParameter("conceptoCedeID2"));
				subCtaPlazoCede.setTipoCedeID(request.getParameter("tipoCedeID"));
				subCtaPlazoCede.setPlazoInferior(request.getParameter("plazoInferior"));
				subCtaPlazoCede.setPlazoSuperior(request.getParameter("plazoSuperior"));
				subCtaPlazoCede.setSubCuenta(request.getParameter("subCuentaP"));
				mensaje = subCtaPlazoCedeDAO.modifica(subCtaPlazoCede);
				break;
		}
		
		return mensaje;
	}

	public CuentasMayorCedeDAO getCuentasMayorCedeDAO() {
		return cuentasMayorCedeDAO;
	}

	public void setCuentasMayorCedeDAO(CuentasMayorCedeDAO cuentasMayorCedeDAO) {
		this.cuentasMayorCedeDAO = cuentasMayorCedeDAO;
	}

	public SubCtaTiProCedeDAO getSubCtaTiProCedeDAO() {
		return subCtaTiProCedeDAO;
	}

	public void setSubCtaTiProCedeDAO(SubCtaTiProCedeDAO subCtaTiProCedeDAO) {
		this.subCtaTiProCedeDAO = subCtaTiProCedeDAO;
	}

	public SubCtaTiPerCedeDAO getSubCtaTiPerCedeDAO() {
		return subCtaTiPerCedeDAO;
	}

	public void setSubCtaTiPerCedeDAO(SubCtaTiPerCedeDAO subCtaTiPerCedeDAO) {
		this.subCtaTiPerCedeDAO = subCtaTiPerCedeDAO;
	}

	public SubCtaMonedaCedeDAO getSubCtaMonedaCedeDAO() {
		return subCtaMonedaCedeDAO;
	}

	public void setSubCtaMonedaCedeDAO(SubCtaMonedaCedeDAO subCtaMonedaCedeDAO) {
		this.subCtaMonedaCedeDAO = subCtaMonedaCedeDAO;
	}

	public SubCtaPlazoCedeDAO getSubCtaPlazoCedeDAO() {
		return subCtaPlazoCedeDAO;
	}

	public void setSubCtaPlazoCedeDAO(SubCtaPlazoCedeDAO subCtaPlazoCedeDAO) {
		this.subCtaPlazoCedeDAO = subCtaPlazoCedeDAO;
	}

	
}
