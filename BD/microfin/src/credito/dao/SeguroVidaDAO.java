package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

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
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import ventanilla.bean.IngresosOperacionesBean;


import credito.bean.SeguroVidaBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

public class SeguroVidaDAO extends BaseDAO {

	/* Consuta Del Seguro de Vida por Llave Principal */
	public SeguroVidaBean consultaPrincipal(SeguroVidaBean seguroVidaBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call SEGUROVIDACON(?,?,?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { seguroVidaBean.getSeguroVidaID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUROVIDACON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				SeguroVidaBean seguroBean = new SeguroVidaBean();
				seguroBean.setSeguroVidaID(String.valueOf(resultSet.getInt("SeguroVidaID")));
				seguroBean.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
				seguroBean.setCuentaAhoID(String.valueOf(resultSet.getString("CuentaID")));
				seguroBean.setCreditoID(String.valueOf(resultSet.getString("CreditoID")));
				seguroBean.setSolicitudCreditoID(String.valueOf(resultSet.getInt("SolicitudCreditoID")));
				seguroBean.setFechaInicio(String.valueOf(resultSet.getDate("FechaInicio")));
				seguroBean.setFechaVencimiento(String.valueOf(resultSet.getDate("FechaVencimiento")));
				seguroBean.setEstatus(resultSet.getString("Estatus"));
				seguroBean.setBeneficiario(resultSet.getString("Beneficiario"));
				seguroBean.setDireccionBeneficiario(resultSet.getString("DireccionBen"));
				seguroBean.setRelacionBeneficiario(String.valueOf(resultSet.getInt("TipoRelacionID")));
				seguroBean.setDescriRelacionBeneficiario(resultSet.getString("Descripcion"));
				seguroBean.setMontoPoliza(resultSet.getString("MontoPoliza"));
				seguroBean.setForCobroSegVida(resultSet.getString("ForCobroSegVida"));

				return seguroBean;

			}
		});

