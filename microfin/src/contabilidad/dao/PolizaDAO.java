package contabilidad.dao;
import fira.bean.RecupCarteraCastAgroBean;
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
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import ventanilla.bean.IngresosOperacionesBean;
import contabilidad.bean.DetallePolizaBean;
import contabilidad.bean.PolizaBean;
import contabilidad.bean.ReportePolizaBean;
import contabilidad.servicio.PolizaServicio.Enum_Tra_Poliza;

public class PolizaDAO extends BaseDAO{
	//Variables
	DetallePolizaDAO detallePolizaDAO = null;

	public static interface Enum_TipoBajaPoliza {
		String bajaPolizaId 		= "1";
		String bajaTransId 			= "2";
	}

	ParametrosSesionBean parametrosSesionBean;
	public PolizaDAO() {
		super();
	}

	public MensajeTransaccionBean alta(final PolizaBean poliza) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		// para cuando llega repetido el conceptoID para que ya no lo duplique
		String[] valuesArray = (poliza.getConceptoID()).split(",\\s*");
		  for (String concepto : valuesArray) {
			  poliza.setConceptoID(concepto);

			}
		  String[] valoresArray = (poliza.getConcepto()).split(",\\s*");
		  for (String conceptoDescripcion : valoresArray) {
			  poliza.setConcepto(conceptoDescripcion);
			     }


