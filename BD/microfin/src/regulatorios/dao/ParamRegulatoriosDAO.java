package regulatorios.dao;

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

import regulatorios.bean.ParamRegulatoriosBean;


public class ParamRegulatoriosDAO extends BaseDAO {

	public ParamRegulatoriosDAO() {
		super();
	}

	/*
	 * Consulta principal de parametros de regulatorios
	 */
	public ParamRegulatoriosBean consultaPrincipal(ParamRegulatoriosBean paramRegulatoriosBean,int tipoConsulta) {
		ParamRegulatoriosBean regulatorioBeanResp = null;
		try{
			//Query con el Store Procedure
			String query = "CALL PARAMREGULATORIOSCON(?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
				tipoConsulta,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ParamRegulatoriosDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL PARAMREGULATORIOSCON(" + Arrays.toString(parametros) + ")");


			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ParamRegulatoriosBean regulatorioBean = new ParamRegulatoriosBean();

					regulatorioBean.setClaveEntidad(resultSet.getString("ClaveEntidad"));
					regulatorioBean.setCuentaEPRC(resultSet.getString("CuentaEPRC"));
					regulatorioBean.setTipoRegulatorios(resultSet.getString("TipoRegulatorios"));
					regulatorioBean.setNivelOperaciones(resultSet.getString("NivelOperaciones"));
					regulatorioBean.setNivelPrudencial(resultSet.getString("NivelPrudencial"));

					regulatorioBean.setClaveFederacion(resultSet.getString("ClaveFederacion"));
					regulatorioBean.setMuestraRegistros(resultSet.getString("MuestraRegistros"));
					regulatorioBean.setMostrarComoOtros(resultSet.getString("MostrarComoOtros"));
					regulatorioBean.setSumaIntCredVencidos(resultSet.getString("IntCredVencidos"));
					regulatorioBean.setAjusteSaldo(resultSet.getString("AjusteSaldo"));

					regulatorioBean.setCuentaContableAjusteSaldo(resultSet.getString("CuentaContableAjusteSaldo"));
					regulatorioBean.setMostrarSucursalOrigen(resultSet.getString("MostrarSucursalOrigen"));
					regulatorioBean.setContarEmpleados(resultSet.getString("ContarEmpleados"));
					regulatorioBean.setTipoRepActEco(resultSet.getString("TipoRepActEco"));
					regulatorioBean.setAjusteResPreventiva(resultSet.getString("AjusteResPreventiva"));

					regulatorioBean.setAjusteCargoAbono(resultSet.getString("AjusteCargoAbono"));
					regulatorioBean.setAjusteRFCMenor(resultSet.getString("AjusteRFCMenor"));
					return regulatorioBean;
				}
			});
			regulatorioBeanResp= matches.size() > 0 ? (ParamRegulatoriosBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Regulatorios", e);

		}
		return regulatorioBeanResp;
	}

	/*
	 * Consulta historica de parametros de regulatorios
	 */
	public ParamRegulatoriosBean consultaHistorica(ParamRegulatoriosBean paramRegulatoriosBean,int tipoConsulta) {
		ParamRegulatoriosBean regulatorioBeanResp = null;
		try{
			//Query con el Store Procedure
			String query = "call PARAMREGULATORIOSCON(?,	?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
									tipoConsulta,
									Utileria.convierteEntero(paramRegulatoriosBean.getAnio()),
									Utileria.convierteEntero(paramRegulatoriosBean.getMes()),
									parametrosAuditoriaBean.getEmpresaID(),
									parametrosAuditoriaBean.getUsuario(),
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"ParamRegulatoriosDAO.consultaHistorica",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PARAMREGULATORIOSCON(" + Arrays.toString(parametros) + ")");


			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
								ParamRegulatoriosBean regulatorioBean = new ParamRegulatoriosBean();
								regulatorioBean.setFechaConsulta(resultSet.getString("FechaConsulta"));
							return regulatorioBean;

						}

			});

			regulatorioBeanResp= matches.size() > 0 ? (ParamRegulatoriosBean) matches.get(0) : null;
		}catch(Exception e){

			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en la consulta de Regulatorios", e);

		}
		return regulatorioBeanResp;
	}


	/*
	 * Modifica los datos de parámetros de regualtorios
	 */
	public MensajeTransaccionBean modificaParametrosRegulatorios(final ParamRegulatoriosBean paramRegulatoriosBean) {
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

									String query = "call PARAMREGULATORIOSMOD(" +
													"?,?,?,?,?," +
													"?,?,?,?,?," +
													"?,?,?,?,?," +
													"?,?," +
													"?,?,?," +			//parametros de salida
													"?,?,?,?,?,?,?);";	//parametros de auditoria

									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_TipoRegulatorios",Utileria.convierteEntero(paramRegulatoriosBean.getTipoRegulatorios()));
									sentenciaStore.setString("Par_ClaveEntidad",paramRegulatoriosBean.getClaveEntidad());
									sentenciaStore.setInt("Par_NivelOperaciones",Utileria.convierteEntero(paramRegulatoriosBean.getNivelOperaciones()));
									sentenciaStore.setInt("Par_NivelPrudencial",Utileria.convierteEntero(paramRegulatoriosBean.getNivelPrudencial()));
									sentenciaStore.setString("Par_CuentaEPRC",paramRegulatoriosBean.getCuentaEPRC());

									sentenciaStore.setString("Par_ClaveFederacion",paramRegulatoriosBean.getClaveFederacion());
									sentenciaStore.setString("Par_MuestraRegistros",paramRegulatoriosBean.getMuestraRegistros());
									sentenciaStore.setString("Par_MostrarComoOtros",paramRegulatoriosBean.getMostrarComoOtros());
									sentenciaStore.setString("Par_SumaIntCredVencidos",paramRegulatoriosBean.getSumaIntCredVencidos());
									sentenciaStore.setString("Par_AjusteSaldo",paramRegulatoriosBean.getAjusteSaldo());

									sentenciaStore.setString("Par_CuentaContableAjusteSaldo",paramRegulatoriosBean.getCuentaContableAjusteSaldo());
									sentenciaStore.setString("Par_MostrarSucursalOrigen",paramRegulatoriosBean.getMostrarSucursalOrigen());
									sentenciaStore.setString("Par_ContarEmpleados",paramRegulatoriosBean.getContarEmpleados());
									sentenciaStore.setString("Par_TipoRepActEco",paramRegulatoriosBean.getTipoRepActEco());
									sentenciaStore.setString("Par_AjusteResPreventiva", paramRegulatoriosBean.getAjusteResPreventiva());

									sentenciaStore.setString("Par_AjusteCargoAbono",paramRegulatoriosBean.getAjusteCargoAbono());
									sentenciaStore.setString("Par_AjusteRFCMenor", paramRegulatoriosBean.getAjusteRFCMenor());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR);
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}

									return mensajeTransaccion;
								}
							});

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR);
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la modificacion de parametros de regulatorios" + e);
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
}
