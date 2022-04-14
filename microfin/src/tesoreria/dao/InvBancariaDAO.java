package tesoreria.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import tesoreria.bean.DistCCInvBancariaBean;
import tesoreria.bean.InvBancariaBean;
import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

public class InvBancariaDAO extends BaseDAO {
	DistCCInvBancariaDAO	distCCInvBancariaDAO	= null;
	PolizaDAO				polizaDAO				= null;
	PolizaBean polizaBean	= new PolizaBean();

	public MensajeTransaccionBean altaInversion(final InvBancariaBean inversionBean, final InvBancariaBean inversionCalculada, final List<DistCCInvBancariaBean> listaDetalle) {
		// CREACION DE LA INVERSION BANCARIA
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		try
		{
		String polizaID=null;
		//DAR DE ALTA LA POLIZA BANCARIA
		polizaBean.setConceptoID(inversionBean.ConceptoContable);
		polizaBean.setConcepto(inversionBean.descripcionContable);
		polizaBean.setFecha(inversionBean.getFechaInicio());
		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		// FIN de alta de poliza
		if((polizaBean.getPolizaID()!=null?Utileria.convierteEntero(polizaBean.getPolizaID()):0)>0)
		{
			mensaje=altaInversion(inversionBean, inversionCalculada);
			if(mensaje.getNumero()>0)
			{

			} else {

				String consecutivo=mensaje.getConsecutivoString();
				inversionBean.setInversionID(consecutivo);
				if(Utileria.convierteEntero(consecutivo)>0){
					altaDistribucciones(inversionBean, listaDetalle);
					vencimientoInvBanSinTransaccion(inversionBean);
				}

			}
		}
	} catch(Exception e){
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Distribución en Centro de Costos de una Inversión Bancaria." + e);
		e.printStackTrace();
		if (mensaje.getNumero() == 0) {
			mensaje.setNumero(999);
		}
		mensaje.setDescripcion(e.getMessage());
	}
		return mensaje;

	}

	public MensajeTransaccionBean altaInversion(final InvBancariaBean inversionBean, final InvBancariaBean inversionCalculada) {
		// CREACION DE LA INVERSION BANCARIA
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					final String tasaISR = inversionBean.getTasaISR();
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call INVBANCARIAALT("
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?,?,?,?,"
											+ "?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(inversionBean.getInstitucionID()));
									sentenciaStore.setString("Par_NumCtaInstit", inversionBean.getNumCtaInstit());
									sentenciaStore.setString("Par_TipoInversion", inversionBean.getTipoInversion());
									sentenciaStore.setString("Par_FechaInicio", inversionBean.getFechaInicio());
									sentenciaStore.setString("Par_FechaVencim", inversionBean.getFechaVencimiento());

									sentenciaStore.setString("Par_Monto", inversionBean.getMonto());
									sentenciaStore.setInt("Par_Plazo", Utileria.convierteEntero(inversionBean.getPlazo()));
									sentenciaStore.setString("Par_Tasa", inversionBean.getTasa());
									sentenciaStore.setString("Par_TasaISR", tasaISR);
									sentenciaStore.setString("Par_TasaNeta", inversionCalculada.getTasaNeta());

									sentenciaStore.setString("Par_InteresGenerado", inversionCalculada.getInteresGenerado());
									sentenciaStore.setString("Par_InteresRecibir", inversionCalculada.getInteresRecibir());
									sentenciaStore.setString("Par_InteresRetener", inversionCalculada.getInteresRetener());
									sentenciaStore.setString("Par_totalRecibir", inversionCalculada.getTotalRecibir());
									sentenciaStore.setInt("Par_UsuarioID", parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(inversionBean.getMonedaID()));
									sentenciaStore.setInt("Par_DiasBase", Utileria.convierteEntero(inversionBean.getDiasBase()));
									sentenciaStore.setString("Par_ClasificacionInver", inversionBean.getClasificacionInver());
									sentenciaStore.setString("Par_TipoTitulo", inversionBean.getTipoTitulo());
									sentenciaStore.setString("Par_TipoRestriccion", inversionBean.getTipoRestriccion());
									sentenciaStore.setString("Par_TipoDeuda", inversionBean.getTipoDeuda());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.registerOutParameter("Par_Consecutivo", Types.CHAR);
									sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID", "InvBancariaDAO.altaInversion");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
									MensajeTransaccionBean mensajeTransaccionR = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccionR.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccionR.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccionR.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccionR.setConsecutivoString(resultadosStore.getString(4));
										String consecutivo = resultadosStore.getString(4);
										inversionBean.setInversionID(consecutivo);

									} else {
										mensajeTransaccionR.setNumero(999);
										mensajeTransaccionR.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
										mensajeTransaccionR.setNombreControl("agrega");
										mensajeTransaccionR.setConsecutivoString("0");
									}
									return mensajeTransaccionR;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setNombreControl("agrega");
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("agrega");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de inversion", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;

	}

