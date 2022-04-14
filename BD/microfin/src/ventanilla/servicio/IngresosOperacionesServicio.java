package ventanilla.servicio;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.ParametrosAplicacionDAO;
import general.servicio.BaseServicio;
import general.servicio.ParametrosAplicacionServicio.Enum_Con_ParAplicacion;
import herramientas.CalculosyOperaciones;
import herramientas.Constantes;
import herramientas.Utileria;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

import pld.bean.PldEscalaVentBean;
import pld.dao.OpeEscalamientoInternoDAO;
import pld.dao.OpeEscalamientoInternoDAO.Enum_EstatusOperacionPLD;
import pld.dao.OpeEscalamientoInternoDAO.Enum_EstatusPLD;
import pld.dao.OpeEscalamientoInternoDAO.Enum_ProcesoPLD;
import reporte.ParametrosReporte;
import reporte.Reporte;
import sms.bean.SMSEnvioMensajeBean;
import sms.bean.SMSIngresosOpsBean;
import sms.dao.SMSEnvioMensajeDAO;
import soporte.PropiedadesSAFIBean;
import soporte.bean.SucursalesBean;
import soporte.dao.SucursalesDAO;
import soporte.servicio.SucursalesServicio;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.ISOTRXServicio;
import tarjetas.servicio.ISOTRXServicio.Cat_Instrumentos_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Pro_OpePeticion_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Tran_ISOTRX;
import ventanilla.bean.CajasVentanillaBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.bean.ReversasOperBean;
import ventanilla.dao.CajasVentanillaDAO;
import ventanilla.dao.IngresosOperacionesDAO;
import ventanilla.servicio.CajasVentanillaServicio.Enum_Trans_CajasVentanilla;
import arrendamiento.bean.ArrendamientosBean;
import credito.bean.CreditosBean;
import credito.dao.CreditosDAO;
import cuentas.bean.BloqueoSaldoBean;
import cuentas.bean.CuentasAhoBean;
import cuentas.dao.CuentasAhoDAO;
import cuentas.dao.CuentasAhoMovDAO;
import cuentas.servicio.MonedasServicio;

public class IngresosOperacionesServicio extends BaseServicio{
	IngresosOperacionesDAO ingresosOperacionesDAO =null;
	CuentasAhoMovDAO cuentasAhoMovDAO = null;
	CreditosDAO creditosDAO = null;
	SucursalesDAO sucursalesDAO = null;
	ParametrosSesionBean parametrosSesionBean =null;
	CajasVentanillaServicio cajasVentanillaServicio = null;
	CajasVentanillaDAO cajasVentanillaDAO = null;
	ParametrosAplicacionDAO parametrosAplicacionDAO = null;
	MonedasServicio monedasServicio = null;
	OpeEscalamientoInternoDAO OpeEscalamientoInternoDAO = null;
	CuentasAhoDAO cuentasAhoDAO = null;
	SMSEnvioMensajeDAO smsEnvioMensajeDAO = null;
	ISOTRXServicio isotrxServicio = null;
	final boolean origenVent = true;
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	protected final Logger loggerVent = Logger.getLogger("Vent");
	public static interface Enum_Tra_Ventanilla {
		int cargoCuenta 			= 1;	// Cargo a Cta
		int abonoCuenta 			= 2;	// Abono a Cta
		int pagoCredito 			= 3; 	// pago de credito en efectivo
		int depGaranLiq	 			= 4;    // Deposito de Garantia Liquida
		int pagoCreditoGrupal		= 5;	// pago de credito grupal
		int comisionApertura		= 6; 	// pago de comision por apertura de credito
		int desembolsoCredito		= 7; 	// desembolso de credito en efectivo
		int devolucionGL			= 8;	// devolucion de garantia liquida en efectivo
		int pagoSeguroVida			=9;		// Pago del seguro de vida
		int cobroSeguroVida			=10;	// Cobro del seguro de vida
		int combiarEfectivo			=11;	// Cambio de Efectivo
		int transferenciaCuenta 	=12;	// Transferencia entre cuentas
		int pagoAportacionSocial	=13;	// Aportacion Social   
		int devAportacionSocial		=14;	// Aportacion Social 
		int cobroSegVidaAyuda		=15;	// Cobro del Seguro de AYUDA
		int aplicaSegVidaAyuda		=16;	// Aplicacion del Seguro AYUDA
		int pagoRemesas				=17;	// Pago de Remesas
		int pagoOportunidades		=18;	// Pago de Oportunidades
		int recepChequeSBC			=19;	// Recepcion de Cheque SBC
		int aplicaChequeSBC			=20;	// Aplica cheque SBC
		int prepagoCredito 			= 21;	// prepago de credito
		int prepagoCreditoGrupal 	= 22;	// prepago de credito
		int pagoServicios		 	= 23;	// pago de servicios
		int recCarteraCastigada	 	= 24;	// Recuperacion de Cartera Castigada
		int pagoCancelSocio			= 25; 	// Pago de Cancelacion Socio
		int pagoSERVIFUN			= 27;	// Pago Servifun
		int pagoApoyoEscolar	 	= 28; 	// Pago Apoyo Escolar
		int pagoPROFUN				=26; 	// Pago Profun
		int ajusteSobrante			=29; 	// Ajuste Sobrante
		int ajusteFaltante			=30; 	// Ajuste Faltante
		int cobroAnualidadTarjeta	=31;	// Cobro Anualidad Tarjeta
		int anticiposGastos			=32;	// Anticipos y Gastos
		int devolucionesGastAnt		=33;	// Devolucion Gastos
		int haberesExMenor			=34;	// Haberes ExMenor
		int pagoArrendamiento		=42;	//Pago de Arrendamiento
		int pagoServiciosLinea 		= 43;	//Pago de Servicios en Linea
		int accesorios				= 44;	// Pago de Accesorios Anticipados
		int depositoActivaCta		= 46;	// DEPOSITO ACTIVACION DE CUENTA
	}
	public static interface Enum_Con_Ventanilla {
		int disponiblePorDenom 	= 1;
	}
	public static interface Enum_Rep_Ventanilla {
		int cargoCuenta 			= 1;
		int abonoCuenta 			= 2;
		int pagoCredito 			= 3;
		int garantiaLiquida 		= 4;
		int pagoCreditoGrupal 		= 5;
		int comisionApCredito 		= 6;
		int desembolsoCred 			= 7;
		int pagoSeguroVida			=8;
		int seguroVidaFallecimiento	=9;
		int garantiaAdicional 		= 10;
		int aportacionSocial 		=11;
		int devAportacionSocial 	=12;
		int cobroSegAyuda			=13;
		int pagoSegAyuda			=14;
		int pagoRemesas				=15;
		int pagoOportunidades		=16;
		int recepChequeSBC			=17;
		int aplicaChequeSBC			=18;
		int recupCartCastigada		=19;
		int pagoServifun			=20;
		int pagoApoyoEscolar		=21; 
		int cobroAnualidadTD		=23; 
		int pagoCancelacionSocio	=25;
		int gastosAnticipos			=26;
		int devolucionesGastAnt		=27;
		int haberesExmenor			=28;
		int pagoArrendamiento		=42;	//Pago de Arrendamiento
		int pagoServiciosLinea		= 43;	//Pago de Servicios en Linea
	}
	//--------ENums Reversas---------------
	public static interface Enum_Lis_Reversa {
		int listaCajasMovs 	= 1;
		int listaPagareGrupal = 2;
	}
	public static interface Enum_Tra_VentanillaReversa{
		int cargoCuentaReversa 		= 1;
		int abonoCuentaReversa 		= 2;
		int depGaranLiqReversa		= 4;
		int cobroSeguroVidaReversa	=10;
		int desembolsoCreditoReversa=7;
		int comisionAperturaReversa=6;
		int accesoriosCreReversa 	= 11;
	}
	public static interface Enum_Con_ReversaCajaMosv {
		int reversaCajaMovs 		= 1;
		int reversaPagoCredito		=2;
		int consultaGarantiaAdicional	=3;
	}
	public static interface Enum_Con_Remesas{
		int consultafolio 		= 1;
	}
	public static interface Enum_Con_Oportunidades{
		int consultafolio 		= 1;
	}
	public static interface Enum_Con_AplicaSeguroAyuda{
		int consultaEstatus		= 1;
	}
	public static interface Enum_Con_ChequeSBC{
		int aplicaCheque		= 1;
		int recepcionCheque 	= 2;
	}	
	public static interface Enum_Con_AportacionSocial{ 
		int consultaSaldoDev	= 1;
		int consultaSaldo		= 2;
	}		
	public static interface Enum_Con_EstatusSegVida{
		int consultaEstatus		= 2;
	}
	public static interface Enum_Tipo_Alerta_Sms
	{
		int trEntreCuentas = 1;
		int desembolso = 2;
		int pagoServicioLinea = 3;
		int trSPEI = 4;
	}
	/**
	 * Método que maneja las operaciones que se realizan en Ingreso de Operaciones
	 * @param tipoTransaccion : Tipo de Transaccion
	 * @param request : {@link HttpServletRequest} con la información de la ventanilla
	 * @param bean : {@link IngresosOperacionesBean} con la información de la ventanilla
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, HttpServletRequest request, IngresosOperacionesBean bean) {
		MensajeTransaccionBean mensaje = null;
		try {
			loggerVent.info("Comienza la transaccion:" + tipoTransaccion);
			boolean reversa = false;
			CajasVentanillaBean cajasVentanillaBean = new CajasVentanillaBean();
			MensajeTransaccionBean mensajePLD =null;

			ParametrosSesionBean datoSesion = new ParametrosSesionBean();
			datoSesion = parametrosAplicacionDAO.consultaFechaSucursal(parametrosSesionBean.getSucursal(), Enum_Con_ParAplicacion.fechaSucursal, parametrosSesionBean.getOrigenDatos());
			parametrosSesionBean.setFechaSucursal(datoSesion.getFechaSucursal());
			parametrosSesionBean.setFechaAplicacion(datoSesion.getFechaAplicacion());

			/*Se actualiza el campo EjecutaProceso a 'S' y si ya es esta en 'S' manda mensaje de 
			 * validacion que la ejecucion ya existe de lo contrario actualiza el valor 'N'*/
			MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

			cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
			cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
			loggerVent.info("Se bloquea el Proceso de Ejecución de otra Operación en la CAJA: " + cajasVentanillaBean.getCajaID());
			mensajeBean = cajasVentanillaDAO.actualizaEjecProSi(cajasVentanillaBean, Enum_Trans_CajasVentanilla.ejecProSi, origenVent);
			int folioEscala = -1;
			if (mensajeBean.getNumero() == 0) {

				switch (tipoTransaccion) {
					case Enum_Tra_Ventanilla.cargoCuenta:

						mensajePLD = validacionPLD(tipoTransaccion, request, bean, Constantes.ENTERO_CERO);
						folioEscala = Utileria.convierteEntero(mensajePLD.getConsecutivoString());
						if (mensajePLD.getNumero() == Enum_EstatusOperacionPLD.AUTORIZADA || mensajePLD.getNumero() == 0) {
							mensaje = cargoCuenta(request, reversa);
							if (mensaje.getNumero() == Constantes.ENTERO_CERO) {
								validacionPLD(tipoTransaccion, request, bean, folioEscala);
							}
						} else {
							mensaje = mensajePLD;
						}
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.abonoCuenta:
						mensajePLD = validacionPLD(tipoTransaccion, request, bean, Constantes.ENTERO_CERO);
						folioEscala = Utileria.convierteEntero(mensajePLD.getConsecutivoString());
						if (mensajePLD.getNumero() == Enum_EstatusOperacionPLD.AUTORIZADA || mensajePLD.getNumero() == 0) {
							mensaje = abonoCuenta(request, reversa);
							if (mensaje.getNumero() == Constantes.ENTERO_CERO) {
								validacionPLD(tipoTransaccion, request, bean, folioEscala);
							}
						} else {
							mensaje = mensajePLD;
						}
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.pagoCredito:
						mensajePLD = validacionPLD(tipoTransaccion, request, bean, Constantes.ENTERO_CERO);
						folioEscala = Utileria.convierteEntero(mensajePLD.getConsecutivoString());
						if (mensajePLD.getNumero() == Enum_EstatusOperacionPLD.AUTORIZADA || mensajePLD.getNumero() == 0) {
							mensaje = pagosCreditoEfectivo(request);
							if (mensaje.getNumero() == Constantes.ENTERO_CERO) {
								validacionPLD(tipoTransaccion, request, bean, folioEscala);
							}
						} else {
							mensaje = mensajePLD;
						}
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.depGaranLiq:
						mensajePLD = validacionPLD(tipoTransaccion, request, bean, Constantes.ENTERO_CERO);
						folioEscala = Utileria.convierteEntero(mensajePLD.getConsecutivoString());
						if (mensajePLD.getNumero() == Enum_EstatusOperacionPLD.AUTORIZADA || mensajePLD.getNumero() == 0) {
							mensaje = depositoGarantiaLiquida(request, reversa);
							if (mensaje.getNumero() == Constantes.ENTERO_CERO) {
								validacionPLD(tipoTransaccion, request, bean, folioEscala);
							}
						} else {
							mensaje = mensajePLD;
						}
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.pagoCreditoGrupal:
						mensaje = pagosGrupalCreditoEfectivo(request, bean);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.comisionApertura:
						mensaje = comisionAperturaCredito(request, reversa);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.desembolsoCredito:
						mensaje = desembolsoCredito(request, reversa);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;

					case Enum_Tra_Ventanilla.devolucionGL:
						mensajePLD = validacionPLD(tipoTransaccion, request, bean, Constantes.ENTERO_CERO);
						folioEscala = Utileria.convierteEntero(mensajePLD.getConsecutivoString());
						if (mensajePLD.getNumero() == Enum_EstatusOperacionPLD.AUTORIZADA || mensajePLD.getNumero() == 0) {
							mensaje = devolucionGL(request);
							if (mensaje.getNumero() == Constantes.ENTERO_CERO) {
								validacionPLD(tipoTransaccion, request, bean, folioEscala);
							}
						} else {
							mensaje = mensajePLD;
						}
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;

					case Enum_Tra_Ventanilla.pagoSeguroVida:
						mensaje = pagoSeguroVida(request, reversa);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;

					case Enum_Tra_Ventanilla.cobroSeguroVida:
						mensaje = cobroSeguroVida(request, reversa);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;

					case Enum_Tra_Ventanilla.combiarEfectivo:
						mensaje = cambiarEfectivo(request);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.transferenciaCuenta:
						mensajePLD = validacionPLD(tipoTransaccion, request, bean, Constantes.ENTERO_CERO);
						folioEscala = Utileria.convierteEntero(mensajePLD.getConsecutivoString());
						if (mensajePLD.getNumero() == Enum_EstatusOperacionPLD.AUTORIZADA || mensajePLD.getNumero() == 0) {
							mensaje = transferenciaEntreCuentas(request);
							if (mensaje.getNumero() == Constantes.ENTERO_CERO) {
								validacionPLD(tipoTransaccion, request, bean, folioEscala);
							}
						} else {
							mensaje = mensajePLD;
						}
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;

					case Enum_Tra_Ventanilla.pagoAportacionSocial:
						mensaje = pagoAportacionSocial(request);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;

					case Enum_Tra_Ventanilla.devAportacionSocial:
						mensaje = devolucionAportacionSocial(request);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;

					case Enum_Tra_Ventanilla.cobroSegVidaAyuda:
						mensaje = cobroSeguroVidaAyuda(request);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.aplicaSegVidaAyuda:
						mensaje = aplicaSeguroAyuda(request);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.pagoRemesas:
						mensajePLD = validacionPLD(tipoTransaccion, request, bean, Constantes.ENTERO_CERO);
						folioEscala = Utileria.convierteEntero(mensajePLD.getConsecutivoString());
						if (mensajePLD.getNumero() == Enum_EstatusOperacionPLD.AUTORIZADA || mensajePLD.getNumero() == 0) {
							mensaje = pagoRemesasyOportunidades(request, Enum_Tra_Ventanilla.pagoRemesas);
							if (mensaje.getNumero() == Constantes.ENTERO_CERO) {
								validacionPLD(tipoTransaccion, request, bean, folioEscala);
							}
						} else {
							mensaje = mensajePLD;
						}
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;

					case Enum_Tra_Ventanilla.pagoOportunidades:
						mensajePLD = validacionPLD(tipoTransaccion, request, bean, Constantes.ENTERO_CERO);
						folioEscala = Utileria.convierteEntero(mensajePLD.getConsecutivoString());
						if (mensajePLD.getNumero() == Enum_EstatusOperacionPLD.AUTORIZADA || mensajePLD.getNumero() == 0) {
							mensaje = pagoRemesasyOportunidades(request, Enum_Tra_Ventanilla.pagoOportunidades);
							if (mensaje.getNumero() == Constantes.ENTERO_CERO) {
								validacionPLD(tipoTransaccion, request, bean, folioEscala);
							}
						} else {
							mensaje = mensajePLD;
						}
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.recepChequeSBC:
						mensajePLD = validacionPLD(tipoTransaccion, request, bean, Constantes.ENTERO_CERO);
						folioEscala = Utileria.convierteEntero(mensajePLD.getConsecutivoString());
						if (mensajePLD.getNumero() == Enum_EstatusOperacionPLD.AUTORIZADA || mensajePLD.getNumero() == 0) {
							mensaje = recepcionChequeSBC(request);
							if (mensaje.getNumero() == Constantes.ENTERO_CERO) {
								validacionPLD(tipoTransaccion, request, bean, folioEscala);
							}
						} else {
							mensaje = mensajePLD;
						}
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.aplicaChequeSBC:
						mensajePLD = validacionPLD(tipoTransaccion, request, bean, Constantes.ENTERO_CERO);
						folioEscala = Utileria.convierteEntero(mensajePLD.getConsecutivoString());
						if (mensajePLD.getNumero() == Enum_EstatusOperacionPLD.AUTORIZADA || mensajePLD.getNumero() == 0) {
							mensaje = aplicaChequeSBC(request);
							if (mensaje.getNumero() == Constantes.ENTERO_CERO) {
								validacionPLD(tipoTransaccion, request, bean, folioEscala);
							}
						} else {
							mensaje = mensajePLD;
						}
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;

					case Enum_Tra_Ventanilla.prepagoCredito:
						mensaje = prepagoCredito(request, Enum_Tra_Ventanilla.prepagoCredito);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.prepagoCreditoGrupal:
						mensaje = prepagoCredito(request, Enum_Tra_Ventanilla.prepagoCreditoGrupal);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.pagoServicios:
						mensaje = pagoServicios(request, Enum_Tra_Ventanilla.pagoServicios);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.recCarteraCastigada:
						mensaje = recuperaCarteraCastigada(request, Enum_Tra_Ventanilla.recCarteraCastigada);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.pagoSERVIFUN:
						mensaje = pagoSERVIFUN(request, Enum_Tra_Ventanilla.pagoSERVIFUN);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.pagoApoyoEscolar:
						mensaje = pagoApoyoEscolar(request, Enum_Tra_Ventanilla.pagoApoyoEscolar);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;

					case Enum_Tra_Ventanilla.ajusteSobrante:
						mensaje = ajusteSobrante(request, Enum_Tra_Ventanilla.ajusteSobrante);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.ajusteFaltante:
						mensaje = ajusteFaltante(request, Enum_Tra_Ventanilla.ajusteFaltante);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.cobroAnualidadTarjeta:
						mensaje = cobroAnualidadTarjeta(request, Enum_Tra_Ventanilla.ajusteFaltante);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.pagoCancelSocio:
						mensaje = pagoCancelacionSocio(request);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.anticiposGastos:
						mensaje = anticiposGastosdevoluciones(request);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());

						break;
					case Enum_Tra_Ventanilla.devolucionesGastAnt:
						mensaje = anticiposGastosdevoluciones(request);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.haberesExMenor:
						mensaje = haberesExMenor(request);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.pagoArrendamiento:
						mensaje = pagoArrendamientoEfectivo(request);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.pagoServiciosLinea:
						mensaje = pagoServiciosLinea(request, Enum_Tra_Ventanilla.pagoServicios);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.accesorios:
						mensaje = accesoriosCredito(request, reversa);
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
					case Enum_Tra_Ventanilla.depositoActivaCta:
//						mensajePLD = validacionPLD(tipoTransaccion, request, bean, Constantes.ENTERO_CERO);
//						folioEscala = Utileria.convierteEntero(mensajePLD.getConsecutivoString());
//						if (mensajePLD.getNumero() == Enum_EstatusOperacionPLD.AUTORIZADA || mensajePLD.getNumero() == 0) {
							mensaje = depositoActivaCta(request);
//							if (mensaje.getNumero() == Constantes.ENTERO_CERO) {
//								validacionPLD(tipoTransaccion, request, bean, folioEscala);
//							}
//						} else {
//							mensaje = mensajePLD;
//						}
						cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
						cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
						cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
						parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
						parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
						break;
				}// switch
					// actualizamos en N
				cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
				cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
				mensajeBean = cajasVentanillaDAO.actualizaEjecProNo(cajasVentanillaBean, Enum_Trans_CajasVentanilla.ejecProNo);
				loggerVent.info("Se Desbloquea el Proceso de Ejecución de otra Operación en la CAJA: " + cajasVentanillaBean.getCajaID());

			} else {// ya estaba en S
				mensaje = mensajeBean;
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion("Error al Grabar la Transaccion." + ex.getMessage());
			loggerVent.info("Error al Grabar la Transaccion de Ventanilla:", ex);
		}
		return mensaje;
	}
	// Lista para el disponible por denominacion
	public  Object[] listaConsulta(int tipoConsulta, IngresosOperacionesBean ingresosOperacionesBean){
		List listIngresosOpBean = null;
		switch(tipoConsulta){
			case Enum_Con_Ventanilla.disponiblePorDenom:
				listIngresosOpBean = ingresosOperacionesDAO.consultaDisponibleDenominacion(ingresosOperacionesBean, tipoConsulta);
			break;
		}
		return listIngresosOpBean.toArray();
		
	}
	/**
	 * Método para armar la Lista de Denominaciones
	 * @param billetesMonedasEntrada : String con las denominaciones de Entrada
	 * @param billetesMonedasSalida : String con las denominaciones de Salida
	 * @return List
	 */
	private List creaListaDenominaciones(String billetesMonedasEntrada,String billetesMonedasSalida){
		StringTokenizer tokensBean = new StringTokenizer(billetesMonedasEntrada, ",");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDenominaciones = new ArrayList();
		IngresosOperacionesBean ingresosOperacionesBean;
		
		while(tokensBean.hasMoreTokens()){
			ingresosOperacionesBean = new IngresosOperacionesBean();
			
			stringCampos = tokensBean.nextToken();
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "-");
			if(Utileria.convierteDoble(tokensCampos[1])>0){
				ingresosOperacionesBean.setDenominacionID(tokensCampos[0]);
				ingresosOperacionesBean.setCantidadDenominacion(tokensCampos[1]);
				ingresosOperacionesBean.setMontoDenominacion(tokensCampos[2]);
				ingresosOperacionesBean.setNaturalezaDenominacion(IngresosOperacionesBean.natDenEntrada);
				listaDenominaciones.add(ingresosOperacionesBean);
			}
		}
			
		StringTokenizer tokensBeanSalida = new StringTokenizer(billetesMonedasSalida, ",");
		String stringCamposSalida;
		String tokensCamposSalida[];
		
		while(tokensBeanSalida.hasMoreTokens()){
			ingresosOperacionesBean = new IngresosOperacionesBean();
			
			stringCamposSalida = tokensBeanSalida.nextToken();
			tokensCamposSalida = herramientas.Utileria.divideString(stringCamposSalida, "-");
			if(Utileria.convierteDoble(tokensCamposSalida[1])>0){
				ingresosOperacionesBean.setDenominacionID(tokensCamposSalida[0]);
				ingresosOperacionesBean.setCantidadDenominacion(tokensCamposSalida[1]);
				ingresosOperacionesBean.setMontoDenominacion(tokensCamposSalida[2]);
				ingresosOperacionesBean.setNaturalezaDenominacion(IngresosOperacionesBean.natDenSalida);
				listaDenominaciones.add(ingresosOperacionesBean);
			}
		}
			
		return listaDenominaciones;
	}
	// funcion para crear lista de cuentas de GL adicional
	private List creaListaCtaGLAdicional(String detalle){
		StringTokenizer tokensBean = new StringTokenizer(detalle, "[");
		String stringCampos;
		String tokensCampos[];
		ArrayList listaDetalle = new ArrayList();
		IngresosOperacionesBean ingresosOperacionesBean;
		
		while(tokensBean.hasMoreTokens()){
			ingresosOperacionesBean = new IngresosOperacionesBean();
		
			stringCampos = tokensBean.nextToken();		
			tokensCampos = herramientas.Utileria.divideString(stringCampos, "]");
	
			ingresosOperacionesBean.setCtaGLAdiID(tokensCampos[0]);
			ingresosOperacionesBean.setGarantiaLiqAdi(tokensCampos[1]);
			ingresosOperacionesBean.setClienteID(tokensCampos[2]);
			listaDetalle.add(ingresosOperacionesBean);
		}
		return listaDetalle;
	}
	/**
	 * Método para dar de alta el Cargo a Cuenta o Reversa de Cargo a Cuenta
	 * @param request : HttpServletRequest con la Informacion de Pantalla
	 * @param reversa : Especifica si la Operacion es de Reversa
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean cargoCuenta(HttpServletRequest request, boolean reversa) {
		MensajeTransaccionBean mensaje = null;
		try {
			ReversasOperBean reversasOperBean = new ReversasOperBean();
			IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

			ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaAhoIDCa"));
			ingresosOperacionesBean.setClienteID(request.getParameter("numClienteCa"));
			ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));

			ingresosOperacionesBean.setCantidadMov(request.getParameter("montoCargar"));
			if (request.getParameter("referenciaCa").replaceAll("\\s", "").isEmpty()) {
				ingresosOperacionesBean.setReferenciaMov(request.getParameter("cuentaAhoIDCa"));
				ingresosOperacionesBean.setReferenciaTicket(Constantes.STRING_VACIO);
			} else {
				ingresosOperacionesBean.setReferenciaMov(request.getParameter("referenciaCa"));
				ingresosOperacionesBean.setReferenciaTicket(request.getParameter("referenciaCa"));
			}

			ingresosOperacionesBean.setMonedaID(request.getParameter("monedaIDCa"));
			ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
			ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);

			ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
			ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);

			ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
			ingresosOperacionesBean.setMontoEnFirme(request.getParameter("montoCargar"));
			ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
			ingresosOperacionesBean.setInstrumento(request.getParameter("cuentaAhoIDCa"));

			ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
			ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);

			ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
			ingresosOperacionesBean.setCargos(Constantes.STRING_CERO);
			ingresosOperacionesBean.setAbonos(request.getParameter("montoCargar"));
			ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
			ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
			ingresosOperacionesBean.setUsuarioAut(request.getParameter("numeroUsuarios"));
			ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

			if (reversa == false) {

				/*Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque*/
				verificaFormaPago(ingresosOperacionesBean, request);

				ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.cargoCta);
				ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desRetiroCuenta);
				if (ingresosOperacionesBean.getFormaPago().equals(IngresosOperacionesBean.formaPago_Cheque)) {
					ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovCargoCtaCheque);
				} else {
					ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovCargoCuenta);
				}

				ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaDepVent);
				ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);

			} else {
				ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);
				ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.reversaDesCargoCuenta);
				ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovCargoCuentaRev);
				ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.reversaconcepContaCargoCta);
				ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);

				ingresosOperacionesBean.setUsuarioLogueado(request.getParameter("claveUsuarioLog"));

				reversasOperBean.setTransaccionID(request.getParameter("numeroTransaccionCC"));
				reversasOperBean.setTipoOperacion(IngresosOperacionesBean.tipoMovCargoCuenta);
				reversasOperBean.setReferencia(ingresosOperacionesBean.getReferenciaMov());
				reversasOperBean.setMonto(ingresosOperacionesBean.getMontoEnFirme());
				reversasOperBean.setCajaID(ingresosOperacionesBean.getCajaID());
				reversasOperBean.setSucursalID(ingresosOperacionesBean.getSucursalID());
				reversasOperBean.setFecha(ingresosOperacionesBean.getFecha());
				reversasOperBean.setMotivo(request.getParameter("motivo"));
				reversasOperBean.setDescripcionOper(request.getParameter("descripcionOper"));
				reversasOperBean.setClaveUsuarioAut(request.getParameter("claveUsuarioAut"));
				reversasOperBean.setContraseniaAut(request.getParameter("contraseniaAut"));
				reversasOperBean.setUsuarioAutID(request.getParameter("usuarioAutID"));
			}

			ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
			ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
			if (reversa == false) {
				mensaje = ingresosOperacionesDAO.altaCargoACuenta(ingresosOperacionesBean, listaDenominaciones);
				if (mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR) {
					CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
					cuentasAhoBean.setCuentaAhoID(request.getParameter("cuentaAhoIDCa"));
					envioSMSCuentaAho(cuentasAhoBean, ingresosOperacionesBean.getCantidadMov(), mensaje.getConsecutivoInt());
				}
			} else {
				mensaje = ingresosOperacionesDAO.reversaCargoACuenta(ingresosOperacionesBean, reversasOperBean, listaDenominaciones);
			}
		} catch (Exception ex) {
			loggerVent.info("Error al Realizar Operación de Cargo a Cuenta.", ex);
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Realizar Operación de Cargo a Cuenta.");
			}
		}
		return mensaje;
	}
	/**
	 * Método para realizar la Operación de Abono a Cuenta
	 * @param request : HttpServletRequest Objeto que trae la Información de Pantalla
	 * @param reversa : Boolean que define si la Operación es de Reversa
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean abonoCuenta(HttpServletRequest request, boolean reversa) {
		MensajeTransaccionBean mensaje = null;
		try {
			ReversasOperBean reversasOperBean = new ReversasOperBean();
			IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

			ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaAhoIDAb"));
			ingresosOperacionesBean.setClienteID(request.getParameter("numClienteAb"));
			ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));

			ingresosOperacionesBean.setCantidadMov(request.getParameter("montoAbonar"));
			if (request.getParameter("referenciaAb").replaceAll("\\s", "").isEmpty()) {
				ingresosOperacionesBean.setReferenciaMov(request.getParameter("cuentaAhoIDAb"));
				ingresosOperacionesBean.setReferenciaTicket("");
			} else {
				ingresosOperacionesBean.setReferenciaMov(request.getParameter("referenciaAb"));
				ingresosOperacionesBean.setReferenciaTicket(request.getParameter("referenciaAb"));
			}

			ingresosOperacionesBean.setMonedaID(request.getParameter("monedaIDAb"));
			ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
			ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);

			ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
			ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);

			ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
			ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
			ingresosOperacionesBean.setInstrumento(request.getParameter("cuentaAhoIDAb"));

			ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
			ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);

			ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
			ingresosOperacionesBean.setCargos(request.getParameter("montoAbonar"));
			ingresosOperacionesBean.setAbonos(Constantes.STRING_CERO);
			ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
			ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
			ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

			if (reversa == false) {
				ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desAbonoCuenta);
				ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);
				ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovAbonoCuenta);
				ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
				ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaDepVent);
			} else {
				ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.reversaAbonoCuenta);
				ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.cargoCta);
				ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovAbonoCuentaRev);
				ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);
				ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.reversaconcepContaAbonoCta);

				ingresosOperacionesBean.setUsuarioLogueado(request.getParameter("claveUsuarioLog"));

				reversasOperBean.setTransaccionID(request.getParameter("numeroTransaccionAC"));
				reversasOperBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalDepCta);
				reversasOperBean.setReferencia(ingresosOperacionesBean.getReferenciaMov());
				reversasOperBean.setMonto(ingresosOperacionesBean.getCantidadMov());
				reversasOperBean.setCajaID(ingresosOperacionesBean.getCajaID());
				reversasOperBean.setSucursalID(ingresosOperacionesBean.getSucursalID());
				reversasOperBean.setFecha(ingresosOperacionesBean.getFecha());
				reversasOperBean.setMotivo(request.getParameter("motivo"));
				reversasOperBean.setDescripcionOper(request.getParameter("descripcionOper"));
				reversasOperBean.setClaveUsuarioAut(request.getParameter("claveUsuarioAut"));
				reversasOperBean.setContraseniaAut(request.getParameter("contraseniaAut"));
				reversasOperBean.setUsuarioAutID(request.getParameter("usuarioAutID"));

			}

			ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
			ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
			if (reversa == false) {
				mensaje = ingresosOperacionesDAO.altaAbonoACuenta(ingresosOperacionesBean, listaDenominaciones);
			} else {
				mensaje = ingresosOperacionesDAO.reversaaltaAbonoACuenta(ingresosOperacionesBean, reversasOperBean, listaDenominaciones);
			}
		} catch (Exception ex) {
			loggerVent.info("Error al Ejecutar Transaccion Abono a Cuenta", ex);
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Ejecutar Transacción Abono a Cuenta.");
			}
		}
		return mensaje;
	}
	/**
	 * Desembolso de credito en efectivo  
	 * @param request
	 * @param reversa
	 * @return
	 */
	public MensajeTransaccionBean desembolsoCredito(HttpServletRequest request, boolean reversa) {
		ReversasOperBean reversasOperBean = new ReversasOperBean();
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaAhoIDDC"));
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDDC"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));

		ingresosOperacionesBean.setCantidadMov(request.getParameter("totalRetirarDC"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("creditoIDDC"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaIDDC"));
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro); // ???

		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setMontoEnFirme(request.getParameter("totalRetirarDC"));
		ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
		ingresosOperacionesBean.setInstrumento(request.getParameter("cuentaAhoIDDC"));
		ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);

		ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
		ingresosOperacionesBean.setCargos(Constantes.STRING_CERO);
		ingresosOperacionesBean.setAbonos(request.getParameter("totalRetirarDC"));

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		if (reversa == false) {

			//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
			verificaFormaPago(ingresosOperacionesBean, request);

			ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.cargoCta);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.retDesemCre);
			if (ingresosOperacionesBean.getFormaPago().equals(IngresosOperacionesBean.formaPago_Cheque)) {
				ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovCargoCtaCheque);
			} else {
				ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovCargoCuenta);
			}
			ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaDepVent);
		} else {
			ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desDesemCreReversa);
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovDesemCredRev);
			ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.reversaConcepContaDesCred);

			ingresosOperacionesBean.setUsuarioLogueado(request.getParameter("claveUsuarioLog"));

			reversasOperBean.setTransaccionID(request.getParameter("numeroTransaccionDC"));
			reversasOperBean.setTipoOperacion(IngresosOperacionesBean.opeCajaDesemCredito);
			reversasOperBean.setReferencia(ingresosOperacionesBean.getReferenciaMov());
			reversasOperBean.setMonto(ingresosOperacionesBean.getMontoEnFirme());
			reversasOperBean.setCajaID(ingresosOperacionesBean.getCajaID());
			reversasOperBean.setSucursalID(ingresosOperacionesBean.getSucursalID());
			reversasOperBean.setFecha(ingresosOperacionesBean.getFecha());
			reversasOperBean.setMotivo(request.getParameter("motivo"));
			reversasOperBean.setDescripcionOper(request.getParameter("descripcionOper"));
			reversasOperBean.setClaveUsuarioAut(request.getParameter("claveUsuarioAut"));
			reversasOperBean.setContraseniaAut(request.getParameter("contraseniaAut"));
			reversasOperBean.setUsuarioAutID(request.getParameter("usuarioAutID"));
		}
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		if (reversa == false) {
			mensaje = ingresosOperacionesDAO.desembolsoCredito(ingresosOperacionesBean, listaDenominaciones);
			if (mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR) {
				CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
				cuentasAhoBean.setCuentaAhoID(request.getParameter("cuentaAhoIDDC"));
//				envioSMSCuentaAho(cuentasAhoBean, ingresosOperacionesBean.getCantidadMov(), mensaje.getConsecutivoInt());
				envioSMSOperacion(Enum_Tipo_Alerta_Sms.desembolso, 
						ingresosOperacionesBean.getClienteID(), 
						cuentasAhoBean.getCuentaAhoID(), 
						null, //cuentaDestino, 
						ingresosOperacionesBean.getCantidadMov(), 
						null, // comision
						null, // iva
						ingresosOperacionesBean.getCantidadMov(), 
						null,		//claveRastreo, 
						null,		//descServicio, 
						mensaje.getConsecutivoInt(), 
						parametrosSesionBean.getFechaAplicacion().toGMTString(),
						ingresosOperacionesBean.getSucursalID());
			}
		} else {
			mensaje = ingresosOperacionesDAO.reversaDesembolsoCredito(ingresosOperacionesBean, reversasOperBean, listaDenominaciones);
		}
		return mensaje;
	}
	/**
	 * Método para realizar la Operación de Pago de Crédito Individual
	 * @param request : HttpServletRequest con la Informacion de la Operación
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean pagosCreditoEfectivo(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		try {
			CreditosBean creditosBean = new CreditosBean();
			IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
			creditosBean.setCreditoID(request.getParameter("creditoID"));
			creditosBean.setCuentaID(request.getParameter("cuentaID"));
			creditosBean.setMonedaID(request.getParameter("monedaID"));
			creditosBean.setFiniquito(request.getParameter("finiquito"));
			creditosBean.setCicloGrupo(request.getParameter("cicloID"));

			ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaID"));
			ingresosOperacionesBean.setClienteID(request.getParameter("creditoID"));
			ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
			ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);

			ingresosOperacionesBean.setCantidadMov(request.getParameter("montoPagar"));
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.depPagoCredito);
			ingresosOperacionesBean.setReferenciaMov(request.getParameter("creditoID"));
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovAbonoCuenta);
			ingresosOperacionesBean.setMonedaID(request.getParameter("monedaID"));

			ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
			ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaDepVent);
			ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
			ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);

			ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
			ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
			ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
			ingresosOperacionesBean.setInstrumento(request.getParameter("cuentaID"));

			ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
			ingresosOperacionesBean.setCargos(request.getParameter("montoPagar"));
			ingresosOperacionesBean.setAbonos(Constantes.STRING_CERO);

			ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
			ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);
			ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
			ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));

			// se ocupan para el abono a cuenta y bloqueo por GL
			ingresosOperacionesBean.setGarantiaLiqAdi(request.getParameter("garantiaAdicionalPC"));
			ingresosOperacionesBean.setClienteID(request.getParameter("clienteID"));
			ingresosOperacionesBean.setCtaGLAdiID(request.getParameter("ctaGLAdiID"));
			ingresosOperacionesBean.setMontoPagadoCredito(request.getParameter("montoPagadoCredito"));
			ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

			ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
			ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
			try {
				if (Double.parseDouble(ingresosOperacionesBean.getGarantiaLiqAdi()) > 0) {
					double cantidadPagar = 0;
					cantidadPagar = CalculosyOperaciones.resta(Double.parseDouble(ingresosOperacionesBean.getCantidadMov()), Double.parseDouble(ingresosOperacionesBean.getGarantiaLiqAdi()));
					ingresosOperacionesBean.setCantidadMov(String.valueOf(cantidadPagar));
				}
				creditosBean.setMontoPagar(ingresosOperacionesBean.getCantidadMov());
				creditosBean.setOrigenPago(Constantes.ORIGEN_PAGO_VENTANILLA);
				if (Double.parseDouble(ingresosOperacionesBean.getGarantiaLiqAdi()) >= 0) {
					mensaje = ingresosOperacionesDAO.pagoCreditoEfectivo(ingresosOperacionesBean, creditosBean, listaDenominaciones);
				}
			} catch (NumberFormatException e) {
				mensaje.setNumero(9);
				mensaje.setDescripcion("El valor indicado para Garantía Líquida adicional no es valido.");
				mensaje.setNombreControl("0");
				mensaje.setConsecutivoString("0");
				e.printStackTrace();
				loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago de credito en efectivo", e);
			}
		} catch (Exception ex) {
			loggerVent.info("Error al realizar la operación de Alta Cargo Cuenta.", ex);
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al realizar la operación de Pago de Crédito.");
			}
		}
		return mensaje;
	}
	/**
	 * Método para realizar proceso de Deposito de Garantia Liquida
	 * @param request : HttpServletRequest
	 * @param reversa : Indica si es un proceso de Reversa
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean depositoGarantiaLiquida(HttpServletRequest request, boolean reversa) {
		MensajeTransaccionBean mensaje = null;
		try {
			ReversasOperBean reversasOperBean = new ReversasOperBean();

			IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
			BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
			String depositoEfectivo = "DE";
			String cargoCuenta = "CC";
			ingresosOperacionesBean.setFormaPagoGL(request.getParameter("formaPagoGL"));

			ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaAhoIDGL"));
			ingresosOperacionesBean.setClienteID(request.getParameter("numClienteGL"));
			ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));

			ingresosOperacionesBean.setCantidadMov(request.getParameter("montoGarantiaLiq"));
			ingresosOperacionesBean.setReferenciaMov(request.getParameter("referenciaGL"));
			ingresosOperacionesBean.setMonedaID(request.getParameter("monedaIDGL"));

			ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
			ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
			ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
			ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);

			ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));

			ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
			ingresosOperacionesBean.setInstrumento(request.getParameter("cuentaAhoIDGL"));

			ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
			ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);

			bloqueoSaldoBean.setClienteID(request.getParameter("numClienteGL"));
			bloqueoSaldoBean.setNatMovimiento(IngresosOperacionesBean.natBloqueo);
			bloqueoSaldoBean.setCuentaAhoID(request.getParameter("cuentaAhoIDGL"));
			bloqueoSaldoBean.setFechaMov(request.getParameter("fechaSistemaP"));
			bloqueoSaldoBean.setMontoBloq(request.getParameter("montoGarantiaLiq"));
			bloqueoSaldoBean.setTiposBloqID(IngresosOperacionesBean.tipoMovBlo);
			bloqueoSaldoBean.setDescripcion(IngresosOperacionesBean.desMovBloqGaranLiq);
			bloqueoSaldoBean.setReferencia(request.getParameter("referenciaGL"));

			ingresosOperacionesBean.setTipoOpDivBillMon(request.getParameter("tipoOpBilletesMonedas"));
			ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
			ingresosOperacionesBean.setCargos(request.getParameter("montoGarantiaLiq"));
			ingresosOperacionesBean.setAbonos(Constantes.STRING_CERO);

			ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
			ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
			ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
			if (reversa == false) {
				ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);
				ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovDepGL);
				ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);

				if ((ingresosOperacionesBean.getFormaPagoGL()).equals(cargoCuenta)) {
					ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desMovBloqGaranLiq);
					ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaDepVent);
				} else if ((ingresosOperacionesBean.getFormaPagoGL()).equals(depositoEfectivo)) {
					ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descMovsDepGlCTA);
					ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepBloqGarLiq);
				}

			} else {
				ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.cargoCta);
				ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.reversaDesMovBloqGaranLiq);
				ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovDepGarLiqRev);
				ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.reversaConcepContaDepGarLiq);
				ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);
				ingresosOperacionesBean.setTransaccionOperacionID(request.getParameter("numeroTransaccionGL")); //para desbloquear el saldo en tabla BLOQUEOS		

				ingresosOperacionesBean.setUsuarioLogueado(request.getParameter("claveUsuarioLog"));

				reversasOperBean.setTransaccionID(request.getParameter("numeroTransaccionGL")); // para tabla de REVERSASOPER
				reversasOperBean.setTipoOperacion(IngresosOperacionesBean.opeCajDepGarLiq);
				reversasOperBean.setReferencia(ingresosOperacionesBean.getReferenciaMov());
				reversasOperBean.setMonto(ingresosOperacionesBean.getCantidadMov());
				reversasOperBean.setCajaID(ingresosOperacionesBean.getCajaID());
				reversasOperBean.setSucursalID(ingresosOperacionesBean.getSucursalID());
				reversasOperBean.setFecha(ingresosOperacionesBean.getFecha());
				reversasOperBean.setMotivo(request.getParameter("motivo"));
				reversasOperBean.setDescripcionOper(request.getParameter("descripcionOper"));
				reversasOperBean.setClaveUsuarioAut(request.getParameter("claveUsuarioAut"));
				reversasOperBean.setContraseniaAut(request.getParameter("contraseniaAut"));
				reversasOperBean.setUsuarioAutID(request.getParameter("usuarioAutID"));

			}

			ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
			ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
			if (reversa == false) {
				mensaje = ingresosOperacionesDAO.depositoGarantiaLiquida(ingresosOperacionesBean, bloqueoSaldoBean, listaDenominaciones);
			} else {
				mensaje = ingresosOperacionesDAO.reversaDepositoGarantiaLiquida(ingresosOperacionesBean, bloqueoSaldoBean, listaDenominaciones, reversasOperBean);
			}
		} catch (Exception ex) {
			loggerVent.info("Error al realizar la operación de Deposito de Garantia Liquida.", ex);
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al realizar la operación de Deposito de Garantia Liquida.");
			}
		}
		return mensaje;
	}
	/**
	 * Método para realizar el pago de Crédito Grupal
	 * @param request
	 * @param bean
	 * @return
	 */
	public MensajeTransaccionBean pagosGrupalCreditoEfectivo(HttpServletRequest request, IngresosOperacionesBean bean) {
		MensajeTransaccionBean mensaje = null;
		CreditosBean creditosBean = new CreditosBean();
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		creditosBean.setCreditoID(request.getParameter("creditoID"));
		creditosBean.setCuentaID(request.getParameter("cuentaID"));
		creditosBean.setMonedaID(request.getParameter("monedaID"));
		creditosBean.setGrupoID(request.getParameter("grupoID"));
		creditosBean.setFiniquito(request.getParameter("finiquito"));
		creditosBean.setCicloGrupo(request.getParameter("cicloID"));

		ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaID"));
		ingresosOperacionesBean.setClienteID(request.getParameter("creditoID"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);

		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoPagar"));
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.depPagoCredito);
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("creditoID"));
		ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovAbonoCuenta);
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaID"));

		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaDepVent);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);

		ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
		ingresosOperacionesBean.setInstrumento(request.getParameter("cuentaID"));

		ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
		ingresosOperacionesBean.setCargos(request.getParameter("montoPagar"));
		ingresosOperacionesBean.setAbonos(Constantes.STRING_CERO);
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));

		ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));

		ingresosOperacionesBean.setGarantiaLiqAdi(request.getParameter("garantiaAdicionalPC"));
		ingresosOperacionesBean.setMontoPagadoCredito(request.getParameter("montoPagadoCredito"));
		ingresosOperacionesBean.setClienteCargoAbono(request.getParameter("clienteID")); //ClienteID que se usara en DENOMINAMOVSALT

		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ArrayList listaCtasGLAd = (ArrayList) creaListaCtaGLAdicional(request.getParameter("listaCuentasGLAdicional"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		try {
			if (Utileria.convierteDoble(ingresosOperacionesBean.getGarantiaLiqAdi()) > 0) {
				double cantidadPagar = 0;
				cantidadPagar = Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()) - Utileria.convierteDoble(ingresosOperacionesBean.getGarantiaLiqAdi());
				ingresosOperacionesBean.setCantidadMov(String.valueOf(cantidadPagar));
			}
			creditosBean.setMontoPagar(ingresosOperacionesBean.getCantidadMov());
			if (Utileria.convierteDoble(ingresosOperacionesBean.getGarantiaLiqAdi()) >= 0) {
				mensaje = ingresosOperacionesDAO.pagoGrupalCreditoEfectivo(ingresosOperacionesBean, creditosBean, listaDenominaciones, listaCtasGLAd, origenVent);
			}
		} catch (NumberFormatException e) {
			mensaje.setNumero('9');
			mensaje.setDescripcion("El valor indicado para Garantía Líquida adicional no es valido.");
			mensaje.setNombreControl("0");
			mensaje.setConsecutivoString("0");
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago grupal de credito", e);
		}
		return mensaje;
	}
	/**
	 * Método para realizar el pago de la Comisión por Apertura de Crédito
	 * @param request
	 * @param reversa
	 * @return
	 */
	public MensajeTransaccionBean comisionAperturaCredito(HttpServletRequest request, boolean reversa) {
		ReversasOperBean reversasOperBean = new ReversasOperBean();
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaAhoIDAR"));
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDAR"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setCreditoID(request.getParameter("creditoIDAR"));

		ingresosOperacionesBean.setCantidadMov(request.getParameter("totalDepAR"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("creditoIDAR"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaIDAR"));

		ingresosOperacionesBean.setProductoCreditoID(request.getParameter("productoCreditoIDAR"));

		ingresosOperacionesBean.setFormaCobroComApCre(request.getParameter("formaCobAR"));

		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));

		ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);

		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));

		ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
		ingresosOperacionesBean.setInstrumento(request.getParameter("cuentaAhoIDAR"));

		ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);

		ingresosOperacionesBean.setTipoOpDivBillMon(request.getParameter("tipoOpBilletesMonedas"));
		ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
		ingresosOperacionesBean.setCargos(request.getParameter("totalDepAR"));
		ingresosOperacionesBean.setAbonos(Constantes.STRING_CERO);

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
		if (reversa != true) {
			ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.depComApCre);
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovComApertura);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaComApCre);
			ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
			ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
			ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);

		} else {
			ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.cargoCta);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.reversaComisionApCre);
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovcomAperCredRev);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.reversaconcepContaComApCre);
			ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);
			ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
			ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);

			ingresosOperacionesBean.setUsuarioLogueado(request.getParameter("claveUsuarioLog"));

			reversasOperBean.setTransaccionID(request.getParameter("numeroTransaccionAR")); // para tabla de REVERSASOPER
			reversasOperBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalComApCre);
			reversasOperBean.setReferencia(ingresosOperacionesBean.getReferenciaMov());
			reversasOperBean.setMonto(ingresosOperacionesBean.getCantidadMov());
			reversasOperBean.setCajaID(ingresosOperacionesBean.getCajaID());
			reversasOperBean.setSucursalID(ingresosOperacionesBean.getSucursalID());
			reversasOperBean.setFecha(ingresosOperacionesBean.getFecha());
			reversasOperBean.setMotivo(request.getParameter("motivo"));
			reversasOperBean.setDescripcionOper(request.getParameter("descripcionOper"));
			reversasOperBean.setClaveUsuarioAut(request.getParameter("claveUsuarioAut"));
			reversasOperBean.setContraseniaAut(request.getParameter("contraseniaAut"));
			reversasOperBean.setUsuarioAutID(request.getParameter("usuarioAutID"));
		}
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		if (reversa != true) {
			mensaje = ingresosOperacionesDAO.comisionAperturaCredito(ingresosOperacionesBean, listaDenominaciones);
		} else {
			mensaje = ingresosOperacionesDAO.reversaComisionAperturaCredito(ingresosOperacionesBean, reversasOperBean, listaDenominaciones);
		}
		return mensaje;
	}
	/**
	 * Devolucion de Garantia Liquida
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean devolucionGL(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaAhoIDDG"));
		ingresosOperacionesBean.setClienteID(request.getParameter("numClienteDG"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.cargoCta);

		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoDevGL"));
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desMovDevGaranLiq);
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("creditoDGL"));
		ingresosOperacionesBean.setFormaPago(request.getParameter("formaPagoOpera"));

		if (ingresosOperacionesBean.getFormaPago().equals(IngresosOperacionesBean.formaPago_Cheque)) {
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovCargoCtaCheque);
		} else {
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovCargoCuenta);
		}

		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaIDDG"));

		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepDevolucionGL);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);

		ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
		ingresosOperacionesBean.setInstrumento(request.getParameter("cuentaAhoIDDG"));

		ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setMontoEnFirme(request.getParameter("montoDevGL"));

		ingresosOperacionesBean.setTipoOpDivBillMon(request.getParameter("tipoOpBilletesMonedas"));
		ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
		ingresosOperacionesBean.setCargos(Constantes.STRING_CERO);
		ingresosOperacionesBean.setAbonos(request.getParameter("montoDevGL"));

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
		//ingresosOperacionesBean.setNaturalezaDenominacion(IngresosOperacionesBean.natDenEntrada);

		//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
		verificaFormaPago(ingresosOperacionesBean, request);

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.devolucionGarantiaLiquida(ingresosOperacionesBean, listaDenominaciones);
		return mensaje;
	}
	/**
	 * PAGO SEGURO VIDA, RELACIONADO AL CREDITO  SINIESTRO
	 * @param request
	 * @param reversa
	 * @return
	 */
	public MensajeTransaccionBean pagoSeguroVida(HttpServletRequest request, boolean reversa) {
		ReversasOperBean reversasOperBean = new ReversasOperBean();
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		ingresosOperacionesBean.setSeguroVidaID(request.getParameter("numeroPolizaS"));
		ingresosOperacionesBean.setCreditoID(request.getParameter("creditoIDS"));
		ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaClienteS"));
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDS"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaS"));
		ingresosOperacionesBean.setProductoCreditoID(request.getParameter("productoCreditoS"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoPoliza"));

		ingresosOperacionesBean.setReferenciaMov(request.getParameter("creditoIDS"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);

		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setMontoEnFirme(request.getParameter("montoPoliza"));
		ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
		ingresosOperacionesBean.setInstrumento(request.getParameter("numeroPolizaS"));

		ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);

		ingresosOperacionesBean.setCargos(Constantes.STRING_CERO);
		ingresosOperacionesBean.setAbonos(request.getParameter("montoPoliza"));
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		if (reversa == false) {
			//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
			verificaFormaPago(ingresosOperacionesBean, request);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepPagoSegVida);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desAplicaSeguroVida);
		} else {
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepPagoSegVida);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desRevAplicaSegVida);

			ingresosOperacionesBean.setUsuarioLogueado(request.getParameter("claveUsuarioLog"));

			reversasOperBean.setTransaccionID(request.getParameter("numeroTransaccionSV"));
			reversasOperBean.setTipoOperacion(IngresosOperacionesBean.opeCajaEntpagoseguroVida);

			reversasOperBean.setReferencia(ingresosOperacionesBean.getReferenciaMov());
			reversasOperBean.setMonto(ingresosOperacionesBean.getMontoEnFirme());
			reversasOperBean.setCajaID(ingresosOperacionesBean.getCajaID());
			reversasOperBean.setSucursalID(ingresosOperacionesBean.getSucursalID());
			reversasOperBean.setFecha(ingresosOperacionesBean.getFecha());
			reversasOperBean.setMotivo(request.getParameter("motivo"));
			reversasOperBean.setDescripcionOper(request.getParameter("descripcionOper"));
			reversasOperBean.setClaveUsuarioAut(request.getParameter("claveUsuarioAut"));
			reversasOperBean.setContraseniaAut(request.getParameter("contraseniaAut"));
			reversasOperBean.setUsuarioAutID(request.getParameter("usuarioAutID"));
		}
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		if (reversa == false) {
			mensaje = ingresosOperacionesDAO.pagoSeguroVida(ingresosOperacionesBean, listaDenominaciones);
		} else {
			mensaje = ingresosOperacionesDAO.reversaPagoSeguroVida(ingresosOperacionesBean, reversasOperBean, listaDenominaciones);
		}
		return mensaje;
	}
	/**
	 * Método que Realiza la Operación de Cobro de Seguro de Vida
	 * @param request
	 * @param reversa
	 * @return
	 */
	public MensajeTransaccionBean cobroSeguroVida(HttpServletRequest request, boolean reversa) {
		MensajeTransaccionBean mensaje = null;
		ReversasOperBean reversasOperBean = new ReversasOperBean();
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		ingresosOperacionesBean.setSeguroVidaID(request.getParameter("numeroPolizaSC"));
		ingresosOperacionesBean.setCreditoID(request.getParameter("creditoIDSC"));
		ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaClienteSC"));
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDSC"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaSC"));
		ingresosOperacionesBean.setProductoCreditoID(request.getParameter("productoCreditoSC"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoSeguroCobro"));

		ingresosOperacionesBean.setReferenciaMov(request.getParameter("creditoIDSC"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);

		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setMontoEnFirme(request.getParameter("montoSeguroCobro"));
		ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
		ingresosOperacionesBean.setInstrumento(request.getParameter("numeroPolizaSC"));
		ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setCargos(request.getParameter("montoSeguroCobro"));
		ingresosOperacionesBean.setAbonos(Constantes.STRING_CERO);
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
		if (reversa == false) {
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepCobroSegVida);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.DesCobroSeguro);
		} else {
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.reversaConcepCobroSegVida);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.DesRevCobroCobeRiesgo);

			ingresosOperacionesBean.setUsuarioLogueado(request.getParameter("claveUsuarioLog"));

			reversasOperBean.setTransaccionID(request.getParameter("numeroTransaccionCSV"));
			reversasOperBean.setTipoOperacion(IngresosOperacionesBean.opeCajaSalCobroseguroVida);

			reversasOperBean.setReferencia(ingresosOperacionesBean.getReferenciaMov());
			reversasOperBean.setMonto(ingresosOperacionesBean.getMontoEnFirme());
			reversasOperBean.setCajaID(ingresosOperacionesBean.getCajaID());
			reversasOperBean.setSucursalID(ingresosOperacionesBean.getSucursalID());
			reversasOperBean.setFecha(ingresosOperacionesBean.getFecha());
			reversasOperBean.setMotivo(request.getParameter("motivo"));
			reversasOperBean.setDescripcionOper(request.getParameter("descripcionOper"));
			reversasOperBean.setClaveUsuarioAut(request.getParameter("claveUsuarioAut"));
			reversasOperBean.setContraseniaAut(request.getParameter("contraseniaAut"));
			reversasOperBean.setUsuarioAutID(request.getParameter("usuarioAutID"));
		}
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");

		if (reversa == false) {
			mensaje = ingresosOperacionesDAO.cobroSeguroVida(ingresosOperacionesBean, listaDenominaciones);
		} else {
			mensaje = ingresosOperacionesDAO.reversaCobroSeguroVida(ingresosOperacionesBean, reversasOperBean, listaDenominaciones);
		}

		return mensaje;
	}
	/**
	 * Método Para Realizar el Proceso de Cambio de Efectivo en la Ventanilla
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean cambiarEfectivo(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));

		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setInstrumento(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("numeroSucursal"));

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.cambioEfectivo(ingresosOperacionesBean, listaDenominaciones);
		return mensaje;
	}
	/**
	 * Método para realizar la Transferencia entre Cuentas
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean transferenciaEntreCuentas(HttpServletRequest httpServletRequest) {

		MensajeTransaccionBean mensajeTransaccionBean = null;
		IngresosOperacionesBean ingresosOperacionesBean = null;
		TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
		long numeroTransaccion = 0;
		String descripcion = "", descripcionWS = "", nombreControl = "", cantidadMov = "",
			   consecutivoString = "", notificar = "N", cuentaOrigen = "", cuentaDestino = "";
		int numeroErrorCuentaOrigen  = 0;
		int numeroErrorCuentaDestino = 0;
		
		try {

			ingresosOperacionesBean = asignacionTransferenciaCuenta(httpServletRequest);
			cuentaOrigen = ingresosOperacionesBean.getCuentaAhoID();
			cuentaDestino = ingresosOperacionesBean.getCuentaCargoAbono();
			cantidadMov = ingresosOperacionesBean.getCantidadMov();

			mensajeTransaccionBean = ingresosOperacionesDAO.transferenciaCuentas(ingresosOperacionesBean);
			if (mensajeTransaccionBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
				CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
				cuentasAhoBean.setCuentaAhoID(httpServletRequest.getParameter("cuentaAhoIDT"));
//				envioSMSCuentaAho(cuentasAhoBean, ingresosOperacionesBean.getCantidadMov(), mensajeTransaccionBean.getConsecutivoString());
				envioSMSOperacion(Enum_Tipo_Alerta_Sms.trEntreCuentas, 
									ingresosOperacionesBean.getClienteID(), 
									cuentaOrigen, 
									cuentaDestino, 
									cantidadMov, 
									ingresosOperacionesBean.getComision(),
									ingresosOperacionesBean.getIVAMonto(), 
									cantidadMov, 
									null,		//claveRastreo, 
									null,		//descServicio, 
									mensajeTransaccionBean.getConsecutivoString(), 
									parametrosSesionBean.getFechaAplicacion().toGMTString(),
									ingresosOperacionesBean.getSucursalID());
			}
			
			notificar = Constantes.STRING_SI;
			numeroTransaccion = Utileria.convierteLong(mensajeTransaccionBean.getConsecutivoString());
			descripcion = mensajeTransaccionBean.getDescripcion();
			nombreControl = mensajeTransaccionBean.getNombreControl();
			consecutivoString = cuentaOrigen;
			
			loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
			// Proceso de tarjetas - Cuenta de Cargo
			tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
			tarjetaDebitoBean.setNumeroInstrumento(cuentaOrigen);
			tarjetaDebitoBean.setMontoOperacion(cantidadMov);
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.transCuentaCargo, numeroTransaccion, Enum_Tran_ISOTRX.operacionPeticion); 

			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				descripcionWS = descripcionWS + "<br><b>WS ISOTRX Cuenta "+cuentaOrigen +":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
				mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
				numeroErrorCuentaOrigen = numeroErrorCuentaOrigen + Constantes.ENTERO_UNO;
				loggerISOTRX.error("WS ISOTRX Cuenta "+cuentaOrigen +": "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
			}
			
			loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
			// Proceso de tarjetas - Cuenta de Abono
			tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
			tarjetaDebitoBean.setNumeroInstrumento(cuentaDestino);
			tarjetaDebitoBean.setMontoOperacion(cantidadMov);
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.transCuentaAbono, numeroTransaccion, Enum_Tran_ISOTRX.operacionPeticion); 

			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				descripcionWS = descripcionWS + "<br><b>WS ISOTRX Cuenta "+cuentaDestino+":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
				mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
				numeroErrorCuentaDestino = numeroErrorCuentaDestino + Constantes.ENTERO_UNO;
				loggerISOTRX.error("WS ISOTRX Cuenta "+cuentaDestino +": "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
			}
			
			if( numeroErrorCuentaOrigen  > Constantes.ENTERO_CERO ||
				numeroErrorCuentaDestino > Constantes.ENTERO_CERO ){
				throw new Exception();
			}

			mensajeTransaccionBean.setDescripcion(descripcion);
			mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
			mensajeTransaccionBean.setNombreControl(nombreControl);
			mensajeTransaccionBean.setConsecutivoString(consecutivoString);
			
		} catch (Exception exception) {
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Ha ocurrido un Error en la Operación de Transferencias Entre Cuentas. ");
			}
			loggerVent.error(mensajeTransaccionBean.getDescripcion(), exception);
			exception.printStackTrace();
	
			if(notificar.equals(Constantes.STRING_SI)){
				
				// Si el proceso falla si se notifica el saldo de la Cuenta de Cargo
				if( numeroErrorCuentaOrigen > Constantes.ENTERO_CERO ){
					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
					tarjetaDebitoBean.setNumeroInstrumento(cuentaOrigen);
	
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.notificaSaldoCuenta, numeroTransaccion, Enum_Tran_ISOTRX.operacionPeticion); 
					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						descripcionWS = descripcionWS + "<br><b>WS ISOTRX Cuenta "+cuentaOrigen +":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
						loggerSAFI.error("<br><b>WS ISOTRX Cuenta "+cuentaOrigen +":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
					}
				}
				
				// Si el proceso falla si se notifica el saldo de la Cuenta de Abono
				if( numeroErrorCuentaDestino > Constantes.ENTERO_CERO ){
					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
					tarjetaDebitoBean.setNumeroInstrumento(cuentaDestino);
	
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.notificaSaldoCuenta, numeroTransaccion, Enum_Tran_ISOTRX.operacionPeticion); 
					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						descripcionWS = descripcionWS + "<br><b>WS ISOTRX Cuenta "+cuentaDestino +":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
						loggerSAFI.error("<br><b>WS ISOTRX Cuenta "+cuentaDestino +":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
					}
				}
		
				// si la operacion se proceso en SFI y fue Existosa se regresa el objeto con mensaje exitoso y el fallo de ISOTRX al momento de notificar
				mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO );
				mensajeTransaccionBean.setDescripcion(descripcion+descripcionWS);
				mensajeTransaccionBean.setNombreControl(nombreControl);
				mensajeTransaccionBean.setConsecutivoString(consecutivoString);
			}
		}
		
		return mensajeTransaccionBean;
	}

	/**
	 * Método para Realizar el Pago de la Aportación Social
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean pagoAportacionSocial(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		// Aportacion Socio, Encabezado y detalle poliza
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDAS"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoAS"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setUsuario(request.getParameter("numeroUsuarios"));

		//movimientos en de billetes
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setInstrumento(request.getParameter("clienteIDAS"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("clienteIDAS"));
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desAportacionSocio);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepAportacionSocio);
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		//DATOS Extras para los tickets
		ingresosOperacionesBean.setMontoPagadoAS(request.getParameter("montoPagadoAS"));
		ingresosOperacionesBean.setMontoPendientePagoAS(request.getParameter("montoPendientePagoAS"));

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.aportacionSocial(ingresosOperacionesBean, listaDenominaciones);

		return mensaje;
	}
	/**
	 * Método para realizar la Devolución de la Aportación Social
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean devolucionAportacionSocial(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		// Aportacion Socio, Encabezado y detalle poliza
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDDAS"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoDAS"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setUsuario(request.getParameter("numeroUsuarios"));

		//movimientos en de billetes
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setInstrumento(request.getParameter("clienteIDDAS"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("clienteIDDAS"));
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desDevolucionASocio);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepDevAportacionSocio);
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
		verificaFormaPago(ingresosOperacionesBean, request);

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.devolucionAportacionSocial(ingresosOperacionesBean, listaDenominaciones);

		return mensaje;
	}
	/**
	 * Método para realizar el proceso de Cobro de Seguro de Vida de Ayuda
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean cobroSeguroVidaAyuda(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		// Seguro Ayuda, Encabezado y detalle poliza
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDCSVA"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoCobrarSeg"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setUsuario(request.getParameter("numeroUsuarios"));
		//movimientos en de billetes
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setInstrumento(request.getParameter("clienteIDCSVA"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("clienteIDCSVA"));
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desCobroSegAyuda);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.ConContaCobSegVida);
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.cobroSeguroAyuda(ingresosOperacionesBean, listaDenominaciones);

		return mensaje;
	}
	/**
	 * Aplicacion, Pago al Cliente del Seguro de Ayuda(Vida), Independiente del Credito
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean aplicaSeguroAyuda(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		// Seguro Ayuda, Encabezado y detalle poliza
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDASVA"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoPolizaSegAyudaCobroA"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setUsuario(request.getParameter("numeroUsuarios"));
		ingresosOperacionesBean.setPolizaSeguro(request.getParameter("numeroPolizaSVAA"));

		//movimientos en de billetes
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setInstrumento(request.getParameter("clienteIDASVA"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("numeroPolizaSVAA")); // checar el numero de Poliza cuando no existe el cliente
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPagoSegAyuda);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.ConContaAplSegVida);
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
		verificaFormaPago(ingresosOperacionesBean, request);

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.pagoSeguroAyuda(ingresosOperacionesBean, listaDenominaciones);

		return mensaje;
	}
	/**
	 * Método pra realizar el Pago de Resemesas y Oportunidades
	 * @param request
	 * @param TipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean pagoRemesasyOportunidades(HttpServletRequest request, int TipoTransaccion) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		//Cliente o Usuario
		if (!request.getParameter("clienteIDServicio").equals(Constantes.STRING_VACIO)) {
			ingresosOperacionesBean.setNombreCliente(request.getParameter("nombreClienteServicio"));
		} else {
			ingresosOperacionesBean.setUsuarioID(request.getParameter("usuarioRem"));
			ingresosOperacionesBean.setNombreCliente(request.getParameter("nombreUsuarioRem"));
		}

		// Alta Remesa y/o oportunidades, Encabezado y detalle poliza
		ingresosOperacionesBean.setReferenciaPago(request.getParameter("referenciaServicio"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoServicio"));
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDServicio"));
		ingresosOperacionesBean.setDireccionCliente(request.getParameter("direccionClienteServicio"));
		ingresosOperacionesBean.setTipoIdentifiCliente(request.getParameter("indentiClienteServicio"));
		ingresosOperacionesBean.setFolioIdentifiCliente(request.getParameter("folioIdentiClienteServicio"));
		ingresosOperacionesBean.setFormaPago(request.getParameter("tipoPagoServicio"));
		ingresosOperacionesBean.setCuentaAhoID(request.getParameter("numeroCuentaServicio"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setUsuario(request.getParameter("numeroUsuarios"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setTelefonoCliente(request.getParameter("telefonoClienteServicio"));

		//movimientos en de billetes
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setInstrumento(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("referenciaServicio"));

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));

		// para eldeposito a cuenta
		ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);
		ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);
		ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaDepVent);
		ingresosOperacionesBean.setRemesaCatalogoID(request.getParameter("remesaCatalogoID"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
		if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
			ingresosOperacionesBean.setBancoEmisor(request.getParameter("institucionID"));
			ingresosOperacionesBean.setCuentaBancos(request.getParameter("numCtaInstit"));
			ingresosOperacionesBean.setNumeroCheque(request.getParameter("numeroCheque"));
			ingresosOperacionesBean.setNombreBeneficiario(request.getParameter("beneCheque"));
			ingresosOperacionesBean.setUsuario(request.getParameter("numeroUsuarios"));
			ingresosOperacionesBean.setTipoChequera(request.getParameter("tipoChequera"));

		}

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		if (TipoTransaccion == Enum_Tra_Ventanilla.pagoRemesas) {
			//Pago de Remesas
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPagoRemesas);
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovPagoRemesa);
			mensaje = ingresosOperacionesDAO.pagoRemesas(ingresosOperacionesBean, listaDenominaciones);
		} else {
			//Pago de Oportunidades
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPagoOportunidades);
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovPagoOportun);
			mensaje = ingresosOperacionesDAO.pagoOportunidades(ingresosOperacionesBean, listaDenominaciones);
		}
		return mensaje;
	}
	/**
	 * Método para la Recepción de Cheques SBC en la Ventanilla
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean recepcionChequeSBC(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		String interna = "I";
		// Alta del cheque SBC y actualizacion del saldo SBC
		ingresosOperacionesBean.setCuentaAhoID(request.getParameter("numeroCuentaRec"));
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDSBC"));
		ingresosOperacionesBean.setNombreCliente(request.getParameter("nombreClienteSBC"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoSBC"));
		ingresosOperacionesBean.setBancoEmisor(request.getParameter("bancoEmisorSBC"));
		ingresosOperacionesBean.setCuentaCargoAbono(request.getParameter("numeroCuentaEmisorSBC"));
		ingresosOperacionesBean.setTipoChequeraRecep(request.getParameter("tipoChequeraRecep"));
		ingresosOperacionesBean.setNumeroCheque(request.getParameter("numeroChequeSBC"));
		ingresosOperacionesBean.setNombreEmisor(request.getParameter("nombreEmisorSBC"));
		ingresosOperacionesBean.setTipoCuenta(request.getParameter("tipoCtaCheque"));
		ingresosOperacionesBean.setFormaCobro(request.getParameter("formaCobro"));
		ingresosOperacionesBean.setNombreBeneficiario(request.getParameter("beneficiarioSBC"));

		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setUsuario(request.getParameter("numeroUsuarios"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));

		ingresosOperacionesBean.setInstrumento(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("numeroChequeSBC"));
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
		ingresosOperacionesBean.setAfectaContaSBC(request.getParameter("afectacionContable"));
		ingresosOperacionesBean.setChequeSBCID(request.getParameter("clientechequeSBCAplic"));

		if (ingresosOperacionesBean.getTipoCuenta().equalsIgnoreCase(interna)) {
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaAplicaCheqInt);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descCobroChequeCtaInt);
		} else {
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaAplicaCheqExt);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descCobroChequeCtaExt);
		}
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.recepcionChequeSBC(ingresosOperacionesBean, listaDenominaciones);

		return mensaje;
	}
	/**
	 * Método que realiza el Proceso de Aplicación de Cheque SBC
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean aplicaChequeSBC(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		// Alta del cheque SBC y actualizacion del saldo SBC
		ingresosOperacionesBean.setChequeSBCID(request.getParameter("clientechequeSBCAplic"));
		ingresosOperacionesBean.setCuentaAhoID(request.getParameter("numeroCuentaSBC"));
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDSBCAplic"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoSBCAplic"));
		ingresosOperacionesBean.setNumeroCheque(request.getParameter("numeroChequeSBCAplic"));

		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setUsuario(request.getParameter("numeroUsuarios"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));

		ingresosOperacionesBean.setInstrumento(request.getParameter("numeroCuentaSBC"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("numeroChequeSBCAplic"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaDepVent);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descAplicaChequeSBC);
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.aplicaChequeSBC(ingresosOperacionesBean, listaDenominaciones);

		return mensaje;
	}
	/**
	 * Método para realizar el Prepago de Crédito
	 * @param request
	 * @param TipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean prepagoCredito(HttpServletRequest request, int TipoTransaccion) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		// PREPAGOCREPRO

		// CAJASMOVS
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoPagarPre"));
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaIDPre"));
		ingresosOperacionesBean.setInstrumento(request.getParameter("cuentaIDPre"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("creditoIDPre"));

		ingresosOperacionesBean.setCicloGrupo(request.getParameter("cicloIDPre"));//nuevo
		ingresosOperacionesBean.setGrupoID(request.getParameter("grupoIDPre")); //nuevo

		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
		// abono a la cta.
		ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaIDPre"));
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDPre"));
		ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPrepagoCredito);
		ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovAbonoCuenta);
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaDepVent);
		ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);
		ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
		ingresosOperacionesBean.setTipoPrepago(request.getParameter("tipoPrepago"));

		if (TipoTransaccion == Enum_Tra_Ventanilla.prepagoCreditoGrupal) { // Prepago de Credito Grupal
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaPrepagCredGrupal);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descPrepagCredGrupal);

		}

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.prepagoCreditoEfectivo(ingresosOperacionesBean, listaDenominaciones, TipoTransaccion);

		return mensaje;
	}
	/**
	 * Método para realizar el Proceso de Pago de Servicio
	 * @param request
	 * @param TipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean pagoServicios(HttpServletRequest request, int TipoTransaccion) {
		MensajeTransaccionBean mensaje = null;

		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		ingresosOperacionesBean.setCatalogoServID(request.getParameter("catalogoServID"));
		ingresosOperacionesBean.setSucursal(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));

		ingresosOperacionesBean.setReferenciaPago(request.getParameter("referenciaPagoServicio"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("segundaRefeServicio"));

		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setMonto(request.getParameter("montoPagoServicio"));
		ingresosOperacionesBean.setIVAMonto(request.getParameter("IvaServicio"));
		ingresosOperacionesBean.setComision(request.getParameter("montoComision"));
		ingresosOperacionesBean.setiVAComision(request.getParameter("ivaComision"));
		ingresosOperacionesBean.setTotalPagar(request.getParameter("totalPagar"));

		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDCobroServ"));
		ingresosOperacionesBean.setProspectoID(request.getParameter("prospectoIDServicio"));
		ingresosOperacionesBean.setCreditoID(request.getParameter("creditoIDServicio"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setInstrumento(request.getParameter("catalogoServID"));

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));

		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.conContaPagoServ);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descPagServ);
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.pagoServicios(ingresosOperacionesBean, listaDenominaciones);

		return mensaje;
	}
	/**
	 * Método para realizar el proceso de Recuperación de la Cartera Castigada
	 * @param request
	 * @param TipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean recuperaCarteraCastigada(HttpServletRequest request, int TipoTransaccion) {
		MensajeTransaccionBean mensaje = null;

		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		ingresosOperacionesBean.setSucursal(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal")); // CAJASMOVS DENOMINACIONMOVS
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja")); //CAJASMOVS DENOMINACIONMOVS
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP")); // CAJASMOVS DENOMINACIONMOVS
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCartVencida")); // CAJASMOVS DENOMINACIONMOVS
		ingresosOperacionesBean.setInstrumento(request.getParameter("creditoVencido")); // CAJASMOVS DENOMINACIONMOVS
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("clienteIDVencido"));// CAJASMOVS DENOMINACIONMOVS
		ingresosOperacionesBean.setCreditoID(request.getParameter("creditoVencido"));

		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setMonto(request.getParameter("montoRecuperar"));
		ingresosOperacionesBean.setIVAMonto(request.getParameter("IvaServicio"));
		ingresosOperacionesBean.setTotalPagar(request.getParameter("montoRecuperar"));

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal")); //CAJASMOVS
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt")); //CAJASMOVS	
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDVencido")); // obteniendo clienteID de 

		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaRecCarteraCas);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descRecCarteraCast);
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.recuperaCarteraCastigada(ingresosOperacionesBean, listaDenominaciones);

		return mensaje;
	}
	/**
	 * Pago Servifun
	 * @param request
	 * @param TipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean pagoSERVIFUN(HttpServletRequest request, int TipoTransaccion) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		ingresosOperacionesBean.setServiFunFolioID(request.getParameter("serviFunFolioID"));
		ingresosOperacionesBean.setServiFunEntregadoID(request.getParameter("folioentregadoID"));
		ingresosOperacionesBean.setTipoIdentifiCliente(request.getParameter("tipoIdentificacion"));
		ingresosOperacionesBean.setFolioIdentifiCliente(request.getParameter("folioIdentificacion"));
		ingresosOperacionesBean.setNombreCliente(request.getParameter("nombreRecibeBeneficio"));

		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setInstrumento(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("serviFunFolioID"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoEntregarServifun").trim().replaceAll(",", ""));

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteServifunID"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		// 	Se agrega una descripcion del tipo de Operacion que se realizo 
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaPagoServifun);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPagoSERVIFUN);

		//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
		verificaFormaPago(ingresosOperacionesBean, request);

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.pagoSERVIFUN(ingresosOperacionesBean, listaDenominaciones);
		return mensaje;

	}
	/**
	 * Método para el Proceso de Pago de Apoyo Escolar de la Ventanilla
	 * @param request
	 * @param TipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean pagoApoyoEscolar(HttpServletRequest request, int TipoTransaccion) {
		MensajeTransaccionBean mensaje = null;

		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		ingresosOperacionesBean.setApoyoEscSolID(request.getParameter("apoyoEscSolID"));

		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setInstrumento(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("apoyoEscSolID"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("monto"));

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));

		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setNombreCliente(request.getParameter("recibeApoyoEscolar"));
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDApoyoEsc"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		// Se agrega una descripcion del tipo de Operacion que se realizo 
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaApoyoEscolar);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descApoyoEscolar);
		//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
		verificaFormaPago(ingresosOperacionesBean, request);

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.pagoApoyoEscolar(ingresosOperacionesBean, listaDenominaciones);
		return mensaje;

	}
	/**
	 * Método para realizar la operación de Ajuste de Sobrante
	 * @param request
	 * @param TipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean ajusteSobrante(HttpServletRequest request, int TipoTransaccion) {
		MensajeTransaccionBean mensaje = null;

		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setUsuarioAut(request.getParameter("claveUsuarioAut"));
		ingresosOperacionesBean.setContraseniaAut(request.getParameter("contraseniaAut"));

		ingresosOperacionesBean.setInstrumento(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoSobrante"));

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));

		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaAjusteSob);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descAjusteSobrante);
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
		ingresosOperacionesBean.setUsuarioLogueado(request.getParameter("usuarioLogueado"));

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.ajusteSobrantePro(ingresosOperacionesBean, listaDenominaciones);
		return mensaje;

	}
	/**
	 * Método para realizar el ajuste de Faltante de la Caja
	 * @param request
	 * @param TipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean ajusteFaltante(HttpServletRequest request, int TipoTransaccion) {
		MensajeTransaccionBean mensaje = null;

		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setUsuarioAut(request.getParameter("claveUsuarioAut"));
		ingresosOperacionesBean.setContraseniaAut(request.getParameter("contraseniaAut"));

		ingresosOperacionesBean.setInstrumento(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoFaltante"));

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));

		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaAjusteFalt);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descAjusteFaltante);
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
		ingresosOperacionesBean.setUsuarioLogueado(request.getParameter("usuarioLogueado"));

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.ajusteFaltantePro(ingresosOperacionesBean, listaDenominaciones);
		return mensaje;

	}
	/**
	 * Método para realizar el proceso de Cobro de Anualidad de Tarjeta
	 * @param request
	 * @param TipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean cobroAnualidadTarjeta(HttpServletRequest request, int TipoTransaccion) {
		MensajeTransaccionBean mensaje = null;

		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		ingresosOperacionesBean.setTarjetaDebID(request.getParameter("tarjetaDebID"));

		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
		ingresosOperacionesBean.setNumCuentaTar(request.getParameter("numCtaTarjetaDeb"));

		ingresosOperacionesBean.setInstrumento(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("tarjetaDebID"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("totalComisionTD"));
		ingresosOperacionesBean.setMonto(request.getParameter("montoComisionTarjeta"));
		ingresosOperacionesBean.setIVAMonto(request.getParameter("ivaComisionTarjeta"));

		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDTarjeta"));
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaPagTarDebAnual);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descPagoTarDebAnual);
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
		ingresosOperacionesBean.setFechSistema(request.getParameter("fechSistema"));

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.cobroAnualTarjeta(ingresosOperacionesBean, listaDenominaciones);
		return mensaje;

	}
	/**
	 * Método para realizar el pago de la cancelación del Socio en la Ventanilla
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean pagoCancelacionSocio(HttpServletRequest request) {
		ReversasOperBean reversasOperBean = new ReversasOperBean();
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setCliCancelaEntregaID(request.getParameter("cliCancelaEntregaID"));
		ingresosOperacionesBean.setClienteCancelaID(request.getParameter("clienteCancelaIDPCC"));
		ingresosOperacionesBean.setNombreBeneficiario(request.getParameter("nombreBeneficiario"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("totalRecibir").replace(",", ""));
		ingresosOperacionesBean.setMonedaID(request.getParameter("numeroMonedaBasePCC"));

		ingresosOperacionesBean.setNombreRecibePago(request.getParameter("nombreRecibePago"));

		ingresosOperacionesBean.setReferenciaMov(request.getParameter("clienteIDPCC"));
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);

		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setMontoEnFirme(request.getParameter("totalRecibir").replace(",", ""));

		ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
		ingresosOperacionesBean.setInstrumento(request.getParameter("clienteIDPCC"));

		ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);

		ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
		ingresosOperacionesBean.setCargos(Constantes.STRING_CERO);
		ingresosOperacionesBean.setAbonos(request.getParameter("totalRecibir"));
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setUsuarioAut(request.getParameter("numeroUsuarios"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
		verificaFormaPago(ingresosOperacionesBean, request);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPagoCancelSocio);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.conContaPagoCancSocio);
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.pagoCancelacionSocio(ingresosOperacionesBean, listaDenominaciones);
		return mensaje;
	}
	/**
	 * Anticipos o Gastos Salida y Entrada
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean anticiposGastosdevoluciones(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		ingresosOperacionesBean.setEsDepODev(request.getParameter("naturaleza"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		if (ingresosOperacionesBean.getEsDepODev().equalsIgnoreCase(IngresosOperacionesBean.SalidaEfectivo)) {
			ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
			ingresosOperacionesBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
			ingresosOperacionesBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
			ingresosOperacionesBean.setMonto(request.getParameter("montoGastoAnt"));
			ingresosOperacionesBean.setFormaPago(request.getParameter("formaPagoOpera"));
			ingresosOperacionesBean.setTipoOperacion(request.getParameter("tipoAntGastoID"));
			ingresosOperacionesBean.setEmpleadoID(request.getParameter("empleadoID"));
			ingresosOperacionesBean.setMonedaID(request.getParameter("numeroMonedaBasePCC"));
			ingresosOperacionesBean.setInstrumento(request.getParameter("instrumento"));
			ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
			ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.conceptoConAnticipos);

			//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
			verificaFormaPago(ingresosOperacionesBean, request);
			if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase("E")) {
				ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descGastosComp);
			} else {
				ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descGastosCompCheq);
			}

			ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
			ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
			mensaje = ingresosOperacionesDAO.anticiposGastos(ingresosOperacionesBean, listaDenominaciones);

		} else {
			ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
			ingresosOperacionesBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
			ingresosOperacionesBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
			ingresosOperacionesBean.setMonto(request.getParameter("montoGastoDev"));
			ingresosOperacionesBean.setFormaPago(request.getParameter("formaPagoOpera"));
			ingresosOperacionesBean.setTipoOperacion(request.getParameter("tipoDevAntGastoID"));
			ingresosOperacionesBean.setEmpleadoID(request.getParameter("empleadoIDDev"));
			ingresosOperacionesBean.setMonedaID(request.getParameter("numeroMonedaBasePCC"));
			ingresosOperacionesBean.setInstrumento(request.getParameter("instrumento"));
			ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
			ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descGastosCompEnt);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.conceptoConAnticipos);

			ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
			ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
			mensaje = ingresosOperacionesDAO.anticiposGastosDev(ingresosOperacionesBean, listaDenominaciones);

		}
		return mensaje;

	}/* fin pagoCancelacionSocio **  */
	/**
	 * Método para pagar los Haberes de Socios/Clientes ex-menores
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean haberesExMenor(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		String Retiro = "R";
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
		ingresosOperacionesBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
		ingresosOperacionesBean.setMonto(request.getParameter("totalHaberes"));
		ingresosOperacionesBean.setFormaPago(request.getParameter("formaPagoOpera"));
		ingresosOperacionesBean.setTipoOperacion(Retiro);
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDMenor"));
		ingresosOperacionesBean.setFolioIdentifiCliente(request.getParameter("descIdentiMenor"));
		ingresosOperacionesBean.setTipoIdentifiCliente(request.getParameter("identiMenor"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("numeroMonedaBasePCC"));
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.conContaPagoCancSocio);
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
		verificaFormaPago(ingresosOperacionesBean, request);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descPagoHaberesMenor);

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.haberesExMenor(ingresosOperacionesBean, listaDenominaciones);
		return mensaje;

	}
	/**
	 * Pago de Arrendamiento
	 * @param request
	 * @return
	 */
	public MensajeTransaccionBean pagoArrendamientoEfectivo(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		ArrendamientosBean arrendamientosBean = new ArrendamientosBean();

		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		arrendamientosBean.setArrendaID(request.getParameter("arrendamientoID"));
		arrendamientosBean.setMonedaID(request.getParameter("monedaArrendamientoID"));
		arrendamientosBean.setMontoPagarArrendamiento(request.getParameter("montoPagarArrendamiento"));

		ingresosOperacionesBean.setClienteID(request.getParameter("clienteArrendamientoID"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);

		ingresosOperacionesBean.setCantidadMov(request.getParameter("montoPagarArrendamiento"));
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.depPagoArrendamiento);
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("arrendamientoID"));
		ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovAbonoCuenta);
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaArrendamientoID"));

		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaDepVent);
		ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);

		ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setInstrumento(request.getParameter("arrendamientoID"));

		ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
		ingresosOperacionesBean.setCargos(request.getParameter("montoPagarArrendamiento"));
		ingresosOperacionesBean.setAbonos(Constantes.STRING_CERO);

		ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
		ingresosOperacionesBean.setEmpleadoID(Integer.toString(parametrosAuditoriaBean.getUsuario()));

		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.pagoArrendamientoEfectivo(ingresosOperacionesBean, arrendamientosBean, listaDenominaciones);

		return mensaje;
	}/* FIN Pago de Arrendamiento **  */
	
	public MensajeTransaccionBean pagoServiciosLinea(HttpServletRequest request, int TipoTransaccion) {
		loggerVent.info("Iniciando proceso de pago de Servicios en Linea");
		MensajeTransaccionBean mensaje = null;
		String strFechaHoraActual = null;
		String formaPagoCargoCta = "C";
		Calendar calendar = Calendar.getInstance();

		
		Date fechaHoraActual = parametrosSesionBean.getFechaSucursal(); //Fecha de Session por compatibilidad con CAJASMOVS en OPERAVENTANILLACOMERREP
		Calendar cFechaHoraActual = Calendar.getInstance();
		cFechaHoraActual.setTime(fechaHoraActual);
		cFechaHoraActual.set(Calendar.HOUR_OF_DAY, calendar.get(Calendar.HOUR_OF_DAY));
		cFechaHoraActual.set(Calendar.MINUTE, calendar.get(Calendar.MINUTE));
		cFechaHoraActual.set(Calendar.SECOND, calendar.get(Calendar.SECOND));
		SimpleDateFormat formato = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		try {
			strFechaHoraActual = formato.format(cFechaHoraActual.getTime());
		}
		catch(Exception e) {
			strFechaHoraActual = Constantes.FECHA_VACIA;
		}
		
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));

		ingresosOperacionesBean.setProductoID(request.getParameter("productoID"));
		ingresosOperacionesBean.setServicioIDPSL(request.getParameter("servicioIDPSL"));
		ingresosOperacionesBean.setClasificacionServPSL(request.getParameter("clasificacionServPSL"));
		ingresosOperacionesBean.setTipoUsuario(request.getParameter("tipoUsuario"));
		ingresosOperacionesBean.setNumeroTarjetaPSL(request.getParameter("numeroTarjetaPSL"));
		ingresosOperacionesBean.setClienteIDPSL(request.getParameter("clienteIDPSL"));
		ingresosOperacionesBean.setCuentaAhorroPSL(request.getParameter("cuentaAhorroPSL"));
		ingresosOperacionesBean.setNombreProductoPSL(request.getParameter("nombreProductoPSL"));
		ingresosOperacionesBean.setFormaPagoPSL(request.getParameter("formaPagoPSL"));
		ingresosOperacionesBean.setPrecio(request.getParameter("precio"));
		ingresosOperacionesBean.setTelefonoPSL(request.getParameter("telefonoPSL"));
		ingresosOperacionesBean.setReferenciaPSL(request.getParameter("referenciaPSL"));
		ingresosOperacionesBean.setComisiProveedor(request.getParameter("comisiProveedor"));
		ingresosOperacionesBean.setComisiInstitucion(request.getParameter("comisiInstitucion"));
		ingresosOperacionesBean.setIvaComisiInstitucion(request.getParameter("ivaComisiInstitucion"));
		ingresosOperacionesBean.setTotalComisiones(request.getParameter("totalComisiones"));
		ingresosOperacionesBean.setTotalPagarPSL(request.getParameter("totalPagarPSL"));
		ingresosOperacionesBean.setFechaHoraPSL(strFechaHoraActual);
		ingresosOperacionesBean.setCanalPSL(request.getParameter("canalPSL"));
		ingresosOperacionesBean.setTipoReferencia(request.getParameter("tipoReferencia"));
		ingresosOperacionesBean.setTipoFront(request.getParameter("tipoFront"));
		ingresosOperacionesBean.setTotalEntradaPSL(request.getParameter("totalEntradaPSL"));
		
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		
		ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.conceptoContaPagoServLinea);
		ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descPagoServicioLinea);
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));		
		
		if("RE".equals(ingresosOperacionesBean.getClasificacionServPSL())) {
			if("a".equals(ingresosOperacionesBean.getTipoReferencia()) || "".equals(ingresosOperacionesBean.getTipoReferencia())) {
				ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getTelefonoPSL());
			}
			else {
				ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getReferenciaPSL());
			}
		}
		else {
			ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getReferenciaPSL());
		}
		
		if("E".equals(ingresosOperacionesBean.getFormaPagoPSL())) {
			ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getProductoID());
		}
		else {
			ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCuentaAhorroPSL());
		}
		
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		mensaje = ingresosOperacionesDAO.pagoServiciosLinea(ingresosOperacionesBean, listaDenominaciones);
		if (mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR && ingresosOperacionesBean.getFormaPagoPSL().equals(formaPagoCargoCta)) {
			CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
			cuentasAhoBean.setCuentaAhoID(request.getParameter("cuentaAhorroPSL"));
//			envioSMSCuentaAho(cuentasAhoBean, ingresosOperacionesBean.getCantidadMov(),mensaje.getConsecutivoString());
			envioSMSOperacion(Enum_Tipo_Alerta_Sms.pagoServicioLinea, 
					ingresosOperacionesBean.getClienteID(), 
					cuentasAhoBean.getCuentaAhoID(), 
					null, //cuentaDestino, 
					ingresosOperacionesBean.getMontoEnFirme(), 
					null, // comision
					null, // iva
					ingresosOperacionesBean.getMontoEnFirme(), 
					null,		//claveRastreo, 
					ingresosOperacionesBean.getNombreProductoPSL(),		//descServicio, 
					mensaje.getConsecutivoString(), 
					parametrosSesionBean.getFechaAplicacion().toGMTString(),
					ingresosOperacionesBean.getSucursalID());
		}
		loggerVent.info("Finaliza proceso de pago de Servicios en Linea");
		return mensaje;
	}
	
	/**
	 * Método que genera los reportes/tickets de Ventanilla.
	 * @param tipoTransaccion : Numero de transaccion
	 * @param request : {@link HttpServletRequest} de pantalla
	 * @param nombreReporte : Nombre del reporte
	 * @return String
	 * @throws Exception
	 */
	public String reporteTicket(int tipoTransaccion,HttpServletRequest request, String nombreReporte) throws Exception{

		String htmlString ="";
		switch(tipoTransaccion){
		case Enum_Rep_Ventanilla.cargoCuenta:
			htmlString= reporteTicketCargoCuenta(request, nombreReporte);
			break;
		case Enum_Rep_Ventanilla.abonoCuenta:
			htmlString= reporteTicketAbonoCuenta(request, nombreReporte);
			break;
		case Enum_Rep_Ventanilla.pagoCredito:
			htmlString= reporteTicketPagoCredito(request, nombreReporte);
			break;
		case Enum_Rep_Ventanilla.garantiaLiquida:
			htmlString= reporteTicketGarantiaLiquida(request, nombreReporte);
			break;
		case Enum_Rep_Ventanilla.pagoCreditoGrupal:
			htmlString= reporteTicketPagoCreditoGrupal(request, nombreReporte);
			break;
		case Enum_Rep_Ventanilla.comisionApCredito:
			htmlString= reporteTicketComisionAperturaCred(request, nombreReporte);
			break;
		case Enum_Rep_Ventanilla.desembolsoCred:
			htmlString= reporteTicketDesembolsoCred(request, nombreReporte);
			break;
		case Enum_Rep_Ventanilla.pagoSeguroVida:
			htmlString= reporteTicketPagoSeguroVida(request,nombreReporte);
			break;
		case Enum_Rep_Ventanilla.seguroVidaFallecimiento: 
			htmlString= repSeguroVidaFallecimiento(request,nombreReporte);
			break;
		case Enum_Rep_Ventanilla.garantiaAdicional: 
			htmlString= reporteTicketGarantiaAdicional(request,nombreReporte);
			break;
		case Enum_Rep_Ventanilla.aportacionSocial: 
			htmlString= reporteTicketAportaSocial(request,nombreReporte);
			break;
		case Enum_Rep_Ventanilla.devAportacionSocial: 
			htmlString= reporteTicketDevAportaSocial(request,nombreReporte);
			break;
		case Enum_Rep_Ventanilla.cobroSegAyuda:  
			htmlString= reporteTicketCobroSeguroAyuda(request,nombreReporte);
			break;
		case Enum_Rep_Ventanilla.pagoSegAyuda: 
			htmlString= reporteTicketPagoSegroAyuda(request,nombreReporte);
			break;
			
		case Enum_Rep_Ventanilla.pagoRemesas: 
			htmlString= reportePagoRemesas(request,nombreReporte);
			break; 
		case Enum_Rep_Ventanilla.pagoOportunidades: 
			htmlString= reporteTicketPagoOportunidades(request,nombreReporte);
			break; 
		case Enum_Rep_Ventanilla.recepChequeSBC: 
			htmlString= reporteRecibeChequeSBC(request,nombreReporte);
			break; 				
		case Enum_Rep_Ventanilla.aplicaChequeSBC: 
			htmlString= reporteAplicaChequeSBC(request,nombreReporte);
			break; 				
		case Enum_Rep_Ventanilla.recupCartCastigada: 
			htmlString= reporteRecupCarteraCastigada(request,nombreReporte);
			break;
		case Enum_Rep_Ventanilla.pagoServifun: 
			htmlString= reportePagoServifun(request,nombreReporte);
			break; 	
		case Enum_Rep_Ventanilla.pagoApoyoEscolar: 
			htmlString= reportePagoApoyoEscolar(request,nombreReporte);
			break; 
		case Enum_Rep_Ventanilla.cobroAnualidadTD: 
			htmlString= reporteAnualidadTD(request,nombreReporte);
			break; 	
		case Enum_Rep_Ventanilla.pagoCancelacionSocio: 
			htmlString= reportePagoCancelacionSocio(request,nombreReporte);
			break; 	
		case Enum_Rep_Ventanilla.gastosAnticipos: 
			htmlString= reporteGastosAnticipos(request,nombreReporte);
			break; 		
		case Enum_Rep_Ventanilla.devolucionesGastAnt: 
			htmlString= reporteDevGastosAnticipos(request,nombreReporte);
			break; 
		case Enum_Rep_Ventanilla.haberesExmenor: 
			htmlString= reporteEntregaHaberesExMenor(request,nombreReporte);
			break; 
		case Enum_Rep_Ventanilla.pagoArrendamiento: 
			htmlString= reporteTicketPagoArrendamiento(request, nombreReporte);
			break; 			
			//LORE
		case Enum_Rep_Ventanilla.pagoServiciosLinea: 
			htmlString= reporteTicketPagoServiciosLinea(request, nombreReporte);
			break;
		}
		return htmlString;
	}

	/**
	 * Reporte de pago de arrendamiento si modifican el tamaño carta no olvidar modificar el formato ticket
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reporteTicketPagoArrendamiento(HttpServletRequest request, String nombreReporte) throws Exception{
		SucursalesBean sucursalBean = new SucursalesBean();
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaPago", request.getParameter("fechaSistemaP"));
		parametrosReporte.agregaParametro("Par_MontoPago",  "$"+request.getParameter("montoPagarArrendamiento"));
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumSucursal", Utileria.completaCerosIzquierda(request.getParameter("numeroSucursal"),4));
		parametrosReporte.agregaParametro("Par_NomSucursal", request.getParameter("nombreSucursal"));
		
		sucursalBean.setSucursalID(request.getParameter("numeroSucursal"));
		sucursalBean = sucursalesDAO.consultaRepTicket(sucursalBean, SucursalesServicio.Enum_Con_Sucursal.repTicket);
		
		parametrosReporte.agregaParametro("Par_Plaza", sucursalBean.getNombreMunicipio());
		parametrosReporte.agregaParametro("Par_NomEstado", sucursalBean.getNombreEstado());
		parametrosReporte.agregaParametro("Par_Caja", Utileria.completaCerosIzquierda(request.getParameter("varCaja"),6));
		parametrosReporte.agregaParametro("Par_NomCajero", request.getParameter("nomCajero"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_ArrendaID", request.getParameter("varArrendamientoID"));
		parametrosReporte.agregaParametro("Par_MontoRecibo", "$"+request.getParameter("sumTotalEnt"));
		parametrosReporte.agregaParametro("Par_Cambio", "$"+request.getParameter("diferencia"));
		parametrosReporte.agregaParametro("Par_FormaPago", request.getParameter("varFormaPago"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("moneda"));		
		parametrosReporte.agregaParametro("Par_ProductoArrendaID", request.getParameter("productoArrendamiento"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/**
	 * Reporte de pago de servicios en linea si modifican el tamaño carta no olvidar modificar el formato ticket
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reporteTicketPagoServiciosLinea(HttpServletRequest request, String nombreReporte) throws Exception{
		SucursalesBean sucursalBean = new SucursalesBean();
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Fecha", request.getParameter("fechaSistemaP"));
		parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));
		parametrosReporte.agregaParametro("Par_RFC", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_Telefono", request.getParameter("telefonoLocal"));
		parametrosReporte.agregaParametro("Par_NoSucursal", Utileria.completaCerosIzquierda(request.getParameter("numeroSucursal"),4));
		parametrosReporte.agregaParametro("Par_NombreSucursal", request.getParameter("nombreSucursal"));
		
		sucursalBean.setSucursalID(request.getParameter("numeroSucursal"));
		sucursalBean = sucursalesDAO.consultaRepTicket(sucursalBean, SucursalesServicio.Enum_Con_Sucursal.repTicket);
		
		parametrosReporte.agregaParametro("Par_Producto", request.getParameter("producto"));
		parametrosReporte.agregaParametro("Par_FormaPago", request.getParameter("formaPago"));
		parametrosReporte.agregaParametro("Par_MontoServicio", "$"+request.getParameter("precio"));
		parametrosReporte.agregaParametro("Par_ComisionProveedor", "$"+request.getParameter("comisiProveedor"));
		parametrosReporte.agregaParametro("Par_ComisionInstitucion", "$"+request.getParameter("comisiInstitucion"));
		parametrosReporte.agregaParametro("Par_IVAComision", "$"+request.getParameter("ivaComisiInstitucion"));
		parametrosReporte.agregaParametro("Par_TotalPago", "$"+request.getParameter("totalPagarPSL"));
		parametrosReporte.agregaParametro("Par_ReferenciaPSL", request.getParameter("referenciaPSL"));
		parametrosReporte.agregaParametro("Par_TelefonoPSL", request.getParameter("telefonoPSL"));
		
		parametrosReporte.agregaParametro("Par_MontoRecibido", "$"+request.getParameter("sumTotalEnt"));
		parametrosReporte.agregaParametro("Par_Cambio", "$"+request.getParameter("diferencia"));
		parametrosReporte.agregaParametro("Par_ClienteID", request.getParameter("clienteIDPSL"));
		parametrosReporte.agregaParametro("Par_NombreCliente", request.getParameter("nombreClientePSL"));
		parametrosReporte.agregaParametro("Par_Caja", Utileria.completaCerosIzquierda(request.getParameter("varCaja"),6));
		parametrosReporte.agregaParametro("Par_NombreCajero", request.getParameter("nomCajero"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("moneda"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/**
	 * Reporte de pago de crédito si modifican el tamaño carta no olvidar modificar el formato ticket
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reporteTicketPagoCredito(HttpServletRequest request, String nombreReporte) throws Exception{
		SucursalesBean sucursalBean = new SucursalesBean();
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaPago", request.getParameter("fechaSistemaP"));
		parametrosReporte.agregaParametro("Par_MontoPago",  "$"+request.getParameter("monto"));
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumSucursal", Utileria.completaCerosIzquierda(request.getParameter("numeroSucursal"),4));
		parametrosReporte.agregaParametro("Par_NomSucursal", request.getParameter("nombreSucursal"));
		
		sucursalBean.setSucursalID(request.getParameter("numeroSucursal"));
		sucursalBean = sucursalesDAO.consultaRepTicket(sucursalBean, SucursalesServicio.Enum_Con_Sucursal.repTicket);
		
		parametrosReporte.agregaParametro("Par_Plaza", sucursalBean.getNombreMunicipio());
		parametrosReporte.agregaParametro("Par_NomEstado", sucursalBean.getNombreEstado());
		parametrosReporte.agregaParametro("Par_Caja", Utileria.completaCerosIzquierda(request.getParameter("varCaja"),6));
		parametrosReporte.agregaParametro("Par_NomCajero", request.getParameter("nomCajero"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_CreditoID", request.getParameter("varCreditoID"));
		parametrosReporte.agregaParametro("Par_MontoRecibo", "$"+request.getParameter("sumTotalEnt"));
		parametrosReporte.agregaParametro("Par_Cambio", "$"+request.getParameter("diferencia"));
		parametrosReporte.agregaParametro("Par_FormaPago", request.getParameter("varFormaPago"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("moneda"));		
		parametrosReporte.agregaParametro("Par_ProductoCred", request.getParameter("productoCred"));

		parametrosReporte.agregaParametro("Par_Grupo", request.getParameter("grupo"));
		parametrosReporte.agregaParametro("Par_Ciclo", request.getParameter("ciclo"));
		parametrosReporte.agregaParametro("Par_CobraSeguroCuota", request.getParameter("cobraSeguroCuota"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	//Reporte Ticket Pago de Credito
	public String reporteTicketPagoCreditoGrupal(HttpServletRequest request, String nombreReporte) throws Exception{
		SucursalesBean sucursalBean = new SucursalesBean();
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaPago", request.getParameter("fechaSistemaP"));
		parametrosReporte.agregaParametro("Par_MontoPago",  "$"+request.getParameter("monto"));
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumSucursal", Utileria.completaCerosIzquierda(request.getParameter("numeroSucursal"),4));
		parametrosReporte.agregaParametro("Par_NomSucursal", request.getParameter("nombreSucursal"));
		
		sucursalBean.setSucursalID(request.getParameter("numeroSucursal"));
		sucursalBean = sucursalesDAO.consultaRepTicket(sucursalBean, SucursalesServicio.Enum_Con_Sucursal.repTicket);
		
		parametrosReporte.agregaParametro("Par_Plaza", sucursalBean.getNombreMunicipio());
		parametrosReporte.agregaParametro("Par_NomEstado", sucursalBean.getNombreEstado());
		parametrosReporte.agregaParametro("Par_Caja", Utileria.completaCerosIzquierda(request.getParameter("varCaja"),6));
		parametrosReporte.agregaParametro("Par_NomCajero", request.getParameter("nomCajero"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_CreditoID", request.getParameter("varCreditoID"));
		parametrosReporte.agregaParametro("Par_MontoRecibo", "$"+request.getParameter("sumTotalEnt"));
		parametrosReporte.agregaParametro("Par_Cambio", "$"+request.getParameter("diferencia"));
		parametrosReporte.agregaParametro("Par_FormaPago", request.getParameter("varFormaPago"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Numero", request.getParameter("numero"));
		parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("moneda"));
		parametrosReporte.agregaParametro("Par_ProductoCred", request.getParameter("productoCred"));
		parametrosReporte.agregaParametro("Par_Grupo", request.getParameter("grupo"));
		parametrosReporte.agregaParametro("Par_Ciclo", request.getParameter("ciclo"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	/**
	 * Deposito de Garantia liquida
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reporteTicketGarantiaLiquida(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_CreditoID", request.getParameter("varCreditoID"));
		parametrosReporte.agregaParametro("Par_NomCom", request.getParameter("nombreCli"));
		parametrosReporte.agregaParametro("Par_NumCta", request.getParameter("cuentaAho"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Grupo", request.getParameter("grupo"));
		parametrosReporte.agregaParametro("Par_Ciclo", request.getParameter("ciclo"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	/**
	 * Ticket para la operación de Retiro de Efectivo(cargo a Cuenta) en formato html.
	 * @param request : Petición HTTP.
	 * @param nombreReporte : ticketCargoCta.prpt
	 * @return String : Código HTML con la estructura del reporte de ticket.
	 * @throws Exception
	 * @author pmontero
	 */
	public String reporteTicketCargoCuenta(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	/**
	 * Ticket para la operación de Abono a Cuenta en formato html.
	 * @param request : Petición HTTP.
	 * @param nombreReporte : ticketAbonoCta.prpt
	 * @return String : Código HTML con la estructura del reporte de ticket.
	 * @throws Exception
	 * @author pmontero
	 */
	public String reporteTicketAbonoCuenta(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	/**
	 * Ticket para la reversa de Retiro de Efectivo.
	 * @param request : Petición HTTP.
	 * @param nombreReporte : reversaAbonoCta.prpt
	 * @return String : Código HTML con la estructura del reporte de ticket.
	 * @throws Exception
	 * @author avelasco
	 */
	public String reporteTicketReversaCargoCuenta(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	/**
	 * Ticket para la reversa de Abono de Efectivo.
	 * @param request : Petición HTTP.
	 * @param nombreReporte : reversaCargoCta.prpt
	 * @return String : Código HTML con la estructura del reporte de ticket.
	 * @throws Exception
	 * @author avelasco
	 */
	public String reporteTicketReversaAbonoCuenta(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	//Reporte Ticket Comision por Apertura de Credito
	public String reporteTicketComisionAperturaCred(HttpServletRequest request, String nombreReporte) throws Exception{
		SucursalesBean sucursalBean = new SucursalesBean(); 
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaPago", request.getParameter("fechaSistemaP"));
		parametrosReporte.agregaParametro("Par_MontoPago",  "$"+request.getParameter("monto"));
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumSucursal", Utileria.completaCerosIzquierda(request.getParameter("numeroSucursal"),4));
		parametrosReporte.agregaParametro("Par_NomSucursal", request.getParameter("nombreSucursal"));
		
		sucursalBean.setSucursalID(request.getParameter("numeroSucursal"));
		sucursalBean = sucursalesDAO.consultaRepTicket(sucursalBean, SucursalesServicio.Enum_Con_Sucursal.repTicket);
		
		parametrosReporte.agregaParametro("Par_Plaza", sucursalBean.getNombreMunicipio());
		parametrosReporte.agregaParametro("Par_NomEstado", sucursalBean.getNombreEstado());
		parametrosReporte.agregaParametro("Par_Caja", Utileria.completaCerosIzquierda(request.getParameter("varCaja"),6));
		parametrosReporte.agregaParametro("Par_NomCajero", request.getParameter("nomCajero"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_CreditoID", request.getParameter("varCreditoID"));
		parametrosReporte.agregaParametro("Par_MontoRecibo", "$"+request.getParameter("sumTotalEnt"));
		parametrosReporte.agregaParametro("Par_Cambio", "$"+request.getParameter("diferencia"));
		parametrosReporte.agregaParametro("Par_FormaPago", request.getParameter("varFormaPago"));
		parametrosReporte.agregaParametro("Par_ClienteID", request.getParameter("numCli"));
		parametrosReporte.agregaParametro("Par_NomCom", request.getParameter("nombreCli"));
		parametrosReporte.agregaParametro("Par_NumCta", request.getParameter("cuentaAho"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("moneda"));
		
		parametrosReporte.agregaParametro("Par_TipoCuenta", request.getParameter("tipoCuen"));
		parametrosReporte.agregaParametro("Par_MontoComision",  "$"+request.getParameter("montoComision"));
		parametrosReporte.agregaParametro("Par_MontoIva", "$"+request.getParameter("montoIva"));
		parametrosReporte.agregaParametro("Par_ProductoCred", request.getParameter("productoCred"));
		parametrosReporte.agregaParametro("Par_Grupo",  request.getParameter("grupo"));
		parametrosReporte.agregaParametro("Par_Ciclo", request.getParameter("ciclo"));
		
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	//Reporte Ticket DESEMBOLSO DE CREDITO
	public String reporteTicketDesembolsoCred(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_MontoCargar",  "$"+request.getParameter("monto"));
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_MontoRecibo", "$"+request.getParameter("sumTotalEnt"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_CreditoID", request.getParameter("varCreditoID"));
		parametrosReporte.agregaParametro("Par_MontoCredito", "$"+request.getParameter("montoCred"));
		parametrosReporte.agregaParametro("Par_MontoPen", request.getParameter("monPorDes"));
		parametrosReporte.agregaParametro("Par_MontoDes", "$"+request.getParameter("montoDes"));
		parametrosReporte.agregaParametro("Par_MontoRecAnt", request.getParameter("montoResAnt"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	//---------------reporte  TICKET de Seguro de vida   pago por siniestro
	public String reporteSegVidaFallece(int tipoTransaccion,
			HttpServletRequest request, String nombreReporte) throws Exception{
		// TODO Auto-generated method stub
		String htmlString ="";
		htmlString= repSeguroVidaFallecimiento(request, nombreReporte);
		return htmlString;
	}
	private String repSeguroVidaFallecimiento(HttpServletRequest request,String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		SucursalesBean sucursalBean = new SucursalesBean(); 
		
		int monedaID= Integer.parseInt(request.getParameter("numMonedaBase"));
		String Simbolo=( request.getParameter("simbMonedaBase"));
		String descripcion=( request.getParameter("descripcionMoneda"));
		String montoPoliza=( request.getParameter("montoPoliza"));

				String montoLetra=Utileria.cantidadEnLetras(montoPoliza,monedaID,Simbolo,descripcion);						
				
				
				int numeroSucursal=Integer.parseInt(request.getParameter("numeroSucursal"));
				sucursalBean = sucursalesDAO.consultaPrincipal(numeroSucursal, SucursalesServicio.Enum_Con_Sucursal.principal);																
				
				parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
				parametrosReporte.agregaParametro("Par_PolizaID",request.getParameter("poliza"));
				parametrosReporte.agregaParametro("Par_ClienteID",request.getParameter("clienteIDSC"));
				parametrosReporte.agregaParametro("Par_NombreCliente",request.getParameter("nombreClienteSC"));
				parametrosReporte.agregaParametro("Par_CreditoID",request.getParameter("creditoIDS"));
				parametrosReporte.agregaParametro("Par_FechaInicio",request.getParameter("fechaInicioSeguro"));
				parametrosReporte.agregaParametro("Par_FechaVencimiento",request.getParameter("fechaVencimiento"));
				parametrosReporte.agregaParametro("Par_Beneficiario",request.getParameter("beneficiarioSeguro"));
				parametrosReporte.agregaParametro("Par_DirBeneficiario",request.getParameter("direccionBeneficiario"));
				parametrosReporte.agregaParametro("Par_Parentesco",request.getParameter("desRelacionBeneficiario"));
				parametrosReporte.agregaParametro("Par_MontoSeguro",Utileria.convierteFormatoMoneda(montoPoliza));
				parametrosReporte.agregaParametro("Par_DirSucursal",sucursalBean.getDirecCompleta().toUpperCase()); 
				parametrosReporte.agregaParametro("Par_Sucursal",request.getParameter("nombreSucursal"));
				parametrosReporte.agregaParametro("Par_NombreCajera",request.getParameter("nomCajero"));
				parametrosReporte.agregaParametro("Par_MontoEnLetras",montoLetra);		
				parametrosReporte.agregaParametro("Par_FechaSistema",request.getParameter("fechaSistema"));	
				//
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	/**
	 * 
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reporteTicketPagoSeguroVida(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucio", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));            
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("transaccion"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	//Reporte Ticket Garantia Liquida ADICIONAL
	public String reporteTicketGarantiaAdicional(HttpServletRequest request, String nombreReporte) throws Exception{
		SucursalesBean sucursalBean = new SucursalesBean();
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaPago", request.getParameter("fechaSistemaP"));
		parametrosReporte.agregaParametro("Par_MontoPago",  "$"+request.getParameter("monto"));
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumSucursal", Utileria.completaCerosIzquierda(request.getParameter("numeroSucursal"),4));
		parametrosReporte.agregaParametro("Par_NomSucursal", request.getParameter("nombreSucursal"));
		
		sucursalBean.setSucursalID(request.getParameter("numeroSucursal"));
		sucursalBean = sucursalesDAO.consultaRepTicket(sucursalBean, SucursalesServicio.Enum_Con_Sucursal.repTicket);
		
		parametrosReporte.agregaParametro("Par_Plaza", sucursalBean.getNombreMunicipio());
		parametrosReporte.agregaParametro("Par_NomEstado", sucursalBean.getNombreEstado());
		parametrosReporte.agregaParametro("Par_Caja", Utileria.completaCerosIzquierda(request.getParameter("varCaja"),6));
		parametrosReporte.agregaParametro("Par_NomCajero", request.getParameter("nomCajero"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_CreditoID", request.getParameter("varCreditoID"));
		parametrosReporte.agregaParametro("Par_MontoRecibo", "$"+request.getParameter("sumTotalEnt"));
		parametrosReporte.agregaParametro("Par_Cambio", "$"+request.getParameter("diferencia"));
		parametrosReporte.agregaParametro("Par_FormaPago", request.getParameter("varFormaPago"));
		parametrosReporte.agregaParametro("Par_ClienteID", request.getParameter("numCli"));
		parametrosReporte.agregaParametro("Par_NomCom", request.getParameter("nombreCli"));
		parametrosReporte.agregaParametro("Par_NumCta", request.getParameter("cuentaAho"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("moneda"));
		parametrosReporte.agregaParametro("Par_ProductoCred", request.getParameter("productoCred"));
		parametrosReporte.agregaParametro("Par_TipoCuenta", request.getParameter("tipoCuen"));
		parametrosReporte.agregaParametro("Par_Grupo", request.getParameter("grupo"));
		parametrosReporte.agregaParametro("Par_Ciclo", request.getParameter("ciclo"));

		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	// PAGO de aportacion social
	public String reporteTicketAportaSocial(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_MontoPendiente","$"+ request.getParameter("montoPendiente"));
		parametrosReporte.agregaParametro("Par_MontoPagado","$"+ request.getParameter("montoPagado"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	// DEVOLUCION de apoprtacion social
	public String reporteTicketDevAportaSocial(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("moneda"));

		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	// COBRO seguro de Ayuda
	public String reporteTicketCobroSeguroAyuda(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();		
		parametrosReporte.agregaParametro("Par_NombreInstitucio", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));            
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("transaccion"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public String reporteTicketPagoSegroAyuda(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucio", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));            
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("transaccion"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));
		parametrosReporte.agregaParametro("Par_FechaSistema", request.getParameter("fechaSistema"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	/**
	 * Método para imprimir el ticket de Pago de Remesas en formato html
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reportePagoRemesas(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucio", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));            
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("transaccion"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/**
	 * Método que regresa el reporte en formato htm para el ticket de Pago de Oportunidades
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reporteTicketPagoOportunidades(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucio", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));            
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("transaccion"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/**
	 * Método para regresar el reporte en formato html de la recepcion de Cheques SBC de Ventanilla-> Ingreso de Operaciones
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reporteRecibeChequeSBC(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucio", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));            
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("transaccion"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	/**
	 * Método para regresar el reporte en formato html de la Aplicacion de Cheques SBC de Ventanilla-> Ingreso de Operaciones
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reporteAplicaChequeSBC(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucio", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));            
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("transaccion"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/**
	 * Ticket para Recuperacion de Cartera Castigada
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reporteRecupCarteraCastigada(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias")); 
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_Numero", request.getParameter("numero"));
		parametrosReporte.agregaParametro("Par_CreditoID", request.getParameter("creditoID"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	/**
	 * PAGO SERVIFUN
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reportePagoServifun(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucio", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));            
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("transaccion"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	//-------- Pago cancelacion Socio 
	public String reportePagoCancelacionSocio(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucio", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));            
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("transaccion"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));
		parametrosReporte.agregaParametro("Par_NombreBeneficiario",request.getParameter("nombreBeneficiario"));
		parametrosReporte.agregaParametro("Par_NombreRecibePago", request.getParameter("nombreRecibePago"));
				
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	
	// -------- TICKET DE GASTOS/ANTICPOS POR COMPROBAR OK
	public String reporteGastosAnticipos(HttpServletRequest request, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// -------- TICKET DEVOLUCION DE GASTOS/ANTICPOS OK
	public String reporteDevGastosAnticipos(HttpServletRequest request, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// -------- TICKET ENTREGA HABERES EXMENOR OK
	public String reporteEntregaHaberesExMenor(HttpServletRequest request, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NomIn", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_NumCopias", request.getParameter("numCopias"));
		parametrosReporte.agregaParametro("Par_NumTrans", request.getParameter("numTrans"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	// TICKET PROFUN ###p
	public String reportePagoProfun(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		int monedaID= Integer.parseInt(request.getParameter("numMonedaBase"));
		String Simbolo=( request.getParameter("simbMonedaBase"));
		String descripcion=( request.getParameter("descripcionMoneda"));
		String montoPoliza=( request.getParameter("monto"));	
		
		String montoLetra=Utileria.cantidadEnLetras(montoPoliza,monedaID,Simbolo,descripcion);
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("RFCInstit"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));
		parametrosReporte.agregaParametro("Par_Sucursal", request.getParameter("nombreSucursal"));
		parametrosReporte.agregaParametro("Par_NombreCajero", request.getParameter("nomCajero"));
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("numTrans"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));
		parametrosReporte.agregaParametro("Par_FechaSistema", request.getParameter("fechaSistemaP"));
		
		parametrosReporte.agregaParametro("Par_SocioID", request.getParameter("clientePROFUN"));
		parametrosReporte.agregaParametro("Par_NombreSocio", request.getParameter("nombreClientePROFUN"));
		parametrosReporte.agregaParametro("Par_BeneficiarioID", request.getParameter("personaIDPROFUN"));
		parametrosReporte.agregaParametro("Par_NombreBeneficiario", request.getParameter("nombreBenePROFUN"));
		parametrosReporte.agregaParametro("Par_PersonaRecibe", request.getParameter("personaRetiraPROFUN"));
		parametrosReporte.agregaParametro("Par_Cuenta", request.getParameter("cuentaAhoIDPROFUN"));
		parametrosReporte.agregaParametro("Par_MontoTotalProfun","$"+request.getParameter("monto"));
		parametrosReporte.agregaParametro("Par_Numero", request.getParameter("numero"));
		parametrosReporte.agregaParametro("Par_Moneda", request.getParameter("moneda"));
		parametrosReporte.agregaParametro("Par_MontoEnLetra", montoLetra);
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	/**
	 * Reporte de apoyo escolar
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reportePagoApoyoEscolar(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("transaccion"));
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));
		parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));
		parametrosReporte.agregaParametro("Par_FechaSistema", request.getParameter("fechaSistema"));
		parametrosReporte.agregaParametro("Par_NombreRecibePago", request.getParameter("nombreRecibePago"));
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/**
	 * Cobro Anualidad Tarjeta de Debito
	 * @param request
	 * @param nombreReporte
	 * @return
	 * @throws Exception
	 */
	public String reporteAnualidadTD(HttpServletRequest request, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreInstitucion", request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_DireccionInstitucion", request.getParameter("direccionInstitucion"));          
		parametrosReporte.agregaParametro("Par_RFCInstitucion", request.getParameter("rfcInstitucion"));
		parametrosReporte.agregaParametro("Par_Folio", request.getParameter("transaccion"));
		parametrosReporte.agregaParametro("Par_TelefonoSucursal", request.getParameter("telefonosucursal"));
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	//////////////////////////////////////  INICIO WEB SERVICES PAGO DE SERVICIO /////////////////////////////////////////
	public MensajeTransaccionBean pagoServicioWS(IngresosOperacionesBean ingresosOperacionesBean){
		MensajeTransaccionBean mensaje= new MensajeTransaccionBean();
		mensaje=ingresosOperacionesDAO.pagoServiciosWS(ingresosOperacionesBean);
		return mensaje;
	}		
	////////////////////////////////////FIN WEB SERVICES PAGO DE SERVICIO /////////////////////////////////////////
	//:::::::::::::::::::::::::::::::::::::::::::::::REVERSAS :::::::::::::::::::::::::::::::::::::::::......
	public List lista(int tipoLista, IngresosOperacionesBean ingresosOperacionesBean){	
		List listaOperaciones = null;
		switch (tipoLista) {
		
			case Enum_Lis_Reversa.listaCajasMovs:	
				listaOperaciones = ingresosOperacionesDAO.listaCajasMovs(tipoLista,ingresosOperacionesBean);				
				break;				
		}		
		return listaOperaciones;
	}
	
	public IngresosOperacionesBean consulta(int tipoConsulta, IngresosOperacionesBean ingresosOperacionesBean){
		IngresosOperacionesBean ingresosOperaciones = null;
		switch (tipoConsulta) {
			case Enum_Con_ReversaCajaMosv.reversaCajaMovs:	
				ingresosOperaciones = ingresosOperacionesDAO.consultaTransaccionCajaMovs(ingresosOperacionesBean, tipoConsulta);				
				break;	
			case Enum_Con_ReversaCajaMosv.reversaPagoCredito:	
				ingresosOperaciones = ingresosOperacionesDAO.consultaTransaccionCajaMovs(ingresosOperacionesBean, tipoConsulta);				
				break;	
			case Enum_Con_ReversaCajaMosv.consultaGarantiaAdicional:	
				ingresosOperaciones = ingresosOperacionesDAO.consultaGarantiaAdicional(ingresosOperacionesBean, tipoConsulta);				
				break;	
		}
		return ingresosOperaciones;
	}
	
	public MensajeTransaccionBean grabaTransaccionReversa(int tipoTransaccion, HttpServletRequest request, ReversasOperBean bean){
		
		MensajeTransaccionBean mensaje = null;
		boolean reversa=true;
		CajasVentanillaBean cajasVentanillaBean = new CajasVentanillaBean();
		switch(tipoTransaccion){ 		
		case Enum_Tra_VentanillaReversa.cargoCuentaReversa:
			mensaje = cargoCuenta(request, reversa);			
			cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
			cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
			cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
			parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
			parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
			break;
		case Enum_Tra_VentanillaReversa.abonoCuentaReversa:			
			mensaje = abonoCuenta(request,reversa);
			cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
			cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
			cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
			parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
			parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
			break;	
			
		case Enum_Tra_VentanillaReversa.depGaranLiqReversa:
			mensaje = depositoGarantiaLiquida(request, reversa);			
			cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
			cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
			cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
			parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
			parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
			break;
		case Enum_Tra_VentanillaReversa.comisionAperturaReversa:
			mensaje = comisionAperturaCredito(request,reversa);
			cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
			cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
			cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
			parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
			parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
			break;
		case Enum_Tra_VentanillaReversa.desembolsoCreditoReversa:
			mensaje = desembolsoCredito(request, reversa);			
			cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
			cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
			cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
			parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
			parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
			break;
			
		case Enum_Tra_VentanillaReversa.cobroSeguroVidaReversa:
			mensaje = cobroSeguroVida(request,reversa );
			cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
			cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
			cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
			parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
			parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
			break;
		case Enum_Tra_Ventanilla.pagoSeguroVida:
			mensaje = pagoSeguroVida(request, reversa);
			cajasVentanillaBean.setCajaID(String.valueOf(parametrosSesionBean.getCajaID()));
			cajasVentanillaBean.setSucursalID(String.valueOf(parametrosSesionBean.getSucursal()));
			cajasVentanillaBean = cajasVentanillaServicio.consulta(CajasVentanillaServicio.Enum_Con_CajasVentanilla.saldos, cajasVentanillaBean);
			parametrosSesionBean.setLimiteEfectivoMN(cajasVentanillaBean.getLimiteEfectivoMN());
			parametrosSesionBean.setSaldoEfecMN(cajasVentanillaBean.getSaldoEfecMN());
			break;
		}

		return mensaje;
	}
		
	public String reporteTicketReversa(int tipoTransaccion,HttpServletRequest request, String nombreReporte) throws Exception{
		String htmlString ="";
		switch(tipoTransaccion){	
		
		case Enum_Rep_Ventanilla.cargoCuenta:
			htmlString= reporteTicketReversaCargoCuenta(request, nombreReporte);
			break;	
		case Enum_Rep_Ventanilla.abonoCuenta:
			htmlString= reporteTicketReversaAbonoCuenta(request, nombreReporte);
			break;		
		case Enum_Rep_Ventanilla.garantiaLiquida:
			htmlString= reporteTicketGarantiaLiquida(request, nombreReporte);
			break;	
			
		case Enum_Rep_Ventanilla.comisionApCredito:
			htmlString= reporteTicketComisionAperturaCred(request, nombreReporte);
			break;
			
		case Enum_Rep_Ventanilla.desembolsoCred:
			htmlString= reporteTicketDesembolsoCred(request, nombreReporte);
			break;
	
		case Enum_Rep_Ventanilla.seguroVidaFallecimiento: 
			htmlString= repSeguroVidaFallecimiento(request,nombreReporte);
			break;
		case Enum_Rep_Ventanilla.pagoSeguroVida:
			htmlString= reporteTicketPagoSeguroVida(request,nombreReporte);
			break;		
		}
		
		return htmlString;
	}
	
	//Metodo para Identificar y Completar el Bean, para aquellas Operaciones cuya Salida es Con Cheque
	private void verificaFormaPago(IngresosOperacionesBean ingresosOperacionesBean,  HttpServletRequest request) {
		
		ingresosOperacionesBean.setFormaPago(request.getParameter("formaPagoOpera"));

		//Identifica como se Entregaron los Recursos al Cliente, verifica si fue con Cheque
		if(ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)){
			ingresosOperacionesBean.setBancoEmisor(request.getParameter("institucionID"));
			ingresosOperacionesBean.setCuentaBancos(request.getParameter("numCtaInstit"));
			ingresosOperacionesBean.setNumeroCheque(request.getParameter("numeroCheque"));
			ingresosOperacionesBean.setNombreBeneficiario(request.getParameter("beneCheque"));
			ingresosOperacionesBean.setUsuario(request.getParameter("numeroUsuarios"));
			ingresosOperacionesBean.setTipoChequera(request.getParameter("tipoChequera"));
			loggerVent.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"IngresoOperacionesServicio. Forma Pago:" + ingresosOperacionesBean.getFormaPago() +
						    "institucionID:" + ingresosOperacionesBean.getBancoEmisor() +
						    "numCtaInstit:" + ingresosOperacionesBean.getCuentaBancos() +
						    "numeroCheque:" + ingresosOperacionesBean.getNumeroCheque() +
						    "beneCheque:" + ingresosOperacionesBean.getNombreBeneficiario()+
						    "tipoChequera:" + ingresosOperacionesBean.getTipoChequera());
		}
	}
	
	public String consultaProperties(){
		String properties   = PropiedadesSAFIBean.propiedadesSAFI.getProperty("MostrarBotones");
		properties += ","+PropiedadesSAFIBean.propiedadesSAFI.getProperty("TipoBusqueda");
		
		return properties;
	}
	
	/**
	 * Método para Validar la Transaccionalidad de las Operaciones en Ventanilla (Referencia Modulo PLD){@link OpeEscalamientoInternoDAO}
	 * @param tipoTransaccion : Numero de Operacion de la Ventanilla
	 * @param request : HttpServletRequest con la Informacion de Pantalla
	 * @param bean : IngresosOperacionesBean con la Informacion de la Operacion
	 * @param folioEscala : Numero de Folio de Escalamiento
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean validacionPLD(int tipoTransaccion, HttpServletRequest request, IngresosOperacionesBean bean, int folioEscala) {
		loggerVent.info("Proceso de Evaluación PLD: " + tipoTransaccion);
		MensajeTransaccionBean mensaje = null;
		try {

			PldEscalaVentBean pldEscalaVentBean = new PldEscalaVentBean();
			if (folioEscala != -1) {
				if (folioEscala == Constantes.ENTERO_CERO) {
					pldEscalaVentBean.setTipoResultEscID(Enum_EstatusPLD.SEGUIMIENTO);
					pldEscalaVentBean.setProceso(Enum_ProcesoPLD.SEGUIMIENTO + "");
				} else {
					pldEscalaVentBean.setFolioEscala(folioEscala + "");
					pldEscalaVentBean.setTipoResultEscID(Enum_EstatusPLD.FINALIZADA);
					pldEscalaVentBean.setProceso(Enum_ProcesoPLD.FINALIZADA + "");
				}
				switch (tipoTransaccion) {
					case Enum_Tra_Ventanilla.cargoCuenta:
						pldEscalaVentBean.setClienteID(request.getParameter("numClienteCa"));
						pldEscalaVentBean.setCuentaAhoID(request.getParameter("cuentaAhoIDCa"));
						pldEscalaVentBean.setFechaOperacion(request.getParameter("fechaSistemaP"));
						pldEscalaVentBean.setMonedaID(request.getParameter("monedaIDCa"));
						pldEscalaVentBean.setMonto(request.getParameter("montoCargar"));
						pldEscalaVentBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
						break;
					case Enum_Tra_Ventanilla.abonoCuenta:
						pldEscalaVentBean.setClienteID(request.getParameter("numClienteAb"));
						pldEscalaVentBean.setCuentaAhoID(request.getParameter("cuentaAhoIDAb"));
						pldEscalaVentBean.setFechaOperacion(request.getParameter("fechaSistemaP"));
						pldEscalaVentBean.setMonedaID(request.getParameter("monedaIDAb"));
						pldEscalaVentBean.setMonto(request.getParameter("montoAbonar"));
						pldEscalaVentBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
						break;
					case Enum_Tra_Ventanilla.pagoCredito:
						pldEscalaVentBean.setClienteID(request.getParameter("clienteID"));
						pldEscalaVentBean.setCuentaAhoID(request.getParameter("cuentaID"));
						pldEscalaVentBean.setFechaOperacion(request.getParameter("fechaSistemaP"));
						pldEscalaVentBean.setMonedaID(request.getParameter("monedaID"));
						pldEscalaVentBean.setMonto(request.getParameter("montoPagar"));
						pldEscalaVentBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
						break;

					case Enum_Tra_Ventanilla.depGaranLiq:
						pldEscalaVentBean.setClienteID(request.getParameter("numClienteGL"));
						pldEscalaVentBean.setCuentaAhoID(request.getParameter("cuentaAhoIDGL"));
						pldEscalaVentBean.setFechaOperacion(request.getParameter("fechaSistemaP"));
						pldEscalaVentBean.setMonedaID(request.getParameter("monedaIDGL"));
						pldEscalaVentBean.setMonto(request.getParameter("montoGarantiaLiq"));
						pldEscalaVentBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
						break;

					case Enum_Tra_Ventanilla.devolucionGL:
						pldEscalaVentBean.setClienteID(request.getParameter("numClienteDG"));
						pldEscalaVentBean.setCuentaAhoID(request.getParameter("cuentaAhoIDDG"));
						pldEscalaVentBean.setFechaOperacion(request.getParameter("fechaSistemaP"));
						pldEscalaVentBean.setMonedaID(request.getParameter("monedaIDDG"));
						pldEscalaVentBean.setMonto(request.getParameter("montoDevGL"));
						pldEscalaVentBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
						break;

					case Enum_Tra_Ventanilla.transferenciaCuenta:
						pldEscalaVentBean.setClienteID(request.getParameter("numClienteT"));
						pldEscalaVentBean.setCuentaAhoID(request.getParameter("cuentaAhoIDT"));
						pldEscalaVentBean.setFechaOperacion(request.getParameter("fechaSistemaP"));
						pldEscalaVentBean.setMonedaID(request.getParameter("monedaIDT"));
						pldEscalaVentBean.setMonto(request.getParameter("montoCargarT"));
						pldEscalaVentBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
						break;

					case Enum_Tra_Ventanilla.pagoRemesas:
					case Enum_Tra_Ventanilla.pagoOportunidades:
						pldEscalaVentBean.setClienteID(request.getParameter("clienteIDServicio"));
						pldEscalaVentBean.setUsuarioServicioID(request.getParameter("usuarioRem"));
						pldEscalaVentBean.setFechaOperacion(request.getParameter("fechaSistemaP"));
						pldEscalaVentBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
						pldEscalaVentBean.setMonto(request.getParameter("montoServicio"));
						pldEscalaVentBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
						break;
					case Enum_Tra_Ventanilla.recepChequeSBC:
						pldEscalaVentBean.setClienteID(request.getParameter("clienteIDSBC"));
						pldEscalaVentBean.setCuentaAhoID(request.getParameter("numeroCuentaRec"));
						pldEscalaVentBean.setFechaOperacion(request.getParameter("fechaSistemaP"));
						pldEscalaVentBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
						pldEscalaVentBean.setMonto(request.getParameter("montoSBC"));
						pldEscalaVentBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
						break;
					case Enum_Tra_Ventanilla.aplicaChequeSBC:
						pldEscalaVentBean.setClienteID(request.getParameter("clientechequeSBCAplic"));
						pldEscalaVentBean.setCuentaAhoID(request.getParameter("numeroCuentaSBC"));
						pldEscalaVentBean.setFechaOperacion(request.getParameter("fechaSistemaP"));
						pldEscalaVentBean.setMonedaID(request.getParameter("monedaCamEfectivoID"));
						pldEscalaVentBean.setMonto(request.getParameter("montoSBCAplic"));
						pldEscalaVentBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
						break;
				}// switch

				mensaje = OpeEscalamientoInternoDAO.validaOpEscalamientoIngreso(pldEscalaVentBean);
			} else {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(Constantes.ENTERO_CERO);
				mensaje.setDescripcion("No se requirio actualización del folio de escalamiento.");
			}
		} catch (Exception ex) {
			loggerVent.info("Error en Evaluación PLD:", ex);
			ex.printStackTrace();
		}
		return mensaje;
	}

	private void envioSMSCuentaAho(CuentasAhoBean cuentasAhoBean, String cantidadMov, String numeroTransaccion) {
		MensajeTransaccionBean mensajeTransaccionBean = null;
		SMSEnvioMensajeBean smsEnvioMensajeBean = new SMSEnvioMensajeBean();
		smsEnvioMensajeBean.setCuentaAhoID(cuentasAhoBean.getCuentaAhoID());
		smsEnvioMensajeBean.setCantidadMov(cantidadMov);
		smsEnvioMensajeBean.setNumTransaccion(numeroTransaccion);
		mensajeTransaccionBean = smsEnvioMensajeDAO.alertasRetirosSMSVentanilla(smsEnvioMensajeBean);
		loggerVent.info(mensajeTransaccionBean.getNumero() + " " + mensajeTransaccionBean.getDescripcion());
	}
	
	/**
	 * Método para el pago de Acceosorios de Crédito
	 * @param request
	 * @param reversa
	 * @return
	 */
	public MensajeTransaccionBean accesoriosCredito(HttpServletRequest request, boolean reversa) {
		ReversasOperBean reversasOperBean = new ReversasOperBean();
		MensajeTransaccionBean mensaje = null;
		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

		ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaAhoIDCAc"));
		ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDCA"));
		ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP")); 
		ingresosOperacionesBean.setCreditoID(request.getParameter("creditoIDCA"));
		ingresosOperacionesBean.setCantidadMov(request.getParameter("totalDepCA"));
		ingresosOperacionesBean.setReferenciaMov(request.getParameter("creditoIDCA"));
		ingresosOperacionesBean.setMonedaID(request.getParameter("monedaIDCAc"));
		ingresosOperacionesBean.setProductoCreditoID(request.getParameter("productoCreditoIDCA"));
		ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
		ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);
		ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
		ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
		ingresosOperacionesBean.setInstrumento(request.getParameter("cuentaAhoIDCAc"));
		ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);
		ingresosOperacionesBean.setCargos(request.getParameter("totalDepCA"));
		ingresosOperacionesBean.setAbonos(Constantes.STRING_CERO);
		ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
		ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
		ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));
		ingresosOperacionesBean.setAccesoriosID(request.getParameter("accesorioID"));
		if (reversa != true) {
			ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descAccesoriosCredito); 
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovAccesCredito);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.contaCobroAccesoriosCre);
			ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
			ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
			ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);

		} else {
			ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.cargoCta);
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.reversaAccesCredito);
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovsAccesCreRev);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.reversaContaCobroAccesCre);
			ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);
			ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo); 
			ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);

			ingresosOperacionesBean.setUsuarioLogueado(request.getParameter("claveUsuarioLog"));

			reversasOperBean.setTransaccionID(request.getParameter("numeroTransaccionAR"));
			reversasOperBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCobroAccesCre); 
			reversasOperBean.setReferencia(ingresosOperacionesBean.getReferenciaMov());
			reversasOperBean.setMonto(ingresosOperacionesBean.getCantidadMov());
			reversasOperBean.setCajaID(ingresosOperacionesBean.getCajaID());
			reversasOperBean.setSucursalID(ingresosOperacionesBean.getSucursalID());
			reversasOperBean.setFecha(ingresosOperacionesBean.getFecha());
			reversasOperBean.setMotivo(request.getParameter("motivo"));
			reversasOperBean.setDescripcionOper(request.getParameter("descripcionOper"));
			reversasOperBean.setClaveUsuarioAut(request.getParameter("claveUsuarioAut"));
			reversasOperBean.setContraseniaAut(request.getParameter("contraseniaAut"));
			reversasOperBean.setUsuarioAutID(request.getParameter("usuarioAutID"));
		}
		
		ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
		ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");
		
		if (reversa != true) {
			mensaje = ingresosOperacionesDAO.accesoriosCredito(ingresosOperacionesBean, listaDenominaciones);
		} else {
			mensaje = ingresosOperacionesDAO.reversaAccesoriosCredito(ingresosOperacionesBean, reversasOperBean, listaDenominaciones);
		}
		return mensaje;
	}

	// Se asigna el bean de Entrada para Transferencia entre cuentas
	public IngresosOperacionesBean asignacionTransferenciaCuenta(HttpServletRequest httpServletRequest){

		IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
		try {
			// cargo a cuenta
			ingresosOperacionesBean.setCuentaAhoID(httpServletRequest.getParameter("cuentaAhoIDT"));
			ingresosOperacionesBean.setClienteID(httpServletRequest.getParameter("numClienteT"));
			ingresosOperacionesBean.setFecha(httpServletRequest.getParameter("fechaSistemaP"));

			ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.cargoCta);
			ingresosOperacionesBean.setCantidadMov(httpServletRequest.getParameter("montoCargarT"));
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descargoCuentaTrans);
			if (httpServletRequest.getParameter("referenciaT").isEmpty()) {
				ingresosOperacionesBean.setReferenciaMov(httpServletRequest.getParameter("cuentaAhoIDT"));
				ingresosOperacionesBean.setReferenciaTicket(Constantes.STRING_VACIO);
			} else {
				ingresosOperacionesBean.setReferenciaMov(httpServletRequest.getParameter("referenciaT"));
				ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
			}
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovTraspasoCuenta);

			ingresosOperacionesBean.setMonedaID(httpServletRequest.getParameter("monedaIDT"));
			ingresosOperacionesBean.setSucursalID(httpServletRequest.getParameter("numeroSucursal"));
			ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepTransfeCuentas);

			ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
			ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);
			ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);

			// abono a cuenta
			ingresosOperacionesBean.setCuentaCargoAbono(httpServletRequest.getParameter("cuentaAhoIDTC"));
			ingresosOperacionesBean.setClienteCargoAbono(httpServletRequest.getParameter("numClienteTC"));
			ingresosOperacionesBean.setReferenciaCargoAbono(httpServletRequest.getParameter("referenciaT")); // Cambio variable por referenciaT valor anterior cuentaAhoIDTC
			ingresosOperacionesBean.setNumClienteTCta(httpServletRequest.getParameter("numClienteTCtaRecep"));//El número del cliente Receptor......Omar
			// para el alta en CAJASMOVS
			ingresosOperacionesBean.setCajaID(httpServletRequest.getParameter("numeroCaja"));
			ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
			ingresosOperacionesBean.setInstrumento(httpServletRequest.getParameter("cuentaAhoIDT"));
			ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
			ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);
			ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
			ingresosOperacionesBean.setOpcionCajaID(httpServletRequest.getParameter("tipoOperacion"));
			ingresosOperacionesBean.setDenominaciones("0");

		} catch (Exception exception) {
			ingresosOperacionesBean = null;
			loggerVent.error("Ha ocurrido un Error en la Asignación de parámetros ", exception);
			exception.printStackTrace();
		}

		return ingresosOperacionesBean;
		
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
		loggerVent.info(mensajeTransaccionBean.getNumero() + " " + mensajeTransaccionBean.getDescripcion());
	}

	/**
	 * Método para realizar la Operación de deposito para Activacion de Cuenta
	 * @param request : HttpServletRequest Objeto que trae la Información de Pantalla
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean depositoActivaCta(HttpServletRequest request) {
		MensajeTransaccionBean mensaje = null;
		try {
			IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();

			ingresosOperacionesBean.setCuentaAhoID(request.getParameter("cuentaAhoIDdepAct"));
			ingresosOperacionesBean.setClienteID(request.getParameter("clienteIDdepAct"));
			ingresosOperacionesBean.setFecha(request.getParameter("fechaSistemaP"));
			ingresosOperacionesBean.setCantidadMov(request.getParameter("montoDepositoActiva"));
			
			ingresosOperacionesBean.setReferenciaMov(request.getParameter("cuentaAhoIDdepAct"));
			ingresosOperacionesBean.setReferenciaTicket(request.getParameter("refCuentaTicketdepAct"));
			
			ingresosOperacionesBean.setMonedaID(request.getParameter("monedaIDdepAct"));
			ingresosOperacionesBean.setSucursalID(request.getParameter("numeroSucursal"));
			ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);

			ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
			ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.depositoActivaCta);

			ingresosOperacionesBean.setCajaID(request.getParameter("numeroCaja"));
			ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
			ingresosOperacionesBean.setInstrumento(request.getParameter("cuentaAhoIDdepAct"));

			ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
			ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);

			ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
			ingresosOperacionesBean.setCargos(Constantes.STRING_CERO);
			ingresosOperacionesBean.setAbonos(request.getParameter("montoDepositoActiva"));
			ingresosOperacionesBean.setTotalSalida(request.getParameter("sumTotalSal"));
			ingresosOperacionesBean.setTotalEntrada(request.getParameter("sumTotalEnt"));
			ingresosOperacionesBean.setOpcionCajaID(request.getParameter("tipoOperacion"));

		
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desDepositoActivaCta);
			ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovDepositoActivaCta);
			ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepContaDepActivaCta);
		

			ArrayList listaDenominaciones = (ArrayList) creaListaDenominaciones(request.getParameter("billetesMonedasEntrada"), request.getParameter("billetesMonedasSalida"));
			ingresosOperacionesBean.setDenominaciones("Entrada:[" + request.getParameter("billetesMonedasEntrada") + "]" + "Salida:[" + request.getParameter("billetesMonedasSalida") + "]");

			mensaje = ingresosOperacionesDAO.altaDepositoActivaCta(ingresosOperacionesBean, listaDenominaciones);
			
		} catch (Exception ex) {
			loggerVent.info("Error al Ejecutar Transaccion Deposito para Activacion de Cuenta. ", ex);
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al Ejecutar Transacción Deposito para Activacion de Cuenta.");
			}
		}
		return mensaje;
	}
	
	public IngresosOperacionesDAO getIngresosOperacionesDAO() {
		return ingresosOperacionesDAO;
	}

	public void setIngresosOperacionesDAO(
			IngresosOperacionesDAO ingresosOperacionesDAO) {
		this.ingresosOperacionesDAO = ingresosOperacionesDAO;
	}

	public CuentasAhoMovDAO getCuentasAhoMovDAO() {
		return cuentasAhoMovDAO;
	}

	public void setCuentasAhoMovDAO(CuentasAhoMovDAO cuentasAhoMovDAO) {
		this.cuentasAhoMovDAO = cuentasAhoMovDAO;
	}

	public CreditosDAO getCreditosDAO() {
		return creditosDAO;
	}

	public void setCreditosDAO(CreditosDAO creditosDAO) {
		this.creditosDAO = creditosDAO;
	}

	public SucursalesDAO getSucursalesDAO() {
		return sucursalesDAO;
	}

	public void setSucursalesDAO(SucursalesDAO sucursalesDAO) {
		this.sucursalesDAO = sucursalesDAO;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public void setCajasVentanillaServicio(
			CajasVentanillaServicio cajasVentanillaServicio) {
		this.cajasVentanillaServicio = cajasVentanillaServicio;
	}

	public MonedasServicio getMonedasServicio() {
		return monedasServicio;
	}

	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}

	public ParametrosAplicacionDAO getParametrosAplicacionDAO() {
		return parametrosAplicacionDAO;
	}

	public void setParametrosAplicacionDAO(
			ParametrosAplicacionDAO parametrosAplicacionDAO) {
		this.parametrosAplicacionDAO = parametrosAplicacionDAO;
	}

	public CajasVentanillaDAO getCajasVentanillaDAO() {
		return cajasVentanillaDAO;
	}

	public void setCajasVentanillaDAO(CajasVentanillaDAO cajasVentanillaDAO) {
		this.cajasVentanillaDAO = cajasVentanillaDAO;
	}
	
	public OpeEscalamientoInternoDAO getOpeEscalamientoInternoDAO() {
		return OpeEscalamientoInternoDAO;
	}

	public void setOpeEscalamientoInternoDAO(
			OpeEscalamientoInternoDAO opeEscalamientoInternoDAO) {
		OpeEscalamientoInternoDAO = opeEscalamientoInternoDAO;
	}
	public CuentasAhoDAO getCuentasAhoDAO() {
		return cuentasAhoDAO;
	}
	public void setCuentasAhoDAO(CuentasAhoDAO cuentasAhoDAO) {
		this.cuentasAhoDAO = cuentasAhoDAO;
	}
	public SMSEnvioMensajeDAO getSmsEnvioMensajeDAO() {
		return smsEnvioMensajeDAO;
	}
	public void setSmsEnvioMensajeDAO(SMSEnvioMensajeDAO smsEnvioMensajeDAO) {
		this.smsEnvioMensajeDAO = smsEnvioMensajeDAO;
	}

	public ISOTRXServicio getIsotrxServicio() {
		return isotrxServicio;
	}

	public void setIsotrxServicio(ISOTRXServicio isotrxServicio) {
		this.isotrxServicio = isotrxServicio;
	}
}
