package arrendamiento.servicio;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import javax.servlet.http.HttpServletRequest;

import arrendamiento.bean.CuentasMayorArrendaBean;
import arrendamiento.bean.SubCtaMonedaArrendaBean;
import arrendamiento.bean.SubCtaPlazoArrendaBean;
import arrendamiento.bean.SubCtaSucurArrendaBean;
import arrendamiento.bean.SubCtaTiProArrendaBean;
import arrendamiento.bean.SubCtaTipoArrendaBean;
import arrendamiento.dao.CuentasMayorArrendaDAO;
import arrendamiento.dao.SubCtaMonedaArrendaDAO;
import arrendamiento.dao.SubCtaPlazoArrendaDAO;
import arrendamiento.dao.SubCtaSucurArrendaDAO;
import arrendamiento.dao.SubCtaTiProArrendaDAO;
import arrendamiento.dao.SubCtaTipoArrendaDAO;

public class GuiaContableArrendaServicio extends BaseServicio{

	private GuiaContableArrendaServicio (){
		super();
	}

	CuentasMayorArrendaDAO		cuentasMayorArrendaDAO		= null;
	SubCtaMonedaArrendaDAO		subCtaMonedaArrendaDAO 		= null;
	SubCtaTipoArrendaDAO		subCtaTipoArrendaDAO		= null;
	SubCtaTiProArrendaDAO		subCtaTiProArrendaDAO		= null;
	SubCtaSucurArrendaDAO		subCtaSucurArrendaDAO		= null;
	SubCtaPlazoArrendaDAO		subCtaPlazoArrendaDAO		= null;
	
	public static interface Enum_Tra_GuiaContableArrenda {
		int alta		= 1;
		int modifica 	= 2;
		int baja 		= 3;
	}

	public static interface Enum_Con_GuiaContableArrenda{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_GuiaContableArrenda{
		int principal = 1;
		int foranea = 2;
	}

