package invkubo.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;

import credito.bean.CreditosBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import invkubo.bean.FondeoKuboBean;
import invkubo.bean.TiposFondeadoresBean;
import invkubo.beanws.request.ConsultaDetalleInverRequest;
import invkubo.beanws.request.ConsultaInversionesRequest;
import invkubo.beanws.response.ConsultaDetalleInverResponse;
import invkubo.beanws.response.ConsultaInversionesResponse;

 
public class FondeoKuboDAO extends BaseDAO{

	public FondeoKuboDAO() {
		super();
	}
	
	public FondeoKuboBean consultaPrincipal(FondeoKuboBean fondeoKuboBean, int tipoConsulta){
		FondeoKuboBean fondeoKubo = new FondeoKuboBean();
			
				return fondeoKubo;
	}
	
	
	//Consulta mis inversiones kubo  webservice 
	public ConsultaInversionesResponse consultaMisInversiones(ConsultaInversionesRequest consultaInversiones) {
		final ConsultaInversionesResponse mensaje = new ConsultaInversionesResponse();
	
		//Query con el Store Procedure  

		String query = "call SALDOSINVERKUBOCON(?,? ,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(consultaInversiones.getNumero()),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"FondeoKuboDAO.consultaMisInversiones",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SALDOSINVERKUBOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				
				ConsultaInversionesResponse consultaInverResp = new ConsultaInversionesResponse();
				consultaInverResp.setGananciaAnuTot(String.valueOf(resultSet.getDouble(1)));
				consultaInverResp.setNumInteresCobrado(String.valueOf(resultSet.getInt(2)));
				consultaInverResp.setInteresCobrado(String.valueOf(resultSet.getDouble(3)));
				consultaInverResp.setPagTotalRecib(String.valueOf(resultSet.getDouble(4)));
				consultaInverResp.setSaldoTotal(String.valueOf(resultSet.getDouble(5)));
				consultaInverResp.setNumeroEfectivoDispon(String.valueOf(resultSet.getInt(6)));
				consultaInverResp.setSaldoEfectivoDispon(String.valueOf(resultSet.getDouble(7)));
				consultaInverResp.setNumeroInverEnProceso(String.valueOf(resultSet.getInt(8)));
				consultaInverResp.setSaldoInverEnProceso(String.valueOf(resultSet.getDouble(9)));
				consultaInverResp.setNumeroInvActivas(String.valueOf(resultSet.getInt(10)));
				consultaInverResp.setSaldoInvActivas(String.valueOf(resultSet.getDouble(11)));
				consultaInverResp.setNumeroIntDevengados(String.valueOf(resultSet.getInt(12)));
				consultaInverResp.setSaldoIntDevengados(String.valueOf(resultSet.getDouble(13)));
				consultaInverResp.setNumeroTotInversiones(String.valueOf(resultSet.getInt(14)));
				consultaInverResp.setNumeroInvActivasResumen(String.valueOf(resultSet.getInt(15)));
				consultaInverResp.setSaldoInvActivasResumen(String.valueOf(resultSet.getDouble(16)));
				consultaInverResp.setNumeroInvAtrasadas1a15Resumen(String.valueOf(resultSet.getInt(17)));
				consultaInverResp.setSaldoInvAtrasadas1a15Resumen(String.valueOf(resultSet.getDouble(18)));
				consultaInverResp.setNumeroInvAtrasadas16a30Resumen(String.valueOf(resultSet.getInt(19)));
				consultaInverResp.setSaldoInvAtrasadas16a30Resumen(String.valueOf(resultSet.getDouble(20)));
				consultaInverResp.setNumeroInvAtrasadas31a90Resumen(String.valueOf(resultSet.getInt(21)));
				consultaInverResp.setSaldoInvAtrasadas31a90Resumen(String.valueOf(resultSet.getDouble(22)));
				consultaInverResp.setNumeroInvVencidas91a120Resumen(String.valueOf(resultSet.getInt(23)));
				consultaInverResp.setSaldoInvVencidas91a120Resumen(String.valueOf(resultSet.getDouble(24)));
				consultaInverResp.setNumeroInvVencidas121a180Resumen(String.valueOf(resultSet.getInt(25)));
				consultaInverResp.setSaldoInvVencidas121a180Resumen(String.valueOf(resultSet.getDouble(26)));
				consultaInverResp.setNumeroInvQuebrantadasResumen(String.valueOf(resultSet.getInt(27)));
				consultaInverResp.setSaldoInvQuebrantadasResumen(String.valueOf(resultSet.getDouble(28)));
				consultaInverResp.setNumeroInvLiquidadasResumen(String.valueOf(resultSet.getInt(29)));
				consultaInverResp.setSaldoInvLiquidadasResumen(String.valueOf(resultSet.getDouble(30)));		
				consultaInverResp.setNumCapitalCobrado(String.valueOf(resultSet.getInt(31)));
				consultaInverResp.setCapitalCobrado(String.valueOf(resultSet.getDouble(32)));
				consultaInverResp.setNumMoraCobrado(String.valueOf(resultSet.getInt(33)));
				consultaInverResp.setMoraCobrado(String.valueOf(resultSet.getDouble(34)));
				consultaInverResp.setNumComFalPago(String.valueOf(resultSet.getInt(35)));
				consultaInverResp.setComFalPago(String.valueOf(resultSet.getDouble(36)));
				consultaInverResp.setCodigoRespuesta(String.valueOf(resultSet.getInt(37)));
				consultaInverResp.setMensajeRespuesta(resultSet.getString(38));
					return consultaInverResp;
				
			}
		});

		return matches.size() > 0 ? (ConsultaInversionesResponse) matches.get(0) : null;
	}
	
	//Consulta detalle de inversiones kubo  webservice 
	public ConsultaDetalleInverResponse consultaDetalleInversionesKuboWS(ConsultaDetalleInverRequest detalleInversiones, int tipoConsulta) {
		final ConsultaInversionesResponse mensaje = new ConsultaInversionesResponse();
		//Query con el Store Procedure  

		String query = "call DETALLEINVKUBOCON(?,?,? ,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(detalleInversiones.getClienteID()),
								tipoConsulta,	
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEINVKUBOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {				
				ConsultaDetalleInverResponse detalleInverResponse = new ConsultaDetalleInverResponse();
				detalleInverResponse.setNumeroTotInversiones(String.valueOf(resultSet.getInt(1)));
				detalleInverResponse.setNumeroInverEnProceso(String.valueOf(resultSet.getInt(2)));
				detalleInverResponse.setSaldoInverEnProceso(String.valueOf(resultSet.getDouble(3)));
				detalleInverResponse.setNumeroInvActivas(String.valueOf(resultSet.getInt(4)));
				detalleInverResponse.setSaldoInvActivas(String.valueOf(resultSet.getDouble(5)));
				detalleInverResponse.setNumeroInvAtrasadas1a15(String.valueOf(resultSet.getInt(6)));
				detalleInverResponse.setSaldoInvAtrasadas1a15(String.valueOf(resultSet.getDouble(7)));
				detalleInverResponse.setNumeroInvAtrasadas16a30(String.valueOf(resultSet.getInt(8)));
				detalleInverResponse.setSaldoInvAtrasadas16a30(String.valueOf(resultSet.getDouble(9)));
				detalleInverResponse.setNumeroInvAtrasadas31a90(String.valueOf(resultSet.getInt(10)));
				detalleInverResponse.setSaldoInvAtrasadas31a90(String.valueOf(resultSet.getDouble(11)));
				detalleInverResponse.setNumeroInvVencidas91a120(String.valueOf(resultSet.getInt(12)));
				detalleInverResponse.setSaldoInvVencidas91a120(String.valueOf(resultSet.getDouble(13)));
				detalleInverResponse.setNumeroInvVencidas121a180(String.valueOf(resultSet.getInt(14)));
				detalleInverResponse.setSaldoInvVencidas121a180(String.valueOf(resultSet.getDouble(15)));
				detalleInverResponse.setNumeroInvQuebrantadas(String.valueOf(resultSet.getInt(16)));
				detalleInverResponse.setSaldoInvQuebrantadas(String.valueOf(resultSet.getDouble(17)));
				detalleInverResponse.setNumeroInvLiquidadas(String.valueOf(resultSet.getInt(18)));
				detalleInverResponse.setSaldoInvLiquidadas(String.valueOf(resultSet.getDouble(19)));
				detalleInverResponse.setTasaPonderada(String.valueOf(resultSet.getDouble(20)));
				detalleInverResponse.setNumeroIntDev(String.valueOf(resultSet.getInt(21)));
				detalleInverResponse.setSaldoIntDev(String.valueOf(resultSet.getDouble(22)));
				detalleInverResponse.setNumPagosRecibidos(String.valueOf(resultSet.getInt(23)));
				detalleInverResponse.setSalPagosRecibidos(String.valueOf(resultSet.getDouble(24)));
				detalleInverResponse.setNumPagosCapital(String.valueOf(resultSet.getInt(25)));
				detalleInverResponse.setSalPagosCapital(String.valueOf(resultSet.getDouble(26)));
				detalleInverResponse.setNumPagosInterOrdi(String.valueOf(resultSet.getInt(27)));
				detalleInverResponse.setSalPagosInterOrdi(String.valueOf(resultSet.getDouble(28)));
				detalleInverResponse.setNumPagosInteMora(String.valueOf(resultSet.getInt(29)));
				detalleInverResponse.setSalPagosInteMora(String.valueOf(resultSet.getDouble(30)));
				detalleInverResponse.setImpuestos(String.valueOf(resultSet.getDouble(31)));
				detalleInverResponse.setComisPagadas(String.valueOf(resultSet.getDouble(32)));
				detalleInverResponse.setNumComisRecibidas(String.valueOf(resultSet.getInt(33)));
				detalleInverResponse.setSalComisRecibidas(String.valueOf(resultSet.getDouble(34)));
				detalleInverResponse.setNumEfecDisp(String.valueOf(resultSet.getInt(35)));
				detalleInverResponse.setSalEfecDisp(String.valueOf(resultSet.getDouble(36)));
				detalleInverResponse.setNumeroInvActivas(String.valueOf(resultSet.getInt(37)));
				detalleInverResponse.setSaldoInvActivas(String.valueOf(resultSet.getDouble(38)));
				detalleInverResponse.setNumeroIntDev(String.valueOf(resultSet.getInt(39)));
				detalleInverResponse.setSaldoIntDev(String.valueOf(resultSet.getDouble(40)));
				detalleInverResponse.setDepositos(String.valueOf(resultSet.getInt(41)));
				detalleInverResponse.setInverRealiz(String.valueOf(resultSet.getInt(42)));
				detalleInverResponse.setPagCapRecib(String.valueOf(resultSet.getInt(43)));
				detalleInverResponse.setIntOrdRec(String.valueOf(resultSet.getInt(44)));
				detalleInverResponse.setIntMoraRec(String.valueOf(resultSet.getInt(45)));
				detalleInverResponse.setRecupMorosos(String.valueOf(resultSet.getInt(46)));
				detalleInverResponse.setISRretenido(String.valueOf(resultSet.getInt(47)));
				detalleInverResponse.setComisCobrad(String.valueOf(resultSet.getInt(48)));
				detalleInverResponse.setComisPagad(String.valueOf(resultSet.getInt(49)));
				detalleInverResponse.setAjustes(String.valueOf(resultSet.getInt(50)));
				detalleInverResponse.setQuebrantos(String.valueOf(resultSet.getInt(51)));
				detalleInverResponse.setQuebranXapli(String.valueOf(resultSet.getInt(52)));
				detalleInverResponse.setPremiosRecom(String.valueOf(resultSet.getInt(53)));
				
				detalleInverResponse.setCodigoRespuesta(String.valueOf(resultSet.getInt(54)));
				detalleInverResponse.setMensajeRespuesta(resultSet.getString(55));
					return detalleInverResponse;
				
			}
		});

		return matches.size() > 0 ? (ConsultaDetalleInverResponse) matches.get(0) : null;
	}
	
	/*Lista de inversiones kubo por calificacion y porcentaje para web service detalle de inv kubo*/
	public List listaInvkuboXcalificPorc(ConsultaDetalleInverRequest detalleInversiones, int tipoConsulta){
		final ConsultaDetalleInverResponse mensajeBean = new ConsultaDetalleInverResponse();
		
			String query = "call DETALLEINVKUBOCON(?,?,?, ?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(detalleInversiones.getClienteID()),
					tipoConsulta,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEINVKUBOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsultaDetalleInverResponse detalleInver = new ConsultaDetalleInverResponse();
					detalleInver.setInfoCalifPorc(resultSet.getString(1)+"&;&"+String.valueOf(resultSet.getInt(2))+"&;&"+String.valueOf(resultSet.getDouble(3)));
					mensajeBean.setCodigoRespuesta(resultSet.getString(4));
					mensajeBean.setMensajeRespuesta(resultSet.getString(5));
					if (Integer.parseInt(mensajeBean.getCodigoRespuesta())== 0) {
						return detalleInver;
					}
					else return mensajeBean;
				}
			});
			return matches;

	}
	
	/*Lista de  saldos y pagos de inversionista kubo*/
	public List listaGridSaldosYpagos(FondeoKuboBean fondeoKuboBean, int tipoLista) {
		final ConsultaDetalleInverResponse mensajeBean = new ConsultaDetalleInverResponse();
		
			String query = "call FONDEOKUBOLIS(?,?,?, ?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					tipoLista,
					Utileria.convierteEntero(fondeoKuboBean.getFondeoKuboID()),
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FONDEOKUBOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					FondeoKuboBean fondeoKuboBean = new FondeoKuboBean();
					fondeoKuboBean.setDiasAtraso(String.valueOf(resultSet.getInt(1)));
					fondeoKuboBean.setSaldoCapVigente(resultSet.getString(2));
					fondeoKuboBean.setSaldoCapExigible(resultSet.getString(3));					
					fondeoKuboBean.setSaldoInteres(resultSet.getString(4));
					fondeoKuboBean.setTotalSaldo(resultSet.getString(5));
					fondeoKuboBean.setCapitalRecibido(resultSet.getString(6));
					fondeoKuboBean.setInteresRecibido(resultSet.getString(7));
					fondeoKuboBean.setMoraRecibido(resultSet.getString(8));
					fondeoKuboBean.setComisionRecibido(resultSet.getString(9));
					fondeoKuboBean.setTotalrecibido(resultSet.getString(10));
					fondeoKuboBean.setIntOrdRetenido(resultSet.getString(11));
					fondeoKuboBean.setIntMorRetenido(resultSet.getString(12));
					fondeoKuboBean.setComFalPagRetenido(resultSet.getString(13));
					fondeoKuboBean.setTotalRetenido(resultSet.getString(14));
					
					return fondeoKuboBean;
				}
			});
			return matches;

	}
	
	
	
	
	
	
	/*Lista de inversiones kubo por plazo y porcentaje para web service detalle de inv kubo*/
	public List listaInvkuboXplazoPorcentaje(ConsultaDetalleInverRequest detalleInversiones, int tipoConsulta){
		final ConsultaDetalleInverResponse mensajeBean = new ConsultaDetalleInverResponse();
		
			String query = "call DETALLEINVKUBOCON(?,?,?, ?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(detalleInversiones.getClienteID()),
					tipoConsulta,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEINVKUBOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsultaDetalleInverResponse detalleInver = new ConsultaDetalleInverResponse();
					detalleInver.setInfoPlazosPorc(String.valueOf(resultSet.getInt(1))+"&;&"+String.valueOf(resultSet.getInt(2))+"&;&"+
					String.valueOf(resultSet.getDouble(3)));
					mensajeBean.setCodigoRespuesta(resultSet.getString(4));
					mensajeBean.setMensajeRespuesta(resultSet.getString(5));
					if (Integer.parseInt(mensajeBean.getCodigoRespuesta())== 0) {
						return detalleInver;
					}
					else return mensajeBean;
				}
			});
			return matches;

	}
	
	/*Lista de inversiones kubo de tasas ponderadas por calificacion para webservice detalle de inv kubo*/
	public List listaInvkuboTasasPonXcalif(ConsultaDetalleInverRequest detalleInversiones, int tipoConsulta){
		final ConsultaDetalleInverResponse mensajeBean = new ConsultaDetalleInverResponse();
		
			String query = "call DETALLEINVKUBOCON(?,?,?, ?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(detalleInversiones.getClienteID()),
					tipoConsulta,
					
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					Constantes.STRING_VACIO,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
					};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEINVKUBOCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ConsultaDetalleInverResponse detalleInver = new ConsultaDetalleInverResponse();
					detalleInver.setInfoTasasPonCalif(resultSet.getString(1)+"&;&"+String.valueOf(resultSet.getDouble(2)));
					mensajeBean.setCodigoRespuesta(resultSet.getString(3));
					mensajeBean.setMensajeRespuesta(resultSet.getString(4));
					if (Integer.parseInt(mensajeBean.getCodigoRespuesta())== 0) {
						return detalleInver;
					}
					else return mensajeBean;
				}
			});
			return matches;

	}
	
	
	/*consulta saldos y pagos para la pantalla de originacion (detalle de inversiones kubo)*/
	public FondeoKuboBean consultaSaldosYpagosInvKubo(FondeoKuboBean fondeoKuboBean, int tipoConsulta) {
		// TODO Auto-generated method stub
		String query = "call FONDEOKUBOLIS(?,?,?,?,?,?,?,?,?);";
						
					Object[] parametros = { fondeoKuboBean.getFondeoKuboID(),
							tipoConsulta,
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO,
							Constantes.FECHA_VACIA,
							Constantes.STRING_VACIO,
							"TiposFodeadoresDAO.consultaPrincipal",
							Constantes.ENTERO_CERO,
							Constantes.ENTERO_CERO};
					//LOGGEO DE JQUERY AL EJECUTAR
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FONDOKUBOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FondeoKuboBean fondeoKuboBean = new FondeoKuboBean();
				fondeoKuboBean.setDiasAtraso(String.valueOf(resultSet.getInt(1)));
				fondeoKuboBean.setSaldoCapVigente(resultSet.getString(2));
				fondeoKuboBean.setSaldoCapExigible(resultSet.getString(3));					
				fondeoKuboBean.setSaldoInteres(resultSet.getString(4));
				fondeoKuboBean.setTotalSaldo(resultSet.getString(5));
				fondeoKuboBean.setCapitalRecibido(resultSet.getString(6));
				fondeoKuboBean.setInteresRecibido(resultSet.getString(7));
				fondeoKuboBean.setMoraRecibido(resultSet.getString(8));
				fondeoKuboBean.setComisionRecibido(resultSet.getString(9));
				fondeoKuboBean.setTotalrecibido(resultSet.getString(10));
				fondeoKuboBean.setIntOrdRetenido(resultSet.getString(11));
				fondeoKuboBean.setIntMorRetenido(resultSet.getString(12));
				fondeoKuboBean.setComFalPagRetenido(resultSet.getString(13));
				fondeoKuboBean.setTotalRetenido(resultSet.getString(14));
				
				return fondeoKuboBean;

		}
	});
			
	return matches.size() > 0 ? (FondeoKuboBean) matches.get(0) : null;
}
	
}

