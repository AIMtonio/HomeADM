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
 
public class ChequeDispersionRepServicio extends BaseServicio{

	//---------- Variables --------------------
	
	MonedasServicio monedasServicio = null;
	
		//---------- Constructor ------------------------------------------------------------------------
		public ChequeDispersionRepServicio() {
			super();
			// TODO Auto-generated constructor stub
		}	
	// Reporte  de Impresion de Cheques
		public ByteArrayOutputStream reporteImprimeChequeDisper(ImprimeChequeBean imprimeChequeBean) throws Exception{
					ParametrosReporte parametrosReporte = new ParametrosReporte();
					
					MonedasBean monedaBean = null;
					monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
							imprimeChequeBean.getMonedaID());
					
					String montoLetra=Utileria.cantidadEnLetras(
							imprimeChequeBean.getMonto(),
							
					
					Integer.parseInt(monedaBean.getMonedaID()),
					monedaBean.getSimbolo(),
					monedaBean.getDescripcion());
				
					int numconsulta = 2;
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
					parametrosReporte.agregaParametro("Par_NumeroCheque",imprimeChequeBean.getNumeroCheque());
					parametrosReporte.agregaParametro("Par_NumConsulta",numconsulta);
					
					return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
				}
		// Getter y Setter		
		public MonedasServicio getMonedasServicio() {
			return monedasServicio;
		}

		public void setMonedasServicio(MonedasServicio monedasServicio) {
			this.monedasServicio = monedasServicio;
		}
}
