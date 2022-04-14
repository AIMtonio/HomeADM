package tesoreria.servicio;

import javax.servlet.http.HttpServletRequest;

import tesoreria.bean.CuentasMayorInvBanBean;
import tesoreria.bean.SubCtaDeudaInvBanBean;
import tesoreria.bean.SubCtaInstInvBanBean;
import tesoreria.bean.SubCtaMonedaInvBanBean;
import tesoreria.bean.SubCtaPlazoInvBanBean;
import tesoreria.bean.SubCtaRestInvBanBean;
import tesoreria.bean.SubCtaTituInvBanBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class GuiaContableInverBancariaServicio extends BaseServicio {
	CuentasMayorInvBanServicio	cuentasMayorInvBanServicio 	= null;
	SubCtaMonedaInvBanServicio	subCtaMonedaInvBanServicio	= null;
	SubCtaInstInvBanServicio	subCtaInstInvBanServicio	= null;
	SubCtaTituInvBanServicio	subCtaTituInvBanServicio	= null;
	SubCtaRestInvBanServicio	subCtaRestInvBanServicio	= null;
	SubCtaDeudaInvBanServicio	subCtaDeudaInvBanServicio	= null;
	SubCtaPlazoInvBanServicio	subCtaPlazoInvBanServicio	= null;

	private GuiaContableInverBancariaServicio(){
		super();
	}
	
	public static interface Enum_Tra_GuiaContableInverBan {
		int alta	= 1;
		int modifica= 2;
		int baja 	= 3;
	}

	public static interface Enum_Con_GuiaContableInverBan{
		int principal	= 1;
	}

	public static interface Enum_Lis_GuiaContableInverBan{
		int principal 	= 1;
	}

	public MensajeTransaccionBean grabaTransaccion(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		int tipoTransaccionCM = (request.getParameter("tipoTransaccionCM")!=null)?Integer.parseInt(request.getParameter("tipoTransaccionCM")):0;
		int tipoTransaccionTM = (request.getParameter("tipoTransaccionTM")!=null)?Integer.parseInt(request.getParameter("tipoTransaccionTM")):0;
		int tipoTransaccionTP = (request.getParameter("tipoTransaccionTP")!=null)?Integer.parseInt(request.getParameter("tipoTransaccionTP")):0;
		int tipoTransaccionTT = (request.getParameter("tipoTransaccionTT")!=null)?Integer.parseInt(request.getParameter("tipoTransaccionTT")):0;
		int tipoTransaccionR = (request.getParameter("tipoTransaccionR")!=null)?Integer.parseInt(request.getParameter("tipoTransaccionR")):0;
		int tipoTransaccionTD = (request.getParameter("tipoTransaccionTD")!=null)?Integer.parseInt(request.getParameter("tipoTransaccionTD")):0;
		int tipoTransaccionPB = (request.getParameter("tipoTransaccionPB")!=null)?Integer.parseInt(request.getParameter("tipoTransaccionPB")):0;

		/** CUENTAS MAYOR **/
		if(tipoTransaccionCM!=0){
			CuentasMayorInvBanBean cuentasMayorInvBan = new CuentasMayorInvBanBean();
			cuentasMayorInvBan.setConceptoInvBanID(request.getParameter("ConceptoInvBanID")!=null?request.getParameter("ConceptoInvBanID"):"0");
			cuentasMayorInvBan.setCuenta(request.getParameter("Cuenta")!=null?request.getParameter("Cuenta"):null);
			cuentasMayorInvBan.setNomenclatura(request.getParameter("Nomenclatura")!=null?request.getParameter("Nomenclatura"):null);
			mensaje = cuentasMayorInvBanServicio.grabaTransaccion(tipoTransaccionCM, cuentasMayorInvBan);
		} else if(tipoTransaccionTM!=0){
				SubCtaMonedaInvBanBean subCtaMonedaInvBanBean=new SubCtaMonedaInvBanBean();
				subCtaMonedaInvBanBean.setConceptoInvBanID(request.getParameter("ConceptoInvBanID")!=null?request.getParameter("ConceptoInvBanID"):"0");
				subCtaMonedaInvBanBean.setMonedaID(request.getParameter("MonedaID")!=null?request.getParameter("MonedaID"):null);
				subCtaMonedaInvBanBean.setSubCuenta(request.getParameter("SubCuenta")!=null?request.getParameter("SubCuenta"):null);
				mensaje= subCtaMonedaInvBanServicio.grabaTransaccion(tipoTransaccionTM, subCtaMonedaInvBanBean);
			} else if(tipoTransaccionTP!=0){
				SubCtaInstInvBanBean SubCtaInstInvBanBean=new SubCtaInstInvBanBean();
				SubCtaInstInvBanBean.setConceptoInvBanID(request.getParameter("ConceptoInvBanID")!=null?request.getParameter("ConceptoInvBanID"):"0");
				SubCtaInstInvBanBean.setInstitucionID(request.getParameter("InstitucionID")!=null?request.getParameter("InstitucionID"):null);
				SubCtaInstInvBanBean.setSubCuenta(request.getParameter("SubCuenta")!=null?request.getParameter("SubCuenta"):null);
				mensaje= subCtaInstInvBanServicio.grabaTransaccion(tipoTransaccionTP, SubCtaInstInvBanBean);
				} else if(tipoTransaccionTT!=0){
					SubCtaTituInvBanBean subCtaTiPerInvBanBean=new SubCtaTituInvBanBean();
					subCtaTiPerInvBanBean.setConceptoInvBanID(request.getParameter("ConceptoInvBanID")!=null?request.getParameter("ConceptoInvBanID"):"0");
					subCtaTiPerInvBanBean.setTituConsVenc(request.getParameter("TituConsVenc")!=null?request.getParameter("TituConsVenc"):null);
					subCtaTiPerInvBanBean.setTituDispVenta(request.getParameter("TituDispVenta")!=null?request.getParameter("TituDispVenta"):null);
					subCtaTiPerInvBanBean.setTituNegocio(request.getParameter("TituNegocio")!=null?request.getParameter("TituNegocio"):null);
					mensaje= subCtaTituInvBanServicio.grabaTransaccion(tipoTransaccionTT, subCtaTiPerInvBanBean);
				} else if(tipoTransaccionR!=0){
					SubCtaRestInvBanBean subCtaRestInvBanBean=new SubCtaRestInvBanBean();
					subCtaRestInvBanBean.setConceptoInvBanID(request.getParameter("ConceptoInvBanID")!=null?request.getParameter("ConceptoInvBanID"):"0");
					subCtaRestInvBanBean.setRestricionCon(request.getParameter("RestricionCon")!=null?request.getParameter("RestricionCon"):null);
					subCtaRestInvBanBean.setRestricionSin(request.getParameter("RestricionSin")!=null?request.getParameter("RestricionSin"):null);
					mensaje= subCtaRestInvBanServicio.grabaTransaccion(tipoTransaccionR, subCtaRestInvBanBean);
				} else if(tipoTransaccionTD!=0){
					SubCtaDeudaInvBanBean subCtaDeudaInvBanBean=new SubCtaDeudaInvBanBean();
					subCtaDeudaInvBanBean.setConceptoInvBanID(request.getParameter("ConceptoInvBanID")!=null?request.getParameter("ConceptoInvBanID"):"0");
					subCtaDeudaInvBanBean.setTipoDeuBanca(request.getParameter("TipoDeuBanca")!=null?request.getParameter("TipoDeuBanca"):null);
					subCtaDeudaInvBanBean.setTipoDeuGuber(request.getParameter("TipoDeuGuber")!=null?request.getParameter("TipoDeuGuber"):null);
					subCtaDeudaInvBanBean.setTipoDeuOtros(request.getParameter("TipoDeuOtros")!=null?request.getParameter("TipoDeuOtros"):null);
					mensaje= subCtaDeudaInvBanServicio.grabaTransaccion(tipoTransaccionTD, subCtaDeudaInvBanBean);
				} else if(tipoTransaccionPB!=0){
					SubCtaPlazoInvBanBean subCtaPlazoInvBanBean=new SubCtaPlazoInvBanBean();
					subCtaPlazoInvBanBean.setConceptoInvBanID(request.getParameter("ConceptoInvBanID")!=null?request.getParameter("ConceptoInvBanID"):"0");
					subCtaPlazoInvBanBean.setPlazo(request.getParameter("Plazo")!=null?request.getParameter("Plazo"):null);
					subCtaPlazoInvBanBean.setSubPlazoMayor(request.getParameter("SubPlazoMayor")!=null?request.getParameter("SubPlazoMayor"):null);
					subCtaPlazoInvBanBean.setSubPlazoMenor(request.getParameter("SubPlazoMenor")!=null?request.getParameter("SubPlazoMenor"):null);
					mensaje= subCtaPlazoInvBanServicio.grabaTransaccion(tipoTransaccionPB, subCtaPlazoInvBanBean);
				}
		
		return mensaje;
	}

	public CuentasMayorInvBanServicio getCuentasMayorInvBanServicio() {
		return cuentasMayorInvBanServicio;
	}

	public void setCuentasMayorInvBanServicio(
			CuentasMayorInvBanServicio cuentasMayorInvBanServicio) {
		this.cuentasMayorInvBanServicio = cuentasMayorInvBanServicio;
	}

	public SubCtaMonedaInvBanServicio getSubCtaMonedaInvBanServicio() {
		return subCtaMonedaInvBanServicio;
	}

	public void setSubCtaMonedaInvBanServicio(
			SubCtaMonedaInvBanServicio subCtaMonedaInvBanServicio) {
		this.subCtaMonedaInvBanServicio = subCtaMonedaInvBanServicio;
	}

	public SubCtaInstInvBanServicio getSubCtaInstInvBanServicio() {
		return subCtaInstInvBanServicio;
	}

	public void setSubCtaInstInvBanServicio(
			SubCtaInstInvBanServicio subCtaInstInvBanServicio) {
		this.subCtaInstInvBanServicio = subCtaInstInvBanServicio;
	}

	public SubCtaTituInvBanServicio getSubCtaTituInvBanServicio() {
		return subCtaTituInvBanServicio;
	}

	public void setSubCtaTituInvBanServicio(
			SubCtaTituInvBanServicio subCtaTituInvBanServicio) {
		this.subCtaTituInvBanServicio = subCtaTituInvBanServicio;
	}

	public SubCtaRestInvBanServicio getSubCtaRestInvBanServicio() {
		return subCtaRestInvBanServicio;
	}

	public void setSubCtaRestInvBanServicio(
			SubCtaRestInvBanServicio subCtaRestInvBanServicio) {
		this.subCtaRestInvBanServicio = subCtaRestInvBanServicio;
	}

	public SubCtaDeudaInvBanServicio getSubCtaDeudaInvBanServicio() {
		return subCtaDeudaInvBanServicio;
	}

	public void setSubCtaDeudaInvBanServicio(
			SubCtaDeudaInvBanServicio subCtaDeudaInvBanServicio) {
		this.subCtaDeudaInvBanServicio = subCtaDeudaInvBanServicio;
	}

	public SubCtaPlazoInvBanServicio getSubCtaPlazoInvBanServicio() {
		return subCtaPlazoInvBanServicio;
	}

	public void setSubCtaPlazoInvBanServicio(
			SubCtaPlazoInvBanServicio subCtaPlazoInvBanServicio) {
		this.subCtaPlazoInvBanServicio = subCtaPlazoInvBanServicio;
	}


}