	public InvBancariaBean consultaInversionBancaria(int numeroInversionBancaria, int tipoConculta) {
		String query = "call INVBANCARIACON(?,?,?,?,?, ?,?,?,?);";
		Object[] parametros = {
				numeroInversionBancaria,
				tipoConculta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,

				Constantes.STRING_VACIO,
				"InvBancariaDAO.consultaInversionBancaria",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call INVBANCARIACON(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvBancariaBean bancariaBean = new InvBancariaBean();

				bancariaBean.setInversionID(resultSet.getString("InversionID"));
				bancariaBean.setInstitucionID(resultSet.getString("InstitucionID"));
				bancariaBean.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
				bancariaBean.setTipoInversion(resultSet.getString("TipoInversion"));
				bancariaBean.setFechaInicio(resultSet.getString("FechaInicio"));
				bancariaBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				bancariaBean.setMonto(resultSet.getString("Monto"));
				bancariaBean.setPlazo(resultSet.getString("Plazo"));
				bancariaBean.setTasa(resultSet.getString("Tasa"));
				bancariaBean.setTasaISR(resultSet.getString("TasaISR"));
				bancariaBean.setTasaNeta(resultSet.getString("TasaNeta"));
				bancariaBean.setInteresGenerado(resultSet.getString("InteresGenerado"));
				bancariaBean.setInteresRecibir(resultSet.getString("InteresRecibir"));
				bancariaBean.setInteresRetener(resultSet.getString("InteresRetener"));
				bancariaBean.setTotalRecibir(resultSet.getString("TotalRecibir"));
				bancariaBean.setMonedaID(resultSet.getString("MonedaID"));
				bancariaBean.setDiasBase(resultSet.getString("DiasBase"));
				bancariaBean.setClasificacionInver(resultSet.getString("ClasificacionInver"));
				bancariaBean.setTipoTitulo(resultSet.getString("TipoTitulo"));
				bancariaBean.setTipoRestriccion(resultSet.getString("TipoRestriccion"));
				bancariaBean.setTipoDeuda(resultSet.getString("TipoDeuda"));

				return bancariaBean;
			}
		});

