package cliente.dao;

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

import seguridad.servicio.SeguridadRecursosServicio;
import cliente.bean.SeguroClienteBean;
import cliente.bean.SucursalesBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class SeguroClienteDAO extends BaseDAO {

	public SeguroClienteDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	ParametrosSesionBean parametrosSesionBean;
	private final static String salidaPantalla = "S";

	public MensajeTransaccionBean cancelaSeguro(final SeguroClienteBean seguroClienteBean) {
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
									String query = "call SEGUROCLICANPRO(" +
										"?,?,?,?,?," +
										"?,?,?,"+//inouts para control de errores
										"?,?,?,?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_Seguro",Utileria.convierteEntero(seguroClienteBean.getSeguroClienteID()));
									sentenciaStore.setInt("Par_Motivo",Utileria.convierteEntero(seguroClienteBean.getMotivoCambioEstatus()));
									sentenciaStore.setString("Par_Observacion",seguroClienteBean.getObservacion());
									sentenciaStore.setString("Par_Clave",seguroClienteBean.getClaveUsuarioAutoriza());
									sentenciaStore.setString("Par_Contrasenia",seguroClienteBean.getContrasenia());

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
										mensajeTransaccion.setCampoGenerico(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .SeguroClienteDAO.cancelaSeguro");
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
							throw new Exception(Constantes.MSG_ERROR + " .SeguroClienteDAO.cancelaSeguro");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Cancelación de Seguro de vida" + e);
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



	public SeguroClienteBean consulta(SeguroClienteBean seguroClienteBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SEGUROCLIENTECON(?,?,?,?,?,   ?,?,?,?,?);";
		Object[] parametros = {
								Utileria.convierteEntero(seguroClienteBean.getSeguroClienteID()),
								Utileria.convierteEntero(seguroClienteBean.getClienteID()),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SeguroClienteDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUROCLIENTECON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SeguroClienteBean seguroCliente = new SeguroClienteBean();

				seguroCliente.setSeguroClienteID(resultSet.getString("SeguroClienteID"));
				seguroCliente.setClienteID(resultSet.getString("ClienteID"));
				seguroCliente.setFechaInicio(resultSet.getString("FechaInicio"));
				seguroCliente.setFechaVencimiento(resultSet.getString("FechaVencimiento"));
				seguroCliente.setEstatus(resultSet.getString("Estatus"));
				seguroCliente.setMontoSegPagado(resultSet.getString("MontoSegPagado"));
				seguroCliente.setMontoPolizaSegAyuda(resultSet.getString("MontoSeguro"));
				seguroCliente.setMontoSeguroApoyo(resultSet.getString("MontoSegAyuda"));
				return seguroCliente;
			}
		});
		return matches.size() > 0 ? (SeguroClienteBean) matches.get(0) : null;

	}
	public SeguroClienteBean consultaCancelacion(SeguroClienteBean seguroClienteBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SEGUROCLIENTECON(?,?,?,?,?,   ?,?,?,?,?);";
		Object[] parametros = {
								Utileria.convierteEntero(seguroClienteBean.getSeguroClienteID()),
								Utileria.convierteEntero(seguroClienteBean.getClienteID()),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SeguroClienteDAO.consulta",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUROCLIENTECON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SeguroClienteBean seguroCliente = new SeguroClienteBean();
				seguroCliente.setSucursalSeguro(resultSet.getString("Sucursal"));
				seguroCliente.setClienteID(resultSet.getString("ClienteID"));
				seguroCliente.setFechaInicio(resultSet.getString("FechaInicio"));
				seguroCliente.setEstatus(resultSet.getString("Estatus"));
				seguroCliente.setMotivoCambioEstatus(resultSet.getString("MotivoCamEst"));
				seguroCliente.setObservacion(resultSet.getString("Observacion"));
				seguroCliente.setClaveUsuarioAutoriza(resultSet.getString("ClaveAutoriza"));

				return seguroCliente;
			}
		});
		return matches.size() > 0 ? (SeguroClienteBean) matches.get(0) : null;

	}
	public List listaSeguroCliente(SeguroClienteBean seguroClienteBean, int tipoLista){
		String query = "call SEGUROCLIENTELIS(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
					Constantes.ENTERO_CERO,
					seguroClienteBean.getNombreCliente(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"SeguroClienteDAO.listaSeguroCliente",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUROCLIENTELIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SeguroClienteBean seguroCliente = new SeguroClienteBean();

				seguroCliente.setClienteID(resultSet.getString(1));
				seguroCliente.setNombreCliente(resultSet.getString(2));
				seguroCliente.setSucursalSeguro(resultSet.getString(5));
				return seguroCliente;
			}
		});
		return matches;
	}

	public List listaSeguroNomCliente(SeguroClienteBean seguroClienteBean, int tipoLista){
		String query = "call SEGUROCLIENTELIS(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
					Constantes.ENTERO_CERO,
					seguroClienteBean.getNombreCliente(),
					tipoLista,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"SeguroClienteDAO.listaSeguroCliente",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUROCLIENTELIS(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SeguroClienteBean seguroCliente = new SeguroClienteBean();
				seguroCliente.setSeguroClienteID(resultSet.getString(1));
				seguroCliente.setClienteID(resultSet.getString(2));
				seguroCliente.setNombreCliente(resultSet.getString(3));
				return seguroCliente;
			}
		});
		return matches;
	}
	// Lista para combos
	public List listaCombo(SeguroClienteBean seguroClienteBean, int tipoLista) {
		String query = "call SEGUROCLIENTELIS(?,?,?,?,?, ?,?,?,?,?);";
		Object[] parametros = {
				seguroClienteBean.getClienteID(),
				Constantes.STRING_VACIO,
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"SeguroClienteDAO.consulta",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				SeguroClienteBean seguroCliente = new SeguroClienteBean();
				seguroCliente.setSeguroClienteID(resultSet.getString(1));
				seguroCliente.setEstatus(resultSet.getString(2));
				return seguroCliente;
			}
		});

		return matches;
	}

}
