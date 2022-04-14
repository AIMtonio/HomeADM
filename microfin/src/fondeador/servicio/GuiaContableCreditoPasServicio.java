package fondeador.servicio;

import fondeador.bean.CuentasMayorCreditoPasBean;
import fondeador.bean.SubCtaInstFonBean;
import fondeador.bean.SubCtaMonFonBean;
import fondeador.bean.SubCtaNacInstFonBean;
import fondeador.bean.SubCtaPorPlazoFonBean;
import fondeador.bean.SubCtaTipInstFonBean;
import fondeador.bean.SubCtaTipPerFonBean;
import fondeador.dao.CuentasMayorCreditoPasDAO;
import fondeador.dao.SubCtaInsFonDAO;
import fondeador.dao.SubCtaMonFonDAO;
import fondeador.dao.SubCtaNacInsFonDAO;
import fondeador.dao.SubCtaPorPlazoFonDAO;
import fondeador.dao.SubCtaTipInsFonDAO;
import fondeador.dao.SubCtaTipPerFonDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import javax.servlet.http.HttpServletRequest;

public class GuiaContableCreditoPasServicio extends BaseServicio{

	private GuiaContableCreditoPasServicio (){
		super();
	}

	CuentasMayorCreditoPasDAO	cuentasMayorCreditoPasDAO	= null;
	SubCtaTipInsFonDAO			subCtaTipInsFonDAO 			= null;
	SubCtaPorPlazoFonDAO		subCtaPorPlazoFonDAO		= null;
	SubCtaNacInsFonDAO			subCtaNacInsFonDAO			= null;
	SubCtaInsFonDAO				subCtaInsFonDAO				= null;
	SubCtaTipPerFonDAO			subCtaTipPerFonDAO			= null;
	SubCtaMonFonDAO				subCtaMonFonDAO				= null;

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
		int tipoTransaccionTPI = (request.getParameter("tipoTransaccionTPI")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionTPI")):
										0;
		int tipoTransaccionPLZ = (request.getParameter("tipoTransaccionPLZ")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionPLZ")):
										0;
		int tipoTransaccionNC = (request.getParameter("tipoTransaccionNC")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionNC")):
										0;
		int tipoTransaccionIF = (request.getParameter("tipoTransaccionIF")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionIF")):
										0;
		int tipoTransaccionTPE = (request.getParameter("tipoTransaccionTPE")!=null)?
									Integer.parseInt(request.getParameter("tipoTransaccionTPE")):
										0;
		int tipoTransaccionTM  = (request.getParameter("tipoTransaccionTM") != null)?
									Integer.parseInt(request.getParameter("tipoTransaccionTM")):
										0;
		CuentasMayorCreditoPasBean cuentasMayorCreditoPas = new CuentasMayorCreditoPasBean();
		//System.out.println("tipooo fondeadoooor"+request.getParameter("tipoFondeador"));
		
		switch(tipoTransaccionCM){
			case Enum_Tra_GuiaContableAho.alta:
				cuentasMayorCreditoPas.setConceptoFondID(request.getParameter("conceptoFondID"));
				cuentasMayorCreditoPas.setTipoFondeador(request.getParameter("tipoFondeador"));
				cuentasMayorCreditoPas.setCuenta(request.getParameter("cuenta"));
				cuentasMayorCreditoPas.setNomenclatura(request.getParameter("nomenclatura"));
				mensaje = cuentasMayorCreditoPasDAO.alta(cuentasMayorCreditoPas);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				cuentasMayorCreditoPas.setConceptoFondID(request.getParameter("conceptoFondID"));
				cuentasMayorCreditoPas.setTipoFondeador(request.getParameter("tipoFondeador"));
				mensaje = cuentasMayorCreditoPasDAO.baja(cuentasMayorCreditoPas);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				cuentasMayorCreditoPas.setConceptoFondID(request.getParameter("conceptoFondID"));
				cuentasMayorCreditoPas.setTipoFondeador(request.getParameter("tipoFondeador"));
				cuentasMayorCreditoPas.setCuenta(request.getParameter("cuenta"));
				cuentasMayorCreditoPas.setNomenclatura(request.getParameter("nomenclatura"));
				mensaje = cuentasMayorCreditoPasDAO.modifica(cuentasMayorCreditoPas);
				break;
		}
		
		//transaccion Tipo Institucion
		SubCtaTipInstFonBean subCtaTipInstFonBean = new SubCtaTipInstFonBean();
		switch(tipoTransaccionTPI){
			case Enum_Tra_GuiaContableAho.alta:
				subCtaTipInstFonBean.setConceptoFondID(request.getParameter("conceptoFondID2"));
				subCtaTipInstFonBean.setTipoFondeador(request.getParameter("tipoFondeador2"));
				subCtaTipInstFonBean.setTipoInstitID(request.getParameter("tipoInstitID"));
				subCtaTipInstFonBean.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subCtaTipInsFonDAO.alta(subCtaTipInstFonBean);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				subCtaTipInstFonBean.setConceptoFondID(request.getParameter("conceptoFondID2"));
				subCtaTipInstFonBean.setTipoFondeador(request.getParameter("tipoFondeador2"));
				subCtaTipInstFonBean.setTipoInstitID(request.getParameter("tipoInstitID"));
						mensaje = subCtaTipInsFonDAO.baja(subCtaTipInstFonBean);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				subCtaTipInstFonBean.setConceptoFondID(request.getParameter("conceptoFondID2"));
				subCtaTipInstFonBean.setTipoFondeador(request.getParameter("tipoFondeador2"));
				subCtaTipInstFonBean.setTipoInstitID(request.getParameter("tipoInstitID"));
				subCtaTipInstFonBean.setSubCuenta(request.getParameter("subCuenta"));
				mensaje = subCtaTipInsFonDAO.modifica(subCtaTipInstFonBean);
				break;
		}	

		//Transaccion Por Plazo
		SubCtaPorPlazoFonBean subCtaPorPlazoFonBean = new SubCtaPorPlazoFonBean();
		switch(tipoTransaccionPLZ){
			case Enum_Tra_GuiaContableAho.alta:
				subCtaPorPlazoFonBean.setConceptoFondID(request.getParameter("conceptoFondID3"));
				subCtaPorPlazoFonBean.setTipoFondeador(request.getParameter("tipoFondeador3"));
				subCtaPorPlazoFonBean.setCortoPlazo(request.getParameter("cortoPlazo"));
				subCtaPorPlazoFonBean.setLargoPlazo(request.getParameter("largoPlazo"));
				mensaje = subCtaPorPlazoFonDAO.alta(subCtaPorPlazoFonBean);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				subCtaPorPlazoFonBean.setConceptoFondID(request.getParameter("conceptoFondID3"));
				subCtaPorPlazoFonBean.setTipoFondeador(request.getParameter("tipoFondeador3"));
						mensaje = subCtaPorPlazoFonDAO.baja(subCtaPorPlazoFonBean);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				subCtaPorPlazoFonBean.setConceptoFondID(request.getParameter("conceptoFondID3"));
				subCtaPorPlazoFonBean.setTipoFondeador(request.getParameter("tipoFondeador3"));
				subCtaPorPlazoFonBean.setCortoPlazo(request.getParameter("cortoPlazo"));
				subCtaPorPlazoFonBean.setLargoPlazo(request.getParameter("largoPlazo"));
				mensaje = subCtaPorPlazoFonDAO.modifica(subCtaPorPlazoFonBean);
				break;
		}	
			
		//Transaccion Por Nacionalidad
		SubCtaNacInstFonBean subCtaNacInstFonBean = new SubCtaNacInstFonBean();
		switch(tipoTransaccionNC){
			case Enum_Tra_GuiaContableAho.alta:
				subCtaNacInstFonBean.setConceptoFondID(request.getParameter("conceptoFondID4"));
				subCtaNacInstFonBean.setTipoFondeador(request.getParameter("tipoFondeador4"));
				subCtaNacInstFonBean.setNacional(request.getParameter("nacional"));
				subCtaNacInstFonBean.setExtranjera(request.getParameter("extranjera"));
						mensaje = subCtaNacInsFonDAO.alta(subCtaNacInstFonBean);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				subCtaNacInstFonBean.setConceptoFondID(request.getParameter("conceptoFondID4"));
				subCtaNacInstFonBean.setTipoFondeador(request.getParameter("tipoFondeador4"));
						mensaje = subCtaNacInsFonDAO.baja(subCtaNacInstFonBean);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				subCtaNacInstFonBean.setConceptoFondID(request.getParameter("conceptoFondID4"));
				subCtaNacInstFonBean.setTipoFondeador(request.getParameter("tipoFondeador4"));
				subCtaNacInstFonBean.setNacional(request.getParameter("nacional"));
				subCtaNacInstFonBean.setExtranjera(request.getParameter("extranjera"));
							mensaje = subCtaNacInsFonDAO.modifica(subCtaNacInstFonBean);
				break;
		}	
				
		//Transaccion Por Instituciónde Fondeo
		SubCtaInstFonBean subCtaInstFonBean = new SubCtaInstFonBean();
		switch(tipoTransaccionIF){
			case Enum_Tra_GuiaContableAho.alta:
				subCtaInstFonBean.setConceptoFondID(request.getParameter("conceptoFondID5"));
				subCtaInstFonBean.setTipoFondeador(request.getParameter("tipoFondeador5"));
				subCtaInstFonBean.setInstitutFondID(request.getParameter("institutFondID"));
				subCtaInstFonBean.setSubCuentaIns(request.getParameter("subCuentaIns"));
				mensaje = subCtaInsFonDAO.alta(subCtaInstFonBean);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				subCtaInstFonBean.setConceptoFondID(request.getParameter("conceptoFondID5"));
				subCtaInstFonBean.setTipoFondeador(request.getParameter("tipoFondeador5"));
				subCtaInstFonBean.setInstitutFondID(request.getParameter("institutFondID"));
						mensaje = subCtaInsFonDAO.baja(subCtaInstFonBean);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				subCtaInstFonBean.setConceptoFondID(request.getParameter("conceptoFondID5"));
				subCtaInstFonBean.setTipoFondeador(request.getParameter("tipoFondeador5"));
				subCtaInstFonBean.setInstitutFondID(request.getParameter("institutFondID"));
				subCtaInstFonBean.setSubCuentaIns(request.getParameter("subCuentaIns"));
				mensaje = subCtaInsFonDAO.modifica(subCtaInstFonBean);
				break;
		}
		
		//Transaccion Por Tipo de Persona
		SubCtaTipPerFonBean subCtaTipPerFonBean = new SubCtaTipPerFonBean();
		switch(tipoTransaccionTPE){
			case Enum_Tra_GuiaContableAho.alta:
				subCtaTipPerFonBean.setConceptoFondID(request.getParameter("conceptoFondID1"));
				subCtaTipPerFonBean.setTipoFondeador(request.getParameter("tipoFondeador1"));
				subCtaTipPerFonBean.setFisica(request.getParameter("fisica"));
				subCtaTipPerFonBean.setFisicaActEmp(request.getParameter("fisicaActEmp"));
				subCtaTipPerFonBean.setMoral(request.getParameter("moral"));
				mensaje = subCtaTipPerFonDAO.alta(subCtaTipPerFonBean);
				break;
			case Enum_Tra_GuiaContableAho.baja:
				subCtaTipPerFonBean.setConceptoFondID(request.getParameter("conceptoFondID1"));
				subCtaTipPerFonBean.setTipoFondeador(request.getParameter("tipoFondeador1"));
				mensaje = subCtaTipPerFonDAO.baja(subCtaTipPerFonBean);
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				subCtaTipPerFonBean.setConceptoFondID(request.getParameter("conceptoFondID1"));
				subCtaTipPerFonBean.setTipoFondeador(request.getParameter("tipoFondeador1"));
				subCtaTipPerFonBean.setFisica(request.getParameter("fisica"));
				subCtaTipPerFonBean.setFisicaActEmp(request.getParameter("fisicaActEmp"));
				subCtaTipPerFonBean.setMoral(request.getParameter("moral"));
				mensaje = subCtaTipPerFonDAO.modifica(subCtaTipPerFonBean);
				break;
		}
		// Transaccion por tipo de moneda
		SubCtaMonFonBean subCtaMonFonBean = new SubCtaMonFonBean();
		switch (tipoTransaccionTM) {
			case Enum_Tra_GuiaContableAho.alta:
				subCtaMonFonBean.setConceptoFonID(request.getParameter("conceptoFondID6"));
				subCtaMonFonBean.setTipoFondeo(request.getParameter("tipoFondeador6"));
				subCtaMonFonBean.setMonedaID(request.getParameter("monedaID"));
				subCtaMonFonBean.setSubCuenta(request.getParameter("subCuentaTM"));
				mensaje = subCtaMonFonDAO.alta(subCtaMonFonBean);			
				break;
			case Enum_Tra_GuiaContableAho.modifica:
				subCtaMonFonBean.setConceptoFonID(request.getParameter("conceptoFondID6"));
				subCtaMonFonBean.setTipoFondeo(request.getParameter("tipoFondeador6"));
				subCtaMonFonBean.setMonedaID(request.getParameter("monedaID"));
				subCtaMonFonBean.setSubCuenta(request.getParameter("subCuentaTM"));
				mensaje = subCtaMonFonDAO.modifica(subCtaMonFonBean);	
				break;
			case Enum_Tra_GuiaContableAho.baja:
				subCtaMonFonBean.setConceptoFonID(request.getParameter("conceptoFondID6"));
				subCtaMonFonBean.setTipoFondeo(request.getParameter("tipoFondeador6"));
				subCtaMonFonBean.setMonedaID(request.getParameter("monedaID"));
				mensaje = subCtaMonFonDAO.baja(subCtaMonFonBean);	
				break;
		}
			
		return mensaje;
	}
	public CuentasMayorCreditoPasDAO getCuentasMayorCreditoPasDAO() {
		return cuentasMayorCreditoPasDAO;
	}

	public SubCtaPorPlazoFonDAO getSubCtaPorPlazoFonDAO() {
		return subCtaPorPlazoFonDAO;
	}
	public void setSubCtaPorPlazoFonDAO(SubCtaPorPlazoFonDAO subCtaPorPlazoFonDAO) {
		this.subCtaPorPlazoFonDAO = subCtaPorPlazoFonDAO;
	}
	public SubCtaNacInsFonDAO getSubCtaNacInsFonDAO() {
		return subCtaNacInsFonDAO;
	}
	public void setSubCtaNacInsFonDAO(SubCtaNacInsFonDAO subCtaNacInsFonDAO) {
		this.subCtaNacInsFonDAO = subCtaNacInsFonDAO;
	}
	public SubCtaInsFonDAO getSubCtaInsFonDAO() {
		return subCtaInsFonDAO;
	}
	public void setSubCtaInsFonDAO(SubCtaInsFonDAO subCtaInsFonDAO) {
		this.subCtaInsFonDAO = subCtaInsFonDAO;
	}
	public SubCtaTipInsFonDAO getSubCtaTipInsFonDAO() {
		return subCtaTipInsFonDAO;
	}

	public void setSubCtaTipInsFonDAO(SubCtaTipInsFonDAO subCtaTipInsFonDAO) {
		this.subCtaTipInsFonDAO = subCtaTipInsFonDAO;
	}

	public void setCuentasMayorCreditoPasDAO(
			CuentasMayorCreditoPasDAO cuentasMayorCreditoPasDAO) {
		this.cuentasMayorCreditoPasDAO = cuentasMayorCreditoPasDAO;
	}
	public SubCtaTipPerFonDAO getSubCtaTipPerFonDAO() {
		return subCtaTipPerFonDAO;
	}
	public void setSubCtaTipPerFonDAO(SubCtaTipPerFonDAO subCtaTipPerFonDAO) {
		this.subCtaTipPerFonDAO = subCtaTipPerFonDAO;
	}
	public SubCtaMonFonDAO getSubCtaMonFonDAO() {
		return subCtaMonFonDAO;
	}
	public void setSubCtaMonFonDAO(SubCtaMonFonDAO subCtaMonFonDAO) {
		this.subCtaMonFonDAO = subCtaMonFonDAO;
	}
	

	
}