		try{
			String query = "call POLIZACONTABLEALT(?,?,?,?,?,?, ?,?,?,?,?,?);";
			Object[] parametros = {
					poliza.getPolizaID(),
					parametrosAuditoriaBean.getEmpresaID(),
					poliza.getFecha(),
					poliza.getTipo(),
					poliza.getConceptoID(),
					poliza.getConcepto(),

					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PolizaDAO.alta",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call POLIZACONTABLEALT(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					mensaje.setConsecutivoString(resultSet.getString(4));
					return mensaje;
				}
			});
			mensaje = matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
			return mensaje;
		} catch (Exception e) {
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de poliza contable", e);
		}
		return mensaje;

	}

	public MensajeTransaccionBean altaPlantillaPoliza(final PolizaBean poliza, final String desPlantilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		try{
			String query = "call POLIZACONTAPLANALT(?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					poliza.getFecha(),
					poliza.getTipo(),
					poliza.getConceptoID(),
					poliza.getConcepto(),
					desPlantilla,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"PolizaDAO.altaPlantilla",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call POLIZACONTAPLANALT(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
					mensaje.setDescripcion(resultSet.getString(2));
					mensaje.setNombreControl(resultSet.getString(3));
					mensaje.setConsecutivoString(resultSet.getString(4));
					return mensaje;
				}
			});
			mensaje = matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
			return mensaje;
		} catch (Exception e) {
			if(mensaje.getNumero()==0){
				mensaje.setNumero(999);
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de plan de poliza contable", e);
		}
		return mensaje;

	}


	public MensajeTransaccionBean altaPolizaInfAdicional(final PolizaBean poliza) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call POLIZAINFADICIONALALT("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_PolizaID", poliza.getPolizaID());
									sentenciaStore.setString("Par_Movimiento", poliza.getMovimiento());
									sentenciaStore.setString("Par_InstitucionID", poliza.getInstitucionID());
									sentenciaStore.setString("Par_NumCtaInstit", poliza.getNumCtaBancaria());
									sentenciaStore.setString("Par_TipoMovimientoID", poliza.getTipoDoc());

									sentenciaStore.setString("Par_Folio", poliza.getNumCheque());
									sentenciaStore.setString("Par_PersonaID", poliza.getPagadorID());
									sentenciaStore.setString("Par_Importe", poliza.getImporte());
									sentenciaStore.setString("Par_Referencia", poliza.getReferenciaDoc());
									sentenciaStore.setString("Par_MetodoPagoID", poliza.getMetodoPago());

									sentenciaStore.setString("Par_MonedaID", poliza.getMonedaIDDoc());
									sentenciaStore.setInt("Par_InstitucionOrigen", Utileria.convierteEntero(poliza.getInstOrigenID()));
									sentenciaStore.setString("Par_ClabeOrigen", poliza.getCtaClabeOrigen());
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "procesaCatalogoIngresos");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.grabar");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.grabar");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en grabar Catalogo Egresos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean modificaPolizaInfAdicional(final PolizaBean poliza) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {

			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call POLIZAINFADICIONALMOD("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?);";

									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_PolizaID", poliza.getPolizaID());
									sentenciaStore.setString("Par_Movimiento", poliza.getMovimiento());
									sentenciaStore.setString("Par_InstitucionID", poliza.getInstitucionID());
									sentenciaStore.setString("Par_NumCtaInstit", poliza.getNumCtaBancaria());
									sentenciaStore.setString("Par_TipoMovimientoID", poliza.getTipoDoc());

									sentenciaStore.setString("Par_Folio", poliza.getNumCheque());
									sentenciaStore.setString("Par_PersonaID", poliza.getPagadorID());
									sentenciaStore.setString("Par_Importe", poliza.getImporte());
									sentenciaStore.setString("Par_Referencia", poliza.getReferenciaDoc());
									sentenciaStore.setString("Par_MetodoPagoID", poliza.getMetodoPago());

									sentenciaStore.setString("Par_MonedaID", poliza.getMonedaIDDoc());
									sentenciaStore.setInt("Par_InstitucionOrigen", Utileria.convierteEntero(poliza.getInstOrigenID()));
									sentenciaStore.setString("Par_ClabeOrigen", poliza.getCtaClabeOrigen());
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
									sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "procesaCatalogoIngresos");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Utileria.convierteEntero(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.grabar");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CatIngresosEgresosDAO.grabar");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en grabar Catalogo Egresos", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	public MensajeTransaccionBean modificaPolizaPlantilla(final PolizaBean poliza) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
					//Query cons el Store Procedure
					String query = "call POLIZACONTAPLANMOD(?,?,?,?,?,?,?, ?,?,?,?,?,?);";
					Object[] parametros = {
							poliza.getPolizaID(),
							poliza.getDesPlantilla(),
							poliza.getEmpresaID(),
							poliza.getFecha(),
							poliza.getTipo(),
							poliza.getConceptoID(),
							poliza.getConcepto(),

							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"PolizaDAO.modificaPoliza",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()

							};
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
						mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
						mensaje.setDescripcion(resultSet.getString(2));
						mensaje.setNombreControl(resultSet.getString(3));
						mensaje.setConsecutivoString(resultSet.getString(4));
						return mensaje;
					}
				});
				mensaje = matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				return mensaje;
			} catch (Exception e) {
				if(mensaje.getNumero()==0){
					mensaje.setNumero(999);
				}
				mensaje.setDescripcion(e.getMessage());
				e.printStackTrace();
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de plan de poliza", e);
			}
			return mensaje;

		}

	public MensajeTransaccionBean grabaListaPoliza(final PolizaBean polizaBean, final List listaDetalle , final int tipoTransaccion, final String desPlantilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			generaPolizaIDGenericoManual(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		  }

		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					DetallePolizaBean detallePoliza = new DetallePolizaBean();

					String consecutivo= polizaBean.getPolizaID();
					for(int i=0; i<listaDetalle.size(); i++){
						detallePoliza = (DetallePolizaBean)listaDetalle.get(i);
						mensajeBean = detallePolizaDAO.alta(detallePoliza, consecutivo);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					if (tipoTransaccion==Enum_Tra_Poliza.polizaPlantilla){
						mensajeBean = grabaListaPlantilla(polizaBean, desPlantilla, listaDetalle);
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Poliza Agregada Exitosamente: "+consecutivo);
					mensajeBean.setNombreControl("polizaID");
					mensajeBean.setConsecutivoString(consecutivo);
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de plan de poliza", e);
				}
				return mensajeBean;
			}
		});

		}else{
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
	}

	public MensajeTransaccionBean grabaListaPlantilla(final PolizaBean polizaBean, final String desPlantilla, final List listaDetalle ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					DetallePolizaBean detallePoliza;
					mensajeBean = altaPlantillaPoliza(polizaBean,desPlantilla);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					String consecutivo= mensajeBean.getConsecutivoString();
					for(int i=0; i<listaDetalle.size(); i++){
						detallePoliza = (DetallePolizaBean)listaDetalle.get(i);
						mensajeBean = detallePolizaDAO.altaPlantilla(detallePoliza, consecutivo);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Plantilla Poliza Agregada Exitosamente: " +consecutivo);
					mensajeBean.setNombreControl("plantillaID");
					mensajeBean.setConsecutivoString(consecutivo);
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de plan depoliza", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaListaPlantilla(final PolizaBean polizaBean, final List listaDetalle ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = detallePolizaDAO.bajaDetallePolizaPlantilla(polizaBean);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					DetallePolizaBean detallePoliza;
					mensajeBean = modificaPolizaPlantilla(polizaBean);

					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					String consecutivo= mensajeBean.getConsecutivoString();
					for(int i=0; i<listaDetalle.size(); i++){
						detallePoliza = (DetallePolizaBean)listaDetalle.get(i);
						mensajeBean = detallePolizaDAO.altaPlantilla(detallePoliza, consecutivo);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
					mensajeBean = new MensajeTransaccionBean();
					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Plantilla Poliza Modificada Exitosamente: "+consecutivo);
					mensajeBean.setNombreControl("plantillaID");
					mensajeBean.setConsecutivoString(consecutivo);
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de plan depoliza", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public PolizaBean consultaPrincipal(PolizaBean poliza, int tipoConsulta){
		String query = "call MAESTROPOLIZACON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
				poliza.getPolizaID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PolizaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PolizaBean poliza = new PolizaBean();
				poliza.setPolizaID(resultSet.getString(1));
				poliza.setFecha(resultSet.getString(2));
				poliza.setTipo(resultSet.getString(3));
				poliza.setConceptoID(resultSet.getString(4));
				poliza.setConcepto(resultSet.getString(5));

				return poliza;
			}
		});
		return matches.size() > 0 ? (PolizaBean) matches.get(0) : null;
	}

	public PolizaBean consultaPrincipalPlantilla(PolizaBean polizaContaPlan, int tipoConsulta){
		String query = "call POLIZACONTAPLANCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
				polizaContaPlan.getPolizaID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PolizaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PolizaBean polizaContaPlan = new PolizaBean();
				polizaContaPlan.setPolizaID(resultSet.getString(1));
				polizaContaPlan.setEmpresaID(resultSet.getString(2));
				polizaContaPlan.setFecha(resultSet.getString(3));
				polizaContaPlan.setTipo(resultSet.getString(4));
				polizaContaPlan.setConceptoID(resultSet.getString(5));
				polizaContaPlan.setConcepto(resultSet.getString(6));
				polizaContaPlan.setDesPlantilla(resultSet.getString(7));
				return polizaContaPlan;
			}
		});
		return matches.size() > 0 ? (PolizaBean) matches.get(0) : null;
	}

	// Consulta Informacion Adicional de la Poliza
	public PolizaBean consultaPolizaInfAdicional(PolizaBean poliza, int tipoConsulta){

		String query = "call POLIZAINFADICIONALCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = {
				poliza.getPolizaID(),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PolizaDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call POLIZAINFADICIONALCON(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PolizaBean poliza = new PolizaBean();

				poliza.setMovimiento(resultSet.getString("Movimiento"));
				poliza.setInstitucionID(resultSet.getString("InstitucionID"));
				poliza.setNumCtaBancaria(resultSet.getString("NumCtaInstit"));
				poliza.setCuentaClabe(resultSet.getString("CueClave"));
				poliza.setTipoDoc(resultSet.getString("TipoMovimiento"));
				poliza.setNumCheque(resultSet.getString("Folio"));
				poliza.setPagadorID(resultSet.getString("PersonaID"));
				poliza.setImporte(resultSet.getString("Importe"));
				poliza.setReferenciaDoc(resultSet.getString("Referencia"));
				poliza.setMetodoPago(resultSet.getString("MetodoPagoID"));
				poliza.setMonedaIDDoc(resultSet.getString("MonedaID"));
				poliza.setTipoCambio(resultSet.getString("TipoCambio"));
				poliza.setInstOrigenID(resultSet.getString("InstitucionOrigen"));
				poliza.setCtaClabeOrigen(resultSet.getString("CueClaveOrigen"));

				return poliza;
			}
		});
		return matches.size() > 0 ? (PolizaBean) matches.get(0) : null;
	}

	//Lista de descripcion
	public List listaPlantillaPoliza(PolizaBean polizaBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call POLIZACONTAPLANLIS(?,?, ?,?,?,?,?,?);";
		Object[] parametros = {
				polizaBean.getDesPlantilla(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"PolizaDAO.listaPlantillaPoliza",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PolizaBean polizaBean = new PolizaBean();
				polizaBean.setPolizaID(String.valueOf(resultSet.getInt(1)));;
				polizaBean.setDesPlantilla(resultSet.getString(2));
				return polizaBean;
			}
		});

		return matches;
	}
	//lista poliza contable
	public List listaPolizaContable(PolizaBean polizaBean, int tipoLista) {
		//Query con el Store Procedure
		String query = "call POLIZACONTABLELIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				polizaBean.getConcepto(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call POLIZACONTABLELIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				PolizaBean polizaBean = new PolizaBean();
				polizaBean.setPolizaID(String.valueOf(resultSet.getInt(1)));;
				polizaBean.setFecha(resultSet.getString(2));
				polizaBean.setConcepto(resultSet.getString(3));
				return polizaBean;
			}
		});

		return matches;
	}

	/**
	 * Método para dar de alta una Póliza Contable.
	 * @param polizaBean : Clase bean con los parámetros de entrada al SP.
	 * @param numTransaccion : Número de Transacción.
	 * @return MensajeTransaccionBean : Clase bean con el resultado del SP.
	 * @author pmontero
	 */
	public MensajeTransaccionBean altaPoliza(final PolizaBean polizaBean, final long numTransaccion){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call MAESTROPOLIZASALT(" +
																	"	?,?,?,?,?," +
																	"	?,?,?,?,?," +
																	"	?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.registerOutParameter("Par_Poliza", Types.BIGINT);
								sentenciaStore.setInt("Par_Empresa",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setDate("Par_Fecha",OperacionesFechas.conversionStrDate(polizaBean.getFecha()));
								sentenciaStore.setString("Par_Tipo",polizaBean.getTipo());
								sentenciaStore.setInt("Par_ConceptoID",Utileria.convierteEntero(polizaBean.getConceptoID()));

								sentenciaStore.setString("Par_Concepto",polizaBean.getConcepto());
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Constantes.ENTERO_CERO);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.CHAR);
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de poliza maestro ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para dar de alta la Poliza
	 * @param polizaBean :  Bean con la información para dar de alta la Poliza
	 * @param numTransaccion : Número de Transacción
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean altaPoliza(final PolizaBean polizaBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call MAESTROPOLIZASALT(" + "	?,?,?,?,?," + "	?,?,?,?,?," + "	?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.registerOutParameter("Par_Poliza", Types.BIGINT);
							sentenciaStore.setInt("Par_Empresa", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setDate("Par_Fecha", OperacionesFechas.conversionStrDate(polizaBean.getFecha()));
							sentenciaStore.setString("Par_Tipo", polizaBean.getTipo());
							sentenciaStore.setInt("Par_ConceptoID", Utileria.convierteEntero(polizaBean.getConceptoID()));

							sentenciaStore.setString("Par_Concepto", polizaBean.getConcepto());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.CHAR);
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);

							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

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
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de poliza maestro ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método para dar de baja los encabezados de las polizas contables
	 * @param polizaBean Bean con los datos para dar de baja la poliza
	 * @return
	 */
	public MensajeTransaccionBean bajaPoliza(final PolizaBean polizaBean){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call MAESTROPOLIZABAJ("
										+ "?,?,?,?,?,    "
										+ "?,?,?,?,?,    "
										+ "?,?,?,?,?,    "
										+ "?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(polizaBean.getPolizaID()));
								sentenciaStore.setLong("Par_Transaccion",Utileria.convierteLong(polizaBean.getNumTransaccion()));
								sentenciaStore.setInt("Par_NumErrPol",Utileria.convierteEntero(polizaBean.getNumErrPol()));
								sentenciaStore.setString("Par_ErrMenPol",polizaBean.getErrMenPol());
								sentenciaStore.setString("Par_DescProceso",polizaBean.getDescProceso());

								sentenciaStore.setInt("Par_Tipo",Utileria.convierteEntero(polizaBean.getTipo()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

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
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de poliza contable ", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List <ReportePolizaBean>consultaPolizaContable(ReportePolizaBean reportePolizaBean){
		String query = "call POLIZACONTABLEREP(?,?,?,?,?, ?,?,?,?,?, ?,?);";
		System.out.println("Uausrio = "+reportePolizaBean.getUsuarioID());
		Object[] parametros = {
				reportePolizaBean.getFechaInicial(),
				reportePolizaBean.getFechaFinal(),
				reportePolizaBean.getPolizaID(),
				reportePolizaBean.getNumeroTransaccion(),
				reportePolizaBean.getSucursalID(),
				reportePolizaBean.getMonedaID(),
				reportePolizaBean.getPrimerRango(),
				reportePolizaBean.getSegundoRango(),
				reportePolizaBean.getPrimerCentroCostos(),
				reportePolizaBean.getSegundoCentroCostos(),
				reportePolizaBean.getTipoInstrumentoID(),
				reportePolizaBean.getUsuarioID()

				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call POLIZACONTABLEREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ReportePolizaBean reportePoliza = new ReportePolizaBean();

				reportePoliza.setFecha(resultSet.getString("Fecha"));
				reportePoliza.setTipo(resultSet.getString("Tipo"));
				reportePoliza.setPolizaID(resultSet.getLong("PolizaID"));
				reportePoliza.setConcepto(resultSet.getString("Concepto"));
				reportePoliza.setInstrumento(resultSet.getString("Instrumento"));
				reportePoliza.setCuentaCompleta(resultSet.getString("CuentaCompleta"));
				reportePoliza.setDetDescri(resultSet.getString("DetDescri"));
				reportePoliza.setReferencia(resultSet.getString("Referencia"));
				reportePoliza.setCargos(resultSet.getString("Cargos"));
				reportePoliza.setAbonos(resultSet.getString("Abonos"));
				reportePoliza.setCueDescri(resultSet.getString("CueDescri"));
				reportePoliza.setMonedaID(resultSet.getInt("MonedaID"));
				reportePoliza.setDescripcion(resultSet.getString("Descripcion"));
				reportePoliza.setSucursalID(resultSet.getInt("SucursalID"));
				reportePoliza.setNombreSucurs(resultSet.getString("NombreSucurs"));
				reportePoliza.setCentroCostoID(resultSet.getString("CentroCostoID"));
				reportePoliza.setTipoInstrumentoID(resultSet.getString("TipoInstrumentoID"));
				reportePoliza.setNombCompletoCli(resultSet.getString("NombreCompleto"));
				reportePoliza.setNombreUsuario(resultSet.getString("NomUsuario"));
				reportePoliza.setUsuarioID(resultSet.getString("UsuarioID"));

				return reportePoliza;
			}
		});
		return matches;
	}

	public MensajeTransaccionBean generaPolizaID(final IngresosOperacionesBean ingresosOperacionesBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				PolizaBean polizaBean=new PolizaBean();
				try {
					Date date = parametrosSesionBean.getFechaSucursal();
					DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
					String fecha = dateFormat.format(date);
					polizaBean.setFecha(fecha);
					polizaBean.setTipo(ingresosOperacionesBean.polizaAutomatica);
					polizaBean.setConceptoID(ingresosOperacionesBean.getConceptoCon());
					polizaBean.setConcepto(ingresosOperacionesBean.getDescripcionMov());
					mensajeBean = altaPoliza(polizaBean,numTransaccion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					ingresosOperacionesBean.setPolizaID(mensajeBean.getConsecutivoString());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al Generar PolizaID", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//Funcion generica para generar numero de poliza
	public MensajeTransaccionBean generaPolizaIDGenerico(final PolizaBean polizaBean,final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					if( polizaBean.getFecha() == null || polizaBean.getFecha().isEmpty()){
						Date date = parametrosSesionBean.getFechaSucursal();
						DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
						String fecha = dateFormat.format(date);
						polizaBean.setFecha(fecha);
					}
					polizaBean.setTipo(polizaBean.polizaAutomatica);
					mensajeBean = altaPoliza(polizaBean,numTransaccion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					polizaBean.setPolizaID(mensajeBean.getConsecutivoString());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al Generar PolizaID", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//Funcion generica para generar numero de poliza manual
	public MensajeTransaccionBean generaPolizaIDGenericoManual(final PolizaBean polizaBean,final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {

					if( polizaBean.getFecha() == null || polizaBean.getFecha().isEmpty()){
						Date date = parametrosSesionBean.getFechaSucursal();
						DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
						String fecha = dateFormat.format(date);
						polizaBean.setFecha(fecha);
					}
					polizaBean.setTipo(polizaBean.polizaManual);
					mensajeBean = altaPoliza(polizaBean,numTransaccion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					polizaBean.setPolizaID(mensajeBean.getConsecutivoString());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al Generar PolizaID", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método para generar el encabezado de la poliza
	 * @param ingresosOperacionesBean : {@link IngresosOperacionesBean} con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean generaPolizaID(final IngresosOperacionesBean ingresosOperacionesBean, final long numTransaccion, boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				PolizaBean polizaBean=new PolizaBean();
				try {
					Date date = parametrosSesionBean.getFechaSucursal();
					DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
					String fecha = dateFormat.format(date);
					polizaBean.setFecha(fecha);
					polizaBean.setTipo(ingresosOperacionesBean.polizaAutomatica);
					polizaBean.setConceptoID(ingresosOperacionesBean.getConceptoCon());
					polizaBean.setConcepto(ingresosOperacionesBean.getDescripcionMov());
					mensajeBean = altaPoliza(polizaBean,numTransaccion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					ingresosOperacionesBean.setPolizaID(mensajeBean.getConsecutivoString());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al Generar PolizaID", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para generar el encabezado de la poliza
	 * @param ingresosOperacionesBean : {@link IngresosOperacionesBean} con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean generaPolizaCredito(final RecupCarteraCastAgroBean recupCarteraCastAgroBean, final long numTransaccion, boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				PolizaBean polizaBean=new PolizaBean();
				try {
					Date date = parametrosSesionBean.getFechaSucursal();
					DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
					String fecha = dateFormat.format(date);
					polizaBean.setFecha(fecha);
					polizaBean.setTipo(RecupCarteraCastAgroBean.polizaAutomatica);
					polizaBean.setConceptoID(recupCarteraCastAgroBean.getConceptoID());
					polizaBean.setConcepto(recupCarteraCastAgroBean.getObservacionesCastigo());

					mensajeBean = altaPoliza(polizaBean,numTransaccion);
					if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
					recupCarteraCastAgroBean.setPolizaID(mensajeBean.getConsecutivoString());
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al Generar PolizaID", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public void setDetallePolizaDAO(DetallePolizaDAO detallePolizaDAO) {
		this.detallePolizaDAO = detallePolizaDAO;
	}

	public DetallePolizaDAO getDetallePolizaDAO(){
		return detallePolizaDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}
