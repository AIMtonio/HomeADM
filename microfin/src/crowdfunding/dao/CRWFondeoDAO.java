package crowdfunding.dao;

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
import crowdfunding.bean.CRWFondeoBean;
import crowdfunding.bean.TiposFondeadoresBean;

public class CRWFondeoDAO extends BaseDAO{

	public CRWFondeoDAO() {
		super();
	}

	public CRWFondeoBean consultaPrincipal(CRWFondeoBean crwFondeoBean, int tipoConsulta){
		CRWFondeoBean crwFondeo = new CRWFondeoBean();

		return crwFondeo;
	}

/*
	//Consulta mis inversiones kubo  webservice
	public ConsultaInversionesResponse consultaMisInversiones(ConsultaInversionesRequest consultaInversiones) {
		final ConsultaInversionesResponse mensaje = new ConsultaInversionesResponse();

		//Query con el Store Procedure

		String query = "call SALDOSINVERKUBOCON(?,?,? ,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(consultaInversiones.getNumero()),
				Utileria.convierteEntero(consultaInversiones.getCuentaAhoID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CRWFondeoDAO.consultaMisInversiones",
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
				consultaInverResp.setGatReal(resultSet.getString(39));
				return consultaInverResp;

			}
		});

		return matches.size() > 0 ? (ConsultaInversionesResponse) matches.get(0) : null;
	}

	//Consulta detalle de inversiones kubo  webservice
	public ConsultaDetalleInverResponse consultaDetalleInversionesKuboWS(ConsultaDetalleInverRequest detalleInversiones, int tipoConsulta) {
		final ConsultaInversionesResponse mensaje = new ConsultaInversionesResponse();
		//Query con el Store Procedure

		String query = "call DETALLEINVKUBOCON(?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(detalleInversiones.getClienteID()),
				Utileria.convierteEntero(detalleInversiones.getCuentaAhoID()),
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

	/*Lista de inversiones kubo por calificacion y porcentaje para web service detalle de inv kubo
	public List listaInvkuboXcalificPorc(ConsultaDetalleInverRequest detalleInversiones, int tipoConsulta){
		final ConsultaDetalleInverResponse mensajeBean = new ConsultaDetalleInverResponse();

		String query = "call DETALLEINVKUBOCON(?,?,?,?, ?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(detalleInversiones.getClienteID()),
				Utileria.convierteEntero(detalleInversiones.getCuentaAhoID()),
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
*/
	/*Lista de  saldos y pagos de inversionista kubo*/
	public List listaGridSaldosYpagos(CRWFondeoBean crwFondeoBean, int tipoLista) {
		String query = "call FONDEOKUBOLIS("
				+ "?,?,?,?,?,     "
				+ "?,?,?,?,?,     "
				+ "?,?);";
		Object[] parametros = {
				tipoLista,
				Utileria.convierteEntero(crwFondeoBean.getSolFondeoID()),
				Utileria.convierteEntero(crwFondeoBean.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"FondeKuboDAO.listaGridSaldosYpagos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FONDEOKUBOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CRWFondeoBean crwFondeoBean = new CRWFondeoBean();
				crwFondeoBean.setDiasAtraso(String.valueOf(resultSet.getInt(1)));
				crwFondeoBean.setSaldoCapVigente(String.valueOf(resultSet.getDouble(2)));
				crwFondeoBean.setSaldoCapExigible(String.valueOf(resultSet.getDouble(3)));
				crwFondeoBean.setSaldoInteres(String.valueOf(resultSet.getDouble(4)));
				crwFondeoBean.setTotalSaldo(String.valueOf(resultSet.getDouble(5)));
				crwFondeoBean.setCapitalRecibido(String.valueOf(resultSet.getDouble(6)));
				crwFondeoBean.setInteresRecibido(String.valueOf(resultSet.getDouble(7)));
				crwFondeoBean.setMoraRecibido(String.valueOf(resultSet.getDouble(8)));
				crwFondeoBean.setComisionRecibido(String.valueOf(resultSet.getDouble(9)));
				crwFondeoBean.setTotalrecibido(String.valueOf(resultSet.getDouble(10)));
				crwFondeoBean.setIntOrdRetenido(String.valueOf(resultSet.getDouble(11)));
				crwFondeoBean.setIntMorRetenido(String.valueOf(resultSet.getDouble(12)));
				crwFondeoBean.setComFalPagRetenido(String.valueOf(resultSet.getDouble(13)));
				crwFondeoBean.setTotalRetenido(String.valueOf(resultSet.getDouble(14)));
				crwFondeoBean.setSaldoInteresMoratorio(String.valueOf(resultSet.getDouble(15)));
				crwFondeoBean.setCapCtaOrden(String.valueOf(resultSet.getDouble(16)));
				crwFondeoBean.setIntCtaOrden(String.valueOf(resultSet.getDouble(17)));

				return crwFondeoBean;
			}
		});
		return matches;

	}