	public MensajeTransaccionBean grabaTransaccion(HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		int tipoTransaccionCM = (request.getParameter("tipoTransaccionCM")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionCM")):
										0;
		int tipoTransaccionSM = (request.getParameter("tipoTransaccionSM")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionSM")):
										0;
		int tipoTransaccionSTP = (request.getParameter("tipoTransaccionSTP")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionSTP")):
										0;
		int tipoTransaccionSTA = (request.getParameter("tipoTransaccionSTA")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionSTA")):
										0;
		int tipoTransaccionSS = (request.getParameter("tipoTransaccionSS")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionSS")):
					0;
		int tipoTransaccionSP = (request.getParameter("tipoTransaccionSP")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionSP")):
					0;
		
		CuentasMayorArrendaBean cuentasMayorArrendaBean = new CuentasMayorArrendaBean();
		cuentasMayorArrendaBean.setConceptoArrendaID(request.getParameter("conceptoArrendaID"));
		cuentasMayorArrendaBean.setCuenta(request.getParameter("cuenta"));
		cuentasMayorArrendaBean.setNomenclatura(request.getParameter("nomenclatura"));
		cuentasMayorArrendaBean.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
		
		switch(tipoTransaccionCM){
			case Enum_Tra_GuiaContableArrenda.alta:
				mensaje = cuentasMayorArrendaDAO.alta(cuentasMayorArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.baja:
				mensaje = cuentasMayorArrendaDAO.baja(cuentasMayorArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.modifica:
				mensaje = cuentasMayorArrendaDAO.modifica(cuentasMayorArrendaBean);
				break;
		}
		
		//transaccion Tipo ARRENDAMIENTO
		SubCtaTipoArrendaBean subCtaTipoArrendaBean = new SubCtaTipoArrendaBean();
		subCtaTipoArrendaBean.setConceptoArrendaID(request.getParameter("conceptoArrendaID3"));
		subCtaTipoArrendaBean.setTipoArrenda(request.getParameter("tipoArrenda"));
		subCtaTipoArrendaBean.setSubCuenta(request.getParameter("subCuenta2"));
		switch(tipoTransaccionSTA){
			case Enum_Tra_GuiaContableArrenda.alta:
				mensaje = subCtaTipoArrendaDAO.alta(subCtaTipoArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.baja:
				mensaje = subCtaTipoArrendaDAO.baja(subCtaTipoArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.modifica:
				mensaje = subCtaTipoArrendaDAO.modifica(subCtaTipoArrendaBean);
				break;
		}	

		//Transaccion Por Plazo
		SubCtaTiProArrendaBean subCtaTiProArrendaBean = new SubCtaTiProArrendaBean();
		subCtaTiProArrendaBean.setConceptoArrendaID(request.getParameter("conceptoArrendaID2"));
		subCtaTiProArrendaBean.setProductoArrendaID(request.getParameter("productoArrendaID"));
		subCtaTiProArrendaBean.setSubCuenta(request.getParameter("subCuenta"));
		switch(tipoTransaccionSTP){
			case Enum_Tra_GuiaContableArrenda.alta:
				mensaje = subCtaTiProArrendaDAO.alta(subCtaTiProArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.baja:
				mensaje = subCtaTiProArrendaDAO.baja(subCtaTiProArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.modifica:
				mensaje = subCtaTiProArrendaDAO.modifica(subCtaTiProArrendaBean);
				break;
		}	
			
		//Transaccion Por Moneda
		SubCtaMonedaArrendaBean subCtaMonedaArrendaBean = new SubCtaMonedaArrendaBean();
		subCtaMonedaArrendaBean.setConceptoArrendaID(request.getParameter("conceptoArrendaID4"));
		subCtaMonedaArrendaBean.setMonedaID(request.getParameter("monedaID"));
		subCtaMonedaArrendaBean.setSubCuenta(request.getParameter("subCuenta3"));
		switch(tipoTransaccionSM){
			case Enum_Tra_GuiaContableArrenda.alta:
				mensaje = subCtaMonedaArrendaDAO.alta(subCtaMonedaArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.baja:
				mensaje = subCtaMonedaArrendaDAO.baja(subCtaMonedaArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.modifica:
				mensaje = subCtaMonedaArrendaDAO.modifica(subCtaMonedaArrendaBean);
				break;
		}	
		
		//Transaccion Por Sucursal
		SubCtaSucurArrendaBean subCtaSucurArrendaBean = new SubCtaSucurArrendaBean();
		subCtaSucurArrendaBean.setConceptoArrendaID(request.getParameter("conceptoArrendaID5"));
		subCtaSucurArrendaBean.setSucursalID(request.getParameter("sucursalID"));
		subCtaSucurArrendaBean.setSubCuenta(request.getParameter("subCuenta4"));
		switch(tipoTransaccionSS){
			case Enum_Tra_GuiaContableArrenda.alta:
				mensaje = subCtaSucurArrendaDAO.alta(subCtaSucurArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.baja:
				mensaje = subCtaSucurArrendaDAO.baja(subCtaSucurArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.modifica:
				mensaje = subCtaSucurArrendaDAO.modifica(subCtaSucurArrendaBean);
				break;
		}	
		
			
		//Transaccion Por PLAZO
		SubCtaPlazoArrendaBean subCtaPlazoArrendaBean = new SubCtaPlazoArrendaBean();
		subCtaPlazoArrendaBean.setConceptoArrendaID(request.getParameter("conceptoArrendaID6"));
		subCtaPlazoArrendaBean.setPlazo(request.getParameter("plazo"));
		subCtaPlazoArrendaBean.setSubCuenta(request.getParameter("subCuenta5"));
		switch(tipoTransaccionSP){
			case Enum_Tra_GuiaContableArrenda.alta:
				mensaje = subCtaPlazoArrendaDAO.alta(subCtaPlazoArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.baja:
				mensaje = subCtaPlazoArrendaDAO.baja(subCtaPlazoArrendaBean);
				break;
			case Enum_Tra_GuiaContableArrenda.modifica:
				mensaje = subCtaPlazoArrendaDAO.modifica(subCtaPlazoArrendaBean);
				break;
		}	
		
		return mensaje;
	}

	public CuentasMayorArrendaDAO getCuentasMayorArrendaDAO() {
		return cuentasMayorArrendaDAO;
	}

	public void setCuentasMayorArrendaDAO(
			CuentasMayorArrendaDAO cuentasMayorArrendaDAO) {
		this.cuentasMayorArrendaDAO = cuentasMayorArrendaDAO;
	}

	public SubCtaMonedaArrendaDAO getSubCtaMonedaArrendaDAO() {
		return subCtaMonedaArrendaDAO;
	}

	public void setSubCtaMonedaArrendaDAO(
			SubCtaMonedaArrendaDAO subCtaMonedaArrendaDAO) {
		this.subCtaMonedaArrendaDAO = subCtaMonedaArrendaDAO;
	}

	public SubCtaTipoArrendaDAO getSubCtaTipoArrendaDAO() {
		return subCtaTipoArrendaDAO;
	}

	public void setSubCtaTipoArrendaDAO(SubCtaTipoArrendaDAO subCtaTipoArrendaDAO) {
		this.subCtaTipoArrendaDAO = subCtaTipoArrendaDAO;
	}

	public SubCtaTiProArrendaDAO getSubCtaTiProArrendaDAO() {
		return subCtaTiProArrendaDAO;
	}

	public void setSubCtaTiProArrendaDAO(SubCtaTiProArrendaDAO subCtaTiProArrendaDAO) {
		this.subCtaTiProArrendaDAO = subCtaTiProArrendaDAO;
	}

	public SubCtaSucurArrendaDAO getSubCtaSucurArrendaDAO() {
		return subCtaSucurArrendaDAO;
	}

	public void setSubCtaSucurArrendaDAO(SubCtaSucurArrendaDAO subCtaSucurArrendaDAO) {
		this.subCtaSucurArrendaDAO = subCtaSucurArrendaDAO;
	}

	public SubCtaPlazoArrendaDAO getSubCtaPlazoArrendaDAO() {
		return subCtaPlazoArrendaDAO;
	}

	public void setSubCtaPlazoArrendaDAO(SubCtaPlazoArrendaDAO subCtaPlazoArrendaDAO) {
		this.subCtaPlazoArrendaDAO = subCtaPlazoArrendaDAO;
	}
}