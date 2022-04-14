package arrendamiento.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import arrendamiento.bean.ArrendaAmortiBean;
import arrendamiento.bean.ArrendamientosBean;
import arrendamiento.bean.DetallePagoArrendaBean;
import arrendamiento.bean.EntregaArrendamientoBean;
import arrendamiento.bean.MesaControlArrendamientoBean;

public class ArrendamientosDAO extends BaseDAO{
	ParametrosSesionBean parametrosSesionBean;
	Logger log = Logger.getLogger( this.getClass() );
	private final static String salidaPantalla = "S";
	private final static String esPrepago = "N";
	private final static String altaEnPolizaNo = "N";
	private final static String altaEnPolizaSi = "S";
	String numcredito = "";  // guarda el numero del credito que se a dado de alta
	String mensajedes = "";  // mesaje del credito

	public ArrendamientosDAO (){
		super();
	}

	/**
	 * Consulta por ArrendamientoID (C=2)
	 * @param arrendamientosBean
	 * @param tipoConsulta
	 * @return
	 * @author vsanmiguel
	 */
	public ArrendamientosBean consultaPorArrendaID(ArrendamientosBean arrendamientosBean, int tipoConsulta) {
		ArrendamientosBean arrendamientoBean = null;
		try{
			//Query con el Store Procedure
			String query = "call ARRENDAMIENTOSCON(?,?,	 ?,?,?,?,?,?,?);";
			Object[] parametros = {	arrendamientosBean.getArrendaID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ArrendamientosDAO.consultaPorArrendaID",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAMIENTOSCON(" + Arrays.toString(parametros) + ")");

			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ArrendamientosBean arrendamiento = new ArrendamientosBean();
					arrendamiento.setArrendaID(resultSet.getString("ArrendaID"));
					arrendamiento.setClienteID(resultSet.getString("ClienteID"));
					arrendamiento.setNombreCliente(resultSet.getString("Cliente"));
					arrendamiento.setProductoArrendaID(resultSet.getString("ProductoArrendaID"));
					arrendamiento.setProductoArrendaDescri(resultSet.getString("NombreCorto"));
					arrendamiento.setEstatus(resultSet.getString("Estatus"));
					arrendamiento.setTipoArrenda(resultSet.getString("TipoArrenda"));
					// **** condiciones ***
					arrendamiento.setMontoArrenda(resultSet.getString("MontoArrenda"));
					arrendamiento.setPorcEnganche(resultSet.getString("PorcEnganche"));
					arrendamiento.setMontoEnganche(resultSet.getString("MontoEnganche"));
					// seguro anual
					arrendamiento.setMontoSeguroAnual(resultSet.getString("MontoSeguroAnual"));
					arrendamiento.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
					arrendamiento.setSeguroArrendaID(resultSet.getString("SeguroArrendaID"));
					arrendamiento.setSeguroDescri(resultSet.getString("SegDescri"));
					// seguro de vida
					arrendamiento.setTipoPagoSeguroVida(resultSet.getString("TipoPagoSeguroVida"));
					arrendamiento.setMontoSeguroVidaAnual(resultSet.getString("MontoSeguroVidaAnual"));
					arrendamiento.setSeguroVidaDescri(resultSet.getString("SegVidaDescri"));
					arrendamiento.setMontoFinanciado(resultSet.getString("MontoFinanciado"));
					arrendamiento.setDiaPagoProd(resultSet.getString("DiaPagoProd"));
					arrendamiento.setMontoResidual(resultSet.getString("MontoResidual"));
					arrendamiento.setFechaApertura(resultSet.getString("FechaApertura"));
					arrendamiento.setFechaPrimerVen(resultSet.getString("FechaPrimerVen"));
					arrendamiento.setFechaUltimoVen(resultSet.getString("FechaUltimoVen"));
					arrendamiento.setFrecuenciaPlazo(resultSet.getString("FrecuenciaPlazo"));
					arrendamiento.setPlazo(resultSet.getString("Plazo"));
					arrendamiento.setTasaFijaAnual(resultSet.getString("TasaFijaAnual"));
					arrendamiento.setMontoCuota(resultSet.getString("MontoCuota"));
					arrendamiento.setFechaInhabil(resultSet.getString("FechaInhabil"));
					// **** Pago Inicial***
					arrendamiento.setIvaEnganche(resultSet.getString("IVAEnganche"));
					arrendamiento.setMontoComApe(resultSet.getString("MontoComApe"));
					arrendamiento.setIvaComApe(resultSet.getString("IVAComApe"));
					arrendamiento.setCantRentaDepo(resultSet.getString("CantRentaDepo"));
					arrendamiento.setMontoDeposito(resultSet.getString("MontoDeposito"));
					arrendamiento.setIvaDeposito(resultSet.getString("IVADeposito"));
					arrendamiento.setOtroGastos(resultSet.getString("PlacasTenencia"));
					arrendamiento.setMontoSeguro(resultSet.getString("MontoSeguro"));
					arrendamiento.setMontoSeguroVida(resultSet.getString("MontoSeguroVida"));
					arrendamiento.setTotalPagoInicial(resultSet.getString("TotalPagoInicial"));
					arrendamiento.setConcRentaAnticipada(resultSet.getString("RentaAnticipada"));
					arrendamiento.setConcIvaRentaAnticipada(resultSet.getString("IVARentaAnticipa"));
					arrendamiento.setConcRentasAdelantadas(resultSet.getString("RentasAdelantadas"));
					arrendamiento.setConcIvaRentasAdelantadas(resultSet.getString("IVARenAdelanta"));
					return arrendamiento;
				}
			});
			arrendamientoBean= matches.size() > 0 ? (ArrendamientosBean) matches.get(0) : null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de arrendamiento.", e);
			e.printStackTrace();
		}
		return arrendamientoBean;
	}// fin del metodo: consultaPorArrendaID

	// Consulta de detalle de arrendamiento
	public MesaControlArrendamientoBean consultaDetalleProducto(int tipoConsulta, MesaControlArrendamientoBean mesaControlArrendamientoBean) {
		MesaControlArrendamientoBean arrendamiento = null;

		try{
			String query = "call ARRENDAMIENTOSCON(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					mesaControlArrendamientoBean.getArrendaID(),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"ArrendamientosDAO.consultaDetalleProducto",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAMIENTOSCON(" + Arrays.toString(parametros) +")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					MesaControlArrendamientoBean resultado = new MesaControlArrendamientoBean();

					resultado.setArrendaID(resultSet.getString("ArrendaID"));
					resultado.setClienteID(resultSet.getString("ClienteID"));
					resultado.setNombreCliente(resultSet.getString("NombreCliente"));
					resultado.setProductoArrendaID(resultSet.getString("ProductoArrendaID"));
					resultado.setNombreCorto(resultSet.getString("NombreCorto"));

					resultado.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
					resultado.setUsuarioAutoriza(resultSet.getString("UsuarioAutoriza"));
					resultado.setNombreUsuario(resultSet.getString("NombreUsuario"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setMontoArrenda(resultSet.getString("MontoArrenda"));

					resultado.setIvaMontoArrenda(resultSet.getString("IVAMontoArrenda"));
					resultado.setFechaApertura(resultSet.getString("FechaApertura"));
					resultado.setMontoEnganche(resultSet.getString("MontoEnganche"));
					resultado.setFrecuenciaPlazo(resultSet.getString("FrecuenciaPlazo"));
					resultado.setMontoSeguroAnual(resultSet.getString("MontoSeguroAnual"));

					resultado.setPlazo(resultSet.getString("Plazo"));
					resultado.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
					resultado.setMontoFinanciado(resultSet.getString("MontoFinanciado"));
					resultado.setDiaPagoProd(resultSet.getString("DiaPagoProd"));

					return resultado;
				}
			});
			arrendamiento = matches.size() > 0 ? (MesaControlArrendamientoBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de detalles de arrendamiento", e);
		}
		return arrendamiento;
	}

	// Consulta de detalle de arrendamiento para entrega
		public EntregaArrendamientoBean consultaEntregaArrendamiento(int tipoConsulta, EntregaArrendamientoBean entregaArrendamientoBean) {
			EntregaArrendamientoBean arrendamiento = null;

			try{
				String query = "call ARRENDAMIENTOSCON(?,?,?,?,?, ?,?,?,?);";
				Object[] parametros = {
						entregaArrendamientoBean.getArrendaID(),
						tipoConsulta,

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						OperacionesFechas.FEC_VACIA,
						Constantes.STRING_VACIO,
						"ArrendamientosDAO.consultaEntregaArrendamiento",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAMIENTOSCON(" + Arrays.toString(parametros) +")");
				List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						EntregaArrendamientoBean resultado = new EntregaArrendamientoBean();

						resultado.setArrendaID(resultSet.getString("ArrendaID"));
						resultado.setClienteID(resultSet.getString("ClienteID"));
						resultado.setNombreCliente(resultSet.getString("NombreCliente"));
						resultado.setProductoArrendaID(resultSet.getString("ProductoArrendaID"));
						resultado.setNombreCorto(resultSet.getString("NombreCorto"));

						resultado.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
						resultado.setUsuarioAutoriza(resultSet.getString("UsuarioAutoriza"));
						resultado.setNombreUsuario(resultSet.getString("NombreUsuario"));
						resultado.setEstatus(resultSet.getString("Estatus"));
						resultado.setMontoArrenda(resultSet.getString("MontoArrenda"));

						resultado.setIvaMontoArrenda(resultSet.getString("IVAMontoArrenda"));
						resultado.setFechaApertura(resultSet.getString("FechaApertura"));
						resultado.setMontoEnganche(resultSet.getString("MontoEnganche"));
						resultado.setFrecuenciaPlazo(resultSet.getString("FrecuenciaPlazo"));
						resultado.setMontoSeguroAnual(resultSet.getString("MontoSeguroAnual"));

						resultado.setPlazo(resultSet.getString("Plazo"));
						resultado.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
						resultado.setMontoFinanciado(resultSet.getString("MontoFinanciado"));
						resultado.setDiaPagoProd(resultSet.getString("DiaPagoProd"));

						return resultado;
					}
				});
				arrendamiento = matches.size() > 0 ? (EntregaArrendamientoBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de detalles de arrendamiento", e);
			}
			return arrendamiento;
		}

	// lista de arrendamientos
	public List<?> listaArrendamientosProductos(int tipoLista, MesaControlArrendamientoBean mesaControlArrendamientoBean) {
		List<?> listaArrendamientos = null;
		try{
			String query = "call ARRENDAMIENTOSLIS(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					mesaControlArrendamientoBean.getArrendaID(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"ArrendamientosDAO.listaArrendamientos",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAMIENTOSLIS(" + Arrays.toString(parametros) +")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {

				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					MesaControlArrendamientoBean resultado = new MesaControlArrendamientoBean();
					resultado.setArrendaID(resultSet.getString("ArrendaID"));
					resultado.setNombreCorto(resultSet.getString("NombreCorto"));
					resultado.setNombreCliente(resultSet.getString("NombreCliente"));

					return resultado;
				}
			});
			listaArrendamientos = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de arrendamientos", e);
		}
		return listaArrendamientos;
	}

	// Lista de arrendamientos autorizados
	public List<?> listaArrendamientosAutorizados(int tipoLista, EntregaArrendamientoBean entregaArrendamientoBean) {
		List<?> listaArrendamientos = null;
		try{
			String query = "call ARRENDAMIENTOSLIS(?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					entregaArrendamientoBean.getArrendaID(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					OperacionesFechas.FEC_VACIA,
					Constantes.STRING_VACIO,
					"ArrendamientosDAO.listaArrendamientosAutorizados",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAMIENTOSLIS(" + Arrays.toString(parametros) +")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {

				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					EntregaArrendamientoBean resultado = new EntregaArrendamientoBean();
					resultado.setArrendaID(resultSet.getString("ArrendaID"));
					resultado.setNombreCorto(resultSet.getString("NombreCorto"));
					resultado.setNombreCliente(resultSet.getString("NombreCliente"));

					return resultado;
				}
			});
			listaArrendamientos = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de arrendamientos autorizados", e);
		}
		return listaArrendamientos;
	}

	/**
	 * Lista de arrendamientos por sucursal
	 * @param arrendamientosBean
	 * @param tipoLista:5
	 * @return List
	 */
	public List<?> listaArrendaSucursal(ArrendamientosBean arrendamientosBean, int tipoLista) {
		List<?> arrendamientoLis = null;
		try{
			//Query con el Store Procedure
			String query = "call ARRENDAMIENTOSLIS(?,?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	arrendamientosBean.getArrendaID(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ArrendamientosDAO.listaArrendaSucursal",
									arrendamientosBean.getSucursalID(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAMIENTOSLIS(" + Arrays.toString(parametros) + ")");

			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ArrendamientosBean	respuesta	= new ArrendamientosBean();
					respuesta.setArrendaID(resultSet.getString("ArrendaID"));
					respuesta.setClienteID(resultSet.getString("ClienteID"));
					respuesta.setNombreCompleto(resultSet.getString("NombreCompleto"));
					respuesta.setEstatus(resultSet.getString("Estatus"));
					respuesta.setFechaApertura(resultSet.getString("FechaApertura"));
					respuesta.setFechaUltimoVen(resultSet.getString("FechaUltimoVen"));
					respuesta.setDescripProducto(resultSet.getString("Descripcion"));
					respuesta.setNombreSucursal(resultSet.getString("NombreSucurs"));
					return respuesta;
				}
			});
			return arrendamientoLis = matches.size() > 0 ? matches: null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la lista de arrendamiento.", e);
			e.printStackTrace();
		}
		return arrendamientoLis;
	}// fin del metodo: listaArrendamiento

	public MensajeTransaccionBean autorizarProducto(final int tipoActualizacion, final ArrendamientosBean arrendamientosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ARRENDAMIENTOSACT(?,?,?,?,?, "	+ "?,?,?,?,?, " + "?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_ArrendaID", Utileria.convierteLong(arrendamientosBean.getArrendaID()));

									sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

									//Parametros de salida
									sentenciaStore.setString("Par_Salida", salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","ArrendamientosDAO.autorizarProducto");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ArrendamientosDAO.autorizarProducto");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ArrendamientosDAO.autorizarProducto");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al actualizar el estatus del producto" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean entregaArrendamiento(final ArrendamientosBean arrendamientosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ENTREGAARRENDAPRO(?,?,?,?,?, "	+ "?,?,?,?,?, " + "?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_ArrendaID", Utileria.convierteLong(arrendamientosBean.getArrendaID()));

									//Parametros de salida
									sentenciaStore.setString("Par_Salida", salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","ArrendamientosDAO.entregaArrendamiento");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ArrendamientosDAO.entregaArrendamiento");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ArrendamientosDAO.entregaArrendamiento");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al actualizar el estatus del arrendamiento" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Alta de credito de Fondeo  */
	public MensajeTransaccionBean alta(final ArrendamientosBean arrendamientosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call ARRENDAMIENTOSALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?,	?,?,?,?,?," +
										"?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_LineaArrendaID",Utileria.convierteEntero(arrendamientosBean.getLineaArrendaID()));
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(arrendamientosBean.getClienteID()));
							sentenciaStore.setString("Par_TipoArrenda",arrendamientosBean.getTipoArrenda());
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(arrendamientosBean.getMonedaID()));
							sentenciaStore.setInt("Par_ProductoArrendaID",Utileria.convierteEntero(arrendamientosBean.getProductoArrendaID()));
							sentenciaStore.setDouble("Par_MontoArrenda",Utileria.convierteDoble(arrendamientosBean.getMontoArrenda()));
							sentenciaStore.setDouble("Par_PorcEnganche",Utileria.convierteDoble(arrendamientosBean.getPorcEnganche()));
							sentenciaStore.setInt("Par_SeguroArrendaID",Utileria.convierteEntero(arrendamientosBean.getSeguroArrendaID()));
							sentenciaStore.setInt("Par_TipoPagoSeguro",Utileria.convierteEntero(arrendamientosBean.getTipoPagoSeguro()));
							sentenciaStore.setDouble("Par_MontoSeguroAnual",Utileria.convierteDoble(arrendamientosBean.getMontoSeguroAnual()));

							sentenciaStore.setInt("Par_SeguroVidaArrendaID",Utileria.convierteEntero(arrendamientosBean.getSeguroVidaArrendaID()));
							sentenciaStore.setInt("Par_TipoPagoSeguroVida",Utileria.convierteEntero(arrendamientosBean.getTipoPagoSeguroVida()));
							sentenciaStore.setDouble("Par_MontoSeguroVidaAnual",Utileria.convierteDoble(arrendamientosBean.getMontoSeguroVidaAnual()));
							sentenciaStore.setDouble("Par_MontoResidual",Utileria.convierteDoble(arrendamientosBean.getMontoResidual()));
							sentenciaStore.setDate("Par_FechaApertura",OperacionesFechas.conversionStrDate(arrendamientosBean.getFechaApertura()));
							sentenciaStore.setDate("Par_FechaPrimerVen",OperacionesFechas.conversionStrDate(arrendamientosBean.getFechaPrimerVen()));
							sentenciaStore.setDate("Par_FechaUltimoVen",OperacionesFechas.conversionStrDate(arrendamientosBean.getFechaUltimoVen()));
							sentenciaStore.setInt("Par_Plazo",Utileria.convierteEntero(arrendamientosBean.getPlazo()));
							sentenciaStore.setString("Par_FrecuenciaPlazo",arrendamientosBean.getFrecuenciaPlazo());
							sentenciaStore.setDouble("Par_TasaFijaAnual",Utileria.convierteDoble(arrendamientosBean.getTasaFijaAnual()));

							sentenciaStore.setDouble("Par_MontoRenta",Utileria.convierteDoble(arrendamientosBean.getMontoRenta()));
							sentenciaStore.setDouble("Par_MontoSeguro",Utileria.convierteDoble(arrendamientosBean.getMontoSeguro()));
							sentenciaStore.setDouble("Par_MontoSeguroVida",Utileria.convierteDoble(arrendamientosBean.getMontoSeguroVida()));
							sentenciaStore.setInt("Par_CantRentaDepo",Utileria.convierteEntero(arrendamientosBean.getCantRentaDepo()));
							sentenciaStore.setDouble("Par_MontoDeposito",Utileria.convierteDoble(arrendamientosBean.getMontoDeposito()));
							sentenciaStore.setDouble("Par_MontoComApe",Utileria.convierteDoble(arrendamientosBean.getMontoComApe()));
							sentenciaStore.setDouble("Par_OtroGastos",Utileria.convierteDoble(arrendamientosBean.getOtroGastos()));
							sentenciaStore.setString("Par_TipCobComMorato",arrendamientosBean.getTipCobComMorato());
							sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(arrendamientosBean.getFactorMora()));
							sentenciaStore.setInt("Par_CantCuota",Utileria.convierteEntero(arrendamientosBean.getCantCuota()));

							sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(arrendamientosBean.getMontoCuota()));
							sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(arrendamientosBean.getSucursalID()));
							sentenciaStore.setString("Par_DiaPagoProd",arrendamientosBean.getDiaPagoProd());
							sentenciaStore.setString("Par_FechaInhabil",arrendamientosBean.getFechaInhabil());
							sentenciaStore.setString("Par_TipoPrepago",arrendamientosBean.getTipoPrepago());
							sentenciaStore.setLong("Par_NumTransacSim",Utileria.convierteEntero(arrendamientosBean.getNumTransacSim()));

							sentenciaStore.setString("Par_EsRentaAnticipada",arrendamientosBean.getRentaAnticipada());
							sentenciaStore.setInt("Par_CantRenAdelantadas",Utileria.convierteEntero(arrendamientosBean.getRentasAdelantadas()));
							sentenciaStore.setString("Par_TipoRenAdelantadas",arrendamientosBean.getAdelanto());
							sentenciaStore.setDouble("Par_RentaAnticipada",Utileria.convierteDoble(arrendamientosBean.getConcRentaAnticipada()));
							sentenciaStore.setDouble("Par_IVARentaAnticipada",Utileria.convierteDoble(arrendamientosBean.getConcIvaRentaAnticipada()));
							sentenciaStore.setDouble("Par_CuotasAdelantadas",Utileria.convierteDoble(arrendamientosBean.getConcRentasAdelantadas()));
							sentenciaStore.setDouble("Par_IVACuotasAdelan",Utileria.convierteDoble(arrendamientosBean.getConcIvaRentasAdelantadas()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback<Object>() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " Arrendamientos.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " Arrendamientos.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Arrendamientos" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Alta de credito de Fondeo  */
	public MensajeTransaccionBean modificacion(final ArrendamientosBean arrendamientosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call ARRENDAMIENTOSMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_ArrendaID",Utileria.convierteEntero(arrendamientosBean.getArrendaID()));
							sentenciaStore.setLong("Par_LineaArrendaID",Utileria.convierteEntero(arrendamientosBean.getLineaArrendaID()));
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(arrendamientosBean.getClienteID()));
							sentenciaStore.setString("Par_TipoArrenda",arrendamientosBean.getTipoArrenda());
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(arrendamientosBean.getMonedaID()));
							sentenciaStore.setInt("Par_ProductoArrendaID",Utileria.convierteEntero(arrendamientosBean.getProductoArrendaID()));
							sentenciaStore.setDouble("Par_MontoArrenda",Utileria.convierteDoble(arrendamientosBean.getMontoArrenda()));
							sentenciaStore.setDouble("Par_PorcEnganche",Utileria.convierteDoble(arrendamientosBean.getPorcEnganche()));
							sentenciaStore.setInt("Par_SeguroArrendaID",Utileria.convierteEntero(arrendamientosBean.getSeguroArrendaID()));
							sentenciaStore.setInt("Par_TipoPagoSeguro",Utileria.convierteEntero(arrendamientosBean.getTipoPagoSeguro()));
							sentenciaStore.setDouble("Par_MontoSeguroAnual",Utileria.convierteDoble(arrendamientosBean.getMontoSeguroAnual()));

							sentenciaStore.setInt("Par_SeguroVidaArrendaID",Utileria.convierteEntero(arrendamientosBean.getSeguroVidaArrendaID()));
							sentenciaStore.setInt("Par_TipoPagoSeguroVida",Utileria.convierteEntero(arrendamientosBean.getTipoPagoSeguroVida()));
							sentenciaStore.setDouble("Par_MontoSeguroVidaAnual",Utileria.convierteDoble(arrendamientosBean.getMontoSeguroVidaAnual()));
							sentenciaStore.setDouble("Par_MontoResidual",Utileria.convierteDoble(arrendamientosBean.getMontoResidual()));
							sentenciaStore.setDate("Par_FechaApertura",OperacionesFechas.conversionStrDate(arrendamientosBean.getFechaApertura()));
							sentenciaStore.setDate("Par_FechaPrimerVen",OperacionesFechas.conversionStrDate(arrendamientosBean.getFechaPrimerVen()));
							sentenciaStore.setDate("Par_FechaUltimoVen",OperacionesFechas.conversionStrDate(arrendamientosBean.getFechaUltimoVen()));
							sentenciaStore.setInt("Par_Plazo",Utileria.convierteEntero(arrendamientosBean.getPlazo()));
							sentenciaStore.setString("Par_FrecuenciaPlazo",arrendamientosBean.getFrecuenciaPlazo());
							sentenciaStore.setDouble("Par_TasaFijaAnual",Utileria.convierteDoble(arrendamientosBean.getTasaFijaAnual()));

							sentenciaStore.setDouble("Par_MontoRenta",Utileria.convierteDoble(arrendamientosBean.getMontoRenta()));
							sentenciaStore.setDouble("Par_MontoSeguro",Utileria.convierteDoble(arrendamientosBean.getMontoSeguro()));
							sentenciaStore.setDouble("Par_MontoSeguroVida",Utileria.convierteDoble(arrendamientosBean.getMontoSeguroVida()));
							sentenciaStore.setInt("Par_CantRentaDepo",Utileria.convierteEntero(arrendamientosBean.getCantRentaDepo()));
							sentenciaStore.setDouble("Par_MontoDeposito",Utileria.convierteDoble(arrendamientosBean.getMontoDeposito()));
							sentenciaStore.setDouble("Par_MontoComApe",Utileria.convierteDoble(arrendamientosBean.getMontoComApe()));
							sentenciaStore.setDouble("Par_OtroGastos",Utileria.convierteDoble(arrendamientosBean.getOtroGastos()));
							sentenciaStore.setString("Par_TipCobComMorato",arrendamientosBean.getTipCobComMorato());
							sentenciaStore.setDouble("Par_FactorMora",Utileria.convierteDoble(arrendamientosBean.getFactorMora()));
							sentenciaStore.setInt("Par_CantCuota",Utileria.convierteEntero(arrendamientosBean.getCantCuota()));

							sentenciaStore.setDouble("Par_MontoCuota",Utileria.convierteDoble(arrendamientosBean.getMontoCuota()));
							sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(arrendamientosBean.getSucursalID()));
							sentenciaStore.setString("Par_DiaPagoProd",arrendamientosBean.getDiaPagoProd());
							sentenciaStore.setString("Par_FechaInhabil",arrendamientosBean.getFechaInhabil());
							sentenciaStore.setString("Par_TipoPrepago",arrendamientosBean.getTipoPrepago());
							sentenciaStore.setLong("Par_NumTransacSim",Utileria.convierteEntero(arrendamientosBean.getNumTransacSim()));

							sentenciaStore.setString("Par_EsRentaAnticipada",arrendamientosBean.getRentaAnticipada());
							sentenciaStore.setInt("Par_CantRenAdelantadas",Utileria.convierteEntero(arrendamientosBean.getRentasAdelantadas()));
							sentenciaStore.setString("Par_TipoRenAdelantadas",arrendamientosBean.getAdelanto());
							sentenciaStore.setDouble("Par_RentaAnticipada",Utileria.convierteDoble(arrendamientosBean.getConcRentaAnticipada()));
							sentenciaStore.setDouble("Par_IVARentaAnticipada",Utileria.convierteDoble(arrendamientosBean.getConcIvaRentaAnticipada()));
							sentenciaStore.setDouble("Par_CuotasAdelantadas",Utileria.convierteDoble(arrendamientosBean.getConcRentasAdelantadas()));
							sentenciaStore.setDouble("Par_IVACuotasAdelan",Utileria.convierteDoble(arrendamientosBean.getConcIvaRentasAdelantadas()));

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback<Object>() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " Arrendamientos.m");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " Arrendamientos.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Arrendamientos" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* SIMULADOR DE PAGOS CRECIENTES CON TASA FIJA */
	public List<?> simuladorPagos (final ArrendamientosBean arrendamientosBean){
		transaccionDAO.generaNumeroTransaccion();
		List<?> matches =new  ArrayList<Object>();
		final List<ArrendaAmortiBean> matches2 =new  ArrayList<ArrendaAmortiBean>();
		ArrendaAmortiBean arrendaAmortizacion = null;
		final ArrendaAmortiBean arrendaAmorti = new ArrendaAmortiBean();
		matches = (List<?>) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ARRENDASIMPAGOSPRO(" +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?,?,?," +
						"?,?,?,?,?, ?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setDouble("Par_Monto",Utileria.convierteDoble(arrendamientosBean.getMontoFinanciado()));
				sentenciaStore.setDouble("Par_MontoSegAnual",Utileria.convierteDoble(arrendamientosBean.getMontoSeguroAnual()));
				sentenciaStore.setDouble("Par_MontoSegVidaAn",Utileria.convierteDoble(arrendamientosBean.getMontoSeguroVidaAnual()));
				sentenciaStore.setString("Par_DiasPago",arrendamientosBean.getDiaPagoProd());
				sentenciaStore.setDouble("Par_ValorResidual",Utileria.convierteDoble(arrendamientosBean.getMontoResidual()));

				sentenciaStore.setDate("Par_FechaApertura",OperacionesFechas.conversionStrDate(arrendamientosBean.getFechaApertura()));
				sentenciaStore.setString("Par_Periodicidad",arrendamientosBean.getFrecuenciaPlazo());
				sentenciaStore.setInt("Par_Plazo",Utileria.convierteEntero(arrendamientosBean.getPlazo()));
				sentenciaStore.setDouble("Par_Tasa",Utileria.convierteDoble(arrendamientosBean.getTasaFijaAnual()));

				sentenciaStore.setString("Par_DiaHabil",arrendamientosBean.getFechaInhabil());
				sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(arrendamientosBean.getClienteID()));
				sentenciaStore.setString("Par_RentaAnticipada",arrendamientosBean.getRentaAnticipada());
				sentenciaStore.setInt("Par_RentasAdelantadas",Utileria.convierteEntero(arrendamientosBean.getRentasAdelantadas()));
				sentenciaStore.setString("Par_Adelanto",arrendamientosBean.getAdelanto());

				sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
				sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
				sentenciaStore.registerOutParameter("Par_NumTransacSim", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_CantCuota", Types.INTEGER);
				sentenciaStore.registerOutParameter("Par_FechaPrimerVen", Types.DATE);
				sentenciaStore.registerOutParameter("Par_FechaUltimoVen", Types.DATE);

			 	sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
				sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
				sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
				sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
				sentenciaStore.setString("Aud_ProgramaID","ArrendamientosDAO.simuladorPagos");
				sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
				sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDASIMPAGOSPRO(  " + sentenciaStore.toString() + ")");
				return sentenciaStore;
			}
		},new CallableStatementCallback<Object>() {
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						ArrendaAmortiBean	arrendaAmorti	=new ArrendaAmortiBean();
						arrendaAmorti.setArrendaAmortiID(resultadosStore.getString("Tmp_Consecutivo"));
						arrendaAmorti.setFechaInicio(resultadosStore.getString("Tmp_FecIni"));
						arrendaAmorti.setFechaVencim(resultadosStore.getString("Tmp_FecFin"));
						arrendaAmorti.setFechaExigible(resultadosStore.getString("Tmp_FecExi"));
						arrendaAmorti.setCapitalRenta(resultadosStore.getString("Tmp_Capital"));

						arrendaAmorti.setInteresRenta(resultadosStore.getString("Tmp_Interes"));
						arrendaAmorti.setRenta(resultadosStore.getString("Tmp_Renta"));
						arrendaAmorti.setIvaRenta(resultadosStore.getString("Tmp_Iva"));
						arrendaAmorti.setSaldoCapital(resultadosStore.getString("Tmp_Insoluto"));
						arrendaAmorti.setSeguro(resultadosStore.getString("Tmp_MontoSeg"));

						arrendaAmorti.setSeguroVida(resultadosStore.getString("Tmp_MontoSegVida"));
						arrendaAmorti.setPagoTotal(resultadosStore.getString("Tmp_PagoTotal"));
						arrendaAmorti.setNumTransaccion(resultadosStore.getString("NumTransaccion"));
						arrendaAmorti.setNumeroCuotas(resultadosStore.getString("NumeroCuotas"));
						arrendaAmorti.setFechaPrimerVen(resultadosStore.getString("FechaPrimerVen"));
						arrendaAmorti.setFechaUltimoVen(resultadosStore.getString("FechaUltimoVen"));
						arrendaAmorti.setMontoCuota(resultadosStore.getString("MontoCuota"));
						arrendaAmorti.setTotalCapital(resultadosStore.getString("TotalCapital"));
						arrendaAmorti.setTotalInteres(resultadosStore.getString("TotalInteres"));
						arrendaAmorti.setTotalIva(resultadosStore.getString("TotalIva"));
						arrendaAmorti.setTotalRenta(resultadosStore.getString("TotalRenta"));
						arrendaAmorti.setTotalPago(resultadosStore.getString("TotalPago"));
						arrendaAmorti.setCodigoError(resultadosStore.getString("NumErr"));
						arrendaAmorti.setMensajeError(resultadosStore.getString("ErrMen"));
						arrendaAmorti.setMontoIVASeguro(resultadosStore.getString("Tmp_MontoSegIva"));
						arrendaAmorti.setMontoIVASeguroVida(resultadosStore.getString("Tmp_MontoSegVidaIva"));

						matches2.add(arrendaAmorti);
					}
				}
				return matches2;
			}
		});
		ArrendamientosBean creditos = new  ArrendamientosBean();
		creditos.setNumTransacSim(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
		return matches;
	}


	/* PARA OBTENER LOS VALORES DEL CALULO */
	public ArrendamientosBean calculoAlta(ArrendamientosBean arrendamientosBean, int tipoCalculo) {
		ArrendamientosBean result = null;
		try{
			// Query con el Store Procedure
			String query = "call ARRENDACALMONTOSPRO(" +
					"?,?,?,?,?, ?,?,?,?,?," +
					"?,?,?,?,?, ?,?,?,?,?," +
					"?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteLong(arrendamientosBean.getClienteID()),
					Utileria.convierteDoble(arrendamientosBean.getMontoArrenda()),
					Utileria.convierteDoble(arrendamientosBean.getPorcEnganche()),
					Utileria.convierteEntero(arrendamientosBean.getTipoPagoSeguro()),
					Utileria.convierteDoble(arrendamientosBean.getMontoSeguroAnual()),

					Utileria.convierteEntero(arrendamientosBean.getTipoPagoSeguroVida()),
					Utileria.convierteDoble(arrendamientosBean.getMontoSeguroVidaAnual()),
					Utileria.convierteEntero(arrendamientosBean.getPlazo()),
					Utileria.convierteDoble(arrendamientosBean.getTasaFijaAnual()),
					Utileria.convierteDoble(arrendamientosBean.getMontoRenta()),

					Utileria.convierteDoble(arrendamientosBean.getMontoDeposito()),
					Utileria.convierteDoble(arrendamientosBean.getMontoComApe()),
					Utileria.convierteDoble(arrendamientosBean.getCantRentaDepo()),
					Utileria.convierteDoble(arrendamientosBean.getMontoEnganche()),
					Utileria.convierteDoble(arrendamientosBean.getOtroGastos()),

					Utileria.convierteDoble(arrendamientosBean.getMontoResidual()),
					Utileria.convierteEntero(arrendamientosBean.getSucursalID()),
					arrendamientosBean.getRentaAnticipada(),
					Utileria.convierteEntero(arrendamientosBean.getRentasAdelantadas()),
					arrendamientosBean.getAdelanto(),

					Utileria.convierteLong(arrendamientosBean.getNumTransacSim()),
					tipoCalculo,
					Constantes.salidaSI,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"ArrendamientosDAO.calculoAlta",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDACALMONTOSPRO( " + Arrays.toString(parametros) + ")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					ArrendamientosBean arrendaBean = new ArrendamientosBean();
					arrendaBean.setIvaMontoArrenda(resultSet.getString("Var_IVAMontoArrenda"));
					arrendaBean.setMontoEnganche(resultSet.getString("Var_MontoEnganche"));
					arrendaBean.setIvaEnganche(resultSet.getString("Var_IVAEnganche"));
					arrendaBean.setMontoFinanciado(resultSet.getString("Var_MontoFinanciado"));
					arrendaBean.setIvaComApe(resultSet.getString("Var_IVAComApe"));

					arrendaBean.setIvaDeposito(resultSet.getString("Var_IVADeposito"));
					arrendaBean.setIvaOtrosGastos(resultSet.getString("Var_IVAOtrosGastos"));
					arrendaBean.setMontoSeguro(resultSet.getString("Var_MontoSeg"));
					arrendaBean.setMontoSeguroVida(resultSet.getString("Var_MontoSegVida"));
					arrendaBean.setTotalPagoInicial(resultSet.getString("Var_TotalPagoInicial"));
					arrendaBean.setMontoDeposito(resultSet.getString("Var_MontoDeposito"));
					arrendaBean.setPorcEnganche(resultSet.getString("Par_PorcEnganche"));
					arrendaBean.setMontoSeguroAnual(resultSet.getString("Var_MontoSegAnual"));
					arrendaBean.setMontoSeguroVidaAnual(resultSet.getString("Var_MontoSegVidaAnual"));
					arrendaBean.setConcRentaAnticipada(resultSet.getString("Var_RentaAnt"));
					arrendaBean.setConcIvaRentaAnticipada(resultSet.getString("Var_IVARenAnt"));
					arrendaBean.setConcRentasAdelantadas(resultSet.getString("Var_RentasAd"));
					arrendaBean.setConcIvaRentasAdelantadas(resultSet.getString("Var_IVARentasAd"));
					arrendaBean.setCodigoError(resultSet.getString("NumErr"));
					arrendaBean.setMensajeError(resultSet.getString("ErrMen"));
				    return arrendaBean;
				}
			});
			result =  matches.size() > 0 ? (ArrendamientosBean) matches.get(0) : null;
		}catch(Exception e ){
			e.printStackTrace();
		}
		return result;
	}


	/* PARA OBTENER LA CONSULTA PRINCIPAL  */
	public ArrendamientosBean consultaPrincipal(ArrendamientosBean arrendamientosBean, int tipoConsulta) {
		ArrendamientosBean result = null;
		try{
			// Query con el Store Procedure
			String query = "call ARRENDAMIENTOSCON(" +
					"?,?,?,?,?, ?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteLong(arrendamientosBean.getArrendaID()),
					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,

					Constantes.STRING_VACIO,
					"ArrendamientosDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAMIENTOSCON( " + Arrays.toString(parametros) + ")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum)throws SQLException {
					ArrendamientosBean arrendaBean = new ArrendamientosBean();
					arrendaBean.setArrendaID(resultSet.getString("ArrendaID"));
					arrendaBean.setLineaArrendaID(resultSet.getString("LineaArrendaID"));
					arrendaBean.setClienteID(resultSet.getString("ClienteID"));
					arrendaBean.setNumTransacSim(resultSet.getString("NumTransacSim"));
					arrendaBean.setTipoArrenda(resultSet.getString("TipoArrenda"));
					arrendaBean.setMonedaID(resultSet.getString("MonedaID"));
					arrendaBean.setProductoArrendaID(resultSet.getString("ProductoArrendaID"));
					arrendaBean.setMontoArrenda(resultSet.getString("MontoArrenda"));
					arrendaBean.setIvaMontoArrenda(resultSet.getString("IVAMontoArrenda"));
					arrendaBean.setMontoEnganche(resultSet.getString("MontoEnganche"));
					arrendaBean.setIvaEnganche(resultSet.getString("IVAEnganche"));
					arrendaBean.setPorcEnganche(resultSet.getString("PorcEnganche"));
					arrendaBean.setMontoFinanciado(resultSet.getString("MontoFinanciado"));
					arrendaBean.setSeguroArrendaID(resultSet.getString("SeguroArrendaID"));
					arrendaBean.setTipoPagoSeguro(resultSet.getString("TipoPagoSeguro"));
					arrendaBean.setMontoSeguroAnual(resultSet.getString("MontoSeguroAnual"));
					arrendaBean.setSeguroVidaArrendaID(resultSet.getString("SeguroVidaArrendaID"));
					arrendaBean.setTipoPagoSeguroVida(resultSet.getString("TipoPagoSeguroVida"));
					arrendaBean.setMontoSeguroVidaAnual(resultSet.getString("MontoSeguroVidaAnual"));
					arrendaBean.setMontoResidual(resultSet.getString("MontoResidual"));
					arrendaBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
					arrendaBean.setFechaApertura(resultSet.getString("FechaApertura"));
					arrendaBean.setFechaPrimerVen(resultSet.getString("FechaPrimerVen"));
					arrendaBean.setFechaUltimoVen(resultSet.getString("FechaUltimoVen"));
					arrendaBean.setFechaLiquida(resultSet.getString("FechaLiquida"));
					arrendaBean.setPlazo(resultSet.getString("Plazo"));
					arrendaBean.setFrecuenciaPlazo(resultSet.getString("FrecuenciaPlazo"));
					arrendaBean.setTasaFijaAnual(resultSet.getString("TasaFijaAnual"));
					arrendaBean.setMontoRenta(resultSet.getString("MontoRenta"));
					arrendaBean.setMontoSeguro(resultSet.getString("MontoSeguro"));
					arrendaBean.setMontoSeguroVida(resultSet.getString("MontoSeguroVida"));
					arrendaBean.setCantRentaDepo(resultSet.getString("CantRentaDepo"));
					arrendaBean.setMontoDeposito(resultSet.getString("MontoDeposito"));
					arrendaBean.setIvaDeposito(resultSet.getString("IVADeposito"));
					arrendaBean.setMontoComApe(resultSet.getString("MontoComApe"));
					arrendaBean.setIvaComApe(resultSet.getString("IVAComApe"));
					arrendaBean.setOtroGastos(resultSet.getString("OtroGastos"));
					arrendaBean.setIvaOtrosGastos(resultSet.getString("IVAOtrosGastos"));
					arrendaBean.setTotalPagoInicial(resultSet.getString("TotalPagoInicial"));
					arrendaBean.setTipCobComMorato(resultSet.getString("TipCobComMorato"));
					arrendaBean.setFactorMora(resultSet.getString("FactorMora"));
					arrendaBean.setCantCuota(resultSet.getString("CantCuota"));
					arrendaBean.setMontoCuota(resultSet.getString("MontoCuota"));
					arrendaBean.setEstatus(resultSet.getString("Estatus"));
					arrendaBean.setSucursalID(resultSet.getString("SucursalID"));
					arrendaBean.setUsuarioAlta(resultSet.getString("UsuarioAlta"));
					arrendaBean.setUsuarioAutoriza(resultSet.getString("UsuarioAutoriza"));
					arrendaBean.setFechaAutoriza(resultSet.getString("FechaAutoriza"));
					arrendaBean.setFechaTraspasaVen(resultSet.getString("FechaTraspasaVen"));
					arrendaBean.setFechaRegulariza(resultSet.getString("FechaRegulariza"));
					arrendaBean.setUsuarioCancela(resultSet.getString("UsuarioCancela"));
					arrendaBean.setFechaCancela(resultSet.getString("FechaCancela"));
					arrendaBean.setMotivoCancela(resultSet.getString("MotivoCancela"));
					arrendaBean.setSaldoCapVigente(resultSet.getString("SaldoCapVigente"));
					arrendaBean.setSaldoCapAtrasad(resultSet.getString("SaldoCapAtrasad"));
					arrendaBean.setSaldoCapVencido(resultSet.getString("SaldoCapVencido"));
					arrendaBean.setMontoIVACapital(resultSet.getString("MontoIVACapital"));
					arrendaBean.setSaldoInteresVigent(resultSet.getString("SaldoInteresVigent"));
					arrendaBean.setSaldoInteresAtras(resultSet.getString("SaldoInteresAtras"));
					arrendaBean.setSaldoInteresVen(resultSet.getString("SaldoInteresVen"));
					arrendaBean.setMontoIVAInteres(resultSet.getString("MontoIVAInteres"));
					arrendaBean.setSaldoSeguro(resultSet.getString("SaldoSeguro"));
					arrendaBean.setMontoIVASeguro(resultSet.getString("MontoIVASeguro"));
					arrendaBean.setSaldoSeguroVida(resultSet.getString("SaldoSeguroVida"));
					arrendaBean.setMontoIVASeguroVida(resultSet.getString("MontoIVASeguroVida"));
					arrendaBean.setSaldoMoratorios(resultSet.getString("SaldoMoratorios"));
					arrendaBean.setMontoIVAMora(resultSet.getString("MontoIVAMora"));
					arrendaBean.setSaldComFaltPago(resultSet.getString("SaldComFaltPago"));
					arrendaBean.setMontoIVAComFalPag(resultSet.getString("MontoIVAComFalPag"));
					arrendaBean.setSaldoOtrasComis(resultSet.getString("SaldoOtrasComis"));
					arrendaBean.setMontoIVAComisi(resultSet.getString("MontoIVAComisi"));
					arrendaBean.setDiaPagoProd(resultSet.getString("DiaPagoProd"));
					arrendaBean.setPagareImpreso(resultSet.getString("PagareImpreso"));
					arrendaBean.setFechaInhabil(resultSet.getString("FechaInhabil"));
					arrendaBean.setTipoPrepago(resultSet.getString("TipoPrepago"));

					arrendaBean.setRentaAnticipada(resultSet.getString("EsRenAnticipada"));
					arrendaBean.setRentasAdelantadas(resultSet.getString("NumRenAdelantada"));
					arrendaBean.setAdelanto(resultSet.getString("TipRenAdelanta"));
					arrendaBean.setConcRentaAnticipada(resultSet.getString("RentaAnticipada"));
					arrendaBean.setConcIvaRentaAnticipada(resultSet.getString("IVARentaAnticipa"));
					arrendaBean.setConcRentasAdelantadas(resultSet.getString("RentasAdelantadas"));
					arrendaBean.setConcIvaRentasAdelantadas(resultSet.getString("IVARenAdelanta"));

				    return arrendaBean;
				}
			});
			result =  matches.size() > 0 ? (ArrendamientosBean) matches.get(0) : null;
		}catch(Exception e ){
			e.printStackTrace();
		}
		return result;
	}
	/**/
	public List<?> listaGralArrenda(final ArrendamientosBean arrendamientosBean, final int tipoLista){
		//transaccionDAO.generaNumeroTransaccion();
		List<?> matches =new  ArrayList<Object>();
		final List<ArrendamientosBean> matches2 =new  ArrayList<ArrendamientosBean>();
		matches =(List<?>) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ARRENDAMIENTOSLIS(" +
						"?,?,?,?,?, ?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setString("Par_Nombre",arrendamientosBean.getArrendaID());
				sentenciaStore.setInt("Par_NumLis",tipoLista);
				sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
				sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
				sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
				sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
				sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
				sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
				sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
				return sentenciaStore;
			}
		},new CallableStatementCallback<Object>() {
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						ArrendamientosBean	respuesta	= new ArrendamientosBean();
						respuesta.setArrendaID(resultadosStore.getString("ArrendaID"));
						respuesta.setNombreCompleto(resultadosStore.getString("NombreCompleto"));
						respuesta.setEstatus(resultadosStore.getString("Estatus"));
						respuesta.setFechaApertura(resultadosStore.getString("FechaApertura"));
						respuesta.setFechaUltimoVen(resultadosStore.getString("FechaUltimoVen"));
						respuesta.setDescripProducto(resultadosStore.getString("Descripcion"));
						matches2.add(respuesta);
					}
				}
				return matches2;
			}
		});
		return matches;
	}
	/* lista principal de arrendamientos*/
	public List<?> listaPrincipal(final ArrendamientosBean arrendamientosBean, final int tipoLista){
		//transaccionDAO.generaNumeroTransaccion();
		List<?> matches =new  ArrayList<Object>();
		final List<ArrendamientosBean> matches2 =new  ArrayList<ArrendamientosBean>();
		matches =(List<?>) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
			public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
				String query = "call ARRENDAMIENTOSLIS(" +
						"?,?,?,?,?, ?,?,?,?);";
				CallableStatement sentenciaStore = arg0.prepareCall(query);
				sentenciaStore.setString("Par_Nombre",arrendamientosBean.getArrendaID());
				sentenciaStore.setInt("Par_NumLis",tipoLista);
				sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
				sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
				sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
				sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
				sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
				sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
				sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
				return sentenciaStore;
			}
		},new CallableStatementCallback<Object>() {
			public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
				if(callableStatement.execute()){
					ResultSet resultadosStore = callableStatement.getResultSet();
					while (resultadosStore.next()) {
						ArrendamientosBean	respuesta	= new ArrendamientosBean();
						respuesta.setArrendaID(resultadosStore.getString("ArrendaID"));
						respuesta.setNombreCompleto(resultadosStore.getString("NombreCompleto"));
						respuesta.setEstatus(resultadosStore.getString("Estatus"));
						respuesta.setFechaApertura(resultadosStore.getString("FechaApertura"));
						respuesta.setFechaUltimoVen(resultadosStore.getString("FechaUltimoVen"));
						respuesta.setDescripProducto(resultadosStore.getString("Descripcion"));
						matches2.add(respuesta);
					}
				}
				return matches2;
			}
		});
		return matches;
	}

	/*Consulta para generales de arrendamiento */
	public ArrendamientosBean consultaGralArrendamiento(ArrendamientosBean arrendamientosBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call ARRENDAMIENTOSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				arrendamientosBean.getArrendaID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ArrendamientosDAO.consultaGralArrendamiento",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAMIENTOSCON(  " + Arrays.toString(parametros) + ")");
		List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ArrendamientosBean arrendamientosBean = new ArrendamientosBean();
				try{
					arrendamientosBean.setArrendaID(resultSet.getString("ArrendaID"));
					arrendamientosBean.setNombreCliente(resultSet.getString("NombreCompleto"));
					arrendamientosBean.setClienteID(resultSet.getString("ClienteID"));
					arrendamientosBean.setLineaArrendaID(resultSet.getString("LineaArrendaID"));
					arrendamientosBean.setProductoArrendaID(resultSet.getString("ProductoArrendaID"));
					arrendamientosBean.setMonedaID(resultSet.getString("MonedaID"));
					arrendamientosBean.setMonedaDescri(resultSet.getString("Descripcion"));
					arrendamientosBean.setEstatus(resultSet.getString("Estatus"));
					arrendamientosBean.setDiasFaltaPago(resultSet.getString("DiasFaltaPago"));
					arrendamientosBean.setSucursalID(resultSet.getString("SucursalID"));
					arrendamientosBean.setFechaApertura(resultSet.getString("FechaApertura"));
					arrendamientosBean.setTasaFijaAnual(resultSet.getString("TasaFijaAnual"));
					arrendamientosBean.setFechaProxPago(resultSet.getString("FechaProxPago"));
					arrendamientosBean.setNombreProducto(resultSet.getString("NombreProd"));

				} catch(Exception ex){
					ex.printStackTrace();
				}
			    return arrendamientosBean;
			}
		});
		return matches.size() > 0 ? (ArrendamientosBean) matches.get(0) : null;
	}

	/**
	 * Método Pago del arrendamiento con Pago en Efectivo
	 * @param arrendamientosBean : Bean con la información de Crédito de Arrendamiento
	 * @param numTransaccion : Número de Transacción
	 * @param numPoliza: Número de Poliza
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean PagoArrendamiento(final ArrendamientosBean arrendamientosBean, final long numTransaccion, final int numPoliza, final boolean origenVentanilla) {
		//public MensajeTransaccionBean PagoArrendamiento(final ArrendamientosBean arrendamientosBean, final long numTransaccion,) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PAGOARRENDAMIENTOPRO(?,?,?, ?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setLong("Par_ArrendaID", Utileria.convierteLong(arrendamientosBean.getArrendaID()));
							sentenciaStore.setDouble("Par_MontoPagar", Utileria.convierteDoble(arrendamientosBean.getMontoPagarArrendamiento()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(arrendamientosBean.getMonedaID()));

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_Salida", salidaPantalla);
							sentenciaStore.setString("Par_AltaEncPoliza", altaEnPolizaNo);
							sentenciaStore.registerOutParameter("Var_MontoPago", Types.DECIMAL);

							sentenciaStore.setLong("Var_Poliza", numPoliza);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

							sentenciaStore.setString("Par_ModoPago", Constantes.MODO_PAGO_EFECTIVO);

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "ArrendamientosDAO.PagoArrendamiento");
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					}, new CallableStatementCallback<Object>() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion(e.getMessage());
					}
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago del arrendamiento en efectivo", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago del arrendamiento en efectivo", e);
					}
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * DAO para actualizar el estatus al imprimir el pagare
	 * @param tipoActualizacion
	 * @param arrendamientosBean
	 * @return
	 * @author vsanmiguel
	 */
	public MensajeTransaccionBean actualizaEstatusImpPagare(final int tipoActualizacion, final ArrendamientosBean arrendamientosBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL ARRENDAMIENTOSACT(?,?,  ?,?,?,  ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_ArrendaID", Utileria.convierteLong(arrendamientosBean.getArrendaID()));
									sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

									sentenciaStore.setString("Par_Salida", salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","ArrendamientosDAO.actualizaEstatusImpPagare");
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " ArrendamientosDAO.actualizaEstatusImpPagare");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " ArrendamientosDAO.actualizaEstatusImpPagare");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al actualizar el estatus de impresión del pagaré" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}// fin del metodo: actualizaEstatusImpPagare

	/**
	 * Consulta de estatus de impresion de pagare (C=5)
	 * @param arrendamientosBean
	 * @param tipoConsulta
	 * @return
	 * @author vsanmiguel
	 */
	public ArrendamientosBean consultaEstatusImpresionPagare(ArrendamientosBean arrendamientosBean, int tipoConsulta) {
		ArrendamientosBean arrendamientoBean = null;
		try{
			//Query con el Store Procedure
			String query = "call ARRENDAMIENTOSCON(?,?,	 ?,?,?,?,?,?,?);";
			Object[] parametros = {	arrendamientosBean.getArrendaID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ArrendamientosDAO.consultaPorArrendaID",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAMIENTOSCON(" + Arrays.toString(parametros) + ")");

			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ArrendamientosBean arrendamiento = new ArrendamientosBean();
					arrendamiento.setArrendaID(resultSet.getString("ArrendaID"));
					arrendamiento.setPagareImpreso(resultSet.getString("PagareImpreso"));
					return arrendamiento;
				}
			});
			arrendamientoBean= matches.size() > 0 ? (ArrendamientosBean) matches.get(0) : null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de estatus de impresión de pagaré de arrendamiento.", e);
			e.printStackTrace();
		}
		return arrendamientoBean;
	}// fin del metodo: consultaEstatusImpresionPagare

	// Metodo para consultar los detalles del pago de Arrendamiento
	public DetallePagoArrendaBean consultaDetallePagoArrenda(final DetallePagoArrendaBean detallePagoBean, final int tipoConsulta) {
		DetallePagoArrendaBean detallePago = null;
		try{
				String query = "call DETALLEPAGARRENDACON(?,?,?,?,?,  ?,?,?,?,?);";
				Object[] parametros = {

										Utileria.convierteLong(detallePagoBean.getArrendaID()),
										detallePagoBean.getFechaPago(),
										tipoConsulta,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										OperacionesFechas.FEC_VACIA,
										Constantes.STRING_VACIO,
										"Arrendamientos DAO ",
										Constantes.ENTERO_CERO,
										detallePagoBean.getTransaccion()};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DETALLEPAGARRENDACON(" + Arrays.toString(parametros) +")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						DetallePagoArrendaBean detallePagoBean = new DetallePagoArrendaBean();

						detallePagoBean.setMontoTotal(resultSet.getString("MontoTotal"));
						detallePagoBean.setCapital(resultSet.getString("Capital"));
						detallePagoBean.setInteres(resultSet.getString("Interes"));
						detallePagoBean.setMontoIVAIntere(resultSet.getString("MontoIVAIntere"));
						detallePagoBean.setMontoIVACap(resultSet.getString("MontoIVACap"));
						detallePagoBean.setMontoIntMora(resultSet.getString("MontoIntMora"));
						detallePagoBean.setMontoIVAMora(resultSet.getString("MontoIVAMora"));
						detallePagoBean.setMontoIVAComFaltPag(resultSet.getString("MontoIVAComFaltPag"));
						detallePagoBean.setMontoComFaltPag(resultSet.getString("MontoComFaltPag"));
						detallePagoBean.setMontoOtrasComis(resultSet.getString("MontoOtrasComis"));
						detallePagoBean.setMontoIVAOtrasComis(resultSet.getString("MontoIVAOtrasComis"));
						detallePagoBean.setMontoSegInmob(resultSet.getString("MontoSegInmob"));
						detallePagoBean.setMontoIVASegInmob(resultSet.getString("MontoIVASegInmob"));
						detallePagoBean.setMontoSegVida(resultSet.getString("MontoSegVida"));
						detallePagoBean.setMontoIVASegVida(resultSet.getString("MontoIVASegVida"));
						detallePagoBean.setTotalArrendamiento(resultSet.getString("TotalArrendamiento"));
						detallePagoBean.setMontoProxPago(resultSet.getString("MontoProxPago"));
						detallePagoBean.setFechaProxPago(resultSet.getString("FechaProxPago"));
						detallePagoBean.setHora(resultSet.getString("Hora"));
						detallePagoBean.setTransaccion(resultSet.getString("Transaccion"));
						detallePagoBean.setClienteID(resultSet.getString("ClienteID"));
						detallePagoBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
						detallePagoBean.setArrendaID(resultSet.getString("ArrendaID"));

						return detallePagoBean;
					}
				});
				detallePago= matches.size() > 0 ? (DetallePagoArrendaBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al Consultar datos del pago arrendamiento", e);
			}
			return detallePago;
		}//fin metodo de detalle de pago


	/**
	 * Metodo de lista para los arrendamients vigentes y vencidos
	 * para la pantalla movimientos de cargo y abono.
	 * @param arrendamientosBean
	 * @param tipoLista
	 * @return
	 */
	public List listaArrendaMovsCA(ArrendamientosBean arrendamientosBean, int tipoLista) {
		List arrendamientos = null;
		try{
			//Query con el Store Procedure
			String query = "call ARRENDAMIENTOSLIS(?,?,	 ?,?,?,?,?,?,?);";
			Object[] parametros = {	arrendamientosBean.getArrendaID(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ArrendamientosDAO.listaArrendaVigenteVencido",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ARRENDAMIENTOSLIS(" + Arrays.toString(parametros) + ")");

			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ArrendamientosBean arrendamiento = new ArrendamientosBean();
					arrendamiento.setArrendaID(resultSet.getString("ArrendaID"));
					arrendamiento.setNombreCliente(resultSet.getString("Cliente"));
					arrendamiento.setProductoArrendaDescri(resultSet.getString("ProductoDescri"));

					return arrendamiento;
				}
			});
			arrendamientos = matches.size() > 0 ? matches : null;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la lista de arrendamiento.", e);
			e.printStackTrace();
		}
		return arrendamientos;
	}// fin del metodo


	//** GET y SET
	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}
