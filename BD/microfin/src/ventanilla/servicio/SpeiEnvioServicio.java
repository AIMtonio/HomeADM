	package ventanilla.servicio;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosAuditoriaBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import sms.bean.SMSEnvioMensajeBean;
import sms.bean.SMSIngresosOpsBean;
import sms.dao.SMSEnvioMensajeDAO;
import cuentas.servicio.MonedasServicio;
import ventanilla.bean.SpeiEnvioBean;
import ventanilla.dao.SpeiEnvioDAO;
import ventanilla.servicio.IngresosOperacionesServicio.Enum_Tipo_Alerta_Sms;
import cuentas.bean.MonedasBean;

		public class SpeiEnvioServicio extends BaseServicio {
			SpeiEnvioDAO speiEnvioDAO = null;
			MonedasServicio monedasServicio = null;
			SMSEnvioMensajeDAO smsEnvioMensajeDAO = null;
			
			private SpeiEnvioServicio(){
				super();
			}
			public static interface Enum_Tra_EnvioSpei {
				int alta 			= 1;
				
			}
			
			public static interface Enum_Act_EnvioSpei {
				int apertura 		= 1;
			
			}
			
			public static interface Enum_Tipo_Alerta_Sms
			{
				int trSPEI = 4;
			}

			public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, HttpServletRequest request, SpeiEnvioBean speiEnvioBean){
				MensajeTransaccionBean mensaje = null;
				switch(tipoTransaccion){
				case Enum_Tra_EnvioSpei.alta:
					mensaje = altaEnvioSpei(speiEnvioBean, tipoTransaccion);
					break;
				}

				return mensaje;
			}


			  
			
			public MensajeTransaccionBean altaEnvioSpei(SpeiEnvioBean speiEnvioBean, int tipoTransaccion){
				MensajeTransaccionBean mensaje = null;
			   mensaje = speiEnvioDAO.altaSPEI(speiEnvioBean, tipoTransaccion);		
				if (mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR) {
//					envioSMSCuentaAho(speiEnvioBean);
					System.out.println(mensaje.getCampoGenerico());
					envioSMSOperacion(Enum_Tipo_Alerta_Sms.trSPEI, 
							null, 
							speiEnvioBean.getCuentaAhoID(), 
							speiEnvioBean.getCuentaBeneficiario(), //cuentaDestino, 
							speiEnvioBean.getMontoTransferir(), 
							speiEnvioBean.getComisionTrans(), // comision
							speiEnvioBean.getIVAPorPagar(), // iva
							speiEnvioBean.getMontoTransferir(), 
							mensaje.getCampoGenerico(),		//claveRastreo, 
							null,		//descServicio, 
							mensaje.getNumerTransaccin().toString(), 
							speiEnvioBean.getFechaActual(),
							speiEnvioBean.getSucursal());
				}
				return mensaje;
			}
			
			private void envioSMSCuentaAho(SpeiEnvioBean speiEnvioBean) {
				MensajeTransaccionBean mensajeTransaccionBean = null;
				SMSEnvioMensajeBean smsEnvioMensajeBean = new SMSEnvioMensajeBean();
				smsEnvioMensajeBean.setCuentaAhoID(speiEnvioBean.getCuentaAhoID());
				smsEnvioMensajeBean.setCantidadMov(speiEnvioBean.getMontoTransferir());
				mensajeTransaccionBean = smsEnvioMensajeDAO.alertasRetirosSMS(smsEnvioMensajeBean);
				loggerSAFI.info(mensajeTransaccionBean.getNumero() + " " + mensajeTransaccionBean.getDescripcion());
			}
			
			private void envioSMSOperacion( int tipoAlerta,
												String clienteID,
												String cuentaOrigenID,
												String cuentaDestinoID,
												String monto,
												String comision,
												String iva,
												String montoTotal,
												String claveRastreo,
												String descServicio,
												String numTransaccion,
												String fechaActual,
												String sucursal) {
			MensajeTransaccionBean mensajeTransaccionBean = null;
			SMSIngresosOpsBean smsIngresosOpsBean = new SMSIngresosOpsBean(); 
			smsIngresosOpsBean.setClienteID(clienteID);
			smsIngresosOpsBean.setCuentaOrigenID(cuentaOrigenID);
			smsIngresosOpsBean.setCuentaDestinoID(cuentaDestinoID);
			smsIngresosOpsBean.setMonto(monto);
			smsIngresosOpsBean.setComision(comision);
			smsIngresosOpsBean.setIva(iva);
			smsIngresosOpsBean.setMontoTotal(montoTotal);
			smsIngresosOpsBean.setClaveRastreo(claveRastreo);
			smsIngresosOpsBean.setDescServicio(descServicio);
			smsIngresosOpsBean.setNumTransaccion(numTransaccion);
			smsIngresosOpsBean.setFechaActual(fechaActual);
			smsIngresosOpsBean.setSucursal(sucursal);
			
			mensajeTransaccionBean = smsEnvioMensajeDAO.alertasSms(tipoAlerta,smsIngresosOpsBean);
			loggerSAFI.info(mensajeTransaccionBean.getNumero() + " " + mensajeTransaccionBean.getDescripcion());
			}
			
			//REPORTE AUTORIZACION DE SPEI
			
			public ByteArrayOutputStream reporteAutorizacionSpei(SpeiEnvioBean speiEnvioBean, HttpServletRequest request,String nombreReporte) throws Exception{
				
				ParametrosReporte parametrosReporte = new ParametrosReporte();	
				MonedasBean monedaBean = null;
				monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
						request.getParameter("monedaID"));
				
					String montoLetra=Utileria.cantidadEnLetras(
							speiEnvioBean.getTotalCargoLetras(),
							Integer.parseInt(monedaBean.getMonedaID()),
							monedaBean.getSimbolo(),
							monedaBean.getDescripcion());
					
				

			
				parametrosReporte.agregaParametro("Par_CuentaAhoID",request.getParameter("cuentaAhoID"));
				parametrosReporte.agregaParametro("Par_ClienteID",request.getParameter("clienteID"));
				parametrosReporte.agregaParametro("Par_NombreInstit",request.getParameter("nombreInstitucion"));
				parametrosReporte.agregaParametro("Par_FechaSistema",request.getParameter("fechaSistema"));
				parametrosReporte.agregaParametro("Par_SucursalID", Utileria.completaCerosIzquierda(request.getParameter("sucursal"),4));
				parametrosReporte.agregaParametro("Par_NomSucursal",request.getParameter("nomSucursal"));
				
				
				
				parametrosReporte.agregaParametro("Par_NombreOrd",request.getParameter("nombreOrd"));
				parametrosReporte.agregaParametro("Par_TotalCargoCuenta",request.getParameter("totalCargoCuenta"));
				parametrosReporte.agregaParametro("Par_NombreBeneficiario",request.getParameter("nombreBeneficiario"));
				parametrosReporte.agregaParametro("Par_CuentaBeneficiario",request.getParameter("cuentaBeneficiario"));
				parametrosReporte.agregaParametro("Par_InstiReceptora",request.getParameter("instiReceptora"));
				parametrosReporte.agregaParametro("Par_DesbancoSPEI",request.getParameter("desbancoSPEI"));
				parametrosReporte.agregaParametro("Par_MontoTransferir",request.getParameter("montoTransferir"));
				parametrosReporte.agregaParametro("Par_PagarIVA",request.getParameter("pagarIVA"));
				parametrosReporte.agregaParametro("Par_ComisionTrans",request.getParameter("comisionTrans"));
				parametrosReporte.agregaParametro("Par_ComisionIVA",request.getParameter("comisionIVA"));
				parametrosReporte.agregaParametro("Par_ConceptoPago",request.getParameter("conceptoPago"));
				parametrosReporte.agregaParametro("Par_EdoMunSuc",request.getParameter("edoMunSucursal"));
			    parametrosReporte.agregaParametro("Par_MontoEnLetras",montoLetra);
	
				return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
			
			}
			
			
			
