package inversiones.dao;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import inversiones.bean.InversionBean;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import cliente.bean.OperacionesCapitalNetoBean;
import cliente.dao.OperacionesCapitalNetoDAO;
import seguridad.servicio.SeguridadRecursosServicio;
import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;

public class InversionDAO extends BaseDAO{
    PolizaDAO polizaDAO	= null;
    OperacionesCapitalNetoDAO operacionesCapitalNetoDAO	= null;
	PolizaBean polizaBean = new PolizaBean();
	OperacionesCapitalNetoBean operCapitalNeto  = new OperacionesCapitalNetoBean();

	static String ESTATUS_VIGENTE="N";

	public InversionDAO(){
		super();
	}
	public MensajeTransaccionBean alta(final InversionBean inversionBean,final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					if (inversionBean.getTasa()== null){
						inversionBean.setTasa(Constantes.DOUBLE_VACIO );
					}
					if (inversionBean.getTasaISR()== null){
						inversionBean.setTasaISR(Constantes.DOUBLE_VACIO );
					}
					if (inversionBean.getTasaNeta()== null){
						inversionBean.setTasaNeta(Constantes.DOUBLE_VACIO );
					}
					if (inversionBean.getInteresGenerado()== null){
						inversionBean.setInteresGenerado(Constantes.DOUBLE_VACIO );
					}
					if (inversionBean.getInteresRecibir()== null){
						inversionBean.setInteresRecibir(Constantes.DOUBLE_VACIO );
					}
					if (inversionBean.getInteresRetener()== null){
						inversionBean.setInteresRetener(Constantes.DOUBLE_VACIO );
					}
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call INVERSIONALT(?,?,?,?,?,?,?,?,?,?,"
											   					   + "?,?,?,?,?,?,?,?,?,?,"
											   					   + "?,?,?,?,?,?,?, ?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(inversionBean.getCuentaAhoID()));
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(inversionBean.getClienteID()));
									sentenciaStore.setInt("Par_TipoInversionID",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
									sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(inversionBean.getFechaInicio()));
									sentenciaStore.setString("Par_FechaVencimiento",Utileria.convierteFecha(inversionBean.getFechaVencimiento()));
									sentenciaStore.setDouble("Par_Monto",inversionBean.getMonto());
									sentenciaStore.setInt("Par_Plazo",inversionBean.getPlazo());

									sentenciaStore.setDouble("Par_Tasa",inversionBean.getTasa());
									sentenciaStore.setDouble("Par_TasaISR", inversionBean.getTasaISR());
									sentenciaStore.setDouble("Par_TasaNeta",inversionBean.getTasaNeta());
									sentenciaStore.setDouble("Par_InteresGenerado",inversionBean.getInteresGenerado());
									sentenciaStore.setDouble("Par_InteresRecibir",inversionBean.getInteresRecibir());
									sentenciaStore.setDouble("Par_InteresRetener",inversionBean.getInteresRetener());
									sentenciaStore.setString("Par_Reinvertir",inversionBean.getReinvertir());
									sentenciaStore.setInt("Par_Usuario",parametrosAuditoriaBean.getUsuario());

									sentenciaStore.setInt("Par_TipoAlta",tipoTransaccion);

									sentenciaStore.setInt("Par_ReinversionId",Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(inversionBean.getMonedaID()));
									sentenciaStore.setString("Par_Etiqueta",inversionBean.getEtiqueta());
									sentenciaStore.setString("Par_Beneficiario",inversionBean.getBeneficiario());// tipo socio o propio de inversion
									sentenciaStore.setInt("Par_Poliza",Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setDate("Par_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Par_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Par_ProgramaID","InversionDAO.alta");
									sentenciaStore.setInt("Par_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Par_NumeroTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERSIONALT "+ sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InversionDAO.alta");
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
							throw new Exception(Constantes.MSG_ERROR + " .InversionDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de inversiones" + e);
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
	public MensajeTransaccionBean actualizaInversion(final InversionBean inversionBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		// ENCABEZADO DE LA POLIZA
		String estado = inversionBean.getEstatus();
		inversionBean.setPolizaID("0");
		boolean crearEncabezado = false;
		// Aplicando conceptos del encabezado de la inversion
		polizaBean=new PolizaBean();
		polizaBean.setConceptoID(inversionBean.concApeInver);
		polizaBean.setConcepto(inversionBean.descApeInver);

		int contador = 0;
		// LLAMAR PRIMERO AL SP DE VALIDACION ANTES DE DAR DE ALTA LA POLIZA
		mensaje = validaInversion(inversionBean, tipoActualizacion);// Si es igual a 0 fue exitosa

		if (mensaje.getNumero() == 0) {
			operCapitalNeto = new OperacionesCapitalNetoBean();

			operCapitalNeto.setInstrumentoID(inversionBean.getInversionID());
			operCapitalNeto.setMontoMov(inversionBean.getMonto());
			operCapitalNeto.setOrigenOperacion("I");
			operCapitalNeto.setPantallaOrigen("AI");

			mensaje = operacionesCapitalNetoDAO.evaluaProcesoOperCapital(operCapitalNeto);
		}

		if (mensaje.getNumero() == 0 ) {
			while (contador <= PolizaBean.numIntentosGeneraPoliza) {
				contador++;
				polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
					break;
				}
			}
		} else {
			return mensaje;
		}

		if (polizaBean.getPolizaID() != null && Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					String numeroPoliza = "0";

					try {
						if (Utileria.convierteEntero(polizaBean.getPolizaID()) != 0) {
							numeroPoliza = polizaBean.getPolizaID();
							inversionBean.setPolizaID(numeroPoliza);
							numeroPoliza = "0";
						} else {
							inversionBean.setPolizaID("0");
						}
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call INVERSIONACT(" + "?,?,?,?,?, ?,?,?,?,?," + "?,?,?,?,?,	?);";//parametros de auditoria

								inversionBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(inversionBean.getUsuarioAutorizaID(), inversionBean.getContraseniaUsuarioAutoriza()));
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_InversionID", Utileria.convierteEntero(inversionBean.getInversionID()));
								sentenciaStore.setString("Par_UsuarioClave", inversionBean.getUsuarioAutorizaID());
								sentenciaStore.setString("Par_ContraseniaAut", inversionBean.getContraseniaUsuarioAutoriza());
								sentenciaStore.setString("Par_AltaEncPoliza", Constantes.STRING_NO);
								sentenciaStore.setInt("Par_NumAct", tipoActualizacion);

								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(inversionBean.getPolizaID()));

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

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
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InversionDAO.actualiza");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						});
						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .InversionDAO.actualiza");
						} else if (mensajeBean.getNumero() != 0) {
							if(mensajeBean.getNumero()==501){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Autorización de Inversión: " + mensajeBean.getDescripcion());
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Actualizacion de inversion " + e);
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
		} else {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacío.");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}

		return mensaje;
	}
	public InversionBean consultaPrincipal(InversionBean inversionBean, int tipoConsulta){
		String query = "call INVERSIONCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(inversionBean.getInversionID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"InversionDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};



		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERSIONCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				InversionBean inversionBean = new InversionBean();

				if(Integer.valueOf(resultSet.getString(1)) != 0){
					inversionBean.setInversionID(Utileria.completaCerosIzquierda(resultSet.getString(1), 10));
					inversionBean.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(2), 11));
					inversionBean.setTipoInversionID(Utileria.completaCerosIzquierda(resultSet.getString(3), 5));
					inversionBean.setFechaInicio(resultSet.getString(4));
					inversionBean.setFechaVencimiento(resultSet.getString(5));
					inversionBean.setMonto(Utileria.convierteDoble(resultSet.getString(6)));
					inversionBean.setPlazo(Integer.valueOf(resultSet.getString(7)));
					inversionBean.setTasa(Utileria.convierteDoble(resultSet.getString(8)));
					inversionBean.setTasaISR(Utileria.convierteDoble(resultSet.getString(9)));
					inversionBean.setTasaNeta(Utileria.convierteDoble(resultSet.getString(10)));
					inversionBean.setInteresGenerado(Utileria.convierteDoble(resultSet.getString(11)));
					inversionBean.setInteresRecibir(Utileria.convierteDoble(resultSet.getString(12)));
					inversionBean.setInteresRetener(Utileria.convierteDoble(resultSet.getString(13)));
					inversionBean.setReinvertir(resultSet.getString(14));
					inversionBean.setEstatus(resultSet.getString(15));
					inversionBean.setClienteID(resultSet.getString(16));
					inversionBean.setMonedaID(resultSet.getString(17));
					inversionBean.setEtiqueta(resultSet.getString(18));
					inversionBean.setValorGat(resultSet.getString("ValorGat"));
					inversionBean.setBeneficiario(resultSet.getString("Beneficiario")); // TIPO DE BENEFICIARIO PROPIO DE LA INVERSION O DE LA CUENTA
					inversionBean.setReinvertirDes(resultSet.getString("ReinvertirDes"));
					inversionBean.setValorGatReal(resultSet.getString("ValorGatReal"));
					inversionBean.setEstatusISR(resultSet.getString("EstatusISR"));
				}else{
					inversionBean.setInversionID(Utileria.completaCerosIzquierda(resultSet.getString(1), 10));
				}

				return inversionBean;
			}
		});


		return matches.size() > 0 ? (InversionBean) matches.get(0) : null;
	}
	public InversionBean consultaVencim_Anticipada(InversionBean inversionBean, int tipoConsulta){
		String query = "call INVERSIONCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(inversionBean.getInversionID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"InversionDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};



		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERSIONCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				InversionBean inversionBean = new InversionBean();

				if(Integer.valueOf(resultSet.getString(1)) != 0){
					inversionBean.setInversionID(Utileria.completaCerosIzquierda(resultSet.getString(1), 10));
					inversionBean.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(2), 11));
					inversionBean.setTipoInversionID(Utileria.completaCerosIzquierda(resultSet.getString(3), 5));
					inversionBean.setFechaInicio(resultSet.getString(4));
					inversionBean.setFechaVencimiento(resultSet.getString(5));
					inversionBean.setMonto(Utileria.convierteDoble(resultSet.getString(6)));
					inversionBean.setPlazo(Integer.valueOf(resultSet.getString(7)));
					inversionBean.setTasa(Utileria.convierteDoble(resultSet.getString(8)));
					inversionBean.setTasaISR(Utileria.convierteDoble(resultSet.getString(9)));
					inversionBean.setTasaNeta(Utileria.convierteDoble(resultSet.getString(10)));
					inversionBean.setInteresGenerado(Utileria.convierteDoble(resultSet.getString(11)));
					inversionBean.setInteresRecibir(Utileria.convierteDoble(resultSet.getString(12)));
					inversionBean.setInteresRetener(Utileria.convierteDoble(resultSet.getString(13)));
					inversionBean.setReinvertir(resultSet.getString(14));
					inversionBean.setEstatus(resultSet.getString(15));
					inversionBean.setClienteID(resultSet.getString(16));
					inversionBean.setMonedaID(resultSet.getString(17));
					inversionBean.setEtiqueta(resultSet.getString(18));
					inversionBean.setSaldoProvision(resultSet.getString(19));
					inversionBean.setDiasTrans(resultSet.getString(20));


				}else{
					inversionBean.setInversionID(Utileria.completaCerosIzquierda(resultSet.getString(1), 10));				}

				return inversionBean;
			}
		});


		return matches.size() > 0 ? (InversionBean) matches.get(0) : null;
	}


	public InversionBean consultaInversionVigente(InversionBean inversionBean, int tipoConsulta){
		String query = "call INVERSIONCON(?,?,?,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(inversionBean.getInversionID()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"InversionDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};



		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERSIONCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				InversionBean inversionBean = new InversionBean();

				if(Integer.valueOf(resultSet.getString(1)) != 0){
					inversionBean.setInversionID(Utileria.completaCerosIzquierda(resultSet.getString(1), 10));
					inversionBean.setCuentaAhoID(Utileria.completaCerosIzquierda(resultSet.getString(2), 11));
					inversionBean.setTipoInversionID(Utileria.completaCerosIzquierda(resultSet.getString(3), 5));
					inversionBean.setFechaInicio(resultSet.getString(4));
					inversionBean.setFechaVencimiento(resultSet.getString(5));
					inversionBean.setMonto(Utileria.convierteDoble(resultSet.getString(6)));
					inversionBean.setPlazo(Integer.valueOf(resultSet.getString(7)));
					inversionBean.setTasa(Utileria.convierteDoble(resultSet.getString(8)));
					inversionBean.setTasaISR(Utileria.convierteDoble(resultSet.getString(9)));
					inversionBean.setTasaNeta(Utileria.convierteDoble(resultSet.getString(10)));
					inversionBean.setInteresGenerado(Utileria.convierteDoble(resultSet.getString(11)));
					inversionBean.setInteresRecibir(Utileria.convierteDoble(resultSet.getString(12)));
					inversionBean.setInteresRetener(Utileria.convierteDoble(resultSet.getString(13)));
					inversionBean.setReinvertir(resultSet.getString(14));
					inversionBean.setEstatus(resultSet.getString(15));
					inversionBean.setClienteID(resultSet.getString(16));
					inversionBean.setMonedaID(resultSet.getString(17));
					inversionBean.setEtiqueta(resultSet.getString(18));
					inversionBean.setSaldoProvision(resultSet.getString(19));
					inversionBean.setDiasTrans(resultSet.getString(20));


				}else{
					inversionBean.setInversionID(Utileria.completaCerosIzquierda(resultSet.getString(1), 10));				}

				return inversionBean;
			}
		});


		return matches.size() > 0 ? (InversionBean) matches.get(0) : null;
	}
	public MensajeTransaccionBean modificaInversion(final InversionBean inversionBean)  {
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
									String query = "call INVERSIONMOD(?,?,?,?,?,	?,?,?,?,?,"
											   					   + "?,?,?,?,?,	?,?,?,?,?,"
											   					   + "?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_InversionID",inversionBean.getInversionID());
									sentenciaStore.setString("Par_CuentaAhoID",inversionBean.getCuentaAhoID());
									sentenciaStore.setString("Par_ClienteID",inversionBean.getClienteID());
									sentenciaStore.setString("Par_TipoInversionID",inversionBean.getTipoInversionID());
									sentenciaStore.setString("Par_FechaInicio",inversionBean.getFechaInicio());

									sentenciaStore.setString("Par_FechaVencimiento",inversionBean.getFechaVencimiento());
									sentenciaStore.setDouble("Par_Monto",inversionBean.getMonto());
									sentenciaStore.setInt("Par_Plazo",inversionBean.getPlazo());
									sentenciaStore.setDouble("Par_Tasa",inversionBean.getTasa());
									sentenciaStore.setDouble("Par_TasaISR",inversionBean.getTasaISR());

									sentenciaStore.setDouble("Par_TasaNeta",inversionBean.getTasaNeta());
									sentenciaStore.setDouble("Par_InteresGenerado",inversionBean.getInteresGenerado());
									sentenciaStore.setDouble("Par_InteresRecibir",inversionBean.getInteresRecibir());
									sentenciaStore.setDouble("Par_InteresRetener",inversionBean.getInteresRetener());
									sentenciaStore.setString("Par_Reinvertir",inversionBean.getReinvertir());

									sentenciaStore.setString("Par_MonedaID",inversionBean.getMonedaID());
									sentenciaStore.setString("Par_Etiqueta",inversionBean.getEtiqueta());
									sentenciaStore.setString("Par_Beneficiario",inversionBean.getBeneficiario()); // tipo beneficiario, cuenta socio o propio de inversion

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Par_UsuarioID",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Par_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Par_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Par_ProgramaID","InversionDAO.modificaInversion");
									sentenciaStore.setInt("Par_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Par_NumeroTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERSIONMOD "+ sentenciaStore.toString());
									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
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
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InversionDAO.alta");
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
							throw new Exception(Constantes.MSG_ERROR + " .InversionDAO.alta");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en modificacion de inversiones" + e);
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
	/************Reinversion**************/
	public MensajeTransaccionBean altaReinversion(final InversionBean inversionBean,final int tipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		polizaBean=new PolizaBean();
		polizaBean.setConceptoID(inversionBean.concReInvInd);
		polizaBean.setConcepto(inversionBean.descReInvInd);
		int	contador  = 0;
		//LLAMAR PRIMERO AL SP DE VALIDACION ANTES DE DAR DE ALTA LA POLIZA
		mensaje=validaInversion(inversionBean, tipoTransaccion);// Si es igual a 0 fue exitosa
		if(mensaje.getNumero()==0){
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		  }
		} else {
			return mensaje;
		}

		if (polizaBean.getPolizaID() != null && Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					String numeroPoliza = "";
					try {

						if (Utileria.convierteEntero(polizaBean.getPolizaID()) != 0) {
							numeroPoliza = polizaBean.getPolizaID();
							inversionBean.setPolizaID(numeroPoliza);

							numeroPoliza = "";
						} else {
							inversionBean.setPolizaID("0");
						}

						// Query con el Store Procedure
						loggerSAFI.debug(parametrosAuditoriaBean.getOrigenDatos()+"-"+" benficiaro " + inversionBean.getBeneficiario());

						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call INVERSIONALT(?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?,?,?,?," + "?,?,?,?,?,?,?, ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_CuentaAhoID", inversionBean.getCuentaAhoID());
								sentenciaStore.setString("Par_ClienteID", inversionBean.getClienteID());
								sentenciaStore.setString("Par_TipoInversionID", inversionBean.getTipoInversionID());
								sentenciaStore.setString("Par_FechaInicio", inversionBean.getFechaInicio());
								sentenciaStore.setString("Par_FechaVencimiento", inversionBean.getFechaVencimiento());
								sentenciaStore.setDouble("Par_Monto", inversionBean.getMonto());
								sentenciaStore.setInt("Par_Plazo", inversionBean.getPlazo());
								sentenciaStore.setDouble("Par_Tasa", inversionBean.getTasa());

								sentenciaStore.setDouble("Par_TasaISR", inversionBean.getTasaISR());
								sentenciaStore.setDouble("Par_TasaNeta", inversionBean.getTasaNeta());
								sentenciaStore.setDouble("Par_InteresGenerado", inversionBean.getInteresGenerado());
								sentenciaStore.setDouble("Par_InteresRecibir", inversionBean.getInteresRecibir());
								sentenciaStore.setDouble("Par_InteresRetener", inversionBean.getInteresRetener());
								sentenciaStore.setString("Par_Reinvertir", inversionBean.getReinvertir());
								sentenciaStore.setInt("Par_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setInt("Par_TipoAlta", tipoTransaccion);

								sentenciaStore.setInt("Par_ReinversionId", Utileria.convierteEntero(inversionBean.getInversionID()));
								sentenciaStore.setString("Par_MonedaID", inversionBean.getMonedaID());
								sentenciaStore.setString("Par_Etiqueta", inversionBean.getEtiqueta());
								sentenciaStore.setString("Par_Beneficiario", inversionBean.getBeneficiario());
								sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(inversionBean.getPolizaID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setDate("Par_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Par_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Par_ProgramaID", "InversionDAO.altaReinversion");
								sentenciaStore.setInt("Par_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Par_NumeroTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "call INVERSIONALT " + sentenciaStore.toString());
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
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InversionDAO.alta");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						});
						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .InversionDAO.alta");
						} else if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Reinversiones" + e);
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

			if(mensaje.getNumero() != 0){
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setPolizaID(inversionBean.getPolizaID());
				polizaDAO.bajaPoliza(bajaPolizaBean);

			}
			/* Baja de Poliza en caso de que haya ocurrido un error */
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0 && mensaje.getNumero() != 0) {
				try {
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
					bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
					bajaPolizaBean.setDescProceso("InversionDAO.altaReinversion");
					bajaPolizaBean.setPolizaID(inversionBean.getPolizaID());
					MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
					mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
					loggerSAFI.error("InversionDAO.altaReinversion: Reinversion: " + inversionBean.getInversionID() + " Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
				} catch (Exception ex) {
					ex.printStackTrace();
				}
			}
			/* Fin Baja de la Poliza Contable*/

		} else {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacío.");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
	}

	//Lista para Pantalla de Resumen del Cliente
	public List<InversionBean> listaResumenCte(InversionBean inversionBean, int tipoLista){
		List<InversionBean> listaInversionBean = null;
		try{
			String query = "CALL INVERSIONESLIS(?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						inversionBean.getClienteID(),
						inversionBean.getNombreCliente(),
						inversionBean.getEstatus(),
						inversionBean.getEtiqueta(),

						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"InversionDAO.listaResumenCte",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
					};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL INVERSIONESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					InversionBean inversionBean = new InversionBean();
					inversionBean.setInversionID(Utileria.completaCerosIzquierda(resultSet.getInt(1),7));
					inversionBean.setTipoInversionID(resultSet.getString(2));
					inversionBean.setEtiqueta(resultSet.getString(3));
					inversionBean.setFechaInicio(resultSet.getString(4));
					inversionBean.setFechaVencimiento(resultSet.getString(5));
					inversionBean.setTasaISRString(resultSet.getString(6));
					inversionBean.setTasaNetaString(resultSet.getString(7));
					inversionBean.setInteresRecibirString(resultSet.getString(8));
					inversionBean.setInteresRetenerString(resultSet.getString(9));
					inversionBean.setInteresGeneradoString(resultSet.getString(10));
					inversionBean.setMontoString(resultSet.getString(11));

					return inversionBean;

				}
			});

			listaInversionBean = matches;

		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Resumen de Inversiones ", exception);
			listaInversionBean = null;
		}

		return listaInversionBean;
	}

	//Lista para Principal por Cliente y Estatus
	public List listaPrincipal(InversionBean inversionBean, int tipoLista){
		String query = "call INVERSIONESLIS(?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					inversionBean.getClienteID(),
					inversionBean.getNombreCliente(),
					inversionBean.getEstatus(),
					inversionBean.getEtiqueta(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"InversionDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERSIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InversionBean inversionBean = new InversionBean();
				inversionBean.setInversionID(Utileria.completaCerosIzquierda(resultSet.getInt(1),7));
				inversionBean.setNombreCompleto(resultSet.getString(2));
				inversionBean.setMontoString(resultSet.getString(3));
				inversionBean.setFechaVencimiento(resultSet.getString(4));
				inversionBean.setDescripcion(resultSet.getString(5));
				return inversionBean;

			}
		});
		return matches;
	}
	//Lista para Principal por Cliente y Estatus
	public List listaParaCancelacion(InversionBean inversionBean, int tipoLista){
		String query = "call INVERSIONESLIS(?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					inversionBean.getClienteID(),
					inversionBean.getNombreCliente(),
					inversionBean.getEstatus(),
					inversionBean.getEtiqueta(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"InversionDAO.listaParaCancelacion",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERSIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InversionBean inversionBean = new InversionBean();
				inversionBean.setInversionID(Utileria.completaCerosIzquierda(resultSet.getInt(1),7));
				inversionBean.setNombreCompleto(resultSet.getString(2));
				inversionBean.setMontoString(resultSet.getString(3));
				inversionBean.setFechaVencimiento(resultSet.getString(4));
				inversionBean.setDescripcion(resultSet.getString(5));
				return inversionBean;

			}
		});
		return matches;
	}

	//Lista para de Inversiones Vigentes (Se utiliza para créditos automáticos)
	public List listaInversionVig(InversionBean inversionBean, int tipoLista){
		String query = "call INVERSIONESLIS(?,?,?,?,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
					inversionBean.getClienteID(),
					inversionBean.getNombreCliente(),
					inversionBean.getEstatus(),
					inversionBean.getEtiqueta(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"InversionDAO.listaParaCancelacion",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERSIONESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				InversionBean inversionBean = new InversionBean();
				inversionBean.setInversionID(Utileria.completaCerosIzquierda(resultSet.getInt(1),7));
				inversionBean.setEtiqueta(resultSet.getString("Etiqueta"));
				inversionBean.setMontoString(resultSet.getString("Monto"));
				inversionBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				inversionBean.setDescripcion(resultSet.getString("Descripcion"));
				return inversionBean;

			}
		});
		return matches;
	}

	public MensajeTransaccionBean validaInversion(final InversionBean inversionBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
											String query = "call INVERSIONVAL("
															+ "?,?,?,?,?,"
															+ "?,?,?,?,?,"
															+ "?,?,?,?,?,"
															+ "?,?,?,?,?,"
															+ "?,?,?,?,?,"
															+ "?,?,?,?,?,"
															+ "?,?);";
											String contrasenia = SeguridadRecursosServicio.encriptaPass(inversionBean.getUsuarioAutorizaID(),
													inversionBean.getContraseniaUsuarioAutoriza());
											CallableStatement sentenciaStore = arg0.prepareCall(query);
											try{
												sentenciaStore.setInt("Par_InversionID",Utileria.convierteEntero(inversionBean.getInversionID()));
												sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(inversionBean.getCuentaAhoID()));
												sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(inversionBean.getClienteID()));
												sentenciaStore.setInt("Par_TipoInversionID",Utileria.convierteEntero(inversionBean.getTipoInversionID()));
												sentenciaStore.setString("Par_FechaInicio",Utileria.convierteFecha(inversionBean.getFechaInicio()));
												sentenciaStore.setString("Par_FechaVencimiento",Utileria.convierteFecha(inversionBean.getFechaVencimiento()));
												sentenciaStore.setDouble("Par_Monto",inversionBean.getMonto());
												sentenciaStore.setInt("Par_Plazo",inversionBean.getPlazo());
												sentenciaStore.setDouble("Par_Tasa",inversionBean.getTasa());
												sentenciaStore.setDouble("Par_TasaISR", inversionBean.getTasaISR());
												sentenciaStore.setDouble("Par_TasaNeta",inversionBean.getTasaNeta());
												if(tipoActualizacion==8){
													sentenciaStore.setDouble("Par_InteresGenerado",Utileria.convierteDoble(inversionBean.getSaldoProvision()));
												} else {
													sentenciaStore.setDouble("Par_InteresGenerado",inversionBean.getInteresGenerado());
												}
												sentenciaStore.setDouble("Par_InteresRecibir",inversionBean.getInteresRecibir());
												sentenciaStore.setDouble("Par_InteresRetener",inversionBean.getInteresRetener());
												sentenciaStore.setString("Par_Reinvertir",inversionBean.getReinvertir());
												sentenciaStore.setInt("Par_Usuario",parametrosAuditoriaBean.getUsuario());

												sentenciaStore.setInt("Par_TipoAlta",tipoActualizacion);

												sentenciaStore.setInt("Par_ReinversionId",Utileria.convierteEntero(inversionBean.getInversionID()));
												sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(inversionBean.getMonedaID()));
												sentenciaStore.setString("Par_Etiqueta",inversionBean.getEtiqueta());
												sentenciaStore.setString("Par_Beneficiario",inversionBean.getBeneficiario());// tipo socio o propio de inversion
												sentenciaStore.setString("Par_UsuarioClave", inversionBean.getUsuarioAutorizaID());
												sentenciaStore.setString("Par_ContraseniaAut", contrasenia);

												sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
												sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
												sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
												sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
												sentenciaStore.setDate("Par_FechaActual",parametrosAuditoriaBean.getFecha());
												sentenciaStore.setString("Par_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
												sentenciaStore.setString("Par_ProgramaID","InversionDAO.alta");
												sentenciaStore.setInt("Par_Sucursal",parametrosAuditoriaBean.getSucursal());
												sentenciaStore.setLong("Par_NumeroTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
											} catch(Exception ex){
												ex.printStackTrace();
											}
											loggerSAFI.info(sentenciaStore.toString());
											return sentenciaStore;
										}
									}, new CallableStatementCallback() {
										public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
												DataAccessException {
											MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
											if (callableStatement.execute()) {
												ResultSet resultadosStore = callableStatement.getResultSet();

												resultadosStore.next();
												mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
												mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
												mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
												mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

											} else {
												mensajeTransaccion.setNumero(999);
												mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InversionDAO.validaInversion");
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
								throw new Exception(Constantes.MSG_ERROR + " .InversionDAO.validaInversion");
							} else if (mensajeBean.getNumero() != 0) {
								if(mensajeBean.getNumero()==501){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Autorización de Inversión: " + mensajeBean.getDescripcion());
								} else {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Actualización de inversión " + e);
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
	public MensajeTransaccionBean cancelaInversion(final InversionBean inversionBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try{
		// ENCABEZADO DE LA POLIZA
		String estado = inversionBean.getEstatus();
		inversionBean.setPolizaID("0");
		polizaBean=new PolizaBean();
		if (estado.equals(ESTATUS_VIGENTE)) {
			polizaBean.setConceptoID(inversionBean.concCanInver);
			polizaBean.setConcepto(inversionBean.descCanInver);
		}

		int contador = 0;
		// LLAMAR PRIMERO AL SP DE VALIDACION ANTES DE DAR DE ALTA LA POLIZA
		mensaje = validaInversion(inversionBean, tipoActualizacion);// Si es igual a 0 fue exitosa
		if (mensaje.getNumero() == 0 && polizaBean.getConceptoID()!=null && !polizaBean.getConceptoID().isEmpty()) {
			while (contador <= PolizaBean.numIntentosGeneraPoliza) {
				contador++;
				polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
					break;
				}
			}
		}
		//if (polizaBean.getPolizaID() != null && Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					String numeroPoliza = "0";
					try {
						if (Utileria.convierteEntero(polizaBean.getPolizaID()) != 0) {
							numeroPoliza = polizaBean.getPolizaID();
							inversionBean.setPolizaID(numeroPoliza);
							numeroPoliza = "0";
						} else {
							inversionBean.setPolizaID("0");
						}
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call INVERSIONACT(" +
										"?,?,?,?,?,"+
										"?,?,?,?,?,"+
										"?,?,?,?,?,"
										+ "?);";
								inversionBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(inversionBean.getUsuarioAutorizaID(), inversionBean.getContraseniaUsuarioAutoriza()));
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_InversionID", Utileria.convierteEntero(inversionBean.getInversionID()));
								sentenciaStore.setString("Par_UsuarioClave", inversionBean.getUsuarioAutorizaID());
								sentenciaStore.setString("Par_ContraseniaAut", inversionBean.getContraseniaUsuarioAutoriza());
								sentenciaStore.setString("Par_AltaEncPoliza", Constantes.STRING_NO);
								sentenciaStore.setInt("Par_NumAct", tipoActualizacion);
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(inversionBean.getPolizaID()));
								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InversionDAO.cancelaInversion");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .InversionDAO.cancelaInversion");
						} else if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Cancelación de la Inversión " + e);
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
		} catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Cancelación de la Inversión " + e);
			e.printStackTrace();
			mensaje.setNumero(999);
			mensaje.setDescripcion(e.getMessage());
		}

		return mensaje;
	}
	public MensajeTransaccionBean imprimePagareInversion(final InversionBean inversionBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					String numeroPoliza = "0";
					try {
						if (Utileria.convierteEntero(polizaBean.getPolizaID()) != 0) {
							numeroPoliza = polizaBean.getPolizaID();
							inversionBean.setPolizaID(numeroPoliza);
							numeroPoliza = "0";
						} else {
							inversionBean.setPolizaID("0");
						}
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call INVERSIONACT(" +
										"?,?,?,?,?,"+
										"?,?,?,?,?,"+
										"?,?,?,?,?,"
										+ "?);";
								inversionBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(inversionBean.getUsuarioAutorizaID(), inversionBean.getContraseniaUsuarioAutoriza()));
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_InversionID", Utileria.convierteEntero(inversionBean.getInversionID()));
								sentenciaStore.setString("Par_UsuarioClave", inversionBean.getUsuarioAutorizaID());
								sentenciaStore.setString("Par_ContraseniaAut", inversionBean.getContraseniaUsuarioAutoriza());
								sentenciaStore.setString("Par_AltaEncPoliza", Constantes.STRING_NO);
								sentenciaStore.setInt("Par_NumAct", tipoActualizacion);
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(inversionBean.getPolizaID()));
								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InversionDAO.imprimePagareInversion");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .InversionDAO.imprimePagareInversion");
						} else if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Imprimir Pagare de la Inversión " + e);
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
	public MensajeTransaccionBean cancelaReInversion(final InversionBean inversionBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		// ENCABEZADO DE LA POLIZA
		String estado = inversionBean.getEstatus();
		inversionBean.setPolizaID("0");
		polizaBean=new PolizaBean();
		if (estado.equals(ESTATUS_VIGENTE)) {
			polizaBean.setConceptoID(inversionBean.concCanReInver);
			polizaBean.setConcepto(inversionBean.descCanReInver);
		}


		int contador = 0;
		// LLAMAR PRIMERO AL SP DE VALIDACION ANTES DE DAR DE ALTA LA POLIZA
		mensaje = validaInversion(inversionBean, tipoActualizacion);// Si es igual a 0 fue exitosa
		if (mensaje.getNumero() == 0) {
			while (contador <= PolizaBean.numIntentosGeneraPoliza) {
				contador++;
				polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
					break;
				}
			}
		} else {
			return mensaje;
		}
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					String numeroPoliza = "0";
					try {
						if (Utileria.convierteEntero(polizaBean.getPolizaID()) != 0) {
							numeroPoliza = polizaBean.getPolizaID();
							inversionBean.setPolizaID(numeroPoliza);
							numeroPoliza = "0";
						} else {
							inversionBean.setPolizaID("0");
						}
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call INVERSIONACT(" +
										"?,?,?,?,?,"+
										"?,?,?,?,?,"+
										"?,?,?,?,?,"
										+ "?);";
								inversionBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(inversionBean.getUsuarioAutorizaID(), inversionBean.getContraseniaUsuarioAutoriza()));
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_InversionID", Utileria.convierteEntero(inversionBean.getInversionID()));
								sentenciaStore.setString("Par_UsuarioClave", inversionBean.getUsuarioAutorizaID());
								sentenciaStore.setString("Par_ContraseniaAut", inversionBean.getContraseniaUsuarioAutoriza());
								sentenciaStore.setString("Par_AltaEncPoliza", Constantes.STRING_NO);
								sentenciaStore.setInt("Par_NumAct", tipoActualizacion);
								sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(inversionBean.getPolizaID()));
								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

								} else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InversionDAO.cancelaReInversion");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						});

						if (mensajeBean == null) {
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .InversionDAO.cancelaReInversion");
						} else if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Cancelación de la Re Inversión " + e);
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
	public MensajeTransaccionBean vencimientoAntiInversion(final InversionBean inversionBean, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		// ENCABEZADO DE LA POLIZA
		inversionBean.setPolizaID("0");
		polizaBean=new PolizaBean();
		polizaBean.setConceptoID(inversionBean.concVenAntInv);
		polizaBean.setConcepto(inversionBean.descVenAntInv);
		int contador = 0;
		mensaje = validaInversion(inversionBean, tipoActualizacion);// Si es igual a 0 fue exitosa
		if (mensaje.getNumero() == 0) {
			while (contador <= PolizaBean.numIntentosGeneraPoliza) {
				contador++;
				polizaDAO.generaPolizaIDGenerico(polizaBean, parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0) {
					break;
				}
			}
		} else {
			return mensaje;
		}
		if (mensaje.getNumero() == 0 && polizaBean.getConceptoID()!=null && !polizaBean.getConceptoID().isEmpty()) {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "0";
						try {
							if (Utileria.convierteEntero(polizaBean.getPolizaID()) != 0) {
								numeroPoliza = polizaBean.getPolizaID();
								inversionBean.setPolizaID(numeroPoliza);
								numeroPoliza = "0";
							} else {
								inversionBean.setPolizaID("0");
							}
							// Query con el Store Procedure
							mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call INVERSIONACT(" +
											"?,?,?,?,?,"+
											"?,?,?,?,?,"+
											"?,?,?,?,?,"
											+ "?);";
									inversionBean.setContraseniaUsuarioAutoriza(SeguridadRecursosServicio.encriptaPass(inversionBean.getUsuarioAutorizaID(), inversionBean.getContraseniaUsuarioAutoriza()));
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_InversionID", Utileria.convierteEntero(inversionBean.getInversionID()));
									sentenciaStore.setString("Par_UsuarioClave", inversionBean.getUsuarioAutorizaID());
									sentenciaStore.setString("Par_ContraseniaAut", inversionBean.getContraseniaUsuarioAutoriza());
									sentenciaStore.setString("Par_AltaEncPoliza", Constantes.STRING_NO);
									sentenciaStore.setInt("Par_NumAct", tipoActualizacion);
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(inversionBean.getPolizaID()));
									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .InversionDAO.cancelaInversion");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							});

							if (mensajeBean == null) {
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(999);
								throw new Exception(Constantes.MSG_ERROR + " .InversionDAO.cancelaInversion");
							} else if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Cancelación de la Inversión " + e);
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
		} else {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacío.");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
	}

	public List<InversionBean> reporteInversionDiaExcel(InversionBean bean){
		List listaInversiones = null ;
		try{
			String query = "call INVERAPERTURDIAREP(?,?,?,?,?);";

	        Object[] parametros ={
	    		 bean.getFechaInicio(),
	    		 Utileria.convierteEntero(bean.getTipoInversionID()),
	    		 Utileria.convierteEntero(bean.getPromotorID()),
	    		 Utileria.convierteEntero(bean.getSucursalID()),
	    		 Utileria.convierteEntero(bean.getMonedaID())
	        };

	        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERAPERTURDIAREP(" + Arrays.toString(parametros) + ")");
	        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

	        	public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					int count = resultSet.getMetaData().getColumnCount();
					InversionBean beanResponse = new InversionBean();
					beanResponse.setInversionID(resultSet.getString("InversionID"));
	        		beanResponse.setClienteID(resultSet.getString("ClienteID"));
	        		beanResponse.setNombreCompleto(resultSet.getString("NombreCompleto"));
	        		beanResponse.setTasa(Utileria.convierteDoble(resultSet.getString("Tasa")));
                    beanResponse.setTasaISR(Utileria.convierteDoble(resultSet.getString("TasaISR")));
                    beanResponse.setTasaNeta(Utileria.convierteDoble(resultSet.getString("TasaNeta")));
                    beanResponse.setMonto(Utileria.convierteDoble(resultSet.getString("Monto")));
                    beanResponse.setPlazo(resultSet.getInt("Plazo"));
                    beanResponse.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
                    beanResponse.setInteresGenerado(Utileria.convierteDoble(resultSet.getString("InteresGenerado")));
                    beanResponse.setInteresRetener(Utileria.convierteDoble(resultSet.getString("InteresRetener")));
                    beanResponse.setInteresRecibir(Utileria.convierteDoble(resultSet.getString("InteresRecibir")));
                    beanResponse.setTotalRecibir(Utileria.convierteDoble(resultSet.getString("TotalRecibir")));
	        		beanResponse.setTipoInversionID(resultSet.getString("TipoInversionID"));
	        		beanResponse.setDescripcionTipoInv(resultSet.getString("DescripInversion"));
	        		beanResponse.setPromotorID(resultSet.getString("PromotorID"));
	        		beanResponse.setNombrePromotor(resultSet.getString("NombrePromotor"));
	        		beanResponse.setSucursalID(resultSet.getString("SucursalID"));
	        		beanResponse.setNombreSucursal(resultSet.getString("NombreSucurs"));
	        		beanResponse.setMonedaID(resultSet.getString("MonedaID"));
	        		beanResponse.setNombreMoneda(resultSet.getString("DescripMoneda"));
					return beanResponse;
	        	}

	        });
	        listaInversiones = matches;
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte de Inversiones por Día " + e);
			e.printStackTrace();
        }
        return listaInversiones;
	}

	public List<InversionBean> reporteCancelacionesInversionDiaExcel(InversionBean bean){
		List listaInversiones = null ;
		try{
			String query = "call INVERCANCELADIAREP(?,?,?,?,?);";

	        Object[] parametros ={
	    		 bean.getFechaInicio(),
	    		 Utileria.convierteEntero(bean.getTipoInversionID()),
	    		 Utileria.convierteEntero(bean.getPromotorID()),
	    		 Utileria.convierteEntero(bean.getSucursalID()),
	    		 Utileria.convierteEntero(bean.getMonedaID())
	        };

	        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERCANCELADIAREP(" + Arrays.toString(parametros) + ")");
	        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

	        	public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					int count = resultSet.getMetaData().getColumnCount();
					InversionBean beanResponse = new InversionBean();
					beanResponse.setInversionID(resultSet.getString("InversionID"));
	        		beanResponse.setClienteID(resultSet.getString("ClienteID"));
	        		beanResponse.setNombreCompleto(resultSet.getString("NombreCompleto"));
	        		beanResponse.setTasa(Utileria.convierteDoble(resultSet.getString("Tasa")));
                    beanResponse.setTasaISR(Utileria.convierteDoble(resultSet.getString("TasaISR")));
                    beanResponse.setTasaNeta(Utileria.convierteDoble(resultSet.getString("TasaNeta")));
                    beanResponse.setMonto(Utileria.convierteDoble(resultSet.getString("Monto")));
                    beanResponse.setPlazo(resultSet.getInt("Plazo"));
                    beanResponse.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
                    beanResponse.setInteresGenerado(Utileria.convierteDoble(resultSet.getString("InteresGenerado")));
                    beanResponse.setInteresRetener(Utileria.convierteDoble(resultSet.getString("InteresRetener")));
                    beanResponse.setInteresRecibir(Utileria.convierteDoble(resultSet.getString("InteresRecibir")));
                    beanResponse.setTotalRecibir(Utileria.convierteDoble(resultSet.getString("TotalRecibir")));
	        		beanResponse.setTipoInversionID(resultSet.getString("TipoInversionID"));
	        		beanResponse.setDescripcionTipoInv(resultSet.getString("DescripInversion"));
	        		beanResponse.setPromotorID(resultSet.getString("PromotorID"));
	        		beanResponse.setNombrePromotor(resultSet.getString("NombrePromotor"));
	        		beanResponse.setSucursalID(resultSet.getString("SucursalID"));
	        		beanResponse.setNombreSucursal(resultSet.getString("NombreSucurs"));
	        		beanResponse.setMonedaID(resultSet.getString("MonedaID"));
	        		beanResponse.setNombreMoneda(resultSet.getString("DescripMoneda"));
					return beanResponse;
	        	}
	        });
        listaInversiones = matches;
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte de Inversiones Canceladas por Día " + e);
			e.printStackTrace();
        }
        return listaInversiones;
	}

	public List<InversionBean> reporteVencimientoInversionDiaExcel(InversionBean bean){
		List listaInversiones = null ;
		try{
			String query = "call INVERVENCIMIENREP(?,?,?,?,?,?);";

	        Object[] parametros ={
	    		 bean.getFechaVencimiento(),
	    		 Utileria.convierteEntero(bean.getTipoInversionID()),
	    		 Utileria.convierteEntero(bean.getPromotorID()),
	    		 Utileria.convierteEntero(bean.getSucursalID()),
	    		 Utileria.convierteEntero(bean.getMonedaID()),
	    		 bean.getEstatus()
	        };

	        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERVENCIMIENREP(" + Arrays.toString(parametros) + ")");
	        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

	        	public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					int count = resultSet.getMetaData().getColumnCount();
					InversionBean beanResponse = new InversionBean();
					beanResponse.setInversionID(resultSet.getString("InversionID"));
	        		beanResponse.setClienteID(resultSet.getString("ClienteID"));
	        		beanResponse.setNombreCompleto(resultSet.getString("NombreCompleto"));
	        		beanResponse.setTasa(Utileria.convierteDoble(resultSet.getString("Tasa")));
                    beanResponse.setTasaISR(Utileria.convierteDoble(resultSet.getString("TasaISR")));
                    beanResponse.setTasaNeta(Utileria.convierteDoble(resultSet.getString("TasaNeta")));
                    beanResponse.setMonto(Utileria.convierteDoble(resultSet.getString("Monto")));
                    beanResponse.setPlazo(resultSet.getInt("Plazo"));
                    beanResponse.setFechaInicio(resultSet.getString("FechaInicio"));
                    beanResponse.setInteresGenerado(Utileria.convierteDoble(resultSet.getString("InteresGenerado")));
                    beanResponse.setInteresRetener(Utileria.convierteDoble(resultSet.getString("InteresRetener")));
                    beanResponse.setInteresRecibir(Utileria.convierteDoble(resultSet.getString("InteresRecibir")));
                    beanResponse.setTotalRecibir(Utileria.convierteDoble(resultSet.getString("TotalRecibir")));
	        		beanResponse.setTipoInversionID(resultSet.getString("TipoInversionID"));
	        		beanResponse.setDescripcionTipoInv(resultSet.getString("DescripInversion"));
	        		beanResponse.setPromotorID(resultSet.getString("PromotorID"));
	        		beanResponse.setNombrePromotor(resultSet.getString("NombrePromotor"));
	        		beanResponse.setSucursalID(resultSet.getString("SucursalID"));
	        		beanResponse.setNombreSucursal(resultSet.getString("NombreSucurs"));
	        		beanResponse.setMonedaID(resultSet.getString("MonedaID"));
	        		beanResponse.setNombreMoneda(resultSet.getString("DescripMoneda"));
	        		beanResponse.setEstatus(resultSet.getString("Estatus"));

					return beanResponse;
	        	}
			});
	        listaInversiones = matches;
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte de Inversiones Vencidas por Día " + e);
			e.printStackTrace();
        }
        return listaInversiones;
	}

	public List<InversionBean> reporteRenovacionesMesExcel(InversionBean bean){
		List listaInversiones = null ;
		try{

			String query = "call INVERRENOVAMES(?,?,?,?,?,?);";

	        Object[] parametros ={
	        	 bean.getAnio(),
	    		 bean.getMes(),
	    		 Utileria.convierteEntero(bean.getTipoInversionID()),
	    		 Utileria.convierteEntero(bean.getPromotorID()),
	    		 Utileria.convierteEntero(bean.getSucursalID()),
	    		 Utileria.convierteEntero(bean.getInversionRenovada())
	        };

	        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERRENOVAMES(" + Arrays.toString(parametros) + ")");
	        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

	        	public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					int count = resultSet.getMetaData().getColumnCount();
					InversionBean beanResponse = new InversionBean();
					beanResponse.setInversionID(resultSet.getString("InversionID"));
	        		beanResponse.setClienteID(resultSet.getString("ClienteID"));
	        		beanResponse.setNombreCompleto(resultSet.getString("NombreCompleto"));
	        		beanResponse.setTasa(Utileria.convierteDoble(resultSet.getString("Tasa")));
                    beanResponse.setTasaISR(Utileria.convierteDoble(resultSet.getString("TasaISR")));
                    beanResponse.setTasaNeta(Utileria.convierteDoble(resultSet.getString("TasaNeta")));
                    beanResponse.setMonto(Utileria.convierteDoble(resultSet.getString("Monto")));
                    beanResponse.setPlazo(resultSet.getInt("Plazo"));
                    beanResponse.setFechaInicio(resultSet.getString("FechaInicio"));
                    beanResponse.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
                    beanResponse.setInteresGenerado(Utileria.convierteDoble(resultSet.getString("InteresGenerado")));
                    beanResponse.setInteresRetener(Utileria.convierteDoble(resultSet.getString("InteresRetener")));
                    beanResponse.setInteresRecibir(Utileria.convierteDoble(resultSet.getString("InteresRecibir")));
                    beanResponse.setTotalRecibir(Utileria.convierteDoble(resultSet.getString("TotalRecibir")));
	        		beanResponse.setTipoInversionID(resultSet.getString("TipoInversionID"));
	        		beanResponse.setDescripcionTipoInv(resultSet.getString("DescripInversion"));
	        		beanResponse.setPromotorID(resultSet.getString("PromotorID"));
	        		beanResponse.setNombrePromotor(resultSet.getString("NombrePromotor"));
	        		beanResponse.setSucursalID(resultSet.getString("SucursalID"));
	        		beanResponse.setNombreSucursal(resultSet.getString("NombreSucurs"));
	        		beanResponse.setEstatus(resultSet.getString("Estatus"));

					return beanResponse;
	        	}
			});
	        listaInversiones = matches;
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte de Inversiones Renovadas por Mes " + e);
			e.printStackTrace();
        }
        return listaInversiones;
	}

	public List<InversionBean> reporteInversionesVigentesExcel(InversionBean bean){
		List listaInversiones = null ;
		try{
			String query = "call INVERSIONESVIGREP(?,?,?,?,?);";

	        Object[] parametros ={
	    		 bean.getFechaInicio(),
	    		 Utileria.convierteEntero(bean.getTipoInversionID()),
	    		 Utileria.convierteEntero(bean.getPromotorID()),
	    		 Utileria.convierteEntero(bean.getSucursalID()),
	    		 Utileria.convierteEntero(bean.getMonedaID())
	        };

	        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERSIONESVIGREP(" + Arrays.toString(parametros) + ")");
	        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

	        	public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					int count = resultSet.getMetaData().getColumnCount();
					InversionBean beanResponse = new InversionBean();
					beanResponse.setInversionID(resultSet.getString("InversionID"));
	        		beanResponse.setClienteID(resultSet.getString("ClienteID"));
	        		beanResponse.setNombreCompleto(resultSet.getString("NombreCompleto"));
					beanResponse.setTasa(Utileria.convierteDoble(resultSet.getString("Tasa")));
					beanResponse.setTasaISR(Utileria.convierteDoble(resultSet.getString("TasaISR")));
					beanResponse.setTasaNeta(Utileria.convierteDoble(resultSet.getString("TasaNeta")));
					beanResponse.setMonto(Utileria.convierteDoble(resultSet.getString("Monto")));
					beanResponse.setPlazo(resultSet.getInt("Plazo"));
					beanResponse.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					beanResponse.setInteresGenerado(Utileria.convierteDoble(resultSet.getString("InteresGenerado")));
					beanResponse.setInteresRetener(Utileria.convierteDoble(resultSet.getString("InteresRetener")));
					beanResponse.setInteresRecibir(Utileria.convierteDoble(resultSet.getString("InteresRecibir")));
					beanResponse.setTotalRecibir(Utileria.convierteDoble(resultSet.getString("TotalRecibir")));
	        		beanResponse.setTipoInversionID(resultSet.getString("TipoInversionID"));
	        		beanResponse.setDescripcionTipoInv(resultSet.getString("DescripInversion"));
	        		beanResponse.setPromotorID(resultSet.getString("PromotorID"));
	        		beanResponse.setNombrePromotor(resultSet.getString("NombrePromotor"));
	        		beanResponse.setSucursalID(resultSet.getString("SucursalID"));
	        		beanResponse.setNombreSucursal(resultSet.getString("NombreSucurs"));
	        		beanResponse.setMonedaID(resultSet.getString("MonedaID"));
	        		beanResponse.setNombreMoneda(resultSet.getString("DescripMoneda"));
	        		beanResponse.setSaldoProvision(resultSet.getString("SaldoProvision"));
	        		return beanResponse;
	        	}
			});
	        listaInversiones = matches;
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte de Inversiones Vigentes " + e);
			e.printStackTrace();
        }
        return listaInversiones;
	}

	public List<InversionBean> reporteInversionesClienteExcel(InversionBean bean){
		List listaInversiones = null ;
			try{
			String query = "call INVERCLIENTEREP(?,?);";

	        Object[] parametros ={
	    		 Utileria.convierteEntero(bean.getClienteID()),
	    		 Utileria.convierteEntero(bean.getSucursalID())
	        };

	        loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call INVERCLIENTEREP(" + Arrays.toString(parametros) + ")");
	        List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

	        	public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					int count = resultSet.getMetaData().getColumnCount();
					InversionBean beanResponse = new InversionBean();
					beanResponse.setInversionID(resultSet.getString("InversionID"));
	        		beanResponse.setClienteID(resultSet.getString("ClienteID"));
	        		beanResponse.setNombreCompleto(resultSet.getString("NombreCompleto"));
	        		beanResponse.setTasa(Utileria.convierteDoble(resultSet.getString("Tasa")));
                    beanResponse.setTasaISR(Utileria.convierteDoble(resultSet.getString("TasaISR")));
                    beanResponse.setTasaNeta(Utileria.convierteDoble(resultSet.getString("TasaNeta")));
                    beanResponse.setMonto(Utileria.convierteDoble(resultSet.getString("Monto")));
                    beanResponse.setPlazo(resultSet.getInt("Plazo"));
                    beanResponse.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
                    beanResponse.setInteresGenerado(Utileria.convierteDoble(resultSet.getString("InteresGenerado")));
                    beanResponse.setInteresRetener(Utileria.convierteDoble(resultSet.getString("InteresRetener")));
                    beanResponse.setInteresRecibir(Utileria.convierteDoble(resultSet.getString("InteresRecibir")));
                    beanResponse.setTotalRecibir(Utileria.convierteDoble(resultSet.getString("TotalRecibir")));
	        		beanResponse.setTipoInversionID(resultSet.getString("TipoInversionID"));
	        		beanResponse.setDescripcionTipoInv(resultSet.getString("DescripInversion"));
	        		beanResponse.setPromotorID(resultSet.getString("PromotorID"));
	        		beanResponse.setNombrePromotor(resultSet.getString("NombrePromotor"));
	        		beanResponse.setSucursalID(resultSet.getString("SucursalID"));
	        		beanResponse.setNombreSucursal(resultSet.getString("NombreSucurs"));
	        		beanResponse.setMonedaID(resultSet.getString("MonedaID"));
	        		beanResponse.setNombreMoneda(resultSet.getString("DescripMoneda"));
	        		beanResponse.setSaldoProvision(resultSet.getString("SaldoProvision"));
	        		return beanResponse;
	        	}
			});
	        listaInversiones = matches;
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el reporte de Inversiones por Socio " + e);
			e.printStackTrace();
        }
        return listaInversiones;
	}

	//Lista de Inversiones para Guarda Valores
	public List listaGuardaValores(InversionBean inversionBean, int tipoLista){

		List<InversionBean> listaInversiones = null;
		try{
			String query = "CALL INVERSIONESLIS(?,?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
						inversionBean.getClienteID(),
						inversionBean.getNombreCliente(),
						inversionBean.getEstatus(),
						inversionBean.getEtiqueta(),
						tipoLista,

						parametrosAuditoriaBean.getEmpresaID(),
						parametrosAuditoriaBean.getUsuario(),
						parametrosAuditoriaBean.getFecha(),
						parametrosAuditoriaBean.getDireccionIP(),
						"InversionDAO.listaPrincipal",
						parametrosAuditoriaBean.getSucursal(),
						parametrosAuditoriaBean.getNumeroTransaccion()
					};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL INVERSIONESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					InversionBean inversionBean = new InversionBean();
					inversionBean.setInversionID(Utileria.completaCerosIzquierda(resultSet.getInt(1),7));
					inversionBean.setNombreCompleto(resultSet.getString(2));
					inversionBean.setMontoString(resultSet.getString(3));
					inversionBean.setFechaVencimiento(resultSet.getString(4));
					inversionBean.setDescripcion(resultSet.getString(5));
					return inversionBean;

				}
			});

			listaInversiones = matches;

		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en la lista de Inversiones en Guarda Valores", exception);
			listaInversiones = null;
		}

		return listaInversiones;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}
	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}
	public OperacionesCapitalNetoDAO getOperacionesCapitalNetoDAO() {
		return operacionesCapitalNetoDAO;
	}
	public void setOperacionesCapitalNetoDAO(OperacionesCapitalNetoDAO operacionesCapitalNetoDAO) {
		this.operacionesCapitalNetoDAO = operacionesCapitalNetoDAO;
	}


}
