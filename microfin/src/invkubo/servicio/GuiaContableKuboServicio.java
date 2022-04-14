package invkubo.servicio;

import javax.servlet.http.HttpServletRequest;

import general.bean.MensajeTransaccionBean;
import invkubo.bean.CuentasMayorKuboBean;
import invkubo.bean.SubctaMonedaKuboBean;
import invkubo.bean.SubctaPlazoKuboBean;
import invkubo.dao.CuentasMayorKuboDAO;
import invkubo.dao.SubctaMonedaKuboDAO;
import invkubo.dao.SubctaPlazoKuboDAO;

public class GuiaContableKuboServicio {
	
	//---------- Variables ------------------------------------------------------------------------

	CuentasMayorKuboDAO cuentasMayorKuboDAO = null;
	SubctaMonedaKuboDAO subctaMonedaKuboDAO = null;
	SubctaPlazoKuboDAO  subctaPlazoKuboDAO = null;

	public GuiaContableKuboServicio() {
		super();
	}
	
	
	//---------- Tipos de Transacciones---------------------------------------------------------------

	public static interface Enum_Tra_GuiaContableKubo {
		int alta	= 1;
		int modifica= 2;
		int baja 	= 3;
	}

	//---------- Tipos de Consultas---------------------------------------------------------------

	public static interface Enum_Con_GuiaContableKubo {
		int principal	= 1;
		int foranea 	= 2;
	}
	
	//---------- Tipos de Listas---------------------------------------------------------------

	public static interface Enum_Lis_GuiaContableKubo {
		int principal 	= 1;
		int foranea 	= 2;
	}
	