public ByteArrayOutputStream reporteTicketTranSpei(SpeiEnvioBean speiEnvioBean, HttpServletRequest request,String nombreReporte) throws Exception{
				
	
	ParametrosReporte parametrosReporte = new ParametrosReporte();	
	

	MonedasBean monedaBean = null;
	monedaBean = monedasServicio.consultaMoneda(MonedasServicio.Enum_Con_Monedas.principal,
			request.getParameter("monedaID"));
	
		String montoLetra=Utileria.cantidadEnLetras(
				speiEnvioBean.getTotalCargoLetras(),
				Integer.parseInt(monedaBean.getMonedaID()),
				monedaBean.getSimbolo(),
				monedaBean.getDescripcion());
		
	


	parametrosReporte.agregaParametro("Par_CuentaAhoID",request.getParameter("cuentaAhoID"));
	parametrosReporte.agregaParametro("Par_ClienteID",request.getParameter("clienteID"));
	parametrosReporte.agregaParametro("Par_NombreInstit",request.getParameter("nombreInstitucion"));
	parametrosReporte.agregaParametro("Par_FechaSistema",request.getParameter("fechaSistema"));
	parametrosReporte.agregaParametro("Par_SucursalID", Utileria.completaCerosIzquierda(request.getParameter("sucursal"),4));
	parametrosReporte.agregaParametro("Par_NomSucursal",request.getParameter("nomSucursal"));
	
	
	
	parametrosReporte.agregaParametro("Par_NombreOrd",request.getParameter("nombreOrd"));
	parametrosReporte.agregaParametro("Par_TotalCargoCuenta",request.getParameter("totalCargoCuenta"));
	parametrosReporte.agregaParametro("Par_NombreBeneficiario",request.getParameter("nombreBeneficiario"));
	parametrosReporte.agregaParametro("Par_CuentaBeneficiario",request.getParameter("cuentaBeneficiario"));
	parametrosReporte.agregaParametro("Par_InstiReceptora",request.getParameter("instiReceptora"));
	parametrosReporte.agregaParametro("Par_DesbancoSPEI",request.getParameter("desbancoSPEI"));
	parametrosReporte.agregaParametro("Par_MontoTransferir",request.getParameter("montoTransferir"));
	parametrosReporte.agregaParametro("Par_PagarIVA",request.getParameter("pagarIVA"));
	parametrosReporte.agregaParametro("Par_ComisionTrans",request.getParameter("comisionTrans"));
	parametrosReporte.agregaParametro("Par_ComisionIVA",request.getParameter("comisionIVA"));
	parametrosReporte.agregaParametro("Par_ConceptoPago",request.getParameter("conceptoPago"));
	parametrosReporte.agregaParametro("Par_EdoMunSuc",request.getParameter("edoMunSucursal"));
    parametrosReporte.agregaParametro("Par_MontoEnLetras",montoLetra);
    parametrosReporte.agregaParametro("Par_Caja", Utileria.completaCerosIzquierda(request.getParameter("caja"),6));
	parametrosReporte.agregaParametro("Par_ClaveUsuario",request.getParameter("claveUsuario"));
	parametrosReporte.agregaParametro("Par_Folio",request.getParameter("folio"));
	parametrosReporte.agregaParametro("Par_ClaveRastreo",request.getParameter("claveRastreo"));


	return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());

			}
			
			
			public SpeiEnvioDAO getSpeiEnvioDAO() {
				return speiEnvioDAO;
			}

			public void setSpeiEnvioDAO(SpeiEnvioDAO speiEnvioDAO) {
				this.speiEnvioDAO = speiEnvioDAO;
			}			
			
			public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
				return parametrosAuditoriaBean;
			}

			public void setParametrosAuditoriaBean(
					ParametrosAuditoriaBean parametrosAuditoriaBean) {
				this.parametrosAuditoriaBean = parametrosAuditoriaBean;
			}
			
			public MonedasServicio getMonedasServicio() {
				return monedasServicio;
			}

			public void setMonedasServicio(MonedasServicio monedasServicio) {
				this.monedasServicio = monedasServicio;
			}

			public SMSEnvioMensajeDAO getSmsEnvioMensajeDAO() {
				return smsEnvioMensajeDAO;
			}

			public void setSmsEnvioMensajeDAO(SMSEnvioMensajeDAO smsEnvioMensajeDAO) {
				this.smsEnvioMensajeDAO = smsEnvioMensajeDAO;
			}


		

		

		
	}
