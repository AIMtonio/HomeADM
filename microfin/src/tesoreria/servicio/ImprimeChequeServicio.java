package tesoreria.servicio;

import java.io.ByteArrayOutputStream;

import javax.servlet.http.HttpServletResponse;

import cuentas.bean.MonedasBean;
import cuentas.servicio.MonedasServicio;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.ImprimeChequeBean;
import tesoreria.dao.ImprimeChequeDAO;

public class ImprimeChequeServicio extends BaseServicio{
 
	//---------- Variables --------------------
	ImprimeChequeDAO imprimeChequeDAO = null;
	MonedasServicio monedasServicio = null;
	
		//---------- Constructor ------------------------------------------------------------------------
		public ImprimeChequeServicio() {
			super();
			// TODO Auto-generated constructor stub
		}
	
	// Reporte  de Impresion de Cheques
		public ByteArrayOutputStream reporteImprimeChequePDF(ImprimeChequeBean imprimeChequeBean) throws Exception{
					ParametrosReporte parametrosReporte = new ParametrosReporte();
					
					MonedasBean monedaBean = null;
					monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
							imprimeChequeBean.getMonedaID());
					int numconsulta = 1;
					int numCheque = 0;
					String montoLetra=Utileria.cantidadEnLetras(
							imprimeChequeBean.getMonto(),
					Integer.parseInt(monedaBean.getMonedaID()),
					monedaBean.getSimbolo(),
					monedaBean.getDescripcion());
					
				    String nombreReporte = ("tesoreria/" + imprimeChequeBean.getNombreReporte()+".prpt");
										
					parametrosReporte.agregaParametro("Par_Poliza",Utileria.convierteEntero(imprimeChequeBean.getPolizaID()));					
					parametrosReporte.agregaParametro("Par_Transaccion",Utileria.convierteLong(imprimeChequeBean.getNumeroTransaccion()));
					parametrosReporte.agregaParametro("Par_Sucursal",Utileria.convierteEntero(imprimeChequeBean.getSucursalID()));
					parametrosReporte.agregaParametro("Par_Moneda",Utileria.convierteEntero(imprimeChequeBean.getMonedaID()));
					parametrosReporte.agregaParametro("Par_FechaEmision",imprimeChequeBean.getFechaEmision());
					parametrosReporte.agregaParametro("Par_NombreOperacion",imprimeChequeBean.getNombreOperacion());
					parametrosReporte.agregaParametro("Par_NombreBeneficiario",imprimeChequeBean.getNombreBeneficiario());
					parametrosReporte.agregaParametro("Par_Monto",Utileria.convierteDoble(imprimeChequeBean.getMonto()));
					parametrosReporte.agregaParametro("Par_NombreUsuario",imprimeChequeBean.getNombreUsuario());
					parametrosReporte.agregaParametro("Par_MontoLetra",montoLetra);
					parametrosReporte.agregaParametro("Par_NumConsulta",numconsulta);
					
					parametrosReporte.agregaParametro("Par_FechaInicial",imprimeChequeBean.getFechaEmision());
					parametrosReporte.agregaParametro("Par_FechaFinal",imprimeChequeBean.getFechaEmision());
					parametrosReporte.agregaParametro("Par_NumeroCheque",imprimeChequeBean.getNumeroCheque());
				
					return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
				}
		// Getter y Setter
		public ImprimeChequeDAO getImprimeChequeDAO() {
			return imprimeChequeDAO;
		}

		public void setImprimeChequeDAO(ImprimeChequeDAO imprimeChequeDAO) {
			this.imprimeChequeDAO = imprimeChequeDAO;
		}

		public MonedasServicio getMonedasServicio() {
			return monedasServicio;
		}

		public void setMonedasServicio(MonedasServicio monedasServicio) {
			this.monedasServicio = monedasServicio;
		}
}
