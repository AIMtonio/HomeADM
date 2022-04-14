package aportaciones.servicio;

import javax.servlet.http.HttpServletRequest;

import aportaciones.bean.CuentasMayorAportacionBean;
import aportaciones.bean.SubCtaMonedaAportacionBean;
import aportaciones.bean.SubCtaPlazoAportacionBean;
import aportaciones.bean.SubCtaTiPerAportacionBean;
import aportaciones.bean.SubCtaTiProAportacionBean;

import aportaciones.dao.CuentasMayorAportacionDAO;
import aportaciones.dao.SubCtaMonedaAportacionDAO;
import aportaciones.dao.SubCtaPlazoAportacionDAO;
import aportaciones.dao.SubCtaTiPerAportacionDAO;
import aportaciones.dao.SubCtaTiProAportacionDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GuiaContableAportacionServicio extends BaseServicio{
	
	private GuiaContableAportacionServicio(){
		super();
	}
	
	CuentasMayorAportacionDAO	cuentasMayorAportacionDAO 	= null;
	SubCtaTiProAportacionDAO 	subCtaTiProAportacionDAO 	= null;
	SubCtaTiPerAportacionDAO 	subCtaTiPerAportacionDAO 	= null;
	SubCtaMonedaAportacionDAO 	subCtaMonedaAportacionDAO	= null;
	SubCtaPlazoAportacionDAO 	subCtaPlazoAportacionDAO 	= null;
	
	public static interface Enum_Tra_GuiaContableAportacion {
		int alta	= 1;
		int modifica= 2;
		int baja 	= 3;
	}

	public static interface Enum_Con_GuiaContableAportacion{
		int principal	= 1;
		int foranea 	= 2;
	}

	public static interface Enum_Lis_GuiaContableAportacion{
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

		CuentasMayorAportacionBean cuentasMayorAportacion = new CuentasMayorAportacionBean();
		switch(tipoTransaccionCM){
			case Enum_Tra_GuiaContableAportacion.alta:
				cuentasMayorAportacion.setConceptoAportacionID(request.getParameter("conceptoAportacionID"));
				cuentasMayorAportacion.setCuenta(request.getParameter("cuenta"));
				cuentasMayorAportacion.setNomenclatura(request.getParameter("nomenclatura"));
				cuentasMayorAportacion.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				mensaje = cuentasMayorAportacionDAO.alta(cuentasMayorAportacion);
				break;
			case Enum_Tra_GuiaContableAportacion.baja:
				cuentasMayorAportacion.setConceptoAportacionID(request.getParameter("conceptoAportacionID"));
				mensaje = cuentasMayorAportacionDAO.baja(cuentasMayorAportacion);
				break;
			case Enum_Tra_GuiaContableAportacion.modifica:
				cuentasMayorAportacion.setConceptoAportacionID(request.getParameter("conceptoAportacionID"));
				cuentasMayorAportacion.setCuenta(request.getParameter("cuenta"));
				cuentasMayorAportacion.setNomenclatura(request.getParameter("nomenclatura"));
				cuentasMayorAportacion.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				mensaje = cuentasMayorAportacionDAO.modifica(cuentasMayorAportacion);
				break;
		}
		SubCtaTiProAportacionBean subCtaTiProAportacion = new SubCtaTiProAportacionBean();
		switch(tipoTransaccionTPR){
			case Enum_Tra_GuiaContableAportacion.alta:
				subCtaTiProAportacion.setConceptoAportacionID(request.getParameter("conceptoAportacionID3"));
				subCtaTiProAportacion.setTipoAportacionID(request.getParameter("tipoProductoID"));
				subCtaTiProAportacion.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subCtaTiProAportacionDAO.alta(subCtaTiProAportacion);
				break;
			case Enum_Tra_GuiaContableAportacion.baja:
				subCtaTiProAportacion.setConceptoAportacionID(request.getParameter("conceptoAportacionID3"));
				subCtaTiProAportacion.setTipoAportacionID(request.getParameter("tipoProductoID"));
				mensaje = subCtaTiProAportacionDAO.baja(subCtaTiProAportacion);
				break;
			case Enum_Tra_GuiaContableAportacion.modifica:
				subCtaTiProAportacion.setConceptoAportacionID(request.getParameter("conceptoAportacionID3"));
				subCtaTiProAportacion.setTipoAportacionID(request.getParameter("tipoProductoID"));
				subCtaTiProAportacion.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subCtaTiProAportacionDAO.modifica(subCtaTiProAportacion);
				break;
		}	
			
		SubCtaTiPerAportacionBean subCtaTiPerAportacionBean = new SubCtaTiPerAportacionBean();
		switch(tipoTransaccionTPE){
			case Enum_Tra_GuiaContableAportacion.alta:
				subCtaTiPerAportacionBean.setConceptoAportacionID(request.getParameter("conceptoAportacionID4"));
				subCtaTiPerAportacionBean.setFisica(request.getParameter("fisica"));
				subCtaTiPerAportacionBean.setFisicaActEmp(request.getParameter("fisicaActEmp"));
				subCtaTiPerAportacionBean.setMoral(request.getParameter("moral"));
				mensaje = subCtaTiPerAportacionDAO.alta(subCtaTiPerAportacionBean);
				break;
			case Enum_Tra_GuiaContableAportacion.baja:
				subCtaTiPerAportacionBean.setConceptoAportacionID(request.getParameter("conceptoAportacionID4"));
				mensaje = subCtaTiPerAportacionDAO.baja(subCtaTiPerAportacionBean);
				break;
			case Enum_Tra_GuiaContableAportacion.modifica:
				subCtaTiPerAportacionBean.setConceptoAportacionID(request.getParameter("conceptoAportacionID4"));
				subCtaTiPerAportacionBean.setFisica(request.getParameter("fisica"));
				subCtaTiPerAportacionBean.setFisicaActEmp(request.getParameter("fisicaActEmp"));
				subCtaTiPerAportacionBean.setMoral(request.getParameter("moral"));
				mensaje = subCtaTiPerAportacionDAO.modifica(subCtaTiPerAportacionBean);
				break;
		}
		
		SubCtaMonedaAportacionBean subCtaMonedaAportacionBean = new SubCtaMonedaAportacionBean();
		switch(tipoTransaccionSM){
			case Enum_Tra_GuiaContableAportacion.alta:
				subCtaMonedaAportacionBean.setConceptoAportacionID(request.getParameter("conceptoAportacionID5"));
				subCtaMonedaAportacionBean.setMonedaID(request.getParameter("monedaID"));
				subCtaMonedaAportacionBean.setSubCuenta(request.getParameter("subCuenta2"));
				mensaje = subCtaMonedaAportacionDAO.alta(subCtaMonedaAportacionBean);
				break;
			case Enum_Tra_GuiaContableAportacion.baja:
				subCtaMonedaAportacionBean.setConceptoAportacionID(request.getParameter("conceptoAportacionID5"));
				subCtaMonedaAportacionBean.setMonedaID(request.getParameter("monedaID"));
				mensaje = subCtaMonedaAportacionDAO.baja(subCtaMonedaAportacionBean);
				break;
			case Enum_Tra_GuiaContableAportacion.modifica:
				subCtaMonedaAportacionBean.setConceptoAportacionID(request.getParameter("conceptoAportacionID5"));
				subCtaMonedaAportacionBean.setMonedaID(request.getParameter("monedaID"));
				subCtaMonedaAportacionBean.setSubCuenta(request.getParameter("subCuenta2"));
				mensaje = subCtaMonedaAportacionDAO.modifica(subCtaMonedaAportacionBean);
				break;
		}		
		SubCtaPlazoAportacionBean subCtaPlazoAportacion = new SubCtaPlazoAportacionBean();
		switch(tipoTransaccionSP){
			case Enum_Tra_GuiaContableAportacion.alta:
				subCtaPlazoAportacion.setConceptoAportacionID(request.getParameter("conceptoAportacionID2"));
				subCtaPlazoAportacion.setTipoAportacionID(request.getParameter("tipoAportacionID"));
				subCtaPlazoAportacion.setPlazoInferior(request.getParameter("plazoInferior"));
				subCtaPlazoAportacion.setPlazoSuperior(request.getParameter("plazoSuperior"));
				subCtaPlazoAportacion.setSubCuenta(request.getParameter("subCuentaP"));
				mensaje = subCtaPlazoAportacionDAO.alta(subCtaPlazoAportacion);	
				break;
			case Enum_Tra_GuiaContableAportacion.baja:
				subCtaPlazoAportacion.setConceptoAportacionID(request.getParameter("conceptoAportacionID2"));
				subCtaPlazoAportacion.setTipoAportacionID(request.getParameter("tipoAportacionID"));
				subCtaPlazoAportacion.setPlazoInferior(request.getParameter("plazoInferior"));
				subCtaPlazoAportacion.setPlazoSuperior(request.getParameter("plazoSuperior"));
				mensaje = subCtaPlazoAportacionDAO.baja(subCtaPlazoAportacion);
				break;
			case Enum_Tra_GuiaContableAportacion.modifica:
				subCtaPlazoAportacion.setConceptoAportacionID(request.getParameter("conceptoAportacionID2"));
				subCtaPlazoAportacion.setTipoAportacionID(request.getParameter("tipoAportacionID"));
				subCtaPlazoAportacion.setPlazoInferior(request.getParameter("plazoInferior"));
				subCtaPlazoAportacion.setPlazoSuperior(request.getParameter("plazoSuperior"));
				subCtaPlazoAportacion.setSubCuenta(request.getParameter("subCuentaP"));
				mensaje = subCtaPlazoAportacionDAO.modifica(subCtaPlazoAportacion);
				break;
		}
		
		return mensaje;
	}

	public CuentasMayorAportacionDAO getCuentasMayorAportacionDAO() {
		return cuentasMayorAportacionDAO;
	}

	public void setCuentasMayorAportacionDAO(
			CuentasMayorAportacionDAO cuentasMayorAportacionDAO) {
		this.cuentasMayorAportacionDAO = cuentasMayorAportacionDAO;
	}

	public SubCtaTiProAportacionDAO getSubCtaTiProAportacionDAO() {
		return subCtaTiProAportacionDAO;
	}

	public void setSubCtaTiProAportacionDAO(
			SubCtaTiProAportacionDAO subCtaTiProAportacionDAO) {
		this.subCtaTiProAportacionDAO = subCtaTiProAportacionDAO;
	}

	public SubCtaTiPerAportacionDAO getSubCtaTiPerAportacionDAO() {
		return subCtaTiPerAportacionDAO;
	}

	public void setSubCtaTiPerAportacionDAO(
			SubCtaTiPerAportacionDAO subCtaTiPerAportacionDAO) {
		this.subCtaTiPerAportacionDAO = subCtaTiPerAportacionDAO;
	}

	public SubCtaMonedaAportacionDAO getSubCtaMonedaAportacionDAO() {
		return subCtaMonedaAportacionDAO;
	}

	public void setSubCtaMonedaAportacionDAO(
			SubCtaMonedaAportacionDAO subCtaMonedaAportacionDAO) {
		this.subCtaMonedaAportacionDAO = subCtaMonedaAportacionDAO;
	}

	public SubCtaPlazoAportacionDAO getSubCtaPlazoAportacionDAO() {
		return subCtaPlazoAportacionDAO;
	}

	public void setSubCtaPlazoAportacionDAO(
			SubCtaPlazoAportacionDAO subCtaPlazoAportacionDAO) {
		this.subCtaPlazoAportacionDAO = subCtaPlazoAportacionDAO;
	}
	
}
