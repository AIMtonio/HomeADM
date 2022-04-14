package cliente.dao;

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
import org.springframework.jdbc.core.RowMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import cliente.bean.NegocioAfiliadoBean;

public class NegocioAfiliadoDAO extends BaseDAO{

	public NegocioAfiliadoDAO() {
		super();
	}
	//Alta de Negocio Afiliado
	public MensajeTransaccionBean altaNegocioAfiliado(final NegocioAfiliadoBean negocioAfiliado) {
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
								String query = 	"call NEGOCIOAFILIADOALT("+
												"?,?,?,?,?, ?,?,?,?,?, " +
												"?,?,?,?,?, ?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_NombreContacto",negocioAfiliado.getNombreContacto());
								sentenciaStore.setString("Par_DireccionCompleta",negocioAfiliado.getDireccionCompleta());
								sentenciaStore.setString("Par_TelefonoContacto",negocioAfiliado.getTelefonoContacto());
								sentenciaStore.setString("Par_Email",negocioAfiliado.getEmail());
								sentenciaStore.setString("Par_RFC",negocioAfiliado.getRfc());

								sentenciaStore.setString("Par_RazonSocial",negocioAfiliado.getRazonSocial());
								sentenciaStore.setInt("Par_PromotorOrigen",Utileria.convierteEntero(negocioAfiliado.getPromotorOrigen()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(negocioAfiliado.getClienteID()));
								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","EmpleadoNominaDAO.AltaClienteNegAfiliado");
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

									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento No Regreso Ningun Resultado.");
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_CERO);
								}

								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento No Regreso Ningun Resultado.");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Alta de Negocio Afiliado", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
		}

	// Baja Negocio Afiliado

	public MensajeTransaccionBean bajaNegocioAfiliado(final NegocioAfiliadoBean negocioAfiliado, final int numAct) {
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
								String query = 	"call NEGOCIOAFILIADOACT("+
												"?,?,?,?,?, ?,?,?,?,?, " +
												"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NegocioAfiliadoID", Utileria.convierteEntero(negocioAfiliado.getNegocioAfiliadoID()));
								sentenciaStore.setInt("Par_NumAct", numAct);
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(negocioAfiliado.getClienteID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","EmpleadoNominaDAO.AltaClienteNegAfiliado");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
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

									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento No Regreso Ningun Resultado.");
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_CERO);
								}

								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento No Regreso Ningun Resultado.");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Baja de Negocio Afiliado", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
		}

	// Termina Baja Negocio Afiliado


	// Modificar Negocio Afiliado

	public MensajeTransaccionBean modificaNegocioAfiliado(final NegocioAfiliadoBean negocioAfiliado) {
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
								String query = 	"call NEGOCIOAFILIADOMOD("+
												"?,?,?,?,?, ?,?,?,?,?, " +
												"?,?,?,?,?, ?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setString("Par_NegocioAfiliadoID",negocioAfiliado.getNegocioAfiliadoID());
								sentenciaStore.setString("Par_NombreContacto",negocioAfiliado.getNombreContacto());
								sentenciaStore.setString("Par_DireccionCompleta",negocioAfiliado.getDireccionCompleta());
								sentenciaStore.setString("Par_TelefonoContacto",negocioAfiliado.getTelefonoContacto());
								sentenciaStore.setString("Par_Email",negocioAfiliado.getEmail());

								sentenciaStore.setString("Par_RFC",negocioAfiliado.getRfc());
								sentenciaStore.setString("Par_RazonSocial",negocioAfiliado.getRazonSocial());
								sentenciaStore.setInt("Par_PromotorOrigen",Utileria.convierteEntero(negocioAfiliado.getPromotorOrigen()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(negocioAfiliado.getClienteID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								//Parametros de Auditoria
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","EmpleadoNominaDAO.AltaClienteNegAfiliado");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
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

									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento No Regreso Ningun Resultado.");
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_CERO);
								}

								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento No Regreso Ningun Resultado.");
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Modificacion de Negocio Afiliado", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
		}

	// Termina Modificar Negocio Afiliado


	//Banca Electronica
	public MensajeTransaccionBean altaNegAfilClienteBanca(final NegocioAfiliadoBean negocioAfiliado, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call NEGAFILICLIENTEALT(?,?,?, ?,?,?, ?,?,?,?,?,?,? );";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_NegocioAfiliadoID",Utileria.convierteEntero(negocioAfiliado.getNegocioAfiliadoID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(negocioAfiliado.getClienteID()));
								sentenciaStore.setInt("Par_ProspectoID",Utileria.convierteEntero(negocioAfiliado.getProspectoID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID","EmpleadoNominaDAO.AltaClienteNegAfiliado");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",numeroTransaccion);

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

									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
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
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Alta de Cliente Negocio Afiliado", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	//Consulta Negocio Afiliado

	public NegocioAfiliadoBean consultaPrincipal(NegocioAfiliadoBean negocioAfiliadoBean, int tipoConsulta){
		String query = "call NEGOCIOAFILIADOCON(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {

				Utileria.convierteEntero(negocioAfiliadoBean.getNegocioAfiliadoID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"NegocioAfiliadoDAO.consultaPromotor",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NEGOCIOAFILIADOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				NegocioAfiliadoBean negocioBean = new NegocioAfiliadoBean();

				negocioBean.setNegocioAfiliadoID(resultSet.getString("NegocioAfiliadoID"));
				negocioBean.setRazonSocial(resultSet.getString("RazonSocial"));
				negocioBean.setRfc(resultSet.getString("RFC"));
				negocioBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				negocioBean.setTelefonoContacto(resultSet.getString("TelefonoContacto"));


				negocioBean.setNombreContacto(resultSet.getString("NombreContacto"));
				negocioBean.setEmail(resultSet.getString("Email"));
				negocioBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				negocioBean.setPromotorOrigen(String.valueOf(resultSet.getInt("PromotorOrigen")));
				negocioBean.setClienteID(resultSet.getString("ClienteID"));

				negocioBean.setEstatusDescripcion(resultSet.getString("EstatusDes"));
				negocioBean.setEstatus(resultSet.getString("Estatus"));
				return negocioBean;
			}
		});

		return matches.size() > 0 ? (NegocioAfiliadoBean) matches.get(0) : null;
	}

	public NegocioAfiliadoBean consultaPrincipalWS(NegocioAfiliadoBean negocioAfiliadoBean, int tipoConsulta){
		String query = "call NEGOCIOAFILIADOCON(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {

				Utileria.convierteEntero(negocioAfiliadoBean.getNegocioAfiliadoID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"NegocioAfiliadoDAO.consultaPromotor",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NEGOCIOAFILIADOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				NegocioAfiliadoBean negocioBean = new NegocioAfiliadoBean();

				negocioBean.setNegocioAfiliadoID(resultSet.getString("NegocioAfiliadoID"));
				negocioBean.setRazonSocial(resultSet.getString("RazonSocial"));
				negocioBean.setRfc(resultSet.getString("RFC"));
				negocioBean.setDireccionCompleta(resultSet.getString("DireccionCompleta"));
				negocioBean.setTelefonoContacto(resultSet.getString("TelefonoContacto"));


				negocioBean.setNombreContacto(resultSet.getString("NombreContacto"));
				negocioBean.setEmail(resultSet.getString("Email"));
				negocioBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				negocioBean.setPromotorOrigen(String.valueOf(resultSet.getInt("PromotorOrigen")));
				negocioBean.setClienteID(resultSet.getString("ClienteID"));

				negocioBean.setEstatusDescripcion(resultSet.getString("EstatusDes"));
				negocioBean.setEstatus(resultSet.getString("Estatus"));
				return negocioBean;
			}
		});

		return matches.size() > 0 ? (NegocioAfiliadoBean) matches.get(0) : null;
	}
	//BANCA ELECTRONICA

	public NegocioAfiliadoBean consultaPromotor(int tipoConsulta, NegocioAfiliadoBean negocioAfiliadoBean){
		String query = "call NEGOCIOAFILIADOCON(" +
				"?,?, ?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(negocioAfiliadoBean.getNegocioAfiliadoID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"NegocioAfiliadoDAO.consultaPromotor",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NEGOCIOAFILIADOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				NegocioAfiliadoBean negocioBean = new NegocioAfiliadoBean();

				negocioBean.setPromotorID(String.valueOf(resultSet.getInt("PromotorID")));
				negocioBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
				negocioBean.setTelefono(resultSet.getString("Telefono"));


				return negocioBean;
			}
		});

		return matches.size() > 0 ? (NegocioAfiliadoBean) matches.get(0) : null;
	}

	public NegocioAfiliadoBean consultaPromotorWS(int tipoConsulta, NegocioAfiliadoBean negocioAfiliadoBean){
		String query = "call NEGOCIOAFILIADOCON(" +
				"?,?, ?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(negocioAfiliadoBean.getNegocioAfiliadoID()),
				Constantes.ENTERO_CERO,
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"NegocioAfiliadoDAO.consultaPromotor",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NEGOCIOAFILIADOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get("microfin")).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

				NegocioAfiliadoBean negocioBean = new NegocioAfiliadoBean();

				negocioBean.setPromotorID(String.valueOf(resultSet.getInt("PromotorID")));
				negocioBean.setNombrePromotor(resultSet.getString("NombrePromotor"));
				negocioBean.setTelefono(resultSet.getString("Telefono"));


				return negocioBean;
			}
		});

		return matches.size() > 0 ? (NegocioAfiliadoBean) matches.get(0) : null;
	}
	public List listaPrincipal(NegocioAfiliadoBean negocioAfiliadoBean, int tipoLista){
		String query = "call NEGOCIOAFILIADOLIS(" +
				"?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
					Constantes.STRING_VACIO,
					negocioAfiliadoBean.getRazonSocial(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NEGOCIOAFILIADOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				NegocioAfiliadoBean negocioAfiliadoBean = new NegocioAfiliadoBean();
				negocioAfiliadoBean.setNegocioAfiliadoID(Utileria.completaCerosIzquierda(resultSet.getString("NegocioAfiliadoID"),NegocioAfiliadoBean.LONGITUD_ID));
				negocioAfiliadoBean.setRazonSocial(resultSet.getString("RazonSocial"));
				negocioAfiliadoBean.setNombreContacto(resultSet.getString("NombreContacto"));
				return negocioAfiliadoBean;
			}
		});
		return matches;
	}


	//Consulta por cliente

	public NegocioAfiliadoBean consultaCte(NegocioAfiliadoBean negocioAfiliadoBean, int tipoConsulta){
		String query = "call NEGOCIOAFILIADOCON(" +
				"?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(negocioAfiliadoBean.getClienteID()),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"NegocioAfiliadoDAO.consultaPromotor",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NEGOCIOAFILIADOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				NegocioAfiliadoBean negocioBean = new NegocioAfiliadoBean();
				negocioBean.setNegocioAfiliadoID(resultSet.getString("NegocioAfiliadoID"));
				negocioBean.setRazonSocial(resultSet.getString("RazonSocial"));
				return negocioBean;
			}
		});

		return matches.size() > 0 ? (NegocioAfiliadoBean) matches.get(0) : null;
	}

	public List listaForanea(NegocioAfiliadoBean negocioAfiliadoBean, int tipoLista){
		String query = "call NEGOCIOAFILIADOLIS(" +
				"?,?,?,?,?,	?,?,?,?,?);";
		Object[] parametros = {
					negocioAfiliadoBean.getNegocioAfiliadoID(),
					Constantes.STRING_VACIO,
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NEGOCIOAFILIADOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				NegocioAfiliadoBean negocioAfiliadoBean = new NegocioAfiliadoBean();
				negocioAfiliadoBean.setNegocioAfiliadoID(Utileria.completaCerosIzquierda(resultSet.getString("NegocioAfiliadoID"),NegocioAfiliadoBean.LONGITUD_ID));
				negocioAfiliadoBean.setRazonSocial(resultSet.getString("RazonSocial"));
				return negocioAfiliadoBean;
			}
		});
		return matches;
	}

}
