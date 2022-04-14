package inversiones.servicio;

import javax.servlet.http.HttpServletRequest;

import inversiones.dao.CuentasMayorInvDAO;
import inversiones.dao.SubCtaMonedaInvDAO;
import inversiones.dao.SubCtaTiPerInvDAO;
import inversiones.dao.SubCtaTiProInvDAO;
import inversiones.dao.SubCtaPlazoInvDAO;

import inversiones.bean.CuentasMayorInvBean;
import inversiones.bean.SubCtaMonedaInvBean;
import inversiones.bean.SubCtaTiPerInvBean;
import inversiones.bean.SubCtaTiProInvBean;
import inversiones.bean.SubCtaPlazoInvBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class GuiaContableInverServicio  extends BaseServicio  {

	private GuiaContableInverServicio(){
		super();
	}
	CuentasMayorInvDAO 	cuentasMayorInvDAO 	= null;
	SubCtaTiProInvDAO 	subCtaTiProInvDAO 	= null;
	SubCtaTiPerInvDAO 	subCtaTiPerInvDAO 	= null;
	SubCtaMonedaInvDAO 	subCtaMonedaInvDAO 	= null;
	SubCtaPlazoInvDAO 	subCtaPlazoInvDAO 	= null;

	public static interface Enum_Tra_GuiaContableInver {
		int alta	= 1;
		int modifica= 2;
		int baja 	= 3;
	}

	public static interface Enum_Con_GuiaContableInver{
		int principal	= 1;
		int foranea 	= 2;
	}

	public static interface Enum_Lis_GuiaContableInver{
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

		CuentasMayorInvBean cuentasMayorInv = new CuentasMayorInvBean();
		switch(tipoTransaccionCM){
			case Enum_Tra_GuiaContableInver.alta:
				cuentasMayorInv.setConceptoInvID(request.getParameter("conceptoInvID"));
				cuentasMayorInv.setCuenta(request.getParameter("cuenta"));
				cuentasMayorInv.setNomenclatura(request.getParameter("nomenclatura"));
				cuentasMayorInv.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				mensaje = cuentasMayorInvDAO.alta(cuentasMayorInv);
				break;
			case Enum_Tra_GuiaContableInver.baja:
				cuentasMayorInv.setConceptoInvID(request.getParameter("conceptoInvID"));
				mensaje = cuentasMayorInvDAO.baja(cuentasMayorInv);
				break;
			case Enum_Tra_GuiaContableInver.modifica:
				cuentasMayorInv.setConceptoInvID(request.getParameter("conceptoInvID"));
				cuentasMayorInv.setCuenta(request.getParameter("cuenta"));
				cuentasMayorInv.setNomenclatura(request.getParameter("nomenclatura"));
				cuentasMayorInv.setNomenclaturaCR(request.getParameter("nomenclaturaCR"));
				mensaje = cuentasMayorInvDAO.modifica(cuentasMayorInv);
				break;
		}
		SubCtaTiProInvBean subCtaTiProInv = new SubCtaTiProInvBean();
		switch(tipoTransaccionTPR){
			case Enum_Tra_GuiaContableInver.alta:
				subCtaTiProInv.setConceptoInvID(request.getParameter("conceptoInvID3"));
				subCtaTiProInv.setTipoProductoID(request.getParameter("tipoProductoID"));
				subCtaTiProInv.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subCtaTiProInvDAO.alta(subCtaTiProInv);
				break;
			case Enum_Tra_GuiaContableInver.baja:
				subCtaTiProInv.setConceptoInvID(request.getParameter("conceptoInvID3"));
				subCtaTiProInv.setTipoProductoID(request.getParameter("tipoProductoID"));
				mensaje = subCtaTiProInvDAO.baja(subCtaTiProInv);
				break;
			case Enum_Tra_GuiaContableInver.modifica:
				subCtaTiProInv.setConceptoInvID(request.getParameter("conceptoInvID3"));
				subCtaTiProInv.setTipoProductoID(request.getParameter("tipoProductoID"));
				subCtaTiProInv.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subCtaTiProInvDAO.modifica(subCtaTiProInv);
				break;
		}	
			
		SubCtaTiPerInvBean subCtaTiPerInvBean = new SubCtaTiPerInvBean();
		switch(tipoTransaccionTPE){
			case Enum_Tra_GuiaContableInver.alta:
				subCtaTiPerInvBean.setConceptoInvID(request.getParameter("conceptoInvID4"));
				subCtaTiPerInvBean.setFisica(request.getParameter("fisica"));
				subCtaTiPerInvBean.setMoral(request.getParameter("moral"));
				mensaje = subCtaTiPerInvDAO.alta(subCtaTiPerInvBean);
				break;
			case Enum_Tra_GuiaContableInver.baja:
				subCtaTiPerInvBean.setConceptoInvID(request.getParameter("conceptoInvID4"));
				mensaje = subCtaTiPerInvDAO.baja(subCtaTiPerInvBean);
				break;
			case Enum_Tra_GuiaContableInver.modifica:
				subCtaTiPerInvBean.setConceptoInvID(request.getParameter("conceptoInvID4"));
				subCtaTiPerInvBean.setFisica(request.getParameter("fisica"));
				subCtaTiPerInvBean.setMoral(request.getParameter("moral"));
				mensaje = subCtaTiPerInvDAO.modifica(subCtaTiPerInvBean);
				break;
		}	
		
		SubCtaMonedaInvBean subCtaMonedaInvBean = new SubCtaMonedaInvBean();
		switch(tipoTransaccionSM){
			case Enum_Tra_GuiaContableInver.alta:
				subCtaMonedaInvBean.setConceptoInvID(request.getParameter("conceptoInvID5"));
				subCtaMonedaInvBean.setMonedaID(request.getParameter("monedaID"));
				subCtaMonedaInvBean.setSubCuenta(request.getParameter("subCuenta2"));
				mensaje = subCtaMonedaInvDAO.alta(subCtaMonedaInvBean);
				break;
			case Enum_Tra_GuiaContableInver.baja:
				subCtaMonedaInvBean.setConceptoInvID(request.getParameter("conceptoInvID5"));
				subCtaMonedaInvBean.setMonedaID(request.getParameter("monedaID"));
				mensaje = subCtaMonedaInvDAO.baja(subCtaMonedaInvBean);
				break;
			case Enum_Tra_GuiaContableInver.modifica:
				subCtaMonedaInvBean.setConceptoInvID(request.getParameter("conceptoInvID5"));
				subCtaMonedaInvBean.setMonedaID(request.getParameter("monedaID"));
				subCtaMonedaInvBean.setSubCuenta(request.getParameter("subCuenta2"));
				mensaje = subCtaMonedaInvDAO.modifica(subCtaMonedaInvBean);
				break;
		}		
		SubCtaPlazoInvBean subCtaPlazoInv = new SubCtaPlazoInvBean();
		switch(tipoTransaccionSP){
			case Enum_Tra_GuiaContableInver.baja:
				subCtaPlazoInv.setConceptoInvID(request.getParameter("conceptoInvID2"));
				subCtaPlazoInv.setSubCtaPlazoInvID(request.getParameter("subCtaPlazoInvID"));
				mensaje = subCtaPlazoInvDAO.baja(subCtaPlazoInv);
				break;
			case Enum_Tra_GuiaContableInver.modifica:
				subCtaPlazoInv.setConceptoInvID(request.getParameter("conceptoInvID2"));
				subCtaPlazoInv.setSubCtaPlazoInvID(request.getParameter("subCtaPlazoInvID"));
				subCtaPlazoInv.setSubCuenta(request.getParameter("subCuentaP"));
				mensaje = subCtaPlazoInvDAO.modifica(subCtaPlazoInv);
				break;
		}
		
		return mensaje;
	}

	public void setCuentasMayorInvDAO(CuentasMayorInvDAO cuentasMayorInvDAO) {
		this.cuentasMayorInvDAO = cuentasMayorInvDAO;
	}
	

	public void setSubCtaTiProInvDAO(SubCtaTiProInvDAO subCtaTiProInvDAO) {
		this.subCtaTiProInvDAO = subCtaTiProInvDAO;
	}

	public void setSubCtaTiPerInvDAO(SubCtaTiPerInvDAO subCtaTiPerInvDAO) {
		this.subCtaTiPerInvDAO = subCtaTiPerInvDAO;
	}

	public void setSubCtaMonedaInvDAO(SubCtaMonedaInvDAO subCtaMonedaInvDAO) {
		this.subCtaMonedaInvDAO = subCtaMonedaInvDAO;
	}

	public void setSubCtaPlazoInvDAO(SubCtaPlazoInvDAO subCtaPlazoInvDAO) {
		this.subCtaPlazoInvDAO = subCtaPlazoInvDAO;
	}

	
}

