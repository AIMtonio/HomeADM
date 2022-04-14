package cliente.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;

import cliente.BeanWS.Request.ListaDireccionClienteRequest;
import cliente.bean.ClienteBean;
import cliente.bean.DireccionesClienteBean;
import cliente.bean.ReporteClienteLocMarginadasBean;

public class DireccionesClienteDAO extends BaseDAO {

	ParametrosSesionBean parametrosSesionBean;
	ParametrosSisServicio parametrosSisServicio;

	public DireccionesClienteDAO() {
		super();
	}

	// ------------------ Transacciones ------------------------------------------
	public MensajeTransaccionBean alta(final DireccionesClienteBean direccionesCliente) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call DIRECCLIENTEALT(" +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(direccionesCliente.getClienteID()));
							sentenciaStore.setInt("Par_TipoDirecID", Utileria.convierteEntero(direccionesCliente.getTipoDireccionID()));
							sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(direccionesCliente.getEstadoID()));
							sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(direccionesCliente.getMunicipioID()));
							sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(direccionesCliente.getLocalidadID()));
							sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(direccionesCliente.getColoniaID()));
							sentenciaStore.setString("Par_NombreColonia", direccionesCliente.getNombreColonia());
							sentenciaStore.setString("Par_Calle", direccionesCliente.getCalle());
							sentenciaStore.setString("Par_NumeroCasa", direccionesCliente.getNumeroCasa());
							sentenciaStore.setString("Par_NumInterior", direccionesCliente.getNumInterior());
							sentenciaStore.setString("Par_Piso", direccionesCliente.getPiso());
							sentenciaStore.setString("Par_PrimECalle", direccionesCliente.getPrimEntreCalle());
							sentenciaStore.setString("Par_SegECalle", direccionesCliente.getSegEntreCalle());
							sentenciaStore.setString("Par_CP", direccionesCliente.getCP());
							sentenciaStore.setString("Par_Descripcion", direccionesCliente.getDescripcion());
							sentenciaStore.setString("Par_Latitud", direccionesCliente.getLatitud());
							sentenciaStore.setString("Par_Longitud", direccionesCliente.getLongitud());
							sentenciaStore.setString("Par_Oficial", direccionesCliente.getOficial());
							sentenciaStore.setString("Par_Fiscal", direccionesCliente.getFiscal());
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_Lote", direccionesCliente.getLote());
							sentenciaStore.setString("Par_Manzana", direccionesCliente.getManzana());
							sentenciaStore.setString("Par_DirecCompleta", direccionesCliente.getDireccionCompleta());
							sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(direccionesCliente.getPaisID()));
							sentenciaStore.setInt("Par_AnioRes", Utileria.convierteEntero(direccionesCliente.getAniosRes()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DireccionesClienteDAO.alta");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .DireccionesClienteDAO.alta");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de direccion de clientes", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para dar de Baja las Direcciones del Cliente
	 * @param direccionesCliente : {@link DireccionesClienteBean}
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean  baja(final DireccionesClienteBean direccionesCliente) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call DIRECCLIENTEBAJ(" +
									"?,?,?,?,?,     " +
									"?,?,?,?,?,     " +
									"?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(direccionesCliente.getClienteID()));
							sentenciaStore.setInt("Par_NumDirec", Utileria.convierteEntero(direccionesCliente.getDireccionID()));
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "DireccionesClienteDAO.baja");
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
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DireccionesClienteDAO.baja");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .DireccionesClienteDAO.baja");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Baja de direccion de clientes", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	/* Modificacion de direccion Cliente */
	public MensajeTransaccionBean modifica(final DireccionesClienteBean direccionesCliente) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DIRECCLIENTEMOD(?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(direccionesCliente.getClienteID()));
									sentenciaStore.setInt("Par_DireccionID",Utileria.convierteEntero(direccionesCliente.getDireccionID()));
									sentenciaStore.setInt("Par_TipoDirecID",Utileria.convierteEntero(direccionesCliente.getTipoDireccionID()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(direccionesCliente.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(direccionesCliente.getMunicipioID()));

									sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(direccionesCliente.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(direccionesCliente.getColoniaID()));
									sentenciaStore.setString("Par_NombreColonia",direccionesCliente.getNombreColonia());
									sentenciaStore.setString("Par_Calle",direccionesCliente.getCalle());
									sentenciaStore.setString("Par_NumeroCasa",direccionesCliente.getNumeroCasa());

									sentenciaStore.setString("Par_NumInterior",direccionesCliente.getNumInterior());
									sentenciaStore.setString("Par_Piso",direccionesCliente.getPiso());
									sentenciaStore.setString("Par_PrimECalle",direccionesCliente.getPrimEntreCalle());
									sentenciaStore.setString("Par_SegECalle",direccionesCliente.getSegEntreCalle());
									sentenciaStore.setString("Par_CP",direccionesCliente.getCP());

									sentenciaStore.setString("Par_Descripcion",direccionesCliente.getDescripcion());
									sentenciaStore.setString("Par_Latitud",direccionesCliente.getLatitud());
									sentenciaStore.setString("Par_Longitud",direccionesCliente.getLongitud());
									sentenciaStore.setString("Par_Oficial",direccionesCliente.getOficial());
									sentenciaStore.setString("Par_Fiscal",direccionesCliente.getFiscal());

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Lote",direccionesCliente.getLote());
									sentenciaStore.setString("Par_Manzana",direccionesCliente.getManzana());
									sentenciaStore.setString("Par_DirecCompleta", direccionesCliente.getDireccionCompleta());
									sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(direccionesCliente.getPaisID()));

									sentenciaStore.setInt("Par_AnioRes", Utileria.convierteEntero(direccionesCliente.getAniosRes()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DireccionesClienteDAO.modifica");
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
							throw new Exception(Constantes.MSG_ERROR + " .DireccionesClienteDAO.modifica");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de direccion de clientes ", e);
					}
					return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modificaReplica(final DireccionesClienteBean direccionesCliente, final String origenReplica) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(origenReplica)).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(origenReplica)).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DIRECCLIENTEMOD(?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(direccionesCliente.getClienteID()));
									sentenciaStore.setInt("Par_DireccionID",Utileria.convierteEntero(direccionesCliente.getDireccionID()));
									sentenciaStore.setInt("Par_TipoDirecID",Utileria.convierteEntero(direccionesCliente.getTipoDireccionID()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(direccionesCliente.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(direccionesCliente.getMunicipioID()));

									sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(direccionesCliente.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(direccionesCliente.getColoniaID()));
									sentenciaStore.setString("Par_NombreColonia",direccionesCliente.getNombreColonia());
									sentenciaStore.setString("Par_Calle",direccionesCliente.getCalle());
									sentenciaStore.setString("Par_NumeroCasa",direccionesCliente.getNumeroCasa());

									sentenciaStore.setString("Par_NumInterior",direccionesCliente.getNumInterior());
									sentenciaStore.setString("Par_Piso",direccionesCliente.getPiso());
									sentenciaStore.setString("Par_PrimECalle",direccionesCliente.getPrimEntreCalle());
									sentenciaStore.setString("Par_SegECalle",direccionesCliente.getSegEntreCalle());
									sentenciaStore.setString("Par_CP",direccionesCliente.getCP());

									sentenciaStore.setString("Par_Descripcion",direccionesCliente.getDescripcion());
									sentenciaStore.setString("Par_Latitud",direccionesCliente.getLatitud());
									sentenciaStore.setString("Par_Longitud",direccionesCliente.getLongitud());
									sentenciaStore.setString("Par_Oficial",direccionesCliente.getOficial());
									sentenciaStore.setString("Par_Fiscal",direccionesCliente.getFiscal());

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Lote",direccionesCliente.getLote());
									sentenciaStore.setString("Par_Manzana",direccionesCliente.getManzana());
									sentenciaStore.setString("Par_DirecCompleta", direccionesCliente.getDireccionCompleta());
									sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(direccionesCliente.getPaisID()));

									sentenciaStore.setInt("Par_AnioRes", Utileria.convierteEntero(direccionesCliente.getAniosRes()));
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());
									loggerSAFI.info(origenReplica+"-"+sentenciaStore.toString());
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
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DireccionesClienteDAO.modifica");
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
							throw new Exception(Constantes.MSG_ERROR + " .DireccionesClienteDAO.modifica");
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
						loggerSAFI.error(origenReplica+"-"+"error en modificacion de direccion de clientes ", e);
					}
					return mensajeBean;
			}
		});
		return mensaje;
	}


	/* Modificacion de direccion Cliente para WS */
	public MensajeTransaccionBean modificaWS(final DireccionesClienteBean direccionesCliente) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		final ParametrosSisBean parametrosSisBean  = parametrosSisServicio.consulta(ParametrosSisServicio.Enum_Con_ParametrosSis.tipoInstitFin, null);
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings({ "unchecked", "rawtypes" })
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DIRECCLIENTEMOD(?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?," +
																		"?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(direccionesCliente.getClienteID()));
									sentenciaStore.setInt("Par_DireccionID",Utileria.convierteEntero(direccionesCliente.getDireccionID()));
									sentenciaStore.setInt("Par_TipoDirecID",Utileria.convierteEntero(direccionesCliente.getTipoDireccionID()));
									sentenciaStore.setInt("Par_EstadoID",Utileria.convierteEntero(direccionesCliente.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID",Utileria.convierteEntero(direccionesCliente.getMunicipioID()));

									sentenciaStore.setInt("Par_LocalidadID",Utileria.convierteEntero(direccionesCliente.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID",Utileria.convierteEntero(direccionesCliente.getColoniaID()));
									sentenciaStore.setString("Par_NombreColonia",direccionesCliente.getNombreColonia());
									sentenciaStore.setString("Par_Calle",direccionesCliente.getCalle());
									sentenciaStore.setString("Par_NumeroCasa",direccionesCliente.getNumeroCasa());

									sentenciaStore.setString("Par_NumInterior",direccionesCliente.getNumInterior());
									sentenciaStore.setString("Par_Piso",direccionesCliente.getPiso());
									sentenciaStore.setString("Par_PrimECalle",direccionesCliente.getPrimEntreCalle());
									sentenciaStore.setString("Par_SegECalle",direccionesCliente.getSegEntreCalle());
									sentenciaStore.setString("Par_CP",direccionesCliente.getCP());

									sentenciaStore.setString("Par_Descripcion",direccionesCliente.getDescripcion());
									sentenciaStore.setString("Par_Latitud",direccionesCliente.getLatitud());
									sentenciaStore.setString("Par_Longitud",direccionesCliente.getLongitud());
									sentenciaStore.setString("Par_Oficial",direccionesCliente.getOficial());
									sentenciaStore.setString("Par_Fiscal",direccionesCliente.getFiscal());

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setString("Par_Lote",direccionesCliente.getLote());
									sentenciaStore.setString("Par_Manzana",direccionesCliente.getManzana());
									sentenciaStore.setString("Par_DirecCompleta", direccionesCliente.getDireccionCompleta());
									sentenciaStore.setInt("Par_PaisID", Utileria.convierteEntero(direccionesCliente.getPaisID()));

									sentenciaStore.setInt("Par_AnioRes", Utileria.convierteEntero(direccionesCliente.getAniosRes()));

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);

									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									//Parametros de Auditoria
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
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSisBean.getNombreCortoInst()));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .DireccionesClienteDAO.modificaWS");
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
							throw new Exception(Constantes.MSG_ERROR + " .DireccionesClienteDAO.modificaWS");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de direccion de clientes ws", e);
					}
					return mensajeBean;
			}
		});
		return mensaje;
	}
	/* Consuta de direccion de Cliente por Llave Principal*/
	public DireccionesClienteBean consultaPrincipal(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBeanConsulta = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Utileria.convierteEntero(direccion.getDireccionID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");

		@SuppressWarnings("unchecked")
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setClienteID(String.valueOf(Utileria.completaCerosIzquierda(
													resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID)));
					direccionesCliente.setDireccionID(String.valueOf(Utileria.completaCerosIzquierda(
													resultSet.getInt("DireccionID"),DireccionesClienteBean.LONGITUD_ID)));
					direccionesCliente.setTipoDireccionID(String.valueOf(resultSet.getInt("TipoDireccionID")));
					direccionesCliente.setEstadoID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt("EstadoID"),3)));
					direccionesCliente.setMunicipioID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt("MunicipioID"),5)));
					direccionesCliente.setCalle(resultSet.getString("Calle"));
					direccionesCliente.setNumeroCasa(resultSet.getString("NumeroCasa"));
					direccionesCliente.setNumInterior(resultSet.getString("NumInterior"));
					direccionesCliente.setPiso(resultSet.getString("Piso"));
					direccionesCliente.setPrimEntreCalle(resultSet.getString("PrimeraEntreCalle"));
					direccionesCliente.setSegEntreCalle(resultSet.getString("SegundaEntreCalle"));
					direccionesCliente.setLocalidadID(resultSet.getString("LocalidadID"));
					direccionesCliente.setNombreLocalidad(resultSet.getString("NombreLocalidad"));
					direccionesCliente.setColoniaID(resultSet.getString("ColoniaID"));
					direccionesCliente.setAsentamiento(resultSet.getString("Asentamiento"));
					direccionesCliente.setCP(resultSet.getString("CP"));
					direccionesCliente.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
					direccionesCliente.setDescripcion(resultSet.getString("Descripcion"));
					direccionesCliente.setLatitud(resultSet.getString("Latitud"));
					direccionesCliente.setLongitud(resultSet.getString("Longitud"));
					direccionesCliente.setOficial(resultSet.getString("Oficial"));
					direccionesCliente.setFiscal(resultSet.getString("Fiscal"));
					direccionesCliente.setLote(resultSet.getString("Lote"));
					direccionesCliente.setManzana(resultSet.getString("Manzana"));
					direccionesCliente.setPaisID(resultSet.getString("PaisID"));
					direccionesCliente.setNombrePais(resultSet.getString("NombrePais"));
					direccionesCliente.setAniosRes(resultSet.getString("AniosRes"));
					return direccionesCliente;
				}
			});
			direccionesClienteBeanConsulta =  matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al consultar direccion de clientes por llave principal", e);
		}
		return direccionesClienteBeanConsulta;
	}

	/* Consuta de direccion de Cliente para WS*/
	public DireccionesClienteBean consultaPrincipalWS(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBeanConsulta = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Utileria.convierteEntero(direccion.getDireccionID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setClienteID(String.valueOf(Utileria.completaCerosIzquierda(
													resultSet.getInt("ClienteID"),ClienteBean.LONGITUD_ID)));
					direccionesCliente.setDireccionID(String.valueOf(Utileria.completaCerosIzquierda(
													resultSet.getInt("DireccionID"),DireccionesClienteBean.LONGITUD_ID)));
					direccionesCliente.setTipoDireccionID(String.valueOf(resultSet.getInt("TipoDireccionID")));
					direccionesCliente.setEstadoID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt("EstadoID"),3)));
					direccionesCliente.setMunicipioID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt("MunicipioID"),5)));
					direccionesCliente.setCalle(resultSet.getString("Calle"));
					direccionesCliente.setNumeroCasa(resultSet.getString("NumeroCasa"));
					direccionesCliente.setNumInterior(resultSet.getString("NumInterior"));
					direccionesCliente.setPiso(resultSet.getString("Piso"));
					direccionesCliente.setPrimEntreCalle(resultSet.getString("PrimeraEntreCalle"));
					direccionesCliente.setSegEntreCalle(resultSet.getString("SegundaEntreCalle"));
					direccionesCliente.setLocalidadID(resultSet.getString("LocalidadID"));
					direccionesCliente.setNombreLocalidad(resultSet.getString("NombreLocalidad"));
					direccionesCliente.setColoniaID(resultSet.getString("ColoniaID"));
					direccionesCliente.setAsentamiento(resultSet.getString("Asentamiento"));
					direccionesCliente.setCP(resultSet.getString("CP"));
					direccionesCliente.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
					direccionesCliente.setDescripcion(resultSet.getString("Descripcion"));
					direccionesCliente.setLatitud(resultSet.getString("Latitud"));
					direccionesCliente.setLongitud(resultSet.getString("Longitud"));
					direccionesCliente.setOficial(resultSet.getString("Oficial"));
					direccionesCliente.setFiscal(resultSet.getString("Fiscal"));
					direccionesCliente.setLote(resultSet.getString("Lote"));
					direccionesCliente.setManzana(resultSet.getString("Manzana"));
					return direccionesCliente;
				}
			});
			direccionesClienteBeanConsulta =  matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al consultar direccion de clientes por llave principal", e);
		}
		return direccionesClienteBeanConsulta;
	}
	//consulta Foranea de Direcciones cliente
	public DireccionesClienteBean consultaForanea(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBeanConsulta = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Utileria.convierteEntero(direccion.getDireccionID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaForanea",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setDireccionID(String.valueOf(Utileria.completaCerosIzquierda(
																	resultSet.getInt(1),DireccionesClienteBean.LONGITUD_ID)));
					direccionesCliente.setDireccionCompleta(resultSet.getString(2));
						return direccionesCliente;
				}
			});
			direccionesClienteBeanConsulta =  matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error de consulta foranea de direccion de clientes", e);
		}
		return direccionesClienteBeanConsulta;
	}

	public DireccionesClienteBean consultaDirecOficial(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBeanConsulta = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Utileria.convierteEntero(direccion.getDireccionID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaDirecOficial",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setDireccionID(String.valueOf(Utileria.completaCerosIzquierda(
							resultSet.getInt("DireccionID"),DireccionesClienteBean.LONGITUD_ID)));
					direccionesCliente.setClienteID(resultSet.getString("ClienteID"));
					direccionesCliente.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
					direccionesCliente.setTipoDireccionID(resultSet.getString("TipoDireccionID"));
					direccionesCliente.setCalle(resultSet.getString("Oficial"));//obtiene el valor de  oficial
					direccionesCliente.setEsMarginada(resultSet.getString("EsMarginada"));
					return direccionesCliente;
				}
			});
			direccionesClienteBeanConsulta = matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de clientes", e);
		}
		return direccionesClienteBeanConsulta;
	}
	public DireccionesClienteBean consultaOficial(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBean = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaOficial",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setOficial(resultSet.getString(1));
					direccionesCliente.setDireccionCompleta(resultSet.getString(2));
					direccionesCliente.setDireccionID(resultSet.getString(3));
					return direccionesCliente;
				}
			});
			direccionesClienteBean = matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de direccion de clientes", e);
		}
		return direccionesClienteBean;
	}
	public DireccionesClienteBean consultaFiscal(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBean = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaOficial",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setFiscal(resultSet.getString(1));
					direccionesCliente.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
					direccionesCliente.setDireccionID(resultSet.getString("DireccionID"));
					return direccionesCliente;
				}
			});
			direccionesClienteBean = matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de direccion de clientes", e);
		}
		return direccionesClienteBean;
	}

	public DireccionesClienteBean consultaVerFiscal(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBean = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaOficial",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setFiscal(resultSet.getString("Fiscal"));
					return direccionesCliente;
				}
			});
			direccionesClienteBean = matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de direccion de clientes", e);
		}
		return direccionesClienteBean;
	}

	//Consulta Para verificar si el cliente cuenta con un tipo de direccion y no duplicar
	public DireccionesClienteBean consultaTieneTipoDir(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBean = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(direccion.getClienteID()),
									Utileria.convierteEntero(direccion.getDireccionID()),
								    Utileria.convierteEntero(direccion.getTipoDireccionID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaTieneTipoDir",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			//logeo de jQuery al ejecutar
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setDireccionCompleta(resultSet.getString(1));
					return direccionesCliente;
				}
			});

			direccionesClienteBean= matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al verificar direccion de clientes", e);
		}
		return direccionesClienteBean;
	}
	//Consulta Para obtener los datos utilizados en la pantalla Avales
	public DireccionesClienteBean consultaDirecAval(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBean = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(direccion.getClienteID()),
									Utileria.convierteEntero(direccion.getDireccionID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaTieneTipoDir",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setClienteID(resultSet.getString(1));
					direccionesCliente.setEstadoID(resultSet.getString(2));
					direccionesCliente.setMunicipioID(resultSet.getString(3));
					direccionesCliente.setCalle(resultSet.getString(4));
					direccionesCliente.setNumeroCasa(resultSet.getString(5));
					direccionesCliente.setNumInterior(resultSet.getString(6));
					direccionesCliente.setColoniaID(resultSet.getString(7));
					direccionesCliente.setLatitud(resultSet.getString(8));
					direccionesCliente.setLongitud(resultSet.getString(9));
					direccionesCliente.setLote(resultSet.getString(10));
					direccionesCliente.setManzana(resultSet.getString(11));
					direccionesCliente.setCP(resultSet.getString(12));
					direccionesCliente.setLocalidadID(resultSet.getString(13));
					return direccionesCliente;
				}
			});
			direccionesClienteBean =  matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al querer obtener los datos de la pantalla avales", e);
		}
		return direccionesClienteBean;
	}
	//Consulta Para obtener los datos la direccion del trabajo del conyugue
	public DireccionesClienteBean consultaDirecTrabajo(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBeanConsulta = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Constantes.ENTERO_CERO,
									Utileria.convierteEntero(direccion.getTipoDireccionID()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setClienteID(String.valueOf(Utileria.completaCerosIzquierda(
													resultSet.getInt(1),ClienteBean.LONGITUD_ID)));
					direccionesCliente.setDireccionID(String.valueOf(Utileria.completaCerosIzquierda(
													resultSet.getInt(2),DireccionesClienteBean.LONGITUD_ID)));
					direccionesCliente.setTipoDireccionID(String.valueOf(resultSet.getInt(3)));
					direccionesCliente.setEstadoID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt(4),3)));
					direccionesCliente.setMunicipioID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt(5),5)));
					direccionesCliente.setCalle(resultSet.getString(6));
					direccionesCliente.setNumeroCasa(resultSet.getString(7));
					direccionesCliente.setNumInterior(resultSet.getString(8));
					direccionesCliente.setPiso(resultSet.getString(9));
					direccionesCliente.setPrimEntreCalle(resultSet.getString(10));
					direccionesCliente.setSegEntreCalle(resultSet.getString(11));
					direccionesCliente.setLocalidadID(resultSet.getString(12));
					direccionesCliente.setNombreLocalidad(resultSet.getString(13));
					direccionesCliente.setColoniaID(resultSet.getString(14));
					direccionesCliente.setAsentamiento(resultSet.getString(15));
					direccionesCliente.setCP(resultSet.getString(16));
					direccionesCliente.setDireccionCompleta(resultSet.getString(17));
					direccionesCliente.setDescripcion(resultSet.getString(18));
					direccionesCliente.setLatitud(resultSet.getString(19));
					direccionesCliente.setLongitud(resultSet.getString(20));
					direccionesCliente.setOficial(resultSet.getString(21));
					direccionesCliente.setLote(resultSet.getString(22));
					direccionesCliente.setManzana(resultSet.getString(23));
					return direccionesCliente;
				}
			});
			direccionesClienteBeanConsulta =  matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al consultar direccion de clientes por llave principal", e);
		}
		return direccionesClienteBeanConsulta;
	}

	/* Consuta de direccion de Cliente pantalla de fondeo*/
	public DireccionesClienteBean consultaPrincipalFondeo(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBeanConsulta = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Utileria.convierteEntero(direccion.getDireccionID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaDirecFondeo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setEstadoID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt("EstadoID"),3)));
					direccionesCliente.setMunicipioID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt("MunicipioID"),5)));
					direccionesCliente.setCalle(resultSet.getString("Calle"));
					direccionesCliente.setNumeroCasa(resultSet.getString("NumeroCasa"));
					direccionesCliente.setNumInterior(resultSet.getString("NumInterior"));
					direccionesCliente.setPiso(resultSet.getString("Piso"));
					direccionesCliente.setPrimEntreCalle(resultSet.getString("PrimeraEntreCalle"));
					direccionesCliente.setSegEntreCalle(resultSet.getString("SegundaEntreCalle"));
					direccionesCliente.setLocalidadID(resultSet.getString("LocalidadID"));
					direccionesCliente.setNombreLocalidad(resultSet.getString("NombreLocalidad"));
					direccionesCliente.setColoniaID(resultSet.getString("ColoniaID"));
					direccionesCliente.setAsentamiento(resultSet.getString("Asentamiento"));
					direccionesCliente.setCP(resultSet.getString("CP"));
					direccionesCliente.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
					return direccionesCliente;
				}
			});
			direccionesClienteBeanConsulta =  matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al consultar direccion de clientes Fondeo", e);
		}
		return direccionesClienteBeanConsulta;
	}


	// Consuta el numero de habitantes de la localidad de un cliente
	public DireccionesClienteBean consultaNumeroHabitantes(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBeanConsulta = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Utileria.convierteEntero(direccion.getDireccionID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaNumeroHabitantes",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setClienteID(resultSet.getString("ClienteID"));
					direccionesCliente.setNumeroHabitantes(resultSet.getInt("NumHabitantes"));



					return direccionesCliente;
				}
			});
			direccionesClienteBeanConsulta =  matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al consultar habitantes de un cliente", e);
		}
		return direccionesClienteBeanConsulta;
	}

	/* Lista  */
	public List listaDirecciones(DireccionesClienteBean direccionesCliente, int tipoLista) {
		List listaDireccionesCliente = null;
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTELIS(?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	direccionesCliente.getClienteID(),
									direccionesCliente.getDireccionCompleta(),
									tipoLista,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									"DireccionesClienteDAO.listaDirecciones",
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTELIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setDireccionID(resultSet.getString(1));
					direccionesCliente.setDireccionCompleta(resultSet.getString(2));
					return direccionesCliente;
				}
			});

			listaDireccionesCliente =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al obtner lista", e);
		}
		return listaDireccionesCliente ;
	}

	/* Consuta de direccion de Cliente BC*/
	public DireccionesClienteBean consultaDirecBC(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBean = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Utileria.convierteEntero(direccion.getDireccionID()),
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setClienteID(String.valueOf(Utileria.completaCerosIzquierda(
													resultSet.getInt(1),ClienteBean.LONGITUD_ID)));
					direccionesCliente.setDireccionID(String.valueOf(Utileria.completaCerosIzquierda(
													resultSet.getInt(2),DireccionesClienteBean.LONGITUD_ID)));
					direccionesCliente.setTipoDireccionID(String.valueOf(resultSet.getInt(3)));
					direccionesCliente.setEstadoID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt(4),3)));
					direccionesCliente.setMunicipioID(String.valueOf(Utileria.completaCerosIzquierda(resultSet.getInt(5),5)));
					direccionesCliente.setCalle(resultSet.getString(6));
					direccionesCliente.setNumeroCasa(resultSet.getString(7));
					direccionesCliente.setNumInterior(resultSet.getString(8));
					direccionesCliente.setPiso(resultSet.getString(9));
					direccionesCliente.setPrimEntreCalle(resultSet.getString(10));
					direccionesCliente.setColoniaID(resultSet.getString(11));
					direccionesCliente.setColonia(resultSet.getString(12));
					direccionesCliente.setCP(resultSet.getString(13));
					direccionesCliente.setDireccionCompleta(resultSet.getString(14));
					direccionesCliente.setDescripcion(resultSet.getString(15));
					direccionesCliente.setLatitud(resultSet.getString(16));
					direccionesCliente.setLongitud(resultSet.getString(17));
					direccionesCliente.setOficial(resultSet.getString(18));
					direccionesCliente.setLote(resultSet.getString(19));
					direccionesCliente.setManzana(resultSet.getString(20));
					direccionesCliente.setEqBuroCred(resultSet.getString("EqBuroCred"));
					direccionesCliente.setMunicipioNombre(resultSet.getString("MunicipioNombre"));
					direccionesCliente.setLocalidadID(resultSet.getString("LocalidadID"));
					direccionesCliente.setNombreLocalidad(resultSet.getString("NombreLocalidad"));
					return direccionesCliente;
				}
			});
			direccionesClienteBean=  matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el metodo de consulta BC", e);
		}
		return direccionesClienteBean;
	}
	public DireccionesClienteBean consultaDirCliTar(DireccionesClienteBean direccion, int tipoConsulta) {
		DireccionesClienteBean direccionesClienteBean = new DireccionesClienteBean();
		try{
			//Query con el Store Procedure
			String query = "call DIRECCLIENTECON(?,?,?,?,?,?,?,?,?,?,?);";
			Object[] parametros = {	Utileria.convierteEntero(direccion.getClienteID()),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									tipoConsulta,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"DireccionesClienteDAO.consultaOficial",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTECON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException                    {
					DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
					direccionesCliente.setDireccionCompleta(resultSet.getString(1));
					direccionesCliente.setCP(resultSet.getString(2));
					return direccionesCliente;
				}
			});
			direccionesClienteBean = matches.size() > 0 ? (DireccionesClienteBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de direccion de clientes", e);
		}
		return direccionesClienteBean;
	}

	//---------------------------REPORTES -------------------------------------------------- //

		// Reporte Localidades Marginadas para generar en excel//
			public List listaClienteLocsMargin( ReporteClienteLocMarginadasBean reporteClienteLocMarginadasBean,
													int tipoLista){
				List ListaResultado=null;

				try{
				String query = "call CLIENTELOCMARGIREP(?,?,?,?,?, ?,?,?,?,?, ?,?,?)";

				Object[] parametros ={
									Utileria.convierteFecha(reporteClienteLocMarginadasBean.getFechaInicio()),
									Utileria.convierteFecha(reporteClienteLocMarginadasBean.getFechaFin()),
									Utileria.convierteFecha(reporteClienteLocMarginadasBean.getEstadoMarginadasID()),
									Utileria.convierteFecha(reporteClienteLocMarginadasBean.getMunicipioMarginadasID()),
									Utileria.convierteEntero(reporteClienteLocMarginadasBean.getLocalidadMarginadasID()),
									tipoLista,

						    		parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									Constantes.ENTERO_CERO};

				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CLIENTELOCMARGIREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						ReporteClienteLocMarginadasBean clienteLocMarginadasBean= new ReporteClienteLocMarginadasBean();
						clienteLocMarginadasBean.setSucursalID(resultSet.getString("SucursalOrigen"));
						clienteLocMarginadasBean.setNombreSucursal(resultSet.getString("NombreSucurs"));
						clienteLocMarginadasBean.setClienteID(resultSet.getString("ClienteID"));
						clienteLocMarginadasBean.setNombreCliente(resultSet.getString("NombreCompleto"));
						clienteLocMarginadasBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
						clienteLocMarginadasBean.setEstatus(resultSet.getString("DesEstatus"));
						clienteLocMarginadasBean.setCURP(resultSet.getString("CURP"));
						clienteLocMarginadasBean.setFechaAlta(resultSet.getString("FechaAlta"));
						clienteLocMarginadasBean.setLocalidadMarginadasID(resultSet.getString("LocalidadID"));
						clienteLocMarginadasBean.setDesEstadoCivil(resultSet.getString("DesEstadoCivil"));
						clienteLocMarginadasBean.setGrupoID(resultSet.getString("GrupoID"));
						clienteLocMarginadasBean.setDesEsMenorEdad(resultSet.getString("DesEsMenorEdad"));
						clienteLocMarginadasBean.setHoraEmision(resultSet.getString("HoraEmision"));

						return clienteLocMarginadasBean ;
					}
				});
				ListaResultado= matches;
				}catch(Exception e){
					 e.printStackTrace();
					 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reporte de Clientes que viven en  Localidades Marginadas", e);
				}
				return ListaResultado;
			}


			/* Actualizacion de coordenadas en las direcciones de los clientes */
			public MensajeTransaccionBean actualizaCor(final DireccionesClienteBean direccion, final int tipoTransaccion) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
							//Query con el Store Procedure
							String query = "call DIRECCLIENTEACT(?,?,?,?,? ,?,?,?,?,?,?,?);";
							Object[] parametros = {
									Utileria.convierteEntero(direccion.getClienteID()),
									Utileria.convierteEntero(direccion.getDireccionID()),
									direccion.getLatitud(),
									direccion.getLongitud(),
									tipoTransaccion,
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									parametrosAuditoriaBean.getFecha(),
									parametrosAuditoriaBean.getDireccionIP(),
									parametrosAuditoriaBean.getNombrePrograma(),
									parametrosAuditoriaBean.getSucursal(),
									parametrosAuditoriaBean.getNumeroTransaccion()
									};
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTEACT(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
								public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
												MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
												mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
												mensaje.setDescripcion(resultSet.getString(2));
												mensaje.setNombreControl(resultSet.getString(3));
												return mensaje;
								}
							});
							if(matches.size() > 0){
								String datos=direccion.getClienteID();
								}
							return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;

						} catch (Exception e) {
							if(mensajeBean.getNumero()==0){
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Actualización de Coordenadas", e);
						}
						return mensajeBean;
					}
				});
				return mensaje;
			}
	/* *************************METODOS DE BANCA EN LINEA   ****************** */

		// Lista Direccion Cliente WS
			public List listaDireccionWS(ListaDireccionClienteRequest listaDireccionClienteRequest){

				String query = "call DIRECCLIENTELIS(?,?,?,	?,?,?,?,?,?,?);";
				Object[] parametros = {
						Utileria.convierteEntero(listaDireccionClienteRequest.getClienteID()),
						Constantes.STRING_VACIO,
						Utileria.convierteEntero(listaDireccionClienteRequest.getNumLis()),

						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO,
						Constantes.FECHA_VACIA,
						Constantes.STRING_VACIO,
						"DireccionesClienteDAO.listaDireccionWS",
						Constantes.ENTERO_CERO,
						Constantes.ENTERO_CERO};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call DIRECCLIENTELIS(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						DireccionesClienteBean direccionesCliente = new DireccionesClienteBean();
						direccionesCliente.setDireccionID(resultSet.getString("DireccionID"));
						direccionesCliente.setDireccionCompleta(resultSet.getString("DireccionCompleta"));

						return direccionesCliente;
					}
				});
			return matches;
		}

		public ParametrosSesionBean getParametrosSesionBean() {
			return parametrosSesionBean;
		}

		public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
			this.parametrosSesionBean = parametrosSesionBean;
		}

		public ParametrosSisServicio getParametrosSisServicio() {
			return parametrosSisServicio;
		}

		public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
			this.parametrosSisServicio = parametrosSisServicio;
		}
}