		return matches.size() > 0 ? (InvBancariaBean) matches.get(0) : null;
	}

	// consulta para reporte en excel de posicion de inversiones bancarias
	public List<InvBancariaBean> consultaPosicionInvExcel(final InvBancariaBean invBancariaBean, int tipoLista) {
		String query = "call INVBANPOSICIREP(?,?,?,?, ?,?,?, ?,?,?, ?)";
		Object[] parametros = {
				invBancariaBean.getInstitucionID(),
				invBancariaBean.getNumCtaInstit(),
				invBancariaBean.getFechaInicio(),
				Constantes.STRING_VACIO,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call INVBANPOSICIREP(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvBancariaBean invBancaria = new InvBancariaBean();
				invBancaria.setInversionID(resultSet.getString(1));
				invBancaria.setInstitucionID(resultSet.getString(2));
				invBancaria.setNumCtaInstit(resultSet.getString(3));
				invBancaria.setTipoInversion(resultSet.getString(4));
				invBancaria.setFechaInicio(resultSet.getString(5));
				invBancaria.setFechaVencimiento(resultSet.getString(6));
				invBancaria.setMonto(resultSet.getString(7));
				invBancaria.setPlazo(resultSet.getString(8));
				invBancaria.setTasa(resultSet.getString(9));
				invBancaria.setTasaISR(resultSet.getString(10));
				invBancaria.setInteresRecibir(resultSet.getString(11));
				invBancaria.setInteresRetener(resultSet.getString(12));
				invBancaria.setInteresProvisionado(resultSet.getString(13));
				invBancaria.setNombreCorto(resultSet.getString(14));
				invBancaria.setTotalRecibir(resultSet.getString(15));
				return invBancaria;
			}
		});
		return matches;
	}

	// consulta para reporte en excel de Apertura de Inversiones bancarias
	public List<InvBancariaBean> consultaAperturaInvExcel(final InvBancariaBean invBancariaBean) {
		String query = "call INVBANAPERTUREP(?,?,?,?,?, ?,?,?, ?,?,?, ?)";
		Object[] parametros = {
				invBancariaBean.getInstitucionID(),
				invBancariaBean.getNumCtaInstit(),
				invBancariaBean.getFechaInicio(),
				invBancariaBean.getFechaVencimiento(),
				Constantes.STRING_VACIO,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
		};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call INVBANAPERTUREP(" + Arrays.toString(parametros) + ")");
		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InvBancariaBean invBancaria = new InvBancariaBean();
				invBancaria.setInversionID(resultSet.getString(1));
				invBancaria.setInstitucionID(resultSet.getString(2));
				invBancaria.setNumCtaInstit(resultSet.getString(3));
				invBancaria.setTipoInversion(resultSet.getString(4));
				invBancaria.setFechaInicio(resultSet.getString(5));
				invBancaria.setFechaVencimiento(resultSet.getString(6));
				invBancaria.setMonto(resultSet.getString(7));
				invBancaria.setPlazo(resultSet.getString(8));
				invBancaria.setTasa(resultSet.getString(9));
				invBancaria.setTasaISR(resultSet.getString(10));
				invBancaria.setInteresRecibir(resultSet.getString(11));
				invBancaria.setInteresRetener(resultSet.getString(12));
				invBancaria.setEstatus(resultSet.getString(13));
				invBancaria.setInteresProvisionado(resultSet.getString(14));
				invBancaria.setNombreCorto(resultSet.getString(15));
				invBancaria.setTotalRecibir(resultSet.getString(16));
				return invBancaria;
			}
		});
		return matches;
	}

	/* Proceso de Vencimiento de Inv Bancarias */
	public MensajeTransaccionBean vencimientoInvBanSinTransaccion(final InvBancariaBean invBancaria) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call INVBANVENCIMPRO(?,?, ?,?,?, ?,?,?, ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Fecha", invBancaria.getFechaSistema());
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMens", Types.VARCHAR);

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							}
							);
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
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en vencimiento de inversion bancaria", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean vencimientoInvBancaria(final InvBancariaBean invBancaria) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call INVBANVENCIMPRO(?,?, ?,?,?, ?,?,?, ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setString("Par_Fecha", invBancaria.getFechaSistema());
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());

									sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							}
							);
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en vencimiento de inversion bancaria", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List lista(int tipoLista, InvBancariaBean inversionBean) {

		//Query con el Store Procedure
		String query = "call INVBANCARIALIS("
				+ "?,?,?,?,?,"
				+ "?,?,?,?);";
		Object[] parametros = {
				inversionBean.getNombreInstitucion(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVBANCARIALIS(" + Arrays.toString(parametros) +")");
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				InvBancariaBean inv = new InvBancariaBean();
				inv.setInversionID(resultSet.getString("InversionID"));
				inv.setNombreInstitucion(resultSet.getString("Nombre"));
				inv.setNumCtaInstit(resultSet.getString("NumCtaInstit"));
				inv.setMonto(resultSet.getString("Monto"));
				inv.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				inv.setEstatus(resultSet.getString("Estatus"));
				return inv;
			}
		});

		return matches;
	}

	public MensajeTransaccionBean altaDistribucciones(final InvBancariaBean inversionBean, final List<DistCCInvBancariaBean> listaDetalle){
		MensajeTransaccionBean mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					DistCCInvBancariaBean distCCInv = new DistCCInvBancariaBean();
					String consectu = inversionBean.getInversionID();
					String altaMovimiento = Constantes.salidaSI; // NO  QUITAR ES PARA DAR DE ALTA LOS MOVIMIENTOS CONTABLES
					String altaPoliza	= Constantes.salidaSI;
					String polizaDev="0";

					for (int i = 0; i < listaDetalle.size(); i++) {
						distCCInv = listaDetalle.get(i);
						distCCInv.setInstitucionID(inversionBean.getInstitucionID());
						distCCInv.setNumCtaInstit(inversionBean.getNumCtaInstit());
						distCCInv.setMonedaID(inversionBean.getMonedaID());
						distCCInv.setTipoInversion(inversionBean.getTipoInversion());
						distCCInv.setMontoOriginalInv(inversionBean.getMonto());
						distCCInv.setFechaInicio(inversionBean.getFechaInicio());
						distCCInv.setInversionID(consectu);
						distCCInv.setPolizaID(polizaBean.getPolizaID()!=null?polizaBean.getPolizaID():"0");
						if (i > 0) {
							altaMovimiento = Constantes.salidaNO;
							altaPoliza	= Constantes.salidaNO;
						}
						mensajeBean = distCCInvBancariaDAO.alta(distCCInv, consectu, altaMovimiento, inversionBean);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						// DAR DE ALTA EL DEVENGAMIENTO DE LA INVERSION SI ES QUE YA VENCIO
						mensajeBean= distCCInvBancariaDAO.altaDevengamiento(altaPoliza, "S", distCCInv, polizaDev, inversionBean);
						if(mensajeBean.getNumero()==0){
							polizaDev=mensajeBean.getConsecutivoString();
						} else {
							throw new Exception(mensajeBean.getDescripcion());
						}
					}

					//
					// FIn detalle poliza
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					mensajeBean.setNombreControl("agrega");
					mensajeBean.setConsecutivoString("0");
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de Distribución den Centro de Costos de una Inversión Bancaria", e);
					return mensajeBean;
				}
				return mensajeBean;
			}
		});

		//if (mensajeTransaccion != null && mensajeTransaccion.getNumero() != 0) {
			return mensajeTransaccion;
		//}
	}

	public DistCCInvBancariaDAO getDistCCInvBancariaDAO() {
		return distCCInvBancariaDAO;
	}

	public void setDistCCInvBancariaDAO(DistCCInvBancariaDAO distCCInvBancariaDAO) {
		this.distCCInvBancariaDAO = distCCInvBancariaDAO;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

}
