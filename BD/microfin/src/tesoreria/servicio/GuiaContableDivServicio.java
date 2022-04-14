package tesoreria.servicio;


import javax.servlet.http.HttpServletRequest;

import tesoreria.bean.CuentasMayorMonBean;
import tesoreria.bean.SubCtaCajeroDivBean;
import tesoreria.bean.SubCtaMonedaDivBean;
import tesoreria.bean.SubCtaSucursDivBean;
import tesoreria.bean.SubCtaTipoCajaDivBean;
import tesoreria.bean.SubCtaTipoDivBean;
import tesoreria.dao.CuentasMayorMonDAO;
import tesoreria.dao.SubCtaCajeroDivDAO;
import tesoreria.dao.SubCtaMonedaDivDAO;
import tesoreria.dao.SubCtaSucursDivDAO;
import tesoreria.dao.SubCtaTipoCajaDivDAO;
import tesoreria.dao.SubCtaTipoDivDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GuiaContableDivServicio extends BaseServicio {
	
	private GuiaContableDivServicio(){
		super();
	}
	
	CuentasMayorMonDAO 	cuentasMayorMonDAO = null;
	SubCtaMonedaDivDAO 	subCtaMonedaDivDAO = null;
	SubCtaTipoDivDAO 	subCtaTipoDivDAO = null;
	
	SubCtaSucursDivDAO 	subCtaSucursDivDAO	=null;
	SubCtaCajeroDivDAO	subCtaCajeroDivDAO	= null;
	SubCtaTipoCajaDivDAO subCtaTipoCajaDivDAO = null;
	
	public static interface Enum_Tra_GuiaContableDiv {
		int alta	= 1;
		int modifica= 2;
		int baja 	= 3;
	}

	public static interface Enum_Con_GuiaContableDiv {
		int principal	= 1;
		int foranea 	= 2;
	}

	public static interface Enum_Lis_GuiaContableDiv {
		int principal 	= 1;
		int foranea 	= 2;
	}
	
	//---------------------- GRABA TRANSACCION -------------
	public MensajeTransaccionBean grabaTransaccion(HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		
		int  tipoTransaccionCM = (request.getParameter("tipoTransaccionCM")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionCM")):0;
									
		int tipoTransaccionMDiv = (request.getParameter("tipoTransaccionMDiv")!=null)?				
									Integer.parseInt(request.getParameter("tipoTransaccionMDiv")):0;
									
		int tipoTransaccionTDiv = (request.getParameter("tipoTransaccionTDiv")!=null)?				
									Integer.parseInt(request.getParameter("tipoTransaccionTDiv")):0;
									
		int tipoTransaccionSucurs= (request.getParameter("tipoTransaccionSuc")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionSuc")): 0;
						
		int tipoTransaccionTipoCaja= (request.getParameter("tipoTransaccionTC")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionTC")): 0;
									
		int tipoTransaccionCaja= (request.getParameter("tipoTransaccionC")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionC")): 0;
			
		// CUENTAS MAYOR			
		CuentasMayorMonBean cuentasMayormon = new CuentasMayorMonBean();
		switch(tipoTransaccionCM){
		case Enum_Tra_GuiaContableDiv.alta:			
			cuentasMayormon.setConceptoMonID(request.getParameter("conceptoMonID"));
			cuentasMayormon.setCuenta(request.getParameter("cuenta"));
			cuentasMayormon.setNomenclatura(request.getParameter("nomenclatura"));
			cuentasMayormon.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
			mensaje = cuentasMayorMonDAO.alta(cuentasMayormon);
			break;
		case Enum_Tra_GuiaContableDiv.baja:
			cuentasMayormon.setConceptoMonID(request.getParameter("conceptoMonID"));
			mensaje = cuentasMayorMonDAO.baja(cuentasMayormon);
			break;
		case Enum_Tra_GuiaContableDiv.modifica:
			cuentasMayormon.setConceptoMonID(request.getParameter("conceptoMonID"));
			cuentasMayormon.setCuenta(request.getParameter("cuenta"));
			cuentasMayormon.setNomenclatura(request.getParameter("nomenclatura"));
			cuentasMayormon.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
			mensaje = cuentasMayorMonDAO.modifica(cuentasMayormon);
			break;	
		}
		//  POR MONEDA
		SubCtaMonedaDivBean subCtaMonedaDiv = new SubCtaMonedaDivBean();
		switch(tipoTransaccionMDiv){
		case Enum_Tra_GuiaContableDiv.alta:
			 subCtaMonedaDiv.setConceptoMonID(request.getParameter("conceptoMonID2"));
			 subCtaMonedaDiv.setMonedaID(request.getParameter("monedaID"));
			 subCtaMonedaDiv.setSubCuenta(request.getParameter("subCuenta"));
			mensaje = subCtaMonedaDivDAO.alta(subCtaMonedaDiv);
			break;
		case Enum_Tra_GuiaContableDiv.baja:
			subCtaMonedaDiv.setConceptoMonID(request.getParameter("conceptoMonID2"));
			subCtaMonedaDiv.setMonedaID(request.getParameter("monedaID"));
			mensaje =subCtaMonedaDivDAO.baja(subCtaMonedaDiv);
			break;
		case Enum_Tra_GuiaContableDiv.modifica:
			subCtaMonedaDiv.setConceptoMonID(request.getParameter("conceptoMonID2"));
			subCtaMonedaDiv.setMonedaID(request.getParameter("monedaID"));
			subCtaMonedaDiv.setSubCuenta(request.getParameter("subCuenta"));
			mensaje = subCtaMonedaDivDAO.modifica(subCtaMonedaDiv);
			break;	
			
		}	
		// TIPO DE DIVISAS
		SubCtaTipoDivBean subCtaTipoDiv = new SubCtaTipoDivBean();
		switch(tipoTransaccionTDiv){
		case Enum_Tra_GuiaContableDiv.alta:
			subCtaTipoDiv.setConceptoMonID(request.getParameter("conceptoMonID3"));
			subCtaTipoDiv.setBilletes(request.getParameter("billetes"));
			subCtaTipoDiv.setMonedas(request.getParameter("monedas"));
			mensaje = subCtaTipoDivDAO .alta(subCtaTipoDiv);
			break;
		case Enum_Tra_GuiaContableDiv.baja:
			subCtaTipoDiv.setConceptoMonID(request.getParameter("conceptoMonID3"));
			mensaje =subCtaTipoDivDAO.baja(subCtaTipoDiv);
			break;
		case Enum_Tra_GuiaContableDiv.modifica:
			subCtaTipoDiv.setConceptoMonID(request.getParameter("conceptoMonID3"));
			subCtaTipoDiv.setBilletes(request.getParameter("billetes"));
			subCtaTipoDiv.setMonedas(request.getParameter("monedas"));
			mensaje = subCtaTipoDivDAO .modifica(subCtaTipoDiv);
			break;		
		}
		
		// POR SUCURSAL
		SubCtaSucursDivBean subCtaSucursDivBean = new SubCtaSucursDivBean();
		switch(tipoTransaccionSucurs){
		case Enum_Tra_GuiaContableDiv.alta:
			subCtaSucursDivBean.setConceptoMonID(request.getParameter("conceptoMonID4"));
			subCtaSucursDivBean.setSucursalID(request.getParameter("sucursalID"));
			subCtaSucursDivBean.setSubCuenta(request.getParameter("subCuenta01"));						
			mensaje = subCtaSucursDivDAO.altaSuctaSucursal(subCtaSucursDivBean);
			break;
		case Enum_Tra_GuiaContableDiv.modifica:
			subCtaSucursDivBean.setConceptoMonID(request.getParameter("conceptoMonID4"));
			subCtaSucursDivBean.setSucursalID(request.getParameter("sucursalID"));
			subCtaSucursDivBean.setSubCuenta(request.getParameter("subCuenta01"));
			mensaje = subCtaSucursDivDAO.modificaSubctaSucursal(subCtaSucursDivBean);
			break;
		case Enum_Tra_GuiaContableDiv.baja:
			subCtaSucursDivBean.setConceptoMonID(request.getParameter("conceptoMonID4"));
			subCtaSucursDivBean.setSucursalID(request.getParameter("sucursalID"));
			mensaje =subCtaSucursDivDAO.eliminaSubctaSucursal(subCtaSucursDivBean, Enum_Tra_GuiaContableDiv.baja);
			break;
		}
		// POR  CAJA  
		SubCtaCajeroDivBean  subCtaCajeroDivBean = new SubCtaCajeroDivBean();
		switch(tipoTransaccionCaja){
		case Enum_Tra_GuiaContableDiv.alta:
			subCtaCajeroDivBean.setConceptoMonID(request.getParameter("conceptoMonID1"));
			subCtaCajeroDivBean.setCajaID(request.getParameter("cajaID"));
			subCtaCajeroDivBean.setSubCuenta(request.getParameter("subCuenta03"));
			mensaje = subCtaCajeroDivDAO.altaSubCtaCajero(subCtaCajeroDivBean);
			break;
		case Enum_Tra_GuiaContableDiv.modifica:
			subCtaCajeroDivBean.setConceptoMonID(request.getParameter("conceptoMonID1"));
			subCtaCajeroDivBean.setCajaID(request.getParameter("cajaID"));
			subCtaCajeroDivBean.setSubCuenta(request.getParameter("subCuenta03"));
			mensaje = subCtaCajeroDivDAO.modificaSubCtaCajero(subCtaCajeroDivBean);
			break;
		case Enum_Tra_GuiaContableDiv.baja:
			subCtaCajeroDivBean.setConceptoMonID(request.getParameter("conceptoMonID1"));
			subCtaCajeroDivBean.setCajaID(request.getParameter("cajaID"));
			mensaje =subCtaCajeroDivDAO.eliminaSubCtaCajero(subCtaCajeroDivBean,Enum_Tra_GuiaContableDiv.baja);
			break;
		}
		// POR TIPO DE CAJA
		SubCtaTipoCajaDivBean  subCtaTipoCajaDivBean = new SubCtaTipoCajaDivBean();
		switch(tipoTransaccionTipoCaja){
		case Enum_Tra_GuiaContableDiv.alta:
			subCtaTipoCajaDivBean.setConceptoMonID(request.getParameter("conceptoMonID5"));
			subCtaTipoCajaDivBean.setTipoCaja(request.getParameter("tipoCaja"));
			subCtaTipoCajaDivBean.setSubCuenta(request.getParameter("subCuenta02"));
			mensaje = subCtaTipoCajaDivDAO.altaSubCtaTipoCaja(subCtaTipoCajaDivBean);
			break;
		case Enum_Tra_GuiaContableDiv.modifica:
			subCtaTipoCajaDivBean.setConceptoMonID(request.getParameter("conceptoMonID5"));
			subCtaTipoCajaDivBean.setTipoCaja(request.getParameter("tipoCaja"));
			subCtaTipoCajaDivBean.setSubCuenta(request.getParameter("subCuenta02"));
			mensaje = subCtaTipoCajaDivDAO.modificaSubCtaTipoCaja(subCtaTipoCajaDivBean);
			break;
		case Enum_Tra_GuiaContableDiv.baja:
			subCtaTipoCajaDivBean.setConceptoMonID(request.getParameter("conceptoMonID5"));
			subCtaTipoCajaDivBean.setTipoCaja(request.getParameter("tipoCaja"));
			mensaje =subCtaTipoCajaDivDAO.eliminaSubCtaTipoCaja(subCtaTipoCajaDivBean,Enum_Tra_GuiaContableDiv.baja);
			break;
		}

		return mensaje;		
	}// Graba Transaccion

	
	//-------------- getter y setter-------------
	public CuentasMayorMonDAO getCuentasMayorMonDAO() {
		return cuentasMayorMonDAO;
	}

	public void setCuentasMayorMonDAO(CuentasMayorMonDAO cuentasMayorMonDAO) {
		this.cuentasMayorMonDAO = cuentasMayorMonDAO;
	}

	public SubCtaMonedaDivDAO getSubCtaMonedaDivDAO() {
		return subCtaMonedaDivDAO;
	}

	public void setSubCtaMonedaDivDAO(SubCtaMonedaDivDAO subCtaMonedaDivDAO) {
		this.subCtaMonedaDivDAO = subCtaMonedaDivDAO;
	}

	public SubCtaTipoDivDAO getSubCtaTipoDivDAO() {
		return subCtaTipoDivDAO;
	}

	public void setSubCtaTipoDivDAO(SubCtaTipoDivDAO subCtaTipoDivDAO) {
		this.subCtaTipoDivDAO = subCtaTipoDivDAO;
	}

	public SubCtaSucursDivDAO getSubCtaSucursDivDAO() {
		return subCtaSucursDivDAO;
	}

	public SubCtaCajeroDivDAO getSubCtaCajeroDivDAO() {
		return subCtaCajeroDivDAO;
	}

	public SubCtaTipoCajaDivDAO getSubCtaTipoCajaDivDAO() {
		return subCtaTipoCajaDivDAO;
	}

	public void setSubCtaSucursDivDAO(SubCtaSucursDivDAO subCtaSucursDivDAO) {
		this.subCtaSucursDivDAO = subCtaSucursDivDAO;
	}

	public void setSubCtaCajeroDivDAO(SubCtaCajeroDivDAO subCtaCajeroDivDAO) {
		this.subCtaCajeroDivDAO = subCtaCajeroDivDAO;
	}

	public void setSubCtaTipoCajaDivDAO(SubCtaTipoCajaDivDAO subCtaTipoCajaDivDAO) {
		this.subCtaTipoCajaDivDAO = subCtaTipoCajaDivDAO;
	}

	

}
