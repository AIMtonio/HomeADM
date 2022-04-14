package tesoreria.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.DistCCInvBancariaBean;
import tesoreria.bean.InvBancariaBean;
import tesoreria.dao.InvBancariaDAO;

public class InvBancariaServicio extends BaseServicio {
	
	InvBancariaDAO	invBancariaDAO	= null;
	
	public static interface Enum_Transaccion {
		int	alta		= 1;
		int	modifica	= 2;
	}
	
	public static interface Enum_Consulta {
		int	primaria	= 1;
	}
	
	public static interface Enum_Lis_InvRep {
		int	posInvRepExcel	= 1;
	}
	
	public static interface Enum_Lis_Inversion {
		int principal = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, InvBancariaBean inversionBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Transaccion.alta:
				InvBancariaBean inversionCalculada = null;
				inversionCalculada = calculaRendimiento(inversionBean);
				mensaje = invBancariaDAO.altaInversion(inversionBean, inversionCalculada);
				break;
			case Enum_Transaccion.modifica:
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean grabaDetalle(int tipoTransaccion, String detalle, InvBancariaBean inversionBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ArrayList<DistCCInvBancariaBean> listaPolizaDetalle = (ArrayList<DistCCInvBancariaBean>) creaListaDetalle(detalle);
		switch (tipoTransaccion) {
			case Enum_Transaccion.alta:
				InvBancariaBean inversionCalculada = null;
				inversionCalculada = inversionBean;//calculaRendimiento(inversionBean);
				mensaje = invBancariaDAO.altaInversion(inversionBean, inversionCalculada, listaPolizaDetalle);
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean vencimientoInvBancaria(InvBancariaBean invBancaria) {
		MensajeTransaccionBean mensaje = null;
		mensaje = invBancariaDAO.vencimientoInvBancaria(invBancaria);
		return mensaje;
	}
	
	public InvBancariaBean consultaInversionBancaria(int tipoConculta, InvBancariaBean inversionBean) {
		InvBancariaBean bean = null;
		
		switch (tipoConculta) {
			case Enum_Consulta.primaria:
				bean = invBancariaDAO.consultaInversionBancaria(Integer.parseInt(inversionBean.getInversionID()), tipoConculta);
				break;
		}
		
		return bean;
	}
	
	public InvBancariaBean calculaRendimiento(InvBancariaBean inversionBean) {
		//DecimalFormat formatDecimal = new DecimalFormat("##.00");
		
		double salarioMinimoGralAnu=0;
		double interesRetener = 0;
		double porcentajeCorrespondienteISR= 0;
		double tasa = Utileria.convierteDoble(inversionBean.getTasa());
		double tasaISR = Utileria.convierteDoble(inversionBean.getTasaISR());
		double monto = Utileria.convierteDoble(inversionBean.getMonto());
		double montoOriginalInversion=Utileria.convierteDoble(inversionBean.getMontoBaseInversion());
		int plazo = Utileria.convierteEntero(inversionBean.getPlazo());
		int diasBase = Utileria.convierteEntero(inversionBean.getDiasBase());
		double tasaNeta = tasa - tasaISR;
		double interesGenerado = ((monto * tasa * plazo) / (diasBase * 100));
		// SI EL MONTO DE INVERSION es MAYOR O IGUAL A 5 Salario minimo General Anualizado Distrito Federal segun DF,(SMAGDF), 
		//entonces se aplica el calculo de ISR PERO SOBRE EL EXCEDENTE DE CAPITAL NO SOBRE EL CAPITAL ORIGINAL,
		// si no es CERO
		// Al pagar intereses a una persona moral siempre se le debe retener ISR sobre el monto total sin contemplar exención alguna.
		salarioMinimoGralAnu=Utileria.convierteDoble(inversionBean.getSalarioMinimo())*
				Utileria.convierteDoble(inversionBean.getNumeroSalarios())*diasBase;
		
			interesRetener=((montoOriginalInversion*tasaISR*plazo)/ (diasBase * 100));
			//BigDecimal intRedondear = new BigDecimal(interesRetener);
			//BigDecimal roundOff = intRedondear.setScale(2, BigDecimal.ROUND_HALF_EVEN);
			porcentajeCorrespondienteISR=(monto/montoOriginalInversion);
			interesRetener=(interesRetener*porcentajeCorrespondienteISR);
			
		double interesRecibir = interesGenerado - interesRetener;
		double totalRecibir = monto + interesRecibir;
		inversionBean.setTasaNeta(String.valueOf(tasaNeta));
		inversionBean.setInteresGenerado(String.valueOf(new BigDecimal(interesGenerado).setScale(2, RoundingMode.HALF_EVEN)));
		inversionBean.setInteresRetener(String.valueOf(new BigDecimal(interesRetener).setScale(2, RoundingMode.HALF_EVEN)));
		inversionBean.setInteresRecibir(String.valueOf(new BigDecimal(interesRecibir).setScale(2, RoundingMode.HALF_EVEN)));
		inversionBean.setTotalRecibir(String.valueOf(new BigDecimal(Double.toString(totalRecibir)).setScale(2, RoundingMode.HALF_EVEN)));
		return inversionBean;
	}
	
	// Reporte de Posicion de Inv Bancarias
	public ByteArrayOutputStream reportePosicionInvBancaria(InvBancariaBean invBancariaBean, String nomReporte, HttpServletRequest request) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Fecha", invBancariaBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_NomInstitucion", request.getParameter("nomInstitucion"));
		parametrosReporte.agregaParametro("Par_NomUsuario", request.getParameter("nomUsuario"));
		parametrosReporte.agregaParametro("Par_NumInstitucion", Utileria.convierteEntero(invBancariaBean.getInstitucionID()));
		parametrosReporte.agregaParametro("Par_NumCuenta", invBancariaBean.getNumCtaInstit());
		parametrosReporte.agregaParametro("Par_Institucion", request.getParameter("nombreInstitucion"));
	
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// Reporte de Apertura de Inv Bancarias
	public ByteArrayOutputStream reporteAperturaInvBancaria(InvBancariaBean invBancariaBean, String nomReporte, HttpServletRequest request) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", invBancariaBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin", invBancariaBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_NomInstitucion", request.getParameter("nomInstitucion"));
		parametrosReporte.agregaParametro("Par_NomUsuario", request.getParameter("nomUsuario"));
		parametrosReporte.agregaParametro("Par_NumInstitucion", Utileria.convierteEntero(invBancariaBean.getInstitucionID()));
		parametrosReporte.agregaParametro("Par_NumCuenta", invBancariaBean.getNumCtaInstit());
		parametrosReporte.agregaParametro("Par_Institucion", request.getParameter("nombreInstitucion"));
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/* case para listas de reportes de credito */
	public List<InvBancariaBean> listaPosicionInvBancaria(int tipoLista, InvBancariaBean invBancariaBean, HttpServletResponse response) {
		List<InvBancariaBean> listaReportes = null;
		listaReportes = invBancariaDAO.consultaPosicionInvExcel(invBancariaBean, tipoLista);
		return listaReportes;
	}
	
	public List<InvBancariaBean> listaAperturaInvBancaria(InvBancariaBean invBancariaBean, HttpServletResponse response) {
		List<InvBancariaBean> listaReportes = null;
		listaReportes = invBancariaDAO.consultaAperturaInvExcel(invBancariaBean);
		return listaReportes;
	}
	
	public List lista(int tipoLista, InvBancariaBean inversionBean){
		List inverLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_Inversion.principal:
	        	inverLista = invBancariaDAO.lista(tipoLista, inversionBean);
	        	break;
		}
		return inverLista;
	}
	
	/**
	 * Crea la lista de detalle de la distribucion de centro de costos de una
	 * Inversion Bancaria
	 **/
	private List<DistCCInvBancariaBean> creaListaDetalle(String detalle) {
		StringTokenizer tokensBean = new StringTokenizer(detalle, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList<DistCCInvBancariaBean> listaDetalle = new ArrayList<DistCCInvBancariaBean>();
		DistCCInvBancariaBean detalleDistCC;
		
		while (tokensBean.hasMoreTokens()) {
			detalleDistCC = new DistCCInvBancariaBean();
			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
			detalleDistCC.setCentroCosto(tokensCampos[0]);
			detalleDistCC.setMonto(tokensCampos[1]);
			detalleDistCC.setInteresGenerado(tokensCampos[2]);
			detalleDistCC.setiSR(tokensCampos[3]);
			detalleDistCC.setTotalRecibir(tokensCampos[4]);
			listaDetalle.add(detalleDistCC);
		}
		return listaDetalle;
	}
	
	public InvBancariaDAO getInvBancariaDAO() {
		return invBancariaDAO;
	}
	
	public void setInvBancariaDAO(InvBancariaDAO invBancariaDAO) {
		this.invBancariaDAO = invBancariaDAO;
	}
	
}
