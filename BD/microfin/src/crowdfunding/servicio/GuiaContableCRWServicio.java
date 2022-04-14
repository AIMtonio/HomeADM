package crowdfunding.servicio;

import javax.servlet.http.HttpServletRequest;

import general.bean.MensajeTransaccionBean;
import herramientas.Utileria;
import crowdfunding.bean.CuentasMayorCRWBean;
import crowdfunding.bean.SubctaMonedaCRWBean;
import crowdfunding.bean.SubctaPlazoCRWBean;
import crowdfunding.dao.CuentasMayorCRWDAO;
import crowdfunding.dao.SubctaMonedaCRWDAO;
import crowdfunding.dao.SubctaPlazoCRWDAO;

public class GuiaContableCRWServicio {

	//---------- Variables ------------------------------------------------------------------------

	CuentasMayorCRWDAO cuentasMayorCRWDAO = null;
	SubctaMonedaCRWDAO subctaMonedaCRWDAO = null;
	SubctaPlazoCRWDAO  subctaPlazoCRWDAO = null;

	public GuiaContableCRWServicio() {
		super();
	}

	public static interface Enum_Tra_GuiaContableCRW {
		int alta	= 1;
		int modifica= 2;
		int baja 	= 3;
	}

	public static interface Enum_Con_GuiaContableCRW {
		int principal	= 1;
		int foranea 	= 2;
	}

	public static interface Enum_Lis_GuiaContableCRW {
		int principal 	= 1;
		int foranea 	= 2;
	}

	public MensajeTransaccionBean grabaTransaccion(HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;

		int  tipoTransaccionCM = Utileria.convierteEntero(request.getParameter("tipoTransaccionCM"));
		int tipoTransaccionTM = Utileria.convierteEntero(request.getParameter("tipoTransaccionTM"));
		int tipoTransaccionTP = Utileria.convierteEntero(request.getParameter("tipoTransaccionTP"));

		CuentasMayorCRWBean cuentasMayorCRWBean = new CuentasMayorCRWBean();
		switch(tipoTransaccionCM){
		case Enum_Tra_GuiaContableCRW.alta:
			cuentasMayorCRWBean.setConceptoCRWID(request.getParameter("conceptoCRWID"));
			cuentasMayorCRWBean.setCuenta(request.getParameter("cuenta"));
			cuentasMayorCRWBean.setNomenclatura(request.getParameter("nomenclatura"));
			cuentasMayorCRWBean.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
			mensaje = cuentasMayorCRWDAO.alta(cuentasMayorCRWBean);
			break;
		case Enum_Tra_GuiaContableCRW.baja:
			cuentasMayorCRWBean.setConceptoCRWID(request.getParameter("conceptoCRWID"));
			mensaje = cuentasMayorCRWDAO.baja(cuentasMayorCRWBean);
			break;
		case Enum_Tra_GuiaContableCRW.modifica:
			cuentasMayorCRWBean.setConceptoCRWID(request.getParameter("conceptoCRWID"));
			cuentasMayorCRWBean.setCuenta(request.getParameter("cuenta"));
			cuentasMayorCRWBean.setNomenclatura(request.getParameter("nomenclatura"));
			cuentasMayorCRWBean.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
			mensaje = cuentasMayorCRWDAO.modifica(cuentasMayorCRWBean);
			break;

		}

		SubctaMonedaCRWBean subctaMonedaCRWBean = new SubctaMonedaCRWBean();
		switch(tipoTransaccionTM){
		case Enum_Tra_GuiaContableCRW.alta:
			subctaMonedaCRWBean.setConceptoCRWID(request.getParameter("conceptoCRWID2"));
			subctaMonedaCRWBean.setMonedaID(request.getParameter("monedaID"));
			subctaMonedaCRWBean.setSubCuenta(request.getParameter("subCuenta"));
			mensaje = subctaMonedaCRWDAO.alta(subctaMonedaCRWBean);
			break;
		case Enum_Tra_GuiaContableCRW.baja:
			subctaMonedaCRWBean.setConceptoCRWID(request.getParameter("conceptoCRWID2"));
			subctaMonedaCRWBean.setMonedaID(request.getParameter("monedaID"));
			mensaje = subctaMonedaCRWDAO.baja(subctaMonedaCRWBean);
			break;
		case Enum_Tra_GuiaContableCRW.modifica:
			subctaMonedaCRWBean.setConceptoCRWID(request.getParameter("conceptoCRWID2"));
			subctaMonedaCRWBean.setMonedaID(request.getParameter("monedaID"));
			subctaMonedaCRWBean.setSubCuenta(request.getParameter("subCuenta"));
			mensaje = subctaMonedaCRWDAO.modifica(subctaMonedaCRWBean);
			break;

		}

		SubctaPlazoCRWBean  subctaPlazoCRWBean  = new SubctaPlazoCRWBean();
		switch(tipoTransaccionTP){
		case Enum_Tra_GuiaContableCRW.alta:
			subctaPlazoCRWBean.setConceptoCRWID(request.getParameter("conceptoCRWID3"));
			subctaPlazoCRWBean.setNumRetiros(request.getParameter("numRetiros"));
			subctaPlazoCRWBean.setSubCuenta(request.getParameter("subCuenta1"));
			mensaje = subctaPlazoCRWDAO.alta(subctaPlazoCRWBean);
			break;
		case Enum_Tra_GuiaContableCRW.baja:
			subctaPlazoCRWBean.setConceptoCRWID(request.getParameter("conceptoCRWID3"));
			subctaPlazoCRWBean.setNumRetiros(request.getParameter("numRetiros"));
			mensaje = subctaPlazoCRWDAO.baja(subctaPlazoCRWBean);
			break;
		case Enum_Tra_GuiaContableCRW.modifica:
			subctaPlazoCRWBean.setConceptoCRWID(request.getParameter("conceptoCRWID3"));
			subctaPlazoCRWBean.setNumRetiros(request.getParameter("numRetiros"));
			subctaPlazoCRWBean.setSubCuenta(request.getParameter("subCuenta1"));
			mensaje = subctaPlazoCRWDAO.modifica(subctaPlazoCRWBean);
			break;
		}
		return mensaje;
	}

	public CuentasMayorCRWDAO getCuentasMayorCRWDAO() {
		return cuentasMayorCRWDAO;
	}

	public void setCuentasMayorCRWDAO(CuentasMayorCRWDAO cuentasMayorCRWDAO) {
		this.cuentasMayorCRWDAO = cuentasMayorCRWDAO;
	}

	public SubctaMonedaCRWDAO getSubctaMonedaCRWDAO() {
		return subctaMonedaCRWDAO;
	}

	public void setSubctaMonedaCRWDAO(SubctaMonedaCRWDAO subctaMonedaCRWDAO) {
		this.subctaMonedaCRWDAO = subctaMonedaCRWDAO;
	}

	public SubctaPlazoCRWDAO getSubctaPlazoCRWDAO() {
		return subctaPlazoCRWDAO;
	}

	public void setSubctaPlazoCRWDAO(SubctaPlazoCRWDAO subctaPlazoCRWDAO) {
		this.subctaPlazoCRWDAO = subctaPlazoCRWDAO;
	}
}