/*

	/*Lista de inversiones kubo por plazo y porcentaje para web service detalle de inv kubo
	public List listaInvkuboXplazoPorcentaje(ConsultaDetalleInverRequest detalleInversiones, int tipoConsulta){
		final ConsultaDetalleInverResponse mensajeBean = new ConsultaDetalleInverResponse();

		String query = "call DETALLEINVKUBOCON(?,?,?,?, ?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(detalleInversiones.getClienteID()),
				Utileria.convierteEntero(detalleInversiones.getCuentaAhoID()),
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

	/*Lista de inversiones kubo de tasas ponderadas por calificacion para webservice detalle de inv kubo
	public List listaInvkuboTasasPonXcalif(ConsultaDetalleInverRequest detalleInversiones, int tipoConsulta){
		final ConsultaDetalleInverResponse mensajeBean = new ConsultaDetalleInverResponse();

		String query = "call DETALLEINVKUBOCON(?,?,?,?, ?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(detalleInversiones.getClienteID()),
				Utileria.convierteEntero(detalleInversiones.getCuentaAhoID()),
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

*/
	/*consulta saldos y pagos para la pantalla de originacion (detalle de inversiones kubo)*/
	public CRWFondeoBean consultaSaldosYpagosInvKubo(CRWFondeoBean crwFondeoBean, int tipoConsulta) {
		// TODO Auto-generated method stub
		String query = "call FONDEOKUBOLIS("
				+ "?,?,?,?,?,    "
				+ "?,?,?,?,?,"
				+ "?,?);";

		Object[] parametros = {
				tipoConsulta,
				Utileria.convierteEntero(crwFondeoBean.getSolFondeoID()),
				Utileria.convierteEntero(crwFondeoBean.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"FondeKuboDAO.consultaSaldosYpagosInvKubo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		//LOGGEO DE JQUERY AL EJECUTAR
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FONDOKUBOLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CRWFondeoBean crwFondeoBean = new CRWFondeoBean();
				crwFondeoBean.setDiasAtraso(String.valueOf(resultSet.getInt(1)));
				crwFondeoBean.setSaldoCapVigente(resultSet.getString(2));
				crwFondeoBean.setSaldoCapExigible(resultSet.getString(3));
				crwFondeoBean.setSaldoInteres(resultSet.getString(4));
				crwFondeoBean.setTotalSaldo(resultSet.getString(5));
				crwFondeoBean.setCapitalRecibido(resultSet.getString(6));
				crwFondeoBean.setInteresRecibido(resultSet.getString(7));
				crwFondeoBean.setMoraRecibido(resultSet.getString(8));
				crwFondeoBean.setComisionRecibido(resultSet.getString(9));
				crwFondeoBean.setTotalrecibido(resultSet.getString(10));
				crwFondeoBean.setIntOrdRetenido(resultSet.getString(11));
				crwFondeoBean.setIntMorRetenido(resultSet.getString(12));
				crwFondeoBean.setComFalPagRetenido(resultSet.getString(13));
				crwFondeoBean.setTotalRetenido(resultSet.getString(14));

				return crwFondeoBean;

			}
		});

		return matches.size() > 0 ? (CRWFondeoBean) matches.get(0) : null;
	}



	public CRWFondeoBean listaGridCastigos(CRWFondeoBean crwFondeoBean, int tipoConsulta) {
		// TODO Auto-generated method stub
		String query = "call FONDEOKUBOLIS("
				+ "?,?,?,?,?,    "
				+ "?,?,?,?,?,"
				+ "?,?);";

		Object[] parametros = {
				tipoConsulta,
				Utileria.convierteEntero(crwFondeoBean.getSolFondeoID()),
				Utileria.convierteEntero(crwFondeoBean.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"FondeKuboDAO.listaGridCastigos",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info("call FONDEOKUBOLIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CRWFondeoBean crwFondeoBean = new CRWFondeoBean();
				crwFondeoBean.setSolFondeoID(resultSet.getString(1));
				crwFondeoBean.setClienteID(resultSet.getString(2));
				crwFondeoBean.setSaldoCapVigente(resultSet.getString(3));
				crwFondeoBean.setSaldoCapExigible(resultSet.getString(4));
				crwFondeoBean.setSaldoInteres(resultSet.getString(5));
				crwFondeoBean.setProvisionAcum(resultSet.getString(6));
				crwFondeoBean.setMontoFondeo(resultSet.getString(7));
				crwFondeoBean.setSaldoInteresMoratorio(resultSet.getString(8));
				crwFondeoBean.setCapCtaOrden(resultSet.getString(9));
				crwFondeoBean.setIntCtaOrden(resultSet.getString(10));
				return crwFondeoBean;

			}
		});

		return matches.size() > 0 ? (CRWFondeoBean) matches.get(0) : null;
	}
	/**
	 * Lista todos los fondeos por cliente
	 * @param crwFondeoBean : Bean con la Informacion para realizar la consulta de la lista
	 * @param tipoConsulta : Numero de Consulta
	 * @return
	 */
	public List<CRWFondeoBean> listaXInvCliente(CRWFondeoBean crwFondeoBean, int tipoConsulta) {
		// TODO Auto-generated method stub
		String query = "call FONDEOKUBOLIS("
				+ "?,?,?,?,?,    "
				+ "?,?,?,?,?,"
				+ "?,?);";

		Object[] parametros = {
				tipoConsulta,
				Utileria.convierteEntero(crwFondeoBean.getSolFondeoID()),
				Utileria.convierteEntero(crwFondeoBean.getClienteID()),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"FondeKuboDAO.listaXCliente",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};

		loggerSAFI.info("call FONDEOKUBOLIS(" + Arrays.toString(parametros) + ")");

		List<CRWFondeoBean> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CRWFondeoBean crwFondeoBean = new CRWFondeoBean();
				crwFondeoBean.setCreditoID(String.valueOf(resultSet.getString("CreditoID")));
				crwFondeoBean.setSolicitudCreditoID(String.valueOf(resultSet.getString("SolicitudCreditoID")));
				crwFondeoBean.setCuentaAhoID(String.valueOf(resultSet.getString("CuentaAhoID")));
				crwFondeoBean.setMontoFondeo(String.valueOf(resultSet.getString("MontoFondeo")));
				crwFondeoBean.setPorcentajeFondeo(String.valueOf(resultSet.getString("PorcentajeFondeo")));
				crwFondeoBean.setFechaInicio(String.valueOf(resultSet.getString("FechaInicio")));
				crwFondeoBean.setFechaVencimiento(String.valueOf(resultSet.getString("FechaVencimiento")));
				crwFondeoBean.setEstatus(String.valueOf(resultSet.getString("Estatus")));

				return crwFondeoBean;
			}
		});

		return matches.size() > 0 ? matches : null;
	}
}