	//---------- Metodo que Contiene las Transacciones---------------------------------------------------------------
	public MensajeTransaccionBean grabaTransaccion(HttpServletRequest request){
		MensajeTransaccionBean mensaje = null;
		
		int  tipoTransaccionCM = (request.getParameter("tipoTransaccionCM")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccionCM")):
					0;
		int tipoTransaccionTM = (request.getParameter("tipoTransaccionTM")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccionTM")):
					0;
		int tipoTransaccionTP = (request.getParameter("tipoTransaccionTP")!=null)?
					Integer.parseInt(request.getParameter("tipoTransaccionTP")):
					0;
							
	//----------Transacciones de CuentasMayor---------------------------------------------------------------
							
		CuentasMayorKuboBean cuentasMayorKuboBean = new CuentasMayorKuboBean();
		switch(tipoTransaccionCM){
			case Enum_Tra_GuiaContableKubo.alta:
				cuentasMayorKuboBean.setConceptoKuboID(request.getParameter("conceptoKuboID"));
				cuentasMayorKuboBean.setCuenta(request.getParameter("cuenta"));
				cuentasMayorKuboBean.setNomenclatura(request.getParameter("nomenclatura"));
				cuentasMayorKuboBean.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				mensaje = cuentasMayorKuboDAO.alta(cuentasMayorKuboBean);
				break;
			case Enum_Tra_GuiaContableKubo.baja:
				cuentasMayorKuboBean.setConceptoKuboID(request.getParameter("conceptoKuboID"));
				mensaje = cuentasMayorKuboDAO.baja(cuentasMayorKuboBean);
				break;
			case Enum_Tra_GuiaContableKubo.modifica:
				cuentasMayorKuboBean.setConceptoKuboID(request.getParameter("conceptoKuboID"));
				cuentasMayorKuboBean.setCuenta(request.getParameter("cuenta"));
				cuentasMayorKuboBean.setNomenclatura(request.getParameter("nomenclatura"));
				cuentasMayorKuboBean.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				mensaje = cuentasMayorKuboDAO.modifica(cuentasMayorKuboBean);
				break;
		
		}
		
		//----------Transacciones por Tipo de Moneda---------------------------------------------------------------
	
		SubctaMonedaKuboBean subctaMonedaKuboBean = new SubctaMonedaKuboBean();
		switch(tipoTransaccionTM){
			case Enum_Tra_GuiaContableKubo.alta:
				subctaMonedaKuboBean.setConceptoKuboID(request.getParameter("conceptoKuboID2"));
				subctaMonedaKuboBean.setMonedaID(request.getParameter("monedaID"));
				subctaMonedaKuboBean.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subctaMonedaKuboDAO.alta(subctaMonedaKuboBean);
				break;
			case Enum_Tra_GuiaContableKubo.baja:
				subctaMonedaKuboBean.setConceptoKuboID(request.getParameter("conceptoKuboID2"));
				subctaMonedaKuboBean.setMonedaID(request.getParameter("monedaID"));
				mensaje = subctaMonedaKuboDAO.baja(subctaMonedaKuboBean);
				break;
			case Enum_Tra_GuiaContableKubo.modifica:
				subctaMonedaKuboBean.setConceptoKuboID(request.getParameter("conceptoKuboID2"));
				subctaMonedaKuboBean.setMonedaID(request.getParameter("monedaID"));
				subctaMonedaKuboBean.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subctaMonedaKuboDAO.modifica(subctaMonedaKuboBean);
				break;
		
		}
		
		//----------Transacciones por Plazo--------------------------------------------------------------

		
		SubctaPlazoKuboBean  subctaPlazoKuboBean  = new SubctaPlazoKuboBean();
		switch(tipoTransaccionTP){
			case Enum_Tra_GuiaContableKubo.alta:
				subctaPlazoKuboBean.setConceptoKuboID(request.getParameter("conceptoKuboID3"));
				subctaPlazoKuboBean.setNumRetiros(request.getParameter("numRetiros"));
				subctaPlazoKuboBean.setSubCuenta(request.getParameter("subCuenta1"));
				mensaje = subctaPlazoKuboDAO.alta(subctaPlazoKuboBean);
				break;
			case Enum_Tra_GuiaContableKubo.baja:
				subctaPlazoKuboBean.setConceptoKuboID(request.getParameter("conceptoKuboID3"));
				subctaPlazoKuboBean.setNumRetiros(request.getParameter("numRetiros"));
				mensaje = subctaPlazoKuboDAO.baja(subctaPlazoKuboBean);
				break;
			case Enum_Tra_GuiaContableKubo.modifica:
				subctaPlazoKuboBean.setConceptoKuboID(request.getParameter("conceptoKuboID3"));
				subctaPlazoKuboBean.setNumRetiros(request.getParameter("numRetiros"));
				subctaPlazoKuboBean.setSubCuenta(request.getParameter("subCuenta1"));
				mensaje = subctaPlazoKuboDAO.modifica(subctaPlazoKuboBean);
				break;		
		}
									
									
		return mensaje;
	}

	
	//------------------ Geters y Seters ------------------------------------------------------	

	public CuentasMayorKuboDAO getCuentasMayorKuboDAO() {
		return cuentasMayorKuboDAO;
	}

	public void setCuentasMayorKuboDAO(CuentasMayorKuboDAO cuentasMayorKuboDAO) {
		this.cuentasMayorKuboDAO = cuentasMayorKuboDAO;
	}

	public SubctaMonedaKuboDAO getSubctaMonedaKuboDAO() {
		return subctaMonedaKuboDAO;
	}

	public void setSubctaMonedaKuboDAO(SubctaMonedaKuboDAO subctaMonedaKuboDAO) {
		this.subctaMonedaKuboDAO = subctaMonedaKuboDAO;
	}

	public SubctaPlazoKuboDAO getSubctaPlazoKuboDAO() {
		return subctaPlazoKuboDAO;
	}

	public void setSubctaPlazoKuboDAO(SubctaPlazoKuboDAO subctaPlazoKuboDAO) {
		this.subctaPlazoKuboDAO = subctaPlazoKuboDAO;
	}
	


}