		return matches.size() > 0 ? (SeguroVidaBean) matches.get(0) : null;
	}

	/* Consuta del Seguro de Vida por Credito o Solicitud */
	public SeguroVidaBean consultaPorCreditoSolicitud(SeguroVidaBean seguroVidaBean, int tipoConsulta) {
		// Query con el Store Procedure
		String query = "call SEGUROVIDACON(?,?,?,?,?,?,?,?,?,?,?,?);";

		Object[] parametros = { Constantes.ENTERO_CERO,
				seguroVidaBean.getSolicitudCreditoID(),
				seguroVidaBean.getCreditoID(),
				seguroVidaBean.getCuentaAhoID(),
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CreditosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUROVIDACON(  " + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				SeguroVidaBean seguroBean = new SeguroVidaBean();
				seguroBean.setSeguroVidaID(String.valueOf(resultSet.getInt("SeguroVidaID")));
				seguroBean.setClienteID(String.valueOf(resultSet.getInt("ClienteID")));
				seguroBean.setCuentaAhoID(String.valueOf(resultSet.getString("CuentaID")));
				seguroBean.setCreditoID(String.valueOf(resultSet.getLong("CreditoID")));
				seguroBean.setSolicitudCreditoID(String.valueOf(resultSet.getInt("SolicitudCreditoID")));
				seguroBean.setFechaInicio(String.valueOf(resultSet.getDate("FechaInicio")));
				seguroBean.setFechaVencimiento(String.valueOf(resultSet.getDate("FechaVencimiento")));
				seguroBean.setEstatus(resultSet.getString("Estatus"));
				seguroBean.setBeneficiario(resultSet.getString("Beneficiario"));
				seguroBean.setDireccionBeneficiario(resultSet.getString("DireccionBen"));
				seguroBean.setRelacionBeneficiario(String.valueOf(resultSet.getInt("TipoRelacionID")));
				seguroBean.setDescriRelacionBeneficiario(resultSet.getString("Descripcion"));
				seguroBean.setMontoPoliza(resultSet.getString("MontoPoliza"));
				seguroBean.setForCobroSegVida(resultSet.getString("ForCobroSegVida"));

				return seguroBean;

			}
		});

		return matches.size() > 0 ? (SeguroVidaBean) matches.get(0) : null;
	}

	/* Alta o Registro del Seguro de Vida */
	public MensajeTransaccionBean altaSeguroVida(final SeguroVidaBean seguroVidaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGUROVIDAALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(seguroVidaBean.getClienteID()));
									sentenciaStore.setLong("Par_CuentaID", Utileria.convierteLong(seguroVidaBean.getCuentaAhoID()));
									sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(seguroVidaBean.getCreditoID()));
									sentenciaStore.setInt("Par_SolCreditoID", Utileria.convierteEntero(seguroVidaBean.getSolicitudCreditoID()));
									sentenciaStore.setDate("Par_FechaVenci",OperacionesFechas.conversionStrDate(seguroVidaBean.getFechaVencimiento()));
									sentenciaStore.setString("Par_Beneficiario", seguroVidaBean.getBeneficiario());
									sentenciaStore.setString("Par_DireccionBen", seguroVidaBean.getDireccionBeneficiario());
									sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(seguroVidaBean.getRelacionBeneficiario()));
									sentenciaStore.setDouble("Par_MontoPoliza", Utileria.convierteDoble(seguroVidaBean.getMontoPoliza()));
									sentenciaStore.setString("Par_ForCobroSegVida",seguroVidaBean.getForCobroSegVida());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_Consecutivo", Types.INTEGER);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(String.valueOf(resultadosStore.getInt("consecutivo")));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero()==0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de seguro de vida", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Alta o Registro del Seguro de Vida  se ocupa al dar de alta el credito*/
	public MensajeTransaccionBean altaSeguroVida(final SeguroVidaBean seguroVidaBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGUROVIDAALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(seguroVidaBean.getClienteID()));
									sentenciaStore.setLong("Par_CuentaID", Utileria.convierteLong(seguroVidaBean.getCuentaAhoID()));
									sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(seguroVidaBean.getCreditoID()));
									sentenciaStore.setInt("Par_SolCreditoID", Utileria.convierteEntero(seguroVidaBean.getSolicitudCreditoID()));
									sentenciaStore.setDate("Par_FechaVenci",OperacionesFechas.conversionStrDate(seguroVidaBean.getFechaVencimiento()));
									sentenciaStore.setString("Par_Beneficiario", seguroVidaBean.getBeneficiario());
									sentenciaStore.setString("Par_DireccionBen", seguroVidaBean.getDireccionBeneficiario());
									sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(seguroVidaBean.getRelacionBeneficiario()));
									sentenciaStore.setDouble("Par_MontoPoliza", Utileria.convierteDoble(seguroVidaBean.getMontoPoliza()));
									sentenciaStore.setString("Par_ForCobroSegVida",seguroVidaBean.getForCobroSegVida());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
									sentenciaStore.registerOutParameter("Par_Consecutivo", Types.INTEGER);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoString(String.valueOf(resultadosStore.getInt("consecutivo")));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero()==0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de seguro de vida", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificacion del Seguro de Vida */
	public MensajeTransaccionBean modificaSeguroVida(final SeguroVidaBean seguroVidaBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGUROVIDAMOD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SeguroVidaID", Utileria.convierteEntero(seguroVidaBean.getSeguroVidaID()));
									sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(seguroVidaBean.getCreditoID()));
									sentenciaStore.setInt("Par_SolCreditoID", Utileria.convierteEntero(seguroVidaBean.getSolicitudCreditoID()));
									sentenciaStore.setDate("Par_FechaVenci",OperacionesFechas.conversionStrDate(seguroVidaBean.getFechaVencimiento()));
									sentenciaStore.setString("Par_Beneficiario", seguroVidaBean.getBeneficiario());
									sentenciaStore.setString("Par_DireccionBen", seguroVidaBean.getDireccionBeneficiario());
									sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(seguroVidaBean.getRelacionBeneficiario()));
									sentenciaStore.setDouble("Par_MontoPoliza", Utileria.convierteDoble(seguroVidaBean.getMontoPoliza()));
									sentenciaStore.setString("Par_ForCobroSegVida", seguroVidaBean.getForCobroSegVida());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero()==0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de seguro de vida", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* Modificacion del Seguro de Vida */
	public MensajeTransaccionBean modificaSeguroVida(final SeguroVidaBean seguroVidaBean, final long numTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGUROVIDAMOD(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_SeguroVidaID", Utileria.convierteEntero(seguroVidaBean.getSeguroVidaID()));
									sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(seguroVidaBean.getCreditoID()));
									sentenciaStore.setInt("Par_SolCreditoID", Utileria.convierteEntero(seguroVidaBean.getSolicitudCreditoID()));
									sentenciaStore.setDate("Par_FechaVenci",OperacionesFechas.conversionStrDate(seguroVidaBean.getFechaVencimiento()));
									sentenciaStore.setString("Par_Beneficiario", seguroVidaBean.getBeneficiario());
									sentenciaStore.setString("Par_DireccionBen", seguroVidaBean.getDireccionBeneficiario());
									sentenciaStore.setInt("Par_TipoRelacionID", Utileria.convierteEntero(seguroVidaBean.getRelacionBeneficiario()));
									sentenciaStore.setDouble("Par_MontoPoliza", Utileria.convierteDoble(seguroVidaBean.getMontoPoliza()));
									sentenciaStore.setString("Par_ForCobroSegVida", seguroVidaBean.getForCobroSegVida());

									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}
									return mensajeTransaccion;
								}
							});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero()==0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de seguro de vida", e);
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/* 2.- Lista de seguros de Vida por beneficiario*/
	public List listaBeneficiario(SeguroVidaBean seguroVidaBean, int tipoLista) {
		List listaSeguroVida = null ;
		try{
			String query = "call SEGUROVIDALIS(?,?,?,?,?,  ?,?,?,?,?);";
			Object[] parametros = {
									Constantes.ENTERO_CERO,
									seguroVidaBean.getBeneficiario(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"SeguroVidaDAO.listaBeneficiario",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUROVIDALIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SeguroVidaBean seguroVidaBean = new SeguroVidaBean();
					seguroVidaBean.setCreditoID(resultSet.getString("CreditoID"));
					seguroVidaBean.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
					seguroVidaBean.setBeneficiario(resultSet.getString("Beneficiario"));

					return seguroVidaBean;
				}
			});

			listaSeguroVida= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de seguro de vida del beneficiario", e);
		}
		return listaSeguroVida;
	